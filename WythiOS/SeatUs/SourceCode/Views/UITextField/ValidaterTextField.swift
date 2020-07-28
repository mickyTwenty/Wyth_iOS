//
//  ValidaterTextField.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/17/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import AETextFieldValidator

class ValidaterTextField: AETextFieldValidator {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.popUpColor=ValidationCustomization.PopUpColorBg
        self.errorImg=ValidationCustomization.ErrorImage
        self.mandatoryInvalidMsg=ValidationMessages.MinimumLengthMessage
        self.popUpFont = ValidationCustomization.ErrorFont
    }
}
