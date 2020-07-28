//
//  ChildSelectionView.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 24/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

protocol ChildSelectionViewDelegate: class {
    func onClickButton(ChildSelectionView index: Int)
}

@IBDesignable class ChildSelectionView: UIView {
    
    private var buttons = [UIButton]()
    private var images = [UIImage]()
    private var imageView: UIImageView?
    
    weak var delegate: ChildSelectionViewDelegate?
    
    @IBInspectable var defaultImage: UIImage? {
        didSet {
            if imageView != nil && defaultImage != nil {
                //       imageView?.image = defaultImage
            }
        }
    }
    
    var defaultIndex: Int? {
        didSet {
            if let index = defaultIndex {
                if index < buttons.count {
                    buttonClickedEvent(sender: buttons[index])
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  setUpImageView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        // setUpImageView()
    }
    
    func initialize(imagesName: [String]){
        for imageName in imagesName {
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        if images.count > 0 {
            setUpButtons(buttonsCount: images.count)
            imageView?.image = images[0]
        }
    }
    
    func initialize(ButtonsTitle title: [String]){
        setUpButtons(buttonsCount: title.count)
        setStateOfButtons()
        for index in 0..<buttons.count {
            buttons[index].setTitle(title[index], for: .normal)
        }
    }
    
    func setStateOfButtons(){
        for button in buttons {
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.setBackgroundImage(UIImage(named: "gray_bg"), for: .normal)
            button.setBackgroundImage(UIImage(named: "black_bg"), for: .selected)
            button.titleLabel?.font = UIFont(name: "Century Gothic", size: 12.0)
        }
    }
    
    func getLeftView(index: Int) -> UIView {
        
        if index == 0 {
            return self
        } else {
            return buttons[index-1]
        }
        
    }
    
    func getRightView(index: Int) -> UIView {
        
        if index == buttons.count - 1 {
            return self
        } else {
            return buttons[index+1]
        }
        
    }
    
    private func setUpImageView(){
        imageView = UIImageView()
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .scaleAspectFit
        self.addSubview(imageView!)
        imageView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setUpButtons(buttonsCount: Int) {
        
        for index in 0..<buttonsCount {
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            // button.backgroundColor = .blue
            
            button.addTarget(self, action:#selector(buttonClickedEvent(sender:)), for: UIControl.Event.touchUpInside)
            
            button.accessibilityIdentifier = "\(index)"
            
            self.addSubview(button)
            
            buttons.append(button)
        }
        
        for index in 0..<buttons.count {
            
            let button = buttons[index]
            
            button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            if index == 0 {
                
                let rightView = getRightView(index: index)
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: rightView.widthAnchor).isActive = true
                button.trailingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
                
                
            } else if (index == buttons.count - 1) {
                
                let leftView = getLeftView(index: index)
                button.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: leftView.widthAnchor).isActive = true
                button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                
                
            } else {
                
                let leftView = getLeftView(index: index)
                let rightView = getRightView(index: index)
                
                button.leadingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: rightView.widthAnchor).isActive = true
                button.trailingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
                
            }
        }
        
    }
    
    
    @objc func buttonClickedEvent(sender: UIButton){
        let index = Int(sender.accessibilityIdentifier!)
        if imageView != nil {
            imageView?.image = images[index!]
        }
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        if delegate != nil {
            delegate?.onClickButton(ChildSelectionView: index!)
        }
    }
    
}
