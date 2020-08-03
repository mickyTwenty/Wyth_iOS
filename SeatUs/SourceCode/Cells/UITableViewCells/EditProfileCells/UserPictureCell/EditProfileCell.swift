//
//  EditProfileCell.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/28/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class EditProfileCell: UITableViewCell {

    @IBOutlet weak var nameLable : UILabel!
    @IBOutlet weak var changePicButton : UIButton!
    @IBOutlet weak var userImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
