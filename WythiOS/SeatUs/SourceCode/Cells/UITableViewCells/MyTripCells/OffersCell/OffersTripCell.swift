//
//  OffersTripCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 06/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol OffersTripCellDelegate : class  {
    func onClickOffersDetail(OffersTripCell index: Int, _ sender: Any,atSection:Int)
}

class OffersTripCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var originLable: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    @IBOutlet weak var profileImageView: ProfileImageView!
    var section: Int!
    
    weak var delegate : OffersTripCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickViewDetail(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickOffersDetail(OffersTripCell: self.tag,sender,atSection:section)
        }
    }
    
    func setDetails(trip:  Trip){
        tripLabel.text = trip.getTripIdOrTripName()
        originLable.text = trip.origin_title
        destinationLabel.text = trip.destination_title

        if Utility.isDriver() {
            headingLabel.text = MyTripsConstant.PassengerHeading
            nameLabel.text = (trip.passenger?.first_name)! + " " + (trip.passenger?.last_name)!
            profileImageView.imageUrl = trip.passenger?.profile_picture ?? ""
            
        }
        else {
            headingLabel.text = MyTripsConstant.DriverHeading
            nameLabel.text = (trip.driver?.first_name)! + " " + (trip.driver?.last_name)!
            profileImageView.imageUrl = trip.driver?.profile_picture ?? ""
        }
    }
}
