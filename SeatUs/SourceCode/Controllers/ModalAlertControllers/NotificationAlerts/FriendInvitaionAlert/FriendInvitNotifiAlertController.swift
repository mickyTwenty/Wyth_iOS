//
//  FriendInvitNotifiAlertController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/27/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class FriendInvitNotifiAlertController: ModalAlertBaseViewController {

    @IBOutlet weak var inviteTextLable: UILabel!
    @IBOutlet weak var contentView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let invitedBy = contentDict[FireBaseConstant.inviterName] as! String
        let dest = contentDict[FireBaseConstant.searchDataDestinationText] as! String
        let origin_text = contentDict[FireBaseConstant.searchDataOriginText] as! String
        let timeStamp = contentDict[FireBaseConstant.searchDataDate] as! String
        let date = Utility.getDateByTimeStamp(timeStamp: timeStamp)
        inviteTextLable.text = invitedBy + " Has invited you for a Trip \n Date: " + date + "\nFrom: " + origin_text + "\n To: " + dest
    }
    
    func getLastInvitedTime(){
        
        FireBaseManager.sharedInstance.getInvityLastUpdatedTime(object:contentDict) { (objInvitedFriendTimeStatus,deatils) in
        
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InvitExpires?:
                Utility.showAlertwithOkButton(message: ApplicationConstants.InviteExpireMessageNotifScreen, controller: self)
                break
                
            default:
                FireBaseManager.sharedInstance.updateInviteStatus(object: self.contentDict, status: FriendInvitedState.Accepted.rawValue)
                self.close()
                self.doneButtonTapped?(self.selectedData)
                break
            }
        }
    }

    
    @IBAction func acceptButtonCliked(_ sender: Any?) {
        
        getLastInvitedTime()
    }
    @IBAction func rejectButtonClicked(_ sender: Any?) {
        
        FireBaseManager.sharedInstance.updateInviteStatus(object: contentDict, status: FriendInvitedState.Rejected.rawValue)
        self.close()
        doneButtonTapped?(selectedData)
    }
    
    @IBAction func cancelButtonCliked(_ sender: Any?) {
        self.close()
        doneButtonTapped?(selectedData)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
