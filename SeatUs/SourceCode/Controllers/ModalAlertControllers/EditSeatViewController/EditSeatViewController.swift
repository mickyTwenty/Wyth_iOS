//
//  EditSeatViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 1/26/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class EditSeatViewController: ModalAlertBaseViewController {

    @IBOutlet weak var selectSeats: SelectNumbersView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let seatCount = "\((Manager.sharedInstance.currentTripInfo.seats_available?.intValue)! +         (Manager.sharedInstance.currentTripInfo.passengers?.count)!)"
        selectSeats.countLabel.text = seatCount
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        
        self.close()
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        
        let param = [ApplicationConstants.Token:User.getUserAccessToken(),"seats":(selectSeats.countLabel.text)!]
        Trip.updateTripSeats(filterObject: param as Any as! [String : Any], tripId: (Manager.sharedInstance.currentTripInfo.trip_id?.stringValue)!) { (object, message, active, status) in
            self.showAlertMessage(responderView: self.view, onContentView: self.view, message: message!["message"] as! String)
        }
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
