//
//  InviteDriverModalController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 11/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class InviteDriverModalController: ModalAlertBaseViewController {

    @IBOutlet weak var inviteTextLabel: UILabel!
    @IBOutlet weak var selectSeats: SelectNumbersView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var returnSelectSeats: SelectNumbersView!
    
    var driverDetails : [String:Any]! = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectSeats.hideBulletView()
        selectSeats.countLabel.text = "1"
        returnSelectSeats.hideBulletView()
        returnSelectSeats.countLabel.text = "1"
        let invitedBy = contentDict[FireBaseConstant.inviterName] as! String
        let dest = contentDict[FireBaseConstant.searchDataDestinationText] as! String
        let origin_text = contentDict[FireBaseConstant.searchDataOriginText] as! String
        let timeStamp = contentDict[FireBaseConstant.searchDataDate] as! String
        let date = Utility.getDateByTimeStamp(timeStamp: timeStamp)
        var isRoundTrip = false
        if let _isRoundTrip = contentDict[FireBaseConstant.isRoundTrip] as? String {
            isRoundTrip = Bool(_isRoundTrip) ?? false
        }
        
        if !isRoundTrip {
            returnSelectSeats.countLabel.text = "0"
            returnSelectSeats.isHidden = true
            returnSelectSeats.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            returnSelectSeats.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        inviteTextLabel.text = invitedBy + " Has invited you for a Trip \n Date: " + date + "\nFrom: " + origin_text + "\n To: " + dest
    }
    
    func getLastInvitedTime(sender:UIButton){
        
        FireBaseManager.sharedInstance.getInvityLastUpdatedTime(object:contentDict) { (objInvitedFriendTimeStatus,details) in
            
            self.driverDetails = details
            if  let driverObject = self.driverDetails[FireBaseConstant.driverNode]{
                
                let driverNode = driverObject as? [String:Any]
                
                let driveStatus = driverNode![FireBaseConstant.driverStatus] as? NSNumber
                
                if (driveStatus == nil || driveStatus?.intValue == 0) {
                    
                    switch objInvitedFriendTimeStatus{
                        
                    case InvitedFriendTimeStatus.InvitExpires?:
                        Utility.showAlertwithOkButton(message: ApplicationConstants.InviteExpireMessageNotifScreen, controller: self)
                        break
                        
                    default:
                        
                        if sender.isEqual(self.leftButton){
                            FireBaseManager.sharedInstance.updateDriverInviteStatus(object: self.contentDict, driverObject: self.driverDetails, status: FriendInvitedState.Rejected.rawValue)
                        }
                        else{
                            FireBaseManager.sharedInstance.updateDriverInviteStatus(object: self.contentDict, driverObject: self.driverDetails, status: FriendInvitedState.Accepted.rawValue, seats: Int(self.selectSeats.countLabel.text!)!, returningSeats: Int(self.returnSelectSeats.countLabel.text!)!
                            )
                        }
                        self.closeView()
                        break
                    }
                }
                else{
                    self.closeView()
                }
            }
            else{
                self.closeView()
            }
        }
        
    }

    func closeView(){
        self.close()
        self.doneButtonTapped?(self.selectedData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func leftButtonClicked(_ sender: UIButton) {
        getLastInvitedTime(sender: sender)
    }
    
    @IBAction func rightButtonClicked(_ sender: UIButton) {
        getLastInvitedTime(sender: sender)
    }
}
