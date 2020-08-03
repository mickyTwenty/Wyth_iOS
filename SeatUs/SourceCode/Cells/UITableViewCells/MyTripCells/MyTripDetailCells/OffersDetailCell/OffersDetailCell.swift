//
//  OffersDetailCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol OffersDetailCellDelegate : class  {
    func onClickProfileButton(_ sender: Any,tag: Int)
}


class OffersDetailCell: UITableViewCell {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var licenseNumberLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var licenseHeadingLabel: UILabel!
    @IBOutlet weak var vehicleHeadingLabel: UILabel!
    var state : OfferDetailsCellState? = nil
    weak var delegate : OffersDetailCellDelegate!
    var showCancelledView = false
    
    @IBOutlet weak var cancelledHeadingLabel: UILabel!
    @IBOutlet weak var cancelledLabel: UILabel!
    @IBOutlet weak var profileButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @IBAction func profileButtonTapped(_ sender: UIButton){
        
        if delegate != nil{
            delegate.onClickProfileButton(sender, tag: self.tag)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !showCancelledView {
            hideCancelledView()
        }
        
    }
    
    func initiliazeCell(object:AnyObject){
        
        if Utility.isDriver(){
            setPassengerAttributes(object: object)
        }else{
            setDriverAttributes(object: object)
        }
        
        if let trip = object as? Trip, let driver = trip.driver {
            
            cancelledLabel.text = String(driver.trips_canceled_driver?.intValue ?? 0)
            
        }
        
        /*
        switch (state){
            
        case OfferDetailsCellState.isComingFromOffers?:
            
            if Utility.isDriver(){
                setPassengerAttributes(object: object)
            }else{
                setDriverAttributes(object: object)
            }
            break
            
        case OfferDetailsCellState.isComingFromPastTrips?:
            break

        case OfferDetailsCellState.isComingFromUpcomingTrips?:
            if Utility.isDriver(){
                setPassengerAttributes(object: object)
            }else{
                setDriverAttributes(object: object)
            }

            break

        default :
            break
        }
 */

    }
    
    func setDriverAttributes(object: AnyObject){
        headingLabel.text = MyTripsConstant.DriverHeading
        driverNameLabel.text = (object.driver??.first_name)! + " " + (object.driver??.last_name)!
        licenseNumberLabel.text = object.driver??.vehicle_id_number
        vehicleTypeLabel.text = object.driver??.vehicle_type
        profileImageView.imageUrl = object.driver??.profile_picture ?? ""
        if let ratingTemp = object.driver??.rating{
            ratingView.rating = ratingTemp.floatValue
        }
    }
    
    func setPassengerAttributes(object: AnyObject){
        headingLabel.text = MyTripsConstant.PassengerHeading
        driverNameLabel.text = (object.passenger??.first_name)! + " " + (object.passenger??.last_name)!
        licenseHeadingLabel.text = MyTripsConstant.NoOfBagsHeading
        licenseNumberLabel.text = String(describing : (object.passenger??.bags_quantity ?? 0))
        vehicleTypeLabel.isHidden = true
        vehicleHeadingLabel.isHidden = true
        profileImageView.imageUrl = object.passenger??.profile_picture ?? ""
        
        if let ratingTemp = object.passenger??.rating{
            ratingView.rating = ratingTemp.floatValue
        }

    }

    
    func hideRatingView(){
        ratingView.isHidden = true
        ratingView.heightAnchor.constraint(equalToConstant: 0)
        ratingView.widthAnchor.constraint(equalToConstant: 0)
    }
    
    func hideCancelledView(){
        cancelledHeadingLabel.isHidden = true
        cancelledLabel.isHidden = true
        cancelledHeadingLabel.heightAnchor.constraint(equalToConstant: 0)
        cancelledLabel.heightAnchor.constraint(equalToConstant: 0)
    }
    
}
