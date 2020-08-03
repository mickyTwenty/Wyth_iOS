//
//  ButtonCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func clickEvent(ButtonIndex tag: Int, isSelected: Bool)
}

class ButtonCell: UITableViewCell {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: ButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCell(_ model: PostTrip){
        titleLabel.text = model.title + " : "
        imageButton.setImage(UIImage(named: model.selectedimage), for: .selected)
        imageButton.setImage(UIImage(named: model.imagename), for: .normal)
        imageButton.isSelected = Bool(truncating: model.isselected)
    }
    
    @IBAction func clickEvent(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if delegate != nil {
            delegate?.clickEvent(ButtonIndex: self.tag, isSelected: sender.isSelected)
        }
    }
}
