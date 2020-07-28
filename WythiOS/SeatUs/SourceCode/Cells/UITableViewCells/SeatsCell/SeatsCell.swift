//
//  SeatsCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SeatsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeButtonView: BadgeButtonView!
    var conditions: [SeatsCondition]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: PostTrip){
        titleLabel.text = model.title + " : "
        conditions = SeatsCondition.getSeatsCondition(model.conditions)
        setConditions(0)
    }
    
    func initializeCell(_ model: TripPlistEntity){
        titleLabel.text = model.title + " : "
        print(model.conditions)
        conditions = SeatsCondition.getSeatsCondition(model.conditions)
        setConditions(0)
    }

    
    func setConditions(_ index: Int){
       let condition = conditions[index]
       badgeButtonView.titleLabel.text = condition.text
        badgeButtonView.countLabel.text = condition.seatscount
       badgeButtonView.circleImage.image = UIImage(named: condition.circleimage)
       badgeButtonView.backgroundImage.image = UIImage(named: condition.backgroundimage)
    }
    
}
