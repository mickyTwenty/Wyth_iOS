//
//  MessagingInfoCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 28/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol MessagingInfoCellDelegate : class  {
    func onClickRideDetail(MessagingInfoCellIndex index: Int, _ sender: Any)
    func onClickGroupChat(MessagingInfoCellIndex index: Int, _ sender: Any)
}

class MessagingInfoCell: UITableViewCell {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var tripNameLable: UILabel!
    @IBOutlet weak var originLable: UILabel!
    @IBOutlet weak var destinationLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    weak var delegate : MessagingInfoCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDetails(trip:  Trip){
        tripNameLable.text = trip.getTripIdOrTripName()
        originLable.text = trip.origin_title
        destinationLable.text = trip.destination_title
        dateLable.text = trip.date
        profileImageView.imageUrl = trip.passenger?.profile_picture ?? ""
        ratingView.rating = (trip.rating?.floatValue)!
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
    
}
