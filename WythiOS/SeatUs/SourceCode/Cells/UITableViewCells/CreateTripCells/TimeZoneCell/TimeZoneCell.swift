//
//  TimeZoneCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/27/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol TimeZoneCellDelegate: class {
    func thresholdDayClicked(_ tag:Int)
    func seatsClicked(_ tag:Int)
}

class TimeZoneCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    var postTrip: PostTrip!
    
    @IBOutlet weak var selectNumbersView: SelectNumbersView!
    @IBOutlet weak var contentLable : UILabel!
    @IBOutlet weak var multipleCheckboxView: MultipleCheckBoxView!
    
    weak var delegate: TimeZoneCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func noSeatBackground(){
        bgImageView.image = UIImage(named: "single_trip_bg_noseats")
    }
    
    func hideSeats(){
        selectNumbersView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        selectNumbersView.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    func initialize(_ object: PostTrip){
        postTrip = object
        multipleCheckboxView.initialize()
        multipleCheckboxView.delegate = self
        selectNumbersView.delegate = self
        selectNumbersView.tag = 0
        multipleCheckboxView.tag = 0
        setThresholdDay()
    }
    
    func setThresholdDay(){
        if let thresholdDay = postTrip.text {
            multipleCheckboxView.thresholdDay = thresholdDay
            multipleCheckboxView.setStateFromThresholdDay()
        }
    }
    
    override func layoutSubviews() {
        selectNumbersView.hideBulletView()
        selectNumbersView.countLabel.textColor = .white
        selectNumbersView.bulletImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        selectNumbersView.leadingHeadingLabel.constant = 0
    }
    
    func addCheckBox(tag: Int, value: String){
      //  let checkBoxStates = CheckboxState.getCheckboxState(postTrip.checkboxes)
        
    }
    
}

extension TimeZoneCell: MultipleCheckBoxViewDelegate {
    @objc func clickEvent(_ tag: Int, ThresholdDay thresholdDay: String) {
        print(thresholdDay)
        if tag == 0 {
            postTrip.text = thresholdDay
        }
        else if tag == 1 {
            postTrip.title = thresholdDay
        }
      //  addCheckBox(tag: tag,value: thresholdDay)
        
        if delegate != nil {
                delegate?.thresholdDayClicked(self.tag)
        }
    }
}

extension TimeZoneCell: SelectNumbersViewDelegate {
    @objc func seatsLimit(WarningMessage message: String) {
        print(message)
    }
    
    @objc func clickEvent(_ tag: Int, SeatsCount seats: Int) {
        if tag == 0 {
            postTrip.placeholdertext = "\(seats)"
        }
        else if tag == 1 {
            postTrip.expected_start_time = "\(seats)"
        }
        if delegate != nil {
            delegate?.seatsClicked(self.tag)
        }
    }
}





