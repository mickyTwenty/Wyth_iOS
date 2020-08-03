//
//  CheckboxCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol MultipleCheckboxCellDelegate: class {
    func clickEvent(_ tag:Int,CheckboxStates checkboxStates: [CheckboxState])
    func rideTimeButtonClicked()
}

class MultipleCheckboxCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rideTimeButton: UIButton!
    @IBOutlet var checkBoxViews: [CheckBoxView]!
    
    var checkboxStates: [CheckboxState]?
    
    weak var delegate: MultipleCheckboxCellDelegate?
    
    var isSelectAllOption = true
    
    var isEnabled = true {
        didSet  {
            for checkBoxView in checkBoxViews {
                checkBoxView.isEnabled = isEnabled
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for checkBoxView in checkBoxViews {
            checkBoxView.delegate = self as CheckBoxViewDelegate
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: AnyObject){
        titleLabel.text = model.title + ": "
        checkboxStates = CheckboxState.getCheckboxState(model.checkboxes)
        isSelectAllOption = ((checkboxStates?.count)! == 4)
        let optionsCount = ((checkboxStates?.count)! <= 4) ? checkboxStates?.count : 4
        
        for checkBoxView in checkBoxViews {
            if checkBoxView.tag >= optionsCount! {
                checkBoxView.isHidden = true
                checkBoxView.checkBoxButton.isEnabled = false
                continue
            }
            checkBoxView.label = checkboxStates![checkBoxView.tag].text
            setCheckBoxStates([checkBoxView.tag], isSelected: Bool(truncating: checkboxStates![checkBoxView.tag].isselected))
            if checkBoxView.tag == 3 {
                checkBoxView.checkBoxButton.setImage(UIImage(named: AssetsName.AllDayImage), for: .normal)
                checkBoxView.checkImageView.isHidden = true
                checkBoxView.titleLabel.isHidden = true
            }
        }
        
    }
    
    func setCheckBoxStates(_ indexes: [Int] ,isSelected: Bool){
        for checkBoxView in checkBoxViews {
            if indexes.contains(checkBoxView.tag){
                if isSelected {
                    checkBoxView.setCheckBoxState(isSelected)
                }
            }
        }
    }
    
    func currentStates() -> Bool{
        var states = [Bool]()
        for checkBoxView in checkBoxViews {
            if checkBoxView.tag != 3 {
                states.append(checkBoxView.checkBoxButton.isSelected)
            }
        }
        return (states.filter{$0 == true}.count == 3) ? (true) : (false)
    }
    
    func updateStates(){
        for checkBoxView in checkBoxViews {
            if checkBoxView.tag < (checkboxStates?.count)! {
                checkboxStates![checkBoxView.tag].isselected = checkBoxView.isSelected as NSNumber
            }
        }
        if delegate != nil {
            delegate?.clickEvent(self.tag, CheckboxStates: checkboxStates!)
        }
    }
    
    @IBAction func rideTimeButtonClicked(_ sender: Any) {
        if delegate != nil {
            delegate?.rideTimeButtonClicked()
        }
    }

    
}

extension MultipleCheckboxCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        if isSelectAllOption {
            if tag == 3 {
                setCheckBoxStates( [0,1,2], isSelected: true)
            }
            else {
                setCheckBoxStates( [3], isSelected: currentStates())
            }
        }
        updateStates()
    }
}
