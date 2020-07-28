//
//  PassengerRatingCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 31/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol PassengerRatingCellDelegate : class  {
    func onRateNowClicked(_ sender: Any, tag: Int)
}

class PassengerRatingCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var headingRatingsLabel: UILabel!
    @IBOutlet weak var headingTripNameLabel: UILabel!
    @IBOutlet weak var contentTripNameLabel: UILabel!
    
    @IBOutlet weak var ratingParentView: UIView!
    @IBOutlet weak var tripParentView: UIView!
    @IBOutlet weak var contentOriginLabel: UILabel!
    @IBOutlet weak var contentDestinationLabel: UILabel!
    @IBOutlet weak var contentDateLabel: UILabel!
    
    weak var delegate : PassengerRatingCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: AnyObject, ratings: [RateModel], trip: Trip? = nil){
        nameTextField.text = (model.first_name ?? "") + " " + (model.last_name ?? "")
        profileImageView.imageUrl = model.profile_picture ?? ""
        
        if let trip = trip {
            contentOriginLabel.text = trip.origin_title
            contentDestinationLabel.text = trip.destination_title
            contentDateLabel.text = trip.date ?? trip.start_time
        }
        
        var user_id: NSNumber!
        
        if model is Passenger {
            user_id = (model as! Passenger).user_id
        }
        
        if model is Driver {
            user_id = (model as! Driver).user_id
        }
        
        
        
        var rating: Float = 0.0
        
        if let rate = ratings.filter( { $0.user_id == user_id.stringValue && ((trip == nil) ? true : ($0.trip_id == trip?.trip_id?.stringValue)) } ).first {
            rating = Float(rate.rating) ?? 0.0
        }
        
        if rating > 0.0 {
            ratingParentView.isHidden = false
        }
        else {
            ratingParentView.isHidden = true
        }
        
        ratingView.rating = rating
        
        if trip == nil {
            tripParentView.isHidden = true
        } else {
            tripParentView.isHidden = false
            contentTripNameLabel.text = trip?.getTripIdOrTripName()
        }
        

    }
    
    @IBAction func onRateNowClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.onRateNowClicked(sender, tag: self.tag)
        }
    }
}
