//
//  PastTripsCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 06/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol PastTripsCellDelegate : class  {
    func onClickViewDetail(PastTripsCell index: Int,_ sender: Any)
}

class PastTripsCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    weak var delegate : PastTripsCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickViewDetail(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickViewDetail(PastTripsCell: self.tag,sender)
        }
    }
    
    func setDetails(trip:  Trip){
        tripLabel.text = trip.getTripIdOrTripName()
        if Utility.isDriver() {
            headingLabel.text = MyTripsConstant.PassengerHeading
            nameLabel.text = "Captain Jack"
            profileImageView.imageUrl = ""
        }
        else {
            headingLabel.text = MyTripsConstant.DriverHeading
            nameLabel.text = trip.driver?.first_name ?? "Captain Jack"
            profileImageView.imageUrl = trip.driver?.profile_picture ?? ""
        }
    }
    
}
