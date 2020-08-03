//
//  AgreementCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/18/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class AgreementCell: UITableViewCell {

    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
