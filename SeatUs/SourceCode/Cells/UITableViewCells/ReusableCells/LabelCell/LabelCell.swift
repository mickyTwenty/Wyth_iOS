//
//  LabelCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewBottom: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCell(_ model: AnyObject,isMultiLineLable:Bool = false){
        
        if isMultiLineLable{
            contentLabel.numberOfLines = 2
        }
        titleLabel.text = model.title + ": "
        contentLabel.text = model.placeholdertext ?? ""
    }
    
    func hideSeparatorView(){
        separatorView.isHidden = true
//        separatorView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        separatorView.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    func showSeparatorView(){
        separatorView.isHidden = false
//        separatorView.heightAnchor.constraint(equalToConstant: 0).isActive = false
//        separatorView.widthAnchor.constraint(equalToConstant: 0).isActive = false
    }
}
