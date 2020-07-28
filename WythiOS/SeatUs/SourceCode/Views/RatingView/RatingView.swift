//
//  RatingView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 16/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

@IBDesignable class RatingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @IBInspectable var inActiveImageName: String = AssetsName.InActiveStarImage {
        didSet {
            emptyStar = inActiveImageName
            setInActiveImages()
        }
    }
    
    var emptyStar = AssetsName.InActiveStarImage
    var filledStar = AssetsName.ActiveStarImage
    var halfStar = AssetsName.HalfActiveStarImage
    
    
    
    var rating: Float = 0 {
        didSet {
            if rating > 5 {
                rating = 5
            }
            else if rating < 0 {
                rating = 0
            }
            setRating()
        }
    }
    
    var contentView:UIView?
    
    func xibSetup() {
        contentView = loadViewFromNib(RatingView.nameOfClass())
        contentView?.frame = bounds
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView!)
        
        if self.tag == 110 {
            
            emptyStar = "inactive_grey_rating_star_b"
            filledStar = "active_rating_star_b"
            halfStar = "half_active_greay_rating_star_b"
            
        }
        setInActiveImages()
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
    
    func setRating(){
        let rateCount = String(rating-1).split(separator: ".")
        let rateIndex = Int(rateCount[0])!
        let halfIndex = Int(rateCount[1])!
        if 0.5...5 ~= rating {
            var viewTag = 0
            for index in 0..<5 {
                viewTag += 5
                if let view = contentView?.viewWithTag((viewTag)) {
                    let imageView = view as! UIImageView
                    var selectedImage: String?
                    if ( index == Int(rating) && halfIndex != 0 ) {
                        selectedImage = halfStar
                    }
                    else if (index <= rateIndex) {
                        selectedImage = filledStar
                    }
                    else {
                        selectedImage = emptyStar
                    }
                    imageView.image = getImage(named: selectedImage!)
                }
            }
        }
    }
    
    func setInActiveImages(){
        for image in (contentView?.subviews)! {
            if image is UIImageView {
                (image as! UIImageView).image = getImage(named: emptyStar)
            }
        }
    }
    
    func setButtonsTarget(){
        for imageView in (contentView?.subviews)! {
            if imageView is UIImageView {
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(RatingView.ratingButtonClicked(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTap)
            }
        }
    }
    
    @objc func ratingButtonClicked(_ sender: UITapGestureRecognizer) {
        rating = Float(sender.view!.tag / 5)
    }
    
}
