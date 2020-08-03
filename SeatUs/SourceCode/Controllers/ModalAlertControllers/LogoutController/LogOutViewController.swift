//
//  LogOutViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/24/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class LogOutViewController: ModalAlertBaseViewController {

    @IBOutlet weak var contentView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func callService(){
    
        FireBaseManager.unSubscribeForTopic()

        let dict : [String:Any] = [ApplicationConstants.Token:User.getUserAccessToken()]
        User.logoutUser(param: dict as [String : AnyObject]) { (response, message, action, status) in
        }
        User.removeArchiveObject()

    }
    
    @IBAction func yesButtonClicked(_ sender: Any?) {
        callService()
        self.close()
        doneButtonTapped?(selectedData)
    }
    @IBAction func noButtonClicked(_ sender: Any?) {        
        self.close()
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
