//
//  RideSeatsDetailViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 24/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class RideSeatsDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var serviceStatus : Bool = false

    
    var contentArray : [Passenger]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        // Do any additional setup after loading the view.
        let trip = Manager.sharedInstance.currentTripInfo
        
        if trip?.driver != nil{
            let pas = cloneDriverToPassenger(driver:(trip?.driver)!)
            contentArray.append(pas)
        }
        
        for (_,value) in (trip?.passengers?.enumerated())!{
            contentArray.append(value)
        }
        
        let seatAvailable = (trip?.seats_available?.intValue)!
        
        if seatAvailable > 0 {
            for _ in 1...seatAvailable {
                contentArray.append(getAvailablePassenger()!)
            }
        }
        
        switch (trip?.ride_status){
            
        case RideStaus.CONFIRMED?,RideStaus.STARTED?,RideStaus.ENDED?,RideStaus.RETURN_CONFIRMED?:
            self.navigationItem.rightBarButtonItem = nil
            break
            
        default:
            break
        }
    }
    
    func cloneDriverToPassenger(driver:Driver)->(Passenger){

        let pass = Passenger()
        pass.first_name = driver.first_name
        pass.last_name = driver.last_name
        pass.profile_picture = driver.profile_picture
        pass.user_id = driver.user_id
        pass.rating = driver.rating
        pass.is_confirmed = NSNumber(booleanLiteral: true)
        pass.has_payment_made = NSNumber(booleanLiteral: true)
        pass.bags_quantity = NSNumber(integerLiteral: 0)
        pass.fare = NSNumber(integerLiteral: 0)
        pass.isDriver = true

        return pass
    }
    
    @IBAction func editSeatButtonClicked(sender:UIButton){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: EditSeatViewController.nameOfClass())
    
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            self.performSegue(withIdentifier: "comingFromSeatDetails_RD", sender: self)
        }

    }
    func getAvailablePassenger()->(Passenger!){
        
        let passenger = Passenger()
        passenger.is_confirmed = NSNumber(booleanLiteral: false)
        return passenger
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func registerCustomCell(){
        
        for cell in [SeatsAvailabiltyCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func reservedButtonClicked(sender: UIButton){
        
        if Utility.isDriver(){
        
            let passengerToRemove = contentArray[sender.tag]
            
            if (!((passengerToRemove.is_confirmed?.boolValue)!) && (passengerToRemove.first_name != nil)){
                showCancelReservationAlert(object: passengerToRemove)
            }
        }
    }
    
     func showCancelReservationAlert(object: Passenger){
        
        let name = object.first_name! + " " + object.last_name!
        let message = ApplicationConstants.CancelReservationAlertMessage + " " + name + " ?"
        
        let alert = UIAlertController(title: ApplicationConstants.CancelReservationAlertTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
        })
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            
            let trip = Manager.sharedInstance.currentTripInfo
            
            let tripID = (trip?.trip_id?.stringValue)! as Any
            let passengerID = (object.user_id?.stringValue)! as Any
            let token = User.getUserAccessToken() as Any
            let obejct : [String:Any] = [ApplicationConstants.Token:token, "trip_id":tripID,"passenger_id":passengerID]
            Trip.eliminateUserFromTrip(userObject: obejct, completionHandler: { (object, message, action, status) in
                
                self.serviceStatus = status!
                let stringMessage = message!["message"] as! String
                
                switch action{
                case .ShowMesasgeAtRunTime?:
                    Utility.showAlertwithOkButton(message: stringMessage, controller: self)
                    break
                case .DoNotShowMesasgeAtRunTime?:
                    break
                    
                case .ShowMesasgeOnAlert?:
                    Utility.showAlertwithOkButton(message: stringMessage, controller: self)
                    break
                    
                default:
                    break
                }

            })
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    @objc override func alertOkButtonHandler(){
        if serviceStatus{
            performSegue(withIdentifier: "comingFromSeatDetails_RD", sender: self)
        }
    }
}

extension RideSeatsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentArray.count/2) + (contentArray.count%2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SeatsAvailabiltyCell.nameOfClass() , for: indexPath) as! SeatsAvailabiltyCell
        cell.delegate = self
        cell.reservedButton.tag = indexPath.row
        cell.reservedButtonRight.tag = indexPath.row
        cell.reservedButton.addTarget(self, action: #selector(reservedButtonClicked), for: .touchUpInside)
        cell.reservedButtonRight.addTarget(self, action: #selector(reservedButtonClicked), for: .touchUpInside)
        cell.initializeCell(passenger: contentArray, atIndexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
}

extension RideSeatsDetailViewController: SeatsDetailsButtonCellDelegate {
    func onClickProfileButton(_ sender: Any,tag: Int){
        
        if (contentArray[tag].first_name != nil){
            let cont = self.storyboard?.instantiateViewController(withIdentifier: FreindProfileViewController.nameOfClass()) as! FreindProfileViewController
            cont.friendsID = contentArray[tag].user_id?.stringValue
            cont.hideDriverFields = tag != 0
            self.navigationController?.pushViewController(cont, animated: true)

        }
    }

}
