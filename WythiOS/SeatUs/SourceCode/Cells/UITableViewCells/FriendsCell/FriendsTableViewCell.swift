//
//  FriendsTableViewCell.swift
//  Friends
//
//  Created by Syed Muhammad Muzzammil on 27/10/2017.
//  Copyright © 2017 Syed Muhammad Muzzammil. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendPictureImageView: ProfileImageView!
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var mutualFriendsLabel: UILabel!
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    func setDetails(OfFriend friend: FriendsConnected){
        
        let url = URL(string: friend.profile_picture!)
        self.friendPictureImageView.profileImageView.af_setImage(withURL: url!)
        friendNameLabel.text = friend.first_name! + " " + friend.last_name!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
