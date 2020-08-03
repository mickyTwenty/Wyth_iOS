//
//  RouteSelectionCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 21/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class RouteSelectionCell: UITableViewCell {

    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var possiblePassengerLabel: UILabel!
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var listingIconImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet var trailingConstraintOnTimeLbl: NSLayoutConstraint!
    @IBOutlet var leadingConstraintOnTimeLbl: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDetails(route:Route,freindType:AddingFreinds){
        
        routeNameLabel.text = route.summary
        distanceLabel.text = Utility.getFormatedDistance(distanceMiles: Route.getTotalDistance(object: route))
        durationLabel.text = Utility.getFormatedTimeFromSeconds(seconds: Route.getTotalTime(object: route))
        seatsLabel.text = "\(route.popularity)"


        switch (freindType){
            
        case .isComingForDriverOnly:
            hidePopularity()
            break
            
        default:
            showPopularity()
            break
        }
    }
    
    func showPopularity(){
        
    }
    
    func hidePopularity(){
        leadingConstraintOnTimeLbl.isActive = true
        trailingConstraintOnTimeLbl.isActive = false
        circleImageView.isHidden = true
        possiblePassengerLabel.isHidden = true
        listingIconImageView.isHidden = true
        seatsLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
