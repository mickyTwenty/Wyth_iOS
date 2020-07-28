//
//  ActionButtonCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol ActionButtonCellDelegate : class  {
    func leftButtonClicked(_ sender: Any)
    func rightButtonClicked(_ sender: Any)
}

class ActionButtonCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate : ActionButtonCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: PostTrip){
        if model.imagename != nil && !model.imagename.isEmpty {
            cancelButton.setImage(UIImage(named: model.imagename), for: .normal)
        }
        if model.selectedimage != nil && !model.selectedimage.isEmpty {
            submitButton.setImage(UIImage(named: model.selectedimage), for: .normal)
        }
    }
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.leftButtonClicked(sender)
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.rightButtonClicked(sender)
        }
    }
    
    func hideLeftButton(){
        cancelButton.isHidden = true
//        cancelButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 0).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
}
