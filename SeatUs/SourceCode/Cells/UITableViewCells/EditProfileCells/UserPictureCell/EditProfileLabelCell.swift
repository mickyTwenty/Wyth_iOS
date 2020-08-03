//
//  EditProfileLabelCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 18/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class EditProfileLabelCell: SignUpTableViewCell {

    @IBOutlet weak var headingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func updateCellForEditProfile(model:SignUpEntity){
        super.updateCellForEditProfile(model: model)
        headingLabel.text = model.placeholdertext ?? ""
    }
}
