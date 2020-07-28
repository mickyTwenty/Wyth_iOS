//
//  SignUpDriverCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/18/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SignUpDriverCell: UITableViewCell {

    @IBOutlet weak var driverSignUpButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.driverSignUpButton.contentHorizontalAlignment = .fill
        self.driverSignUpButton.contentVerticalAlignment = .fill
        self.driverSignUpButton.imageView?.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
