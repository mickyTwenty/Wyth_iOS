//
//  LabelCheckBoxCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol LabelCheckBoxCellDelegate: class {
    func clickEvent(LabelCheckBoxIndex tag: Int, isSelected: Bool)
}

class LabelCheckBoxCell: UITableViewCell {

    weak var delegate: LabelCheckBoxCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: AnyObject){
        
        titleLabel.text = model.title + " : "
        checkBoxView.label = model.placeholdertext ?? ""
        if let card = model.card {
            checkBoxView.setCheckBoxState((card!.is_default!.boolValue))
            checkBoxView.isEnabled = !card!.is_default!.boolValue
        }
        
    }
    
    func hideSeparatorView(){
        separatorView.isHidden = true
//        separatorView.heightAnchor.constraint(equalToConstant: 0)
//        separatorView.widthAnchor.constraint(equalToConstant: 0)
    }
    
    func showSeparatorView(){
        separatorView.isHidden = false
        //        separatorView.heightAnchor.constraint(equalToConstant: 0)
        //        separatorView.widthAnchor.constraint(equalToConstant: 0)
    }

}

extension LabelCheckBoxCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        if delegate != nil {
            delegate?.clickEvent(LabelCheckBoxIndex: self.tag, isSelected: isSelected)
        }
    }
}
