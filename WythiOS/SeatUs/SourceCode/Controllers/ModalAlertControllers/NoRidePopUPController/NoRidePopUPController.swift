//
//  NoRidePopUPController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 4/2/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class NoRidePopUPController: ModalAlertBaseViewController {

    @IBOutlet weak var createRideButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch (Utility.getUserType()){
            
        case UserType.UserDriver:
            createRideButton.setImage(UIImage(named: AssetsName.PostRidePopUpImageName), for: .normal)
            break
            
        case UserType.UserNormal:
            break
            
        default :
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createRideButtonClicked(_ sender: Any?) {
        selectedData = ["action":"1"] as [String : AnyObject]
        self.close()
        doneButtonTapped?(selectedData)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any?) {
        selectedData = ["action":"0"] as [String : AnyObject]
        self.close()
        doneButtonTapped?(selectedData)
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
