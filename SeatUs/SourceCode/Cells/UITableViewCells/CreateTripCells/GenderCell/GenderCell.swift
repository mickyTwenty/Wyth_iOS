//
//  GenderCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/28/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {

    var postTrip: PostTrip!
    var vc: UIViewController!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initialize(_ object: PostTrip, vc: UIViewController){
        postTrip = object
        self.vc = vc
        genderLabel.text = postTrip.placeholdertext
    }

    @IBAction func onAlertActionButtonClicked(_ sender: Any) {
        Utility.selectDropDown(label: genderLabel, array: Utility.getGenderArrayForRidePrephences(), title: postTrip.title, vc: vc, object: postTrip)
    }
}
