//
//  MessagingViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 28/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class MessagingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var contentArray: [Trip]! = []
    
    let messageCellDriver = MessagingInfoDriverCell.nameOfClass()
    let messageCellPassenger = MessagingInfoCell.nameOfClass()
    var currentStateCell : String! = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        getUpcomingTrips()
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.MessagingHelp
        
        present(controller, animated: true, completion: nil)
    }

    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    
    func getUpcomingTrips(date: String = "",latitude: String = "",longitude: String = ""){
        let filterObject: [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,
                                           "date":date, "latitude":latitude, "longitude":longitude ]
        
        Trip.getTripsFromSever(filterObject: filterObject, rideService: MyTripsConstant.Upcoming)
        { (object, message, active, status) in
            
            self.contentArray = Trip.getTrips(object!)
            self.updateTableView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showRideDetailsScreen(trip:Trip){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: RideDetailsViewController.nameOfClass()) as! RideDetailsViewController
        controller.tripID = String(describing: trip.trip_id!)
        navigationController?.pushViewController(controller, animated: true)
    }

    
    func registerCustomCell(){
        
        let cellNib = UINib(nibName: MessagingInfoCell.nameOfClass(), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: MessagingInfoCell.nameOfClass())
        
        let cellNibDriver = UINib(nibName: MessagingInfoDriverCell.nameOfClass(), bundle: nil)
        tableView.register(cellNibDriver, forCellReuseIdentifier: MessagingInfoDriverCell.nameOfClass())

        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        if (Utility.isDriver()){
            currentStateCell = messageCellDriver
        }
        else{
            currentStateCell = messageCellPassenger
        }

        
    }
    
}

extension MessagingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentStateCell , for: indexPath)
        cell.tag = indexPath.row

        switch (cell){
            
        case is MessagingInfoCell:
            
            let cellPassenger = cell as! MessagingInfoCell
            cellPassenger.delegate = self
            cellPassenger.setDetails(trip: contentArray[indexPath.row])
            break
            
        case is MessagingInfoDriverCell:
            
            let cellDriver = cell as! MessagingInfoDriverCell
            cellDriver.delegate = self
            cellDriver.setDetails(trip: contentArray[indexPath.row])
            break
            
        default:
            break
        
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }

}

extension MessagingViewController: MessagingInfoCellDelegate {
    func onClickRideDetail(MessagingInfoCellIndex index: Int, _ sender: Any) {
        showRideDetailsScreen(trip:contentArray[index])
    }
    
    func onClickGroupChat(MessagingInfoCellIndex index: Int, _ sender: Any) {
        print("onClickGroupChat")
        pushViewController(controllerIdentifier: ChatViewController.nameOfClass(), navigationTitle: ApplicationConstants.GroupChatTitle, conditons: contentArray[index])
    }
}
