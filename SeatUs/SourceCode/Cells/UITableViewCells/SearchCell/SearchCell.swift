//
//  SearchCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var checkMarkButton : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDetails(OfFriend friend: FriendsConnected){
        
        if let url = URL(string: friend.profile_picture ?? "") {
            self.userImageView.af_setImage(withURL: url)
        }
        self.userImageView.setRounded()
        self.nameLable.text = friend.first_name! + " "  + friend.last_name!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
