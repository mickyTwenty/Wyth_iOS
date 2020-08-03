//
//  PopUpAlertView.swift
//  SeatUs
//
//  Created by Qazi Naveed on 1/2/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PopUpAlertView: UIView {

    
    @IBOutlet weak var alertLable: UILabel!
    @IBOutlet weak var alertOkButton: UIButton!
    @IBOutlet weak var doubleButtonsView: UIView!
    @IBOutlet weak var alertYesButton: UIButton!
    @IBOutlet weak var alertNoButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    var contentView:UIView?
    
    func xibSetup() {
        contentView = loadViewFromNib(PopUpAlertView.nameOfClass())
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

    
    @IBAction func okButtonClicked(sender:UIButton){
        print("okButtonClicked")
    }

    @IBAction func onNoButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func onYesButtonClicked(_ sender: Any) {
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
