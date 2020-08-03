//
//  SingleActionButtonCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol SingleActionButtonCellDelegate : class  {
    func onClickButton(_ sender: Any,tag: Int)
}

class SingleActionButtonCell: UITableViewCell {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIButton!
    weak var delegate : SingleActionButtonCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: AnyObject){
        if model.imagename != nil && !model.imagename!.isEmpty {
            button.setImage(UIImage(named: model.imagename), for: .normal)
        }
        let title = model.title!
        if title != nil && !title.isEmpty {
            button.setTitle(model.title, for: .normal)
            if trailingConstraint != nil {
                trailingConstraint.isActive = false
            }
        }
    }
    
    func setButtonImage(_ model: AnyObject){
        if model.imagename != nil && !model.imagename!.isEmpty {
            button.setImage(UIImage(named: model.imagename), for: .normal)
        }
    }
    
    @IBAction func onClickButton(_ sender: Any) {
        if delegate != nil {
            delegate?.onClickButton(sender, tag: self.tag)
        }
    }

}
