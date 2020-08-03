//
//  CheckboxCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol CheckboxCellDelegate: class {
    func clickEvent(CheckboxIndex tag: Int, isSelected: Bool)
}

class CheckboxCell: UITableViewCell {
    
     @IBOutlet weak var checkBoxView: CheckBoxView!
    
    weak var delegate: CheckboxCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCell(_ model: PostTrip){
        checkBoxView.label = model.title
        checkBoxView.setCheckBoxState(Bool(truncating: model.isselected))
    }
}

extension CheckboxCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        if delegate != nil {
            delegate?.clickEvent(CheckboxIndex: self.tag, isSelected: isSelected)
        }
    }
}
