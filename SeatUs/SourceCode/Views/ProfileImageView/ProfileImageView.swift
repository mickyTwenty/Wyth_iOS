//
//  ProfileImageView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 17/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

@IBDesignable class ProfileImageView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    var imageName: String = AssetsName.ProfilePlaceHolderImage {
        didSet {
            updateImage()
        }
    }
    
    var imageUrl: String = "" {
        didSet {
//            imageUrl = "http://34.213.248.253/frontend/images/profile/14269-9LM3q0DFu9s4.jpeg"
            if let url = URL(string: imageUrl) {
                profileImageView.af_setImage(withURL: url)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.3 {
        didSet {
            profileImageView.setRounded(cornerRadius)
        }
    }
    
    var contentView:UIView?
    
    func xibSetup() {
        contentView = loadViewFromNib(ProfileImageView.nameOfClass())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
        updateImage()
        profileImageView.setRounded(0.3)
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func getImage(named: String) -> UIImage {
        let bundle = Bundle(for: type(of: self))
        return UIImage(named: named, in: bundle, compatibleWith: self.traitCollection) ?? UIImage()
    }
    
    func updateImage(){
        profileImageView.image = getImage(named: imageName)
    }
    
}
