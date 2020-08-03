//
//  ForgotPasswordController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/18/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ForgotPasswordController: ModalAlertBaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var emailTxtField: ValidaterTextField!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var resendCodeButton: UIButton!

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateView()
    }
    

    
    func updateView(){
        
        switch popUpScreen! {
            
        case .ForgotPassword:
            
            resendCodeButton.isHidden = true
            emailTxtField.keyboardType = .emailAddress
            emailTxtField.placeholder = ForgotPasswordPopup.ForgotPassTxtFieldPlaceHolder
            bgImageView.image=ForgotPasswordPopup.ForgotPassBG
            contentLabel.text=ForgotPasswordPopup.ForgotPassContentText
            titleImageView.image=ForgotPasswordPopup.ForgotPassTxtFieldTitleImage
            emailTxtField.restorationIdentifier = ValidationExpressions.EmailValidator + "|" + ValidationMessages.EmailValidationMessage
            emailTxtField.addRegx(ValidationExpressions.EmailValidator, withMsg: ValidationMessages.EmailValidationMessage)
            break

        case .NumberValidation:
            
            resendCodeButton.isHidden = false
            emailTxtField.keyboardType = .numberPad
            emailTxtField.placeholder = ValidationPopup.ValidateNumberTxtFieldPlaceHolder
            emailTxtField.restorationIdentifier = ""
            emailTxtField.validateOnCharacterChanged = false
            emailTxtField.isMandatory=false
            emailTxtField.validateOnResign = false
            bgImageView.image=ValidationPopup.ValidateNumberBG
            contentLabel.text=ValidationPopup.ValidateNumberContentText
            titleImageView.image=ValidationPopup.ValidateNumberTxtFieldTitleImage
            Manager.sharedInstance.transitionState=TransitionState.IsOnLoginScreen

            break

        default:
            break
        }
    }
    
    @IBAction func submittButtonClicked(_ sender: Any) {
        
        switch popUpScreen! {
            
        case .ForgotPassword:
             callServiceForForgotPassword()
            break
            
        case .NumberValidation:
             callServiceNumberVerification()
            break
            
            
        default:
            break
        }
    }
    
    @IBAction func resendCodeButtonClicked(_ sender: Any){
    
        //weak var weakSelf = self

        User.resendCode(email: Utility.getCacheEmail()) { (object, message, action, status) in
            let stringMessage = message!["message"] as! String
            
            switch action{
            case .ShowMesasgeAtRunTime?:
                self.errorLable.text=stringMessage
                break
            case .DoNotShowMesasgeAtRunTime?:
                break
            case .ShowMesasgeOnAlert?:
                self.errorLable.text=stringMessage
                //Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                break
                
            default:
                break
            }
        }
    }

    
    func callServiceForForgotPassword(){
        weak var weakSelf = self
        self.errorLable.text = ""

        if emailTxtField.validate() {
            
            let emailValue = emailTxtField.text as AnyObject
            let dic:[String:AnyObject] = ["email":emailValue]
            
            User.resetPassword(param: dic, completionHandler: { (response, message, action, status) in
    
                let stringMessage = message!["message"] as! String

                
                switch action{
                case .ShowMesasgeAtRunTime?:
                    self.errorLable.text=stringMessage
                    break
                case .DoNotShowMesasgeAtRunTime?:
                    break
                case .ShowMesasgeOnAlert?:
                    Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                    break

                default:
                    break
                }
            })
        }

    }
    
    func callServiceNumberVerification(){
        
        self.errorLable.text = ""
        weak var weakSelf = self

        if emailTxtField.validate() {
            
            let code = emailTxtField.text as AnyObject
            let dic:[String:AnyObject] = ["code":code]
            User.verifyUser(param: dic, completionHandler: { (response, message, action, status) in
                
//                let errorInfo = message!["error_code"] as! String
                let stringMessage = message!["message"] as! String

                switch action{
                    
                case .ShowMesasgeAtRunTime?:
                    self.errorLable.text=stringMessage
                    break
                case .DoNotShowMesasgeAtRunTime?:
                    break
                    
                case .ShowMesasgeOnAlert?:
                    Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                    break

                default:
                    break
                }
            })
        }
    }

    
    @IBAction func cancelButtonClicked(_ sender: Any?) {
        performAnimation(axis: ApplicationConstants.ForgotDialogOriginY)
        self.close()
    }
    
    @objc override func alertOkButtonHandler(){
        cancelButtonClicked(nil)
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
