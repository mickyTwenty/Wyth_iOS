//
//  ItineraryDetailsCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 28/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ItineraryDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetails(OfFriend friend: Friend){
        nameLabel.text = friend.full_name
        emailLabel.text = friend.email
        phoneLabel.text = friend.phone
    }

}
