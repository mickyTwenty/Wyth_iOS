//
//  SelectNumbersView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 14/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol SelectNumbersViewDelegate: class {
    func clickEvent(_ tag:Int,SeatsCount seats: Int)
    func seatsLimit(WarningMessage message: String)
}

@IBDesignable class SelectNumbersView: UIView {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bulletImageView: UIImageView!
    
    @IBOutlet weak var leadingHeadingLabel: NSLayoutConstraint!
    @IBOutlet weak var leadingBulletView: NSLayoutConstraint!
    
    
    @IBInspectable var minimumLimit: Int = 0 {
        didSet {
            if countLabel != nil {
                countLabel.text = "\(minimumLimit)"
            }
        }
    }
    @IBInspectable var maximumLimit: Int = 10
    @IBInspectable var heading: String = "" {
        didSet {
            if headingLabel != nil {
                headingLabel.text = heading
            }
        }
    }
    @IBInspectable var image: UIImage?
    
    var contentView:UIView?
    weak var delegate: SelectNumbersViewDelegate?
    
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
        contentView = loadViewFromNib(SelectNumbersView.nameOfClass())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
        
        headingLabel.text = heading
        countLabel.text = "\(minimumLimit)"
        if let image = image {
            selectionImageView.image = image
        }
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    
    @IBAction func minusButtonClicked(_ sender: Any) {
        let seats = seatsCount(-1)
        if seats != countLabel.text {
            countLabel.text = seats
            seatsChanged()
        }
        else {
            warningMessage()
        }
        
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        let seats = seatsCount(+1)
        if seats != countLabel.text {
            countLabel.text = seats
            seatsChanged()
        }
        else {
            warningMessage()
        }
    }
    
    func seatsCount(_ num: Int)-> String{
        let count = Int(countLabel.text!)! + num
        return (minimumLimit...maximumLimit ~= count) ? ("\(count)") : (countLabel.text)!
    }
    
    func seatsChanged(){
        if delegate != nil {
            delegate?.clickEvent(self.tag, SeatsCount: Int(countLabel.text!)!)
        }
    }
    
    func warningMessage(){
        if delegate != nil {
            delegate?.seatsLimit(WarningMessage: "Seats range limited.")
        }
    }
    
    func hideBulletView(){
        bulletImageView.isHidden = true
        leadingBulletView.constant = 0
//        bulletImageView.heightAnchor.constraint(equalToConstant: 0)
//        bulletImageView.widthAnchor.constraint(equalToConstant: 0)
    }

    func hideHeadingLabel(){
        headingLabel.isHidden = true
        headingLabel.heightAnchor.constraint(equalToConstant: 0)
        headingLabel.widthAnchor.constraint(equalToConstant: 0)
    }
    
}
