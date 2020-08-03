//
//  SelectSeatsCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 17/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol SelectSeatsCellDelegate: class {
    func clickEvent(tag: Int, seatsCount: Int)
    func seatsLimit(_ message: String)
}

class SelectSeatsCell: UITableViewCell {

    @IBOutlet weak var seatsCountLabel: UILabel!
    @IBOutlet weak var seatTitleLabel: UILabel!

    
    weak var delegate: SelectSeatsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: PostTrip){
        seatTitleLabel.text = model.title
        if !(model.placeholdertext.isEmpty){
            if (model.placeholdertext != nil && !model.placeholdertext.isEmpty){
                seatsCountLabel.text = model.placeholdertext
            }
            else{
//                seatsCountLabel.text = ""
            }
        }
    }
    
    @IBAction func onClickMinusButton(_ sender: UIButton) {
        let seats = seatsCount(-1)
        if seats != seatsCountLabel.text {
            seatsCountLabel.text = seats
            seatsChanged()
        }
        else {
            if delegate != nil {
                //delegate?.seatsLimit("Seats range 0 - 10")
            }
        }
    }
    
    @IBAction func onClickPlusButton(_ sender: UIButton) {
        let seats = seatsCount(+1)
        if seats != seatsCountLabel.text {
            seatsCountLabel.text = seats
            seatsChanged()
        }
        else {
            if delegate != nil {
                //delegate?.seatsLimit("Seats range 0 - 10")
            }
        }
    }
    
    func seatsChanged(){
        if delegate != nil {
            delegate?.clickEvent(tag: self.tag, seatsCount: Int(seatsCountLabel.text!)!)
        }
    }
    
    func seatsCount(_ num: Int)-> String{
        let count = Int(seatsCountLabel.text!)! + num
        return (0...8 ~= count) ? ("\(count)") : (seatsCountLabel.text)!
    }

}
