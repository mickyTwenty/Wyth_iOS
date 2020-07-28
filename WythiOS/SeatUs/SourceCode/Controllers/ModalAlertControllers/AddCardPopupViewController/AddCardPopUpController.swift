//
//  AddCardPopUpController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 1/24/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import Stripe


class AddCardPopUpController: ModalAlertBaseViewController {

    
    @IBOutlet weak var cardField: STPPaymentCardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardField.delegate = self
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        self.close()
        doneButtonTapped?(selectedData)
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        getToken()
    }
    
    
    func getToken(){
        let cardParams = cardField.isValid
        
        if cardParams  {
         
            WebServices.sharedInstance.showHud(message: "")
            STPAPIClient.shared().createToken(withCard: cardField.cardParams) { token, error in
                guard let stripeToken = token else {
                    NSLog("Error creating token: %@", error!.localizedDescription);
                    return
                }
                
                let filterObject: [String: Any] = ["card_token":"\(stripeToken)", "last_digits":self.cardField.cardNumber ?? "" ]
                
                Card.requestToServer(service: WebServicesConstant.AddCreditCard, filterObject: filterObject)
                    { (object, message, active, status) in
                        
                        WebServices.sharedInstance.hideHud()

                        self.close()
                        self.selectButtonTapped?(true as AnyObject)
                        
                }
                

            }
        }
        else{
            
            showAlertMessage(responderView: self.view, onContentView: self.view, message: "Card not Valid")
        }
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

extension AddCardPopUpController : STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
    }
}
