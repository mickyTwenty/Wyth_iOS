//
//  ChangePasswordViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/25/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ModalAlertBaseViewController {

    @IBOutlet var contentView:UIView!

    @IBOutlet var textFeildCollectionArr: [ValidaterTextField]!
    @IBOutlet weak var oldPasswordField: ValidaterTextField!
    @IBOutlet weak var newPasswordField: ValidaterTextField!
    @IBOutlet weak var confirmPasswordField: ValidaterTextField!
    var serviceStatus: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupValidation()
    }
    
    
    func callService(){
        
        weak var weakSelf = self
        let dict : [String:AnyObject] = ["old_pwd":oldPasswordField.text as AnyObject, "password":confirmPasswordField.text as AnyObject, ApplicationConstants.Token:User.getUserAccessToken() as AnyObject]
        User.changePassword(param: dict) { (response, message, action, status) in
            
            self.showAlertMessage(responderView: self.view, onContentView: self.contentView, message: (message?["message"] as! String))

            self.serviceStatus = status!
            let stringMessage = message!["message"] as! String

            switch action{
            case .ShowMesasgeAtRunTime?:
                break
            case .DoNotShowMesasgeAtRunTime?:
                self.close()
                break
            case .ShowMesasgeOnAlert?:
//                Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                break
                
            default:
                break
            }
        }
    }
    
    func setupValidation(){
        oldPasswordField.restorationIdentifier = ValidationExpressions.PasswordLengthValidator + "|" + ValidationMessages.MinimumPasswordLengthMessage
        
        newPasswordField.restorationIdentifier = ValidationExpressions.PasswordLengthValidator + "|" + ValidationMessages.MinimumPasswordLengthMessage

        confirmPasswordField.addConfirmValidation(to: newPasswordField, withMsg: ValidationMessages.PasswordMismatchMessage)
    }
    
    func isFieldsValidated()->(Bool){
        var isValidated:Bool = false
        for (_,element) in textFeildCollectionArr.enumerated(){
            let txtField : ValidaterTextField = element
            isValidated = txtField.validate()
            if (!isValidated){
                isValidated = txtField.validate()
            }
        }
        return isValidated
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        
        if isFieldsValidated() {
            
            callService()
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any?) {        
        close()
    }
    
    @objc override func alertOkButtonHandler(){
        print("calling alertOkButtonHandler from BaseViewController")
        if serviceStatus{
            self.close()
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
