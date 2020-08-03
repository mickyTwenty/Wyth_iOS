//
//  AddFriendModalController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 16/02/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class AddFriendModalController: ModalAlertBaseViewController {

    @IBOutlet weak var firstNameTextField: ValidaterTextField!
    @IBOutlet weak var lastNameTextField: ValidaterTextField!
    @IBOutlet weak var emailTextField: ValidaterTextField!
    @IBOutlet weak var phoneTextField: ValidaterTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyValidation(validateType: ValidationType.NotEmptyValidation, textField: firstNameTextField)
        applyValidation(validateType: ValidationType.NotEmptyValidation, textField: lastNameTextField)
        applyValidation(validateType: ValidationType.EmailValidation, textField: emailTextField)
        applyValidation(validateType: ValidationType.NumberValidation, textField: phoneTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onOkButtonClicked(_ sender: Any) {
        
        if isFieldsValidated() {
            
            let friend = Friend()
            friend.first_name = firstNameTextField.text
            friend.last_name = lastNameTextField.text
            friend.email = emailTextField.text
            friend.phone = phoneTextField.text
        
            self.close()
            self.selectButtonTapped?(friend as AnyObject)
            
        }
        else {
            
            Utility.showAlertwithOkButton(message: "All Fields Required.", controller: self)
            
        }
        
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        close()
    }
    
    func isFieldsValidated()->(Bool){
        if !firstNameTextField.validate() {
            return false
        }
        
        if !lastNameTextField.validate() {
            return false
        }
        
        if !emailTextField.validate() {
            return false
        }
        
        if !phoneTextField.validate() {
            return false
        }
        return true
    }
    
    func applyValidation(validateType:ValidationType, textField: ValidaterTextField){
        
        // handling pre-process validation
        textField.rightView=nil
        textField.isMandatory=true
        textField.validateOnResign = true
        textField.validateOnCharacterChanged = true
        
        switch validateType {
        case ValidationType.DefaultValidation:
            textField.mandatoryInvalidMsg=ValidationMessages.MinimumLengthMessage
            textField.restorationIdentifier = ValidationExpressions.LengthValidator + "|" + ValidationMessages.MinimumLengthMessage
            textField.addRegx(ValidationExpressions.LengthValidator, withMsg: ValidationMessages.MinimumLengthMessage)
            break
            
        case ValidationType.EmailValidation:
        textField.mandatoryInvalidMsg=ValidationMessages.EmailValidationMessage
            textField.restorationIdentifier = ValidationExpressions.EmailValidator + "|" + ValidationMessages.EmailValidationMessage
            textField.addRegx(ValidationExpressions.EmailValidator, withMsg: ValidationMessages.EmailValidationMessage)
            textField.keyboardType = UIKeyboardType.emailAddress
            break
            
        case ValidationType.NumberValidation:
           
        textField.mandatoryInvalidMsg=ValidationMessages.NumberValidationMessage
            textField.restorationIdentifier = ValidationExpressions.NumberValidation + "|" + ValidationMessages.NumberValidationMessage
            textField.addRegx(ValidationExpressions.NumberValidation, withMsg: ValidationMessages.NumberValidationMessage)
            textField.delegate = self
            textField.keyboardType = UIKeyboardType.phonePad
            break
            
        case ValidationType.NotEmptyValidation:
            textField.mandatoryInvalidMsg=ValidationMessages.NotEmptyValidationMessage
            break
            
        default:
            break
        }
        
    }
    
}

extension AddFriendModalController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.keyboardType == UIKeyboardType.phonePad {
            return Utility.formatPhoneNumber(textField: textField, range: range, string: string)
        }
        return true
    }
}

