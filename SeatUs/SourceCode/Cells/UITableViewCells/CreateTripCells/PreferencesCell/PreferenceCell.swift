//
//  PreferenceCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/28/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PreferenceCell: UITableViewCell {

    var postTrip: PostTrip!
    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet weak var leftLable:UILabel!
    @IBOutlet weak var rightLable:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(_ object: PostTrip){
        postTrip = object
        leftLable.text = object.placeholdertext
        checkBoxView.delegate = self
        checkBoxView.label = object.text
        postTrip.isselected = postTrip.isselected ?? NSNumber(booleanLiteral: false)
        checkBoxView.setCheckBoxState(postTrip.isselected.boolValue)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension PreferenceCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        postTrip.isselected = NSNumber(booleanLiteral: isSelected)
    }
}
