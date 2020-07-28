//
//  TextFieldView.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/11/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldView: UIView,UITextFieldDelegate {

    var contentView:TextFieldView?
    @IBOutlet weak var customTxtField: UITextField!
    @IBOutlet weak var titleImageView: UIImageView!


    @IBInspectable var nibName:String?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable internal var title: String = "" {
        didSet {
            contentView?.customTxtField.text = title
        }
    }

    @IBInspectable internal var imageName: String = "" {
        didSet {
            contentView?.titleImageView.image = UIImage(named: imageName)
        }
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        let castView : TextFieldView = view as! TextFieldView
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView?.customTxtField.delegate=self;
        contentView = castView
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Begin
        print("textFieldDidBeginEditing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // End
        print("textFieldDidEndEditing")
        self.contentView?.title = textField.text!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Return
        print("textFieldShouldReturn")
        return true
    }

}
