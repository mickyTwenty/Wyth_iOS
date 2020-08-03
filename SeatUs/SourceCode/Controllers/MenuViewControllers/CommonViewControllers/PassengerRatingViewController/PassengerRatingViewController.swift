    //
//  PassengerRatingViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 31/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PassengerRatingViewController: BaseViewController {

    var contentArray: [Passenger]!
    var tripInfo :Trip!
    var ratings : [RateModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = tripInfo.passengers
        registerCustomCell()
        updateTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        User.setPendingRatings(hasPending: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerCustomCell(){
        
        for cell in [PassengerRatingCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
    }
    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        
        var rateArray: [[String:String]] = []
        
        var isAllRated = contentArray.count == ratings.count
        
        for rate in ratings {
            if ( Float(rate.rating) ?? 0.0 ) > 0.0 {
                rateArray.append( [ "user_id":rate.user_id, "rating":rate.rating, "feedback":rate.feedback,"trip_id":(tripInfo.trip_id?.stringValue)! ] )
            }
            else {
                isAllRated = false
                break
            }
        }
        
        if isAllRated {
            
            Trip.rateTrip(rateArray: rateArray, isDriver: false)
                { (object, message, active, status) in

                    User.setPendingRatings(hasPending: false)
                    self.performSegue(withIdentifier: "BackToRideDetailScreen", sender: self)
                    
            }
        
        } else {
            
            Utility.showAlertwithOkButton(message: ValidationMessages.RatingValidationMessage, controller: self)
            
        }
        
    }

}

extension PassengerRatingViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PassengerRatingCell.nameOfClass() , for: indexPath) as! PassengerRatingCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.initializeCell(contentArray[indexPath.row], ratings: ratings, trip: tripInfo)
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
        
}
    
extension PassengerRatingViewController: PassengerRatingCellDelegate {
    func onRateNowClicked(_ sender: Any, tag: Int) {
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: RatingCommentsViewController.nameOfClass()) as! RatingCommentsViewController
        cont.hideRatingField = true
        cont.date = tripInfo.date
        cont.name = (self.contentArray[tag].first_name ?? "") + " " + (self.contentArray[tag].last_name ?? "")
        cont.show(controller: self)
        cont.selectButtonTapped = { selectedData in
            let user_id = self.contentArray[tag].user_id?.stringValue
            let rate = selectedData as! RateModel
            if let rateObj = self.ratings.filter( { $0.user_id == user_id } ).first {
                rateObj.feedback = rate.feedback
                rateObj.rating = rate.rating
            }
            else {
                rate.trip_id = self.tripInfo.trip_id?.stringValue
                rate.user_id = user_id
                self.ratings.append(rate)
            }
            self.tableView.reloadData()
        }
    }
}
