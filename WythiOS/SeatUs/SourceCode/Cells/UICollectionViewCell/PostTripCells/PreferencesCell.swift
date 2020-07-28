//
//  PreferencesCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol PreferencesCellDelegate: class {
    func clickEvent(_ tag: Int, selectedStates: [Int:Bool])
}

class PreferencesCell: UICollectionViewCell {
    
    @IBOutlet weak var prefrenceTitleLbl : UILabel!
    @IBOutlet weak var checkmarkButtonLeft : CheckBoxView!
    @IBOutlet weak var checkmarkButtonRight : CheckBoxView!
    
    var selectedStates = [Int:Bool]()
    weak var delegate: PreferencesCellDelegate?
    
    enum Options: String {
        case label = "label"
        case options = "options"
        case title = "title"
        case checked = "checked"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkmarkButtonLeft.delegate = self
        checkmarkButtonRight.delegate = self
    }
    
    func setDetails(OfPreference object: [String:Any]) {
        
        self.prefrenceTitleLbl.text = (object[Options.title.rawValue] as! String)
        var options = object[Options.options.rawValue] as! [[String:Any]]
        
        let firstOption = options[0]
        let secondOption = options[1]
        
        let firstOptionTag = 5
        let secondOptionTag = 10
        
        if firstOption[Options.checked.rawValue] != nil {
            selectedStates[firstOptionTag] = firstOption[Options.checked.rawValue]! as? Bool
        }
        else {
            selectedStates[firstOptionTag] = false
        }
        
        if secondOption[Options.checked.rawValue] != nil {
            selectedStates[secondOptionTag] = secondOption[Options.checked.rawValue]! as? Bool
        }
        else {
            selectedStates[secondOptionTag] = false
        }
        
        self.checkmarkButtonLeft.tag = firstOptionTag
        self.checkmarkButtonLeft.titleLabel.text = firstOption[Options.label.rawValue] as? String
        self.checkmarkButtonRight.tag = secondOptionTag
        self.checkmarkButtonRight.titleLabel.text = secondOption[Options.label.rawValue] as? String
        self.checkmarkButtonLeft.setCheckBoxState(selectedStates[firstOptionTag]!)
        self.checkmarkButtonRight.setCheckBoxState(selectedStates[secondOptionTag]!)
    }
}

extension PreferencesCell: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        selectedStates[tag] = isSelected
        if delegate != nil {
            delegate?.clickEvent(self.tag, selectedStates: selectedStates)
        }
    }
}
