//
//  SenderCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 08/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.setCornerRadius(6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func initializeCell(_ model: OffersModel){
        senderLabel.text = ""
        msgLabel.text = "$ " + model.price!
        dateLabel.text = Utility.getTimeStamp(byDate: model.timestamp!)
    }
    
    func initializeCell(_ model: Chat){
        senderLabel.text = model.first_name! + " " + model.last_name!
        msgLabel.text = model.message_text
        if model.timestamp != nil{
            dateLabel.text = Utility.getTimeStamp(byDate: model.timestamp!)
        }
        else{
            dateLabel.text = "Now"
        }
    }
}
