//
//  NotificationCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 29/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: Notifications){
        contentLabel.text = model.data?.data_message
        dateLabel.text = Utility.getDateByTimeStamp(timeStamp: String(describing: model.unix_timestamp!), isFireBase: false, dateFormat: ApplicationConstants.DateTimeFormat_12 )
    }
    
}
