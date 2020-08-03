//
//  InvitedDriverCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 1/11/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class InvitedDriverCell: UITableViewCell {

    
    @IBOutlet weak var pictureImageView: ProfileImageView!
    
    @IBOutlet weak var nameLabe: UILabel!
    
    @IBOutlet weak var seatsLable: UILabel!
    
    @IBOutlet weak var statusLable: UILabel!

    @IBOutlet weak var returningSeatsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func initializeCell(_ model: Driver){
        
        nameLabe.text = (model.first_name)! + (model.last_name)!
        var seatsText = "0"
        if let text = model.seats?.stringValue{
            seatsText = text
        }
        seatsLable.text = seatsText
        returningSeatsLabel.text = model.seats_returning?.stringValue ?? "0"
        let url = URL(string: model.profile_picture!)
        pictureImageView.profileImageView.af_setImage(withURL: url!)
        
        switch model.status?.intValue {
            
        case FriendInvitedState.Accepted.rawValue?:
            statusLable.text = ApplicationConstants.AcceptedText
            statusLable.textColor = UIColor.green
            
            break
        case FriendInvitedState.Pending.rawValue?:
            statusLable.text = ApplicationConstants.PendingText
            statusLable.textColor = ApplicationConstants.OrangeColor
            
            break
            
        case FriendInvitedState.Rejected.rawValue?:
            statusLable.text = ApplicationConstants.RejectedText
            statusLable.textColor = UIColor.red
            break
            
            
        default:
            statusLable.text = ApplicationConstants.PendingText
            statusLable.textColor = ApplicationConstants.OrangeColor
            break
        }


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
