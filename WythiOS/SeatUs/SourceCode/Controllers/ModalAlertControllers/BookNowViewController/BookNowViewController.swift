//
//  BookNowViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 13/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class BookNowViewController: ModalAlertBaseViewController {

    @IBOutlet weak var selectNumbersView: SelectNumbersView!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var promoCodeTextField: ValidaterTextField!
    @IBOutlet weak var detailsLable: UILabel!
    

    var numberOfBags: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectNumbersView.delegate = self
        
        promoCodeTextField.keyboardType = .alphabet
        promoCodeTextField.autocapitalizationType = .allCharacters
        
        let estimatedPrice = Manager.sharedInstance.currentTripInfo.estimates ?? "5.00"
        detailsLable.text = "Original Price: $5.50\nBooknow Price : $0.00 - Welcome Promo"// +  estimatedPrice
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
        
        getLastInvitedTime()
    }
    
    
    func dismissView(){
        self.close()
        doneButtonTapped?(selectedData)

    }
    func bookedTrip(shouldFtechMembers:Bool){
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        let tripID = (trip?.trip_id?.stringValue)! as Any
        let driverID = (trip?.driver?.user_id?.stringValue)! as Any
        
        let tripFromCoreData = DataPersister.sharedInstance.getTripInfo()

        //let isRoundTrip = NSNumber(booleanLiteral: (tripFromCoreData?.roundTrip)!)
        //let timeRange = (tripFromCoreData?.timeOfDay)! as Any
        
        let tripOriginTitle = (tripFromCoreData?.origin)!
        let tripOriginLat = (tripFromCoreData?.originCoordinates?.components(separatedBy: ",")[0])!
        let tripOriginLon =  (tripFromCoreData?.originCoordinates?.components(separatedBy: ",")[1])!
        
        
        let tripDesTitle = (tripFromCoreData?.destination)!
        let tripDesLat = (tripFromCoreData?.destinationCoordinates?.components(separatedBy: ",")[0])!
        let tripDesLon =  (tripFromCoreData?.destinationCoordinates?.components(separatedBy: ",")[1])!

        let promo_code = promoCodeTextField.text ?? ""
        
        let tripDetails :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":tripID,"driver_id":driverID,"bags":numberOfBags,"is_roundtrip":false,"pickup_latitude":tripOriginLat,"pickup_longitude":tripOriginLon,"pickup_title":tripOriginTitle,"dropoff_latitude":tripDesLat,"dropoff_longitude":tripDesLon,"dropoff_title":tripDesTitle,"promo_code":promo_code]

        
        Trip.bookedTrip(tripObject: tripDetails, shouldFetchMembers: shouldFtechMembers) { (object, message, action, status) in
            
            self.showAlertMessage(responderView: self.view, onContentView: self.contentView, message: (message?["message"] as! String))

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
        self.contentViewClone = contentView

        FireBaseManager.sharedInstance.getLastUpdatedTime { (objInvitedFriendTimeStatus) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                self.bookedTrip(shouldFtechMembers: false)
                break
                
            case InvitedFriendTimeStatus.InvitExpires?:
                self.bookedTrip(shouldFtechMembers: false)
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                self.bookedTrip(shouldFtechMembers: true)
                break
                
            case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                self.bookedTrip(shouldFtechMembers: false)
                break
                
            default:
                break
            }
        }
    }

}

extension BookNowViewController: SelectNumbersViewDelegate {
    func clickEvent(_ tag: Int, SeatsCount seats: Int) {
        numberOfBags = String(seats)
    }
    
//    func clickEvent(SeatsCount seats: Int) {
//        
//        numberOfBags = String(seats)
////        print(numberOfBags)
//    }
//    
    func seatsLimit(WarningMessage message: String) {
        print(message)
    }
}
