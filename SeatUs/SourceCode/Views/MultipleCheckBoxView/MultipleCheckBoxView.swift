//
//  MultipleCheckBoxView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 02/04/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol MultipleCheckBoxViewDelegate: class {
    func clickEvent(_ tag:Int,ThresholdDay thresholdDay: String)
}

@IBDesignable class MultipleCheckBoxView: UIView {
    
    final var thresholdDayStates:[String: [Int]] =
        [
            "7":[0,1,2],
            "6":[1,2],
            "5":[0,2],
            "4":[2],
            "3":[0,1],
            "2":[1],
            "1":[0]
            
    ]
    
    var contentView:UIView?
    var isSelectAllOption = true
    @IBOutlet var checkBoxViews: [CheckBoxView]!
    var thresholdDay = "0"
    weak var delegate: MultipleCheckBoxViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize(){
        let checkBoxTitles = ["Morning", "Afternoon", "Night", ""]
        for checkBoxView in checkBoxViews {
            checkBoxView.delegate = self as CheckBoxViewDelegate
            checkBoxView.label = checkBoxTitles[checkBoxView.tag]
            checkBoxView.titleLabel.font = checkBoxView.titleLabel.font.withSize(17)
            if checkBoxView.tag == 3 {
                checkBoxView.checkBoxButton.setImage(UIImage(named: AssetsName.AnyTimeImage), for: .normal)
                checkBoxView.checkImageView.isHidden = true
                checkBoxView.titleLabel.isHidden = true
            }
        }
        setStateFromThresholdDay()
    }

    func xibSetup() {
        contentView = loadViewFromNib(MultipleCheckBoxView.nameOfClass())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
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
    
    func currentStates() -> [Int]{
        var states = [Int]()
        for checkBoxView in checkBoxViews {
            if checkBoxView.tag != 3 {
                if checkBoxView.checkBoxButton.isSelected {
                    states.append(checkBoxView.tag)
                }
            }
        }
        return states
//        var states = [Bool]()
//        for checkBoxView in checkBoxViews {
//            if checkBoxView.tag != 3 {
//                states.append(checkBoxView.checkBoxButton.isSelected)
//            }
//        }
//        return (states.filter{$0 == true}.count == 3) ? (true) : (false)
    }
    
    func updateStates(){
//        for checkBoxView in checkBoxViews {
//            if checkBoxView.tag < (checkboxStates?.count)! {
//                checkboxStates![checkBoxView.tag].isselected = checkBoxView.isSelected as NSNumber
//            }
//        }
//        if delegate != nil {
//            delegate?.clickEvent(self.tag, CheckboxStates: checkboxStates!)
//        }
    }
    
    func setStateFromThresholdDay(){
        
        if let state = thresholdDayStates[thresholdDay] {
            setCheckBoxStates(state, isSelected: true)
        }
        else {
            setCheckBoxStates([0, 1, 2, 3], isSelected: false)
        }
        
    }
    
}

extension MultipleCheckBoxView: CheckBoxViewDelegate {
    func clickEvent(_ tag: Int, isSelected: Bool) {
        if tag == 3 {
            self.thresholdDay = "7"
        } else if let thresholdDay = thresholdDayStates.filter( { $0.value == currentStates() } ).first {
            self.thresholdDay = thresholdDay.key
        } else {
            self.thresholdDay = "0"
        }
        setStateFromThresholdDay()
        if delegate != nil {
            delegate?.clickEvent(self.tag, ThresholdDay: thresholdDay)
        }
    }
}
