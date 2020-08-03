//
//  OffersViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 21/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class OffersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellName = OffersTripCell.nameOfClass()
    var contentArray: [GroupTrip]!
    
    private let refreshControl = UIRefreshControl()
    
    var isServiceCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCustomCell()
        setUpPullToReferesh()
        if contentArray != nil {
            updateTableView()
        }
        else {
            self.getOffers()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getOffers()
    }
    
    @IBAction func goBackToOffersViewController(segue:UIStoryboardSegue) {
        
        if segue.identifier?.compare("comingFromOfferDetailsVC") == ComparisonResult.orderedSame{
            getOffers()
        }
    }


    func registerCustomCell(){
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        tableView.tableFooterView = UIView()
    }
    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func setUpPullToReferesh() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.getOffers()
    }
    
    func getOffers(){
        if isServiceCalled {
            return
        }
        isServiceCalled = true
        let filterObject: [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any]
        
        Trip.getTripsFromSever(filterObject: filterObject, rideService: MyTripsConstant.Offers )
        { (object, message, active, status) in
            self.isServiceCalled = false
            self.contentArray = Trip.getTrips(object!)
            self.updateTableView()
        }
    }

}

extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray[section].trips.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName , for: indexPath) as! OffersTripCell
        cell.tag = indexPath.row
        cell.section = indexPath.section
        cell.delegate = self
        cell.setDetails(trip: contentArray[indexPath.section].trips[indexPath.row])
        
        if contentArray[indexPath.section].group_id != nil {
            cell.backgroundColor = UIColor.groupTableViewBackground
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = " Group Offer" ?? "Not grouped"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if contentArray[section].group_id != nil {
            return 20
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController(controllerIdentifier: OffersDetailViewController.nameOfClass(), navigationTitle: ApplicationConstants.OfferDetailsScreenTitle,conditons: contentArray[indexPath.section].trips[indexPath.row])
    }

}

extension OffersViewController: OffersTripCellDelegate {
    func onClickOffersDetail(OffersTripCell index: Int, _ sender: Any,atSection:Int) {
        pushViewController(controllerIdentifier: OffersDetailViewController.nameOfClass(), navigationTitle: ApplicationConstants.OfferDetailsScreenTitle,conditons: contentArray[atSection].trips[index])
    }
}
