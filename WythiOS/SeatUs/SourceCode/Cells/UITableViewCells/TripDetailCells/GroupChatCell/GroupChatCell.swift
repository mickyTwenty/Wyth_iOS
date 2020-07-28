//
//  GroupChatCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol GroupChatCellDelegate : class  {
    func viewSeatButtonClicked(_ sender: Any)
    func groupChatButtonClicked(_ sender: Any)
}

class GroupChatCell: UITableViewCell {

    weak var delegate : GroupChatCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewSeat(_ sender: Any) {
        if delegate != nil {
            delegate?.viewSeatButtonClicked(sender)
        }
    }
    
    @IBAction func groupChat(_ sender: Any) {
        if delegate != nil {
            delegate?.groupChatButtonClicked(sender)
        }
    }
    
}
