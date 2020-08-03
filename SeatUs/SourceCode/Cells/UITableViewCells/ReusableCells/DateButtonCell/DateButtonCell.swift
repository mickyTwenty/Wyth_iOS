//
//  DateButtonCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class DateButtonCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var callenderImageView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initializeCell(_ model: PostTrip){
        headingLabel.text = model.title + " : "
        dateLabel.text = model.placeholdertext
        if model.imagename != nil && !model.imagename.isEmpty {
            callenderImageView.setImage(UIImage(named: model.imagename!), for: .normal)
        }
    }
    
    func initializeCell(_ model: AnyObject){
        headingLabel.text = model.title + " : "
        dateLabel.text = model.placeholdertext
    }
}
