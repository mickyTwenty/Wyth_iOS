//
//  SaveChangesCell.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/28/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SaveChangesCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.saveButton.contentHorizontalAlignment = .fill
        self.saveButton.contentVerticalAlignment = .fill
        self.saveButton.imageView?.contentMode = .scaleAspectFit
        
        self.cancelButton.contentHorizontalAlignment = .fill
        self.cancelButton.contentVerticalAlignment = .fill
        self.cancelButton.imageView?.contentMode = .scaleAspectFit
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
