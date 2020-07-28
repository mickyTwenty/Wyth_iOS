//
//  ShareItinaryCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol ShareItinaryCellDelegate : class  {
    func onClickShare(_ sender: Any)
    func onClickCancelOrLeaveTrip(_ sender: Any)
}


class ShareItinaryCell: UITableViewCell {

    weak var delegate : ShareItinaryCellDelegate!
    @IBOutlet weak var cancelLeaveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Utility.isDriver() {
            setButtonTitleImage(image: AssetsName.CancelRideImage)
        } else {
            setButtonTitleImage(image: AssetsName.LeaveRideImage)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickShare(sender)
        }
    }
    
    @IBAction func onClickCancelOrLeaveTrip(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickCancelOrLeaveTrip(sender)
        }
    }
    
    func setButtonTitleImage(image: String){
        cancelLeaveButton.setImage(UIImage(named: image), for: .normal)
    }
    
}
