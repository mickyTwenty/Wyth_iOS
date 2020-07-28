//
//  ActionDetailsCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol ActionDetailsCellDelegate : class  {
    func onClickViewMap(_ sender: Any)
    func onClickShare(_ sender: Any)
}

class ActionDetailsCell: UITableViewCell {

    weak var delegate : ActionDetailsCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickViewMap(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickViewMap(sender)
        }
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickShare(sender)
        }
    }
    
    
}
