//
//  UpcomingTripDriverCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/27/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit


class UpcomingTripDriverCell: UITableViewCell {

    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var tripNameLable: UILabel!
    @IBOutlet weak var originLable: UILabel!
    @IBOutlet weak var destinationLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    weak var delegate : UpComingTripsCellDelegate!
    @IBOutlet weak var profileImageView: ProfileImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func onClickViewDetail(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickViewDetail(UpComingTripsCell: self.tag,sender)
        }
    }
    
    func setDetails(trip:  Trip){
        originLable.text = trip.origin_title
        destinationLable.text = trip.destination_title
        dateLable.text = trip.date
        
        if (trip.driver != nil) && (trip.driver!.first_name != nil) {
            headingLabel.isHidden = false
            tripNameLable.isHidden = false
            headingLabel.text = MyTripsConstant.DriverHeading
            tripNameLable.text = (trip.driver!.first_name ?? "") + " " + (trip.driver!.last_name ?? "")
            profileImageView.imageUrl = trip.driver!.profile_picture!
        }
        else {
            headingLabel.isHidden = true
            tripNameLable.isHidden = true
            headingLabel.text = ""
            tripNameLable.text = ""
            profileImageView.imageName = AssetsName.NoDriverImage
        
    
        originLable.text = trip.origin_title
        destinationLable.text = trip.destination_title
            
        seatsLabel.text = String(Passenger.getAvailableSeats(passengers: (trip.passengers)!)) + " of " +  (trip.seats_total?.stringValue)! + " seats filled"
            
        dateLable.text = trip.date
        if(!(trip.start_time?.contains("00:00:00") ?? true)) {
            let localTime = trip.start_time
            let convertedTime = Utility.getFormatedDate(sourceDate: trip.start_time!, sourceDateFormat: ApplicationConstants.DateTimeServerFormat, destinationDateFormat: ApplicationConstants.TimeFormat_12)
            let dateTime = trip.date! + " - " + convertedTime
            dateLable.text = dateTime
        }
            
        if (trip.driver?.first_name) != nil {
            userTypeLabel.text = "Driver Name: "
            tripNameLable.text = (trip.driver?.first_name)! + " " + (trip.driver?.last_name)!
            self.profileImageView.imageUrl = trip.driver?.profile_picture ?? ""
        }
        else{
            userTypeLabel.text = "Trip ID"
            tripNameLable.text = (trip.trip_id?.stringValue)!
        }
        
    }

        func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
}
