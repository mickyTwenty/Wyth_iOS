//
//  SignUpTableViewCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import AETextFieldValidator


class SignUpTableViewCell: UITableViewCell,UITextFieldDelegate {

    var modelSignUp : SignUpEntity!
    @IBOutlet weak var textField: ValidaterTextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var textFieldImageView: UIImageView!
    @IBOutlet weak var actionParentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellWithObject(model:SignUpEntity){
        
        modelSignUp = model
        let isSecured = Bool(truncating: model.issecured as NSNumber)
        let isTxtFieldDisabled = Bool(truncating: model.hascustomaction as NSNumber)
        textField.text=model.text
        textField.keyboardType=UIKeyboardType(rawValue: model.keyboardtype.intValue)!
        textField.delegate=self
        textField.isSecureTextEntry=isSecured
        actionParentView.isHidden = !isTxtFieldDisabled
        titleImageView.image=UIImage(named: model.imagename)
        
        applyValidation()
        
        textField.attributedPlaceholder = NSAttributedString(string: model.placeholdertext,
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        if textField.keyboardType == UIKeyboardType.alphabet {
            textField.autocapitalizationType = .words
        }
        
    }
    
    
    func updateCellForEditProfile(model:SignUpEntity){
        
        modelSignUp = model
        let isSecured = Bool(truncating: model.issecured as NSNumber)
        let isTxtFieldDisabled = Bool(truncating: model.hascustomaction as NSNumber)
        textField.text=model.text
        textField.textColor = .black
        textField.keyboardType=UIKeyboardType(rawValue: model.keyboardtype.intValue)!
        textField.delegate=self
        textField.isSecureTextEntry=isSecured
        actionParentView.isHidden = !isTxtFieldDisabled
        titleImageView.image=UIImage(named: model.imagename)
        textFieldImageView.image = UIImage(named: AssetsName.EditProfileTxtFiledBgImageName)
        
        if (model.customactionname.isEmpty){
            dropDownImageView.isHidden = true
        }
        else{
            dropDownImageView.image = UIImage(named: AssetsName.EditProfileTxtDropDownImageName)
            dropDownImageView.isHidden = false
        }
        
        applyValidation(isEmailEditable: true)
        
        textField.attributedPlaceholder = NSAttributedString(string: model.placeholdertext,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        if textField.keyboardType == UIKeyboardType.alphabet {
            textField.autocapitalizationType = .words
        }
        
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let isTxtFieldDisabled = Bool(truncating: modelSignUp.hascustomaction as NSNumber)
        var shouldEdit = true
        
        if isTxtFieldDisabled{
            shouldEdit = false
        }
        return shouldEdit
    }
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        modelSignUp.text=textField.text
    }
    
    func applyValidation(isEmailEditable:Bool = false){
        
        // handling pre-process validation
        textField.rightView=nil
        textField.isMandatory=true
        textField.validateOnResign = true
        textField.validateOnCharacterChanged = true


        switch modelSignUp.validationtype.intValue {
        case ValidationType.DefaultValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.MinimumLengthMessage
            textField.restorationIdentifier = ValidationExpressions.LengthValidator + "|" + ValidationMessages.MinimumLengthMessage
            textField.addRegx(ValidationExpressions.LengthValidator, withMsg: ValidationMessages.MinimumLengthMessage)
            break
            
        case ValidationType.EmailValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.EmailValidationMessage
            textField.restorationIdentifier = ValidationExpressions.EmailValidator + "|" + ValidationMessages.EmailValidationMessage
            textField.addRegx(ValidationExpressions.EmailValidator, withMsg: ValidationMessages.EmailValidationMessage)
            break
            
        case ValidationType.ZipValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.MinimumLengthMessage
            textField.restorationIdentifier = ValidationExpressions.LengthValidator + "|" + ValidationMessages.MinimumLengthMessage
            textField.addRegx(ValidationExpressions.LengthValidator, withMsg: ValidationMessages.MinimumLengthMessage)
            break
            
        case ValidationType.SelectorTypeValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.SelectorMessage
            textField.restorationIdentifier = ValidationExpressions.ZeroLengthValidator + "|" + ValidationMessages.SelectorMessage
            textField.addRegx(ValidationExpressions.ZeroLengthValidator, withMsg: ValidationMessages.SelectorMessage)
            break

            
        case ValidationType.NotEmptyValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.NotEmptyValidationMessage
            break
            
        case ValidationType.SelectorTypeSchoolValidation.rawValue:
            dropDownImageView.isHidden = true
            textField.mandatoryInvalidMsg=ValidationMessages.SelectorMessage
            textField.restorationIdentifier = ValidationExpressions.ZeroLengthValidator + "|" + ValidationMessages.SelectorMessage
            textField.addRegx(ValidationExpressions.ZeroLengthValidator, withMsg: ValidationMessages.SelectorMessage)
            break


        case ValidationType.NumberValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.NumberValidationMessage
            textField.restorationIdentifier = ValidationExpressions.NumberValidation + "|" + ValidationMessages.NumberValidationMessage
            textField.addRegx(ValidationExpressions.NumberValidation, withMsg: ValidationMessages.NumberValidationMessage)
            break

        case ValidationType.PasswordValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.MinimumLengthMessage
            textField.restorationIdentifier = ValidationExpressions.PasswordLengthValidator + "|" + ValidationMessages.MinimumPasswordLengthMessage
            textField.addRegx(ValidationExpressions.PasswordLengthValidator , withMsg: ValidationMessages.MinimumPasswordLengthMessage)
            break
            
        case ValidationType.NoValidation.rawValue:
            textField.restorationIdentifier = ""
            textField.validateOnCharacterChanged = false
            textField.isMandatory=false
            textField.validateOnResign = false
            break
            
        case ValidationType.SSNValidation.rawValue:
            textField.mandatoryInvalidMsg=ValidationMessages.SSNLengthMessage
            textField.restorationIdentifier = ValidationExpressions.SSNLengthValidator + "|" + ValidationMessages.SSNLengthMessage
            textField.addRegx(ValidationExpressions.SSNLengthValidator, withMsg: ValidationMessages.SSNLengthMessage)
            break
            
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.placeholder == PaymentConstant.SSNLast4Heading {
            return ( ((textField.text! as NSString).replacingCharacters(in: range, with: string).count ?? 0) <= 4 )
        }
        
        if textField.keyboardType == UIKeyboardType.phonePad {
            return Utility.formatPhoneNumber(textField: textField, range: range, string: string)
        }
        
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
