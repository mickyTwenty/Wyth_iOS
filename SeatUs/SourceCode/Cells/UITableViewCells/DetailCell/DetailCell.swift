//
//  DetailCell.swift
//  SeatUs
//
//  Created by Qazi Naveed on 8/9/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var contentLable : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeCell(_ model: SignUpEntity){
        contentLable.text = model.placeholdertext!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
