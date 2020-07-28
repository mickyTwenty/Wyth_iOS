//
//  SignUpCountinueCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/17/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SignUpCountinueCell: UITableViewCell {

    @IBOutlet weak var countinueButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.countinueButton.contentHorizontalAlignment = .fill
        self.countinueButton.contentVerticalAlignment = .fill
        self.countinueButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
