//
//  TextFieldCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func textChanged(TextFieldCell tag: Int, _ text: String)
}

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!
    
    weak var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: AnyObject){
        
        titleLabel.text = model.title + " : "
        contentTextField.placeholder = ApplicationConstants.PlaceHolderText
        contentTextField.text = model.placeholdertext ?? ""
    }
    
    
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField){
        if delegate != nil {
            delegate?.textChanged(TextFieldCell: self.tag, textField.text!)
        }
    }
}
