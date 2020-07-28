//
//  AlertActionSheetCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 16/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class AlertActionSheetCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
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
        contentLabel.text = model.placeholdertext
    }
    
}
