//
//  InvitedFriendCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class InvitedFriendCell: UITableViewCell {

    @IBOutlet weak var friendPictureImageView: ProfileImageView!
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDetails(OfFriend friend: Friend){
        
        let url = URL(string: friend.profile_picture!)
        self.friendPictureImageView.profileImageView.af_setImage(withURL: url!)
        friendNameLabel.text = (friend.first_name)! + " "   + friend.last_name! as? String
        
        switch friend.status?.intValue {
            
        case FriendInvitedState.Accepted.rawValue?:
            friendStatusLabel.text = ApplicationConstants.AcceptedText
            friendStatusLabel.textColor = UIColor.green

            break
        case FriendInvitedState.Pending.rawValue?:
            friendStatusLabel.text = ApplicationConstants.PendingText
            friendStatusLabel.textColor = ApplicationConstants.OrangeColor

            break

        case FriendInvitedState.Rejected.rawValue?:
            friendStatusLabel.text = ApplicationConstants.RejectedText
            friendStatusLabel.textColor = UIColor.red
            break

            
        default:
            friendStatusLabel.text = ApplicationConstants.PendingText
            friendStatusLabel.textColor = ApplicationConstants.OrangeColor
            break
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
