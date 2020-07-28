//
//  RoundTripTimeZoneCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/29/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class RoundTripTimeZoneCell: TimeZoneCell {

    @IBOutlet weak var returnMultipleCheckBoxView: MultipleCheckBoxView!
    @IBOutlet weak var returnSelectNumbersView: SelectNumbersView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func initialize(_ object: PostTrip){
        super.initialize(object)
        returnMultipleCheckBoxView.initialize()
        returnMultipleCheckBoxView.delegate = self
        returnSelectNumbersView.delegate = self
        returnSelectNumbersView.tag = 1
        returnMultipleCheckBoxView.tag = 1
        setThresholdDay()
    }
    
    override func setThresholdDay(){
        super.setThresholdDay()
        if let thresholdDay = postTrip.title {
            returnMultipleCheckBoxView.thresholdDay = thresholdDay
            returnMultipleCheckBoxView.setStateFromThresholdDay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        returnSelectNumbersView.hideBulletView()
        returnSelectNumbersView.countLabel.textColor = .white
        returnSelectNumbersView.bulletImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        returnSelectNumbersView.leadingHeadingLabel.constant = 0
    }
    
    override func clickEvent(_ tag: Int, ThresholdDay thresholdDay: String) {
        super.clickEvent(tag, ThresholdDay: thresholdDay)
    }
    
    override func clickEvent(_ tag: Int, SeatsCount seats: Int) {
        super.clickEvent(tag, SeatsCount: seats)
    }
    
    override func noSeatBackground(){
        bgImageView.image = UIImage(named: "departure_arrival_bg_noseats")
    }
    
    override func hideSeats(){
        super.hideSeats()
        returnSelectNumbersView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        returnSelectNumbersView.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
}
