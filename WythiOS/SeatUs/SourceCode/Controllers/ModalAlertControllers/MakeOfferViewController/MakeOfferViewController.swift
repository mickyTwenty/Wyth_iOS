//
//  MakeOfferViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 14/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class MakeOfferViewController: ModalAlertBaseViewController {
    
    @IBOutlet weak var selectNumbersView: SelectNumbersView!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var priceTextField: ValidaterTextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailsLable: UILabel!
    @IBOutlet weak var returningSelectNumbersView: SelectNumbersView!
    
    var user_id: String = ""
    var bagsOrSeats: String = ""
    var numberOfBags: String = "0"
    var userID: Any = ""
    
    var isRoundTrip = false
    var isRoundTripButSingle = false
    var estimates = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   //     let estimatedPrice = Manager.sharedInstance.currentTripInfo.estimates
//        let (minEstimate,maxEstimate) : (Double,Double) = Utility.getEstimates()
//
//        let estimatedPrice = Utility.getFormattedEstimate(factor: 2, minEstimate: minEstimate, maxEstimate: maxEstimate)
        
//        detailsLable.text = "Estimate : $" + (estimatedPrice ?? "") + " (Double for Round Trip)"
//        detailsLable.text = "Estimate : $" + (estimatedPrice ?? "")


        selectNumbersView.delegate = self
        selectNumbersView.hideBulletView()
        returningSelectNumbersView.hideBulletView()
        setupValidation()
        
//        var factor = 1.0
//        if isRoundTrip {
//            factor = 2.0
//        }
//
//        let (minEstimate,maxEstimate) : (Double,Double) = Utility.getEstimates()
//
//        let estimatedPrice = Utility.getFormattedEstimate(factor: factor, minEstimate: minEstimate, maxEstimate: maxEstimate)
        detailsLable.text = "Estimate : " + estimates
    }
    func setupValidation(){
        
        priceTextField.mandatoryInvalidMsg=ValidationMessages.NotEmptyValidationMessage

        priceTextField.restorationIdentifier = ValidationExpressions.ZeroLengthValidator + "|" + ValidationMessages.NotEmptyValidationMessage
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        if Utility.isDriver() {
            if let passenger = trip?.passenger {
                userID = (passenger.user_id?.stringValue) ?? ""
            }
            selectNumbersView.heading = MakeOfferConstant.NoOfSeatsHeading
//            user_id = MakeOfferConstant.PassengerId
            user_id = MakeOfferConstant.DriverId

            bagsOrSeats = MakeOfferConstant.Seats
            selectNumbersView.minimumLimit = trip?.passengers?.count ?? MakeOfferConstant.MinimumSeatsLimit
            
        }
        else {
            if let driver = trip?.driver {
                userID = (driver.user_id?.stringValue) ?? ""
            }
            selectNumbersView.heading = MakeOfferConstant.NoOfBagsHeading
            user_id = MakeOfferConstant.DriverId
            bagsOrSeats = MakeOfferConstant.Bags
            selectNumbersView.minimumLimit = MakeOfferConstant.MinimumBagsLimit
        }
        
        numberOfBags = "\(selectNumbersView.minimumLimit)"
        
        if isRoundTrip && Utility.isDriver() {
            returningSelectNumbersView.countLabel.text = "1"
        }
        else {
            hideReturnSelectView()
        }
        
    }

    func hideReturnSelectView(){
        returningSelectNumbersView.countLabel.text = "0"
        returningSelectNumbersView.isHidden = true
        returningSelectNumbersView.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //cancel
    @IBAction func leftButtonClicked(_ sender: Any) {
        self.close()
        doneButtonTapped?(selectedData)

    }
    
    // submit
    @IBAction func rightButtonClicked(_ sender: Any) {
        
        if priceTextField.validate() {
            getLastInvitedTime()
        }

    }
    
    func dismissView(){
        
        self.close()
        doneButtonTapped?(selectedData)
    }
    
    func makeOfferToTrip(shouldFtechMembers:Bool){
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        let tripID = (trip?.trip_id?.stringValue)! as Any
        
        let price = (priceTextField.text)! as Any
        let tripFromCoreData = DataPersister.sharedInstance.getTripInfo()
        
//        CreateTripDetails.shared.searchArray[0].text
//        CreateTripDetails.shared.searchArray[0].title
        
//        let isRoundTrip = NSNumber(booleanLiteral: (tripFromCoreData?.roundTrip)!)
//        var timeRange = ""
//        if tripFromCoreData?.timeOfDay != nil {
//            timeRange = (tripFromCoreData?.timeOfDay)! as! String
//        }
//        else {
//            timeRange = trip?.time_range?.stringValue ?? ""
//        }
//        let timeRange = (tripFromCoreData?.timeOfDay)! as Any
        
        let tripOriginTitle = (tripFromCoreData?.origin)!
        let tripOriginLat = (tripFromCoreData?.originCoordinates?.components(separatedBy: ",")[0])!
        let tripOriginLon =  (tripFromCoreData?.originCoordinates?.components(separatedBy: ",")[1])!
        
        
        let tripDesTitle = (tripFromCoreData?.destination)!
        let tripDesLat = (tripFromCoreData?.destinationCoordinates?.components(separatedBy: ",")[0])!
        let tripDesLon =  (tripFromCoreData?.destinationCoordinates?.components(separatedBy: ",")[1])!        
        
        var tripDetails :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":tripID,user_id:userID,bagsOrSeats:numberOfBags,"is_roundtrip":isRoundTrip,"price":price,"pickup_latitude":tripOriginLat,"pickup_longitude":tripOriginLon,"pickup_title":tripOriginTitle,"dropoff_latitude":tripDesLat,"dropoff_longitude":tripDesLon,"dropoff_title":tripDesTitle]
    
        if CreateTripDetails.shared.searchArray.count > 0 {
            tripDetails["time_range"] = CreateTripDetails.shared.searchArray[0].text ?? "0"
        }
        
        if isRoundTrip {
            if isRoundTripButSingle {
                tripDetails["is_roundtrip"] = "0"
            }
            else {
                tripDetails["is_roundtrip"] = "1"
                if CreateTripDetails.shared.searchArray.count > 0 {
                    tripDetails["time_range_returning"] = CreateTripDetails.shared.searchArray[0].title ?? "0"
                }
                if Utility.isDriver() {
                    tripDetails["seats_total_returning"] = returningSelectNumbersView.countLabel.text
                }
            }
        }
        
        if !Trip.isOfferAcceptable(price: price, vc: self) {
            return
        }
        
        Trip.makeOfferOnTrip(tripObject: tripDetails, shouldFetchMembers: shouldFtechMembers) { (object, message, action, status) in
            
            
            if let code = message!["error_code"] as? String{
                if code == ErrorTypes.InvalidCCErrorCode{
                    self.showAlertMessage(responderView: self.view, onContentView: self.contentView, message: ApplicationConstants.NoCreditCardMessage, isYesNoButton: true)
                }
            }
            else{
                self.showAlertMessage(responderView: self.view, onContentView: self.contentView, message: (message?["message"] as! String))
            }

            self.selectedData = message as! [String : AnyObject]
            
            switch action{
            case .ShowMesasgeAtRunTime?:
//                self.errorLable.text = (message?["message"] as! String)
                break
                
            case .DoNotShowMesasgeAtRunTime?:
//                self.dismissView()
                break
                
            default :
                break
            }
        }
    }

    
    
    func getLastInvitedTime(){
        FireBaseManager.sharedInstance.getLastUpdatedTime { (objInvitedFriendTimeStatus) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                self.makeOfferToTrip(shouldFtechMembers: false)
                break
                
            case InvitedFriendTimeStatus.InvitExpires?:
                self.makeOfferToTrip(shouldFtechMembers: false)
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                self.makeOfferToTrip(shouldFtechMembers: true)
                break
                
            case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                self.makeOfferToTrip(shouldFtechMembers: false)
                break
                
            default:
                break
            }
        }
    }
    
}

extension MakeOfferViewController: SelectNumbersViewDelegate {
    func clickEvent(_ tag: Int, SeatsCount seats: Int) {
        numberOfBags = String(seats)
    }
    
//    func clickEvent(SeatsCount seats: Int) {
//        numberOfBags = String(seats)
////        print(seats)
//    }
    
    func seatsLimit(WarningMessage message: String) {
        print(message)
    }
}
