//
//  FindRidesCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 16/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol FindRidesCellDelegate : class  {
    func onClickRideDetail(_ sender: Any)
    func onClickBookNow(_ sender: Any)
}

class FindRidesCell: UITableViewCell {

    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var destinationlabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var originlabel: UILabel!
    @IBOutlet weak var tripNameLable : UILabel!
    @IBOutlet weak var userTypeLable : UILabel!

    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    
    weak var delegate : FindRidesCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.imageName = AssetsName.ProfilePlaceHolderImage
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCell(_ model: [String:Any]){
        driverNameLabel.text = model["drivername"] as? String
        destinationlabel.text = model["destination"] as? String
        profileImageView.imageName = model["profilepic"] as! String
        ratingView.rating = model["rating"] as! Float
        distanceLabel.text = "\(model["distance"] as! Int) miles"
    }

    func initializeCell(_ trip: SearchTrip){
        
        selectionStyle = .none
        var profileImageUrl = ""
        var rating: Float = 0.0
        
        if Utility.isDriver(){
            userTypeLable.text = MyTripsConstant.PassengerHeading
            if let passenger = trip.passenger {
                if let name = passenger.first_name {
                    profileImageUrl = passenger.profile_picture ?? ""
                    driverNameLabel.text = (name) + " " + (passenger.last_name  ?? "")
                }
                rating = passenger.rating?.floatValue ?? 0
            }
        }
        else{
            userTypeLable.text = MyTripsConstant.DriverHeading
            if let driver = trip.drive {
                if let name = driver.first_name {
                    profileImageUrl = driver.profile_picture ?? ""
                    driverNameLabel.text = (name) + " " + (driver.last_name  ?? "")
                }
                rating = driver.rating?.floatValue ?? 0
            }
        }
        
        if let url = URL(string: (profileImageUrl)){
            profileImageView.profileImageView.af_setImage(withURL: url)
        }
        
        originlabel.text = trip.origin_title
        destinationlabel.text = trip.destination_title
        ratingView.rating = rating
        distanceLabel.text = "\(trip.expected_distance_format ?? "") "
        tripNameLable.text = trip.getTripIdOrTripName()
        
        dateLabel.text = "--:--"
        if(!(trip.start_time?.contains("00:00:00") ?? true)) {
            dateLabel.text = Utility.getFormatedDate(sourceDate: trip.start_time!, sourceDateFormat: ApplicationConstants.DateTimeServerFormat, destinationDateFormat: ApplicationConstants.TimeFormat_12)
        }
        
        // Doing seat maths while unpacking integers
        let seatsTotal  = trip.seats_total?.intValue ?? 0
        let seatsAvailable  = trip.seats_available?.intValue ?? 1
        let seatsFilled = seatsTotal - seatsAvailable
        let text1 = "\(seatsFilled) of "
        let text2 = "\(seatsTotal) seats filled"
        seatsLabel.text = text1 + text2
    }

    @IBAction func onClickRideDetail(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickRideDetail(sender)
        }
    }
    
    @IBAction func onClickBookNow(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickBookNow(sender)
        }
    }
    
}
