//
//  AcceptOfferRecieverCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 18/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol AcceptOfferRecieverCellDelegate : class  {
    func acceptOfferButtonClicked(_ index: Int, _ sender: Any)
}

class AcceptOfferRecieverCell: UITableViewCell {

    @IBOutlet weak var recieverLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    weak var delegate : AcceptOfferRecieverCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.setCornerRadius(6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: OffersModel){
        recieverLabel.text = ""
        msgLabel.text = "$ " + model.price!        
        dateLabel.text = Utility.getTimeStamp(byDate: model.timestamp!)

    }
    
    @IBAction func acceptOfferButtonClicked(_ sender: Any)
    {
        if delegate != nil {
            delegate?.acceptOfferButtonClicked(self.tag,sender)
        }
    }
    
}
