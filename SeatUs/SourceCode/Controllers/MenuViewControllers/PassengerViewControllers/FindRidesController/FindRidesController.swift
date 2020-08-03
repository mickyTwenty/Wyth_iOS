//
//  FindRidesController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/21/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class FindRidesController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    
    @IBAction func changePasswordButtonClicked(_ sender: Any) {
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: ChangePasswordViewController.nameOfClass())
        cont.show(controller: self)

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
