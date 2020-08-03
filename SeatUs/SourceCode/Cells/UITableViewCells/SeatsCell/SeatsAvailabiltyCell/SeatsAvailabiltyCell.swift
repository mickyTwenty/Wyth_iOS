//
//  SeatsAvailabiltyCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 24/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol SeatsDetailsButtonCellDelegate : class  {
    func onClickProfileButton(_ sender: Any,tag: Int)
}

class SeatsAvailabiltyCell: UITableViewCell {

    @IBOutlet weak var column1ContentView: UIView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var infoLabelBotom: UILabel!
    @IBOutlet weak var infoLabelTop: UILabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var seatStatusLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var paseengerDetailsImageView: UIImageView!
    @IBOutlet weak var reservedButton: UIButton!
    @IBOutlet weak var detailsLable: UILabel!
    @IBOutlet weak var profileButton: UIButton!

    weak var delegate : SeatsDetailsButtonCellDelegate!
    
    @IBOutlet weak var column2ContentView: UIView!
    @IBOutlet weak var ratingViewRight: RatingView!
    @IBOutlet weak var infoLabelBotomRight: UILabel!
    @IBOutlet weak var infoLabelTopRight: UILabel!
    @IBOutlet weak var profileImageViewRight: ProfileImageView!
    @IBOutlet weak var seatStatusLabelRight: UILabel!
    @IBOutlet weak var topImageViewRight: UIImageView!
    @IBOutlet weak var paseengerDetailsImageViewRight: UIImageView!
    @IBOutlet weak var reservedButtonRight: UIButton!
    @IBOutlet weak var detailsLableRight: UILabel!
    @IBOutlet weak var profileButtonRight: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeCell(passenger: [Passenger], atIndexPath:Int){
        
        if Utility.isDriver() {
            detailsLableRight.isHidden = false
        }
        else{
            detailsLableRight.isHidden = true

        }
        var indexPathEven = atIndexPath
            indexPathEven = indexPathEven * 2
//            print("making object at : \(indexPathEven)")
            profileButton.tag = indexPathEven
            setLeftPassenger(object: passenger[indexPathEven])
            let index = indexPathEven + 1
            reservedButton.tag = indexPathEven
            reservedButtonRight.tag = index
//            print("making object at : \(index)")
        
            column2ContentView.isHidden = false
            
            if passenger.count > index{
                profileButtonRight.tag = index

                setRightPassenger(object: passenger[index])
            }
            else{
                column2ContentView.isHidden = true
            }
    }

    
    func setLeftPassenger(object:Passenger){
        
        if Utility.isDriver() {
            detailsLable.isHidden = false
        }
        else{
            detailsLable.isHidden = true
            
        }
        var topViewImageName = ""
        var paseengerDetailsImageName = ""
        
        if object.isDriver! {
            
            infoLabelTop.text = "Driver"
            topViewImageName = AssetsName.DriverSeatIcon
            paseengerDetailsImageName = AssetsName.SeatFilledDetailsBG
            detailsLable.text = ""
            detailsLable.isHidden = true
            topImageView.image = UIImage(named: topViewImageName)
            paseengerDetailsImageView.image = UIImage(named: paseengerDetailsImageName)



            if object.first_name != nil
            {
                let url = URL(string: (object.profile_picture!))
                profileImageView.profileImageView.af_setImage(withURL: url!)
                ratingView.rating = (object.rating?.floatValue)!
                
                seatStatusLabel.text = "Available"
                infoLabelBotom.text = (object.first_name)! + " " + (object.last_name)!
                

            }
            else{
                seatStatusLabel.text = "Not Available"
                ratingView.rating = Float(truncating: NSNumber(floatLiteral: 0.0))
                profileImageView.imageName = "profile_placeholder_default"
                infoLabelBotom.text = ""
                
            }

            return
        }
        
        if (object.first_name != nil){
            let url = URL(string: (object.profile_picture!))
            profileImageView.profileImageView.af_setImage(withURL: url!)
            ratingView.rating = (object.rating?.floatValue)!

            //isConfirmed false is reserved
            if ((object.is_confirmed?.boolValue)! && (object.has_payment_made?.boolValue)!){
                infoLabelTop.text = "Booked by:"
                seatStatusLabel.text = "Filled"
                infoLabelBotom.text = (object.first_name)! + " " + (object.last_name)!
                topViewImageName = AssetsName.SeatCrossImageForFilled
                paseengerDetailsImageName = AssetsName.SeatFilledDetailsBG
                
                if Utility.isDriver(){
                    detailsLable.text = "Bags: " + (object.bags_quantity?.stringValue)! + " Price: $" + (object.fare?.stringValue)!
                }
            }
            else{
                
                infoLabelTop.text = "Reserved by:"
                seatStatusLabel.text = "Reserved"
                infoLabelBotom.text = (object.first_name)! + " " + (object.last_name)!
                detailsLable.isHidden = true

                topViewImageName = AssetsName.SeatCrossImageForReserved
                paseengerDetailsImageName = AssetsName.SeatReservedDetailsBG
            }
        }
        else{
            
            profileImageView.updateImage()
            detailsLable.isHidden = true

            ratingView.rating = 0.0
            infoLabelTop.text = "Not Booked"
            infoLabelBotom.text = "XXX"
            seatStatusLabel.text = "Available"
            topViewImageName = AssetsName.SeatCrossImageForAvailable
            paseengerDetailsImageName = AssetsName.SeatFilledDetailsBG
        }
        topImageView.image = UIImage(named: topViewImageName)
        paseengerDetailsImageView.image = UIImage(named: paseengerDetailsImageName)
    }
    
    func setRightPassenger(object:Passenger){
        
        if Utility.isDriver() {
            detailsLableRight.isHidden = false
        }
        else{
            detailsLableRight.isHidden = true
            
        }
        var topViewImageName = ""
        var paseengerDetailsImageName = ""

        if (object.first_name != nil){
            
            let url = URL(string: (object.profile_picture!))
            profileImageViewRight.profileImageView.af_setImage(withURL: url!)
            ratingViewRight.rating = (object.rating?.floatValue)!

            if ((object.is_confirmed?.boolValue)! && (object.has_payment_made?.boolValue)!){
                
                seatStatusLabelRight.text = "Filled"
                infoLabelTopRight.text = "Booked by:"
                infoLabelBotomRight.text = (object.first_name)! + " " + (object.last_name)!
                
                if Utility.isDriver() {
                    detailsLableRight.text = "Bags: " + (object.bags_quantity?.stringValue)! + " Price: $" + (object.fare?.stringValue)!
                }

                topViewImageName = AssetsName.SeatCrossImageForFilled
                paseengerDetailsImageName = AssetsName.SeatFilledDetailsBG
            }
            else{
                
                infoLabelTopRight.text = "Reserved by:"
                seatStatusLabelRight.text = "Reserved"
                infoLabelBotomRight.text = (object.first_name)! + " " + (object.last_name)!
                detailsLableRight.isHidden = true

                topViewImageName = AssetsName.SeatCrossImageForReserved
                paseengerDetailsImageName = AssetsName.SeatReservedDetailsBG
            }
        }
        else{
            profileImageView.updateImage()

            topImageViewRight.image = UIImage(named: AssetsName.SeatCrossImageForAvailable)
            ratingViewRight.rating = 0.0
            infoLabelTopRight.text = "Not Booked"
            infoLabelBotomRight.text = "XXX"
            detailsLableRight.isHidden = true

            topViewImageName = AssetsName.SeatCrossImageForAvailable
            paseengerDetailsImageName = AssetsName.SeatFilledDetailsBG
            seatStatusLabelRight.text = "Available"
        }
        
        topImageViewRight.image = UIImage(named: topViewImageName)
        paseengerDetailsImageViewRight.image = UIImage(named: paseengerDetailsImageName)
    }
    
    @IBAction func onClickProfileButton(_ sender: Any) {
        if delegate != nil {
            let button = sender as! UIButton
            delegate?.onClickProfileButton(sender, tag: button.tag)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
