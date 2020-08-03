//
//  MarkPassengerTripCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 06/02/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol MarkPassengerTripCellDelegate: class {
    func clickEvent(LabelCheckBoxIndex tag: Int, isSelected: Bool)
}

class MarkPassengerTripCell: UITableViewCell {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var checkboxView: CheckBoxView!
    weak var delegate: MarkPassengerTripCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ passenger: Passenger){
        profileImageView.imageUrl = passenger.profile_picture!
        checkboxView.label = (passenger.first_name ?? "") + " " + (passenger.last_name ?? "")
    }
    
}

extension MarkPassengerTripCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        if delegate != nil {
            delegate?.clickEvent(LabelCheckBoxIndex: self.tag, isSelected: isSelected)
        }
    }
}
