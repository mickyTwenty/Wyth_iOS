//
//  MessagingInfoDriverCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/28/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class MessagingInfoDriverCell: UITableViewCell {

    
    @IBOutlet weak var tripNameLable: UILabel!
    @IBOutlet weak var originLable: UILabel!
    @IBOutlet weak var destinationLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    weak var delegate : MessagingInfoCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDetails(trip:  Trip){
        tripNameLable.text = trip.getTripIdOrTripName()
        originLable.text = trip.origin_title
        destinationLable.text = trip.destination_title
        dateLable.text = trip.date
    }
    
    
    @IBAction func onClickRideDetail(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickRideDetail(MessagingInfoCellIndex: self.tag, sender)
        }
    }
    
    @IBAction func onClickGroupChat(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickGroupChat(MessagingInfoCellIndex: self.tag, sender)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
