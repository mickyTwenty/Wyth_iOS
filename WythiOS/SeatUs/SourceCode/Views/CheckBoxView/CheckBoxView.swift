//
//  CheckBoxView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol CheckBoxViewDelegate:class {
    func clickEvent(_ tag: Int, isSelected: Bool)
}

@IBDesignable class CheckBoxView: UIView {
    
    var contentView:UIView?
    var isEnabled = true
    
    weak var delegate: CheckBoxViewDelegate?
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBInspectable var typeView: Int = 0
    
    var label: String = String() {
        didSet {
            titleLabel.text = label
        }
    }
    
    var isSelected: Bool {
          return checkBoxButton.isSelected
    }

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
    
    func xibSetup() {
        contentView = loadViewFromNib(CheckBoxView.nameOfClass())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        setViewReferences()
        addSubview(contentView!)
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[typeView] as! UIView
        return view
    }
    
    func setViewReferences(){
        for view in (contentView?.subviews[0].subviews)! {
            switch view {
            case is UIImageView:
                checkImageView = view as! UIImageView
                break
            case is UILabel:
                titleLabel = view as! UILabel
                break
            case is UIButton:
                checkBoxButton = view as! UIButton
                break
            default:
                break
            }
        }
    }
    
    func setCheckBoxState(_ isSelected:Bool){
        checkBoxButton.isSelected = isSelected
        checkImageView.isHighlighted = isSelected
    }
    
    @IBAction func clickEvent(_ sender: UIButton) {
        if isEnabled {
            setCheckBoxState(!sender.isSelected)
            if delegate != nil {
                delegate?.clickEvent(self.tag,isSelected: sender.isSelected)
            }
        }
    }
    
}
