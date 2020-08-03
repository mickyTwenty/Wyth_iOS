 //
//  DriverAcceptedRideViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/21/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class DriverAcceptedRideViewController: ModalAlertBaseViewController {

    @IBOutlet weak var contentTextLable: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var promoCodeTextField: ValidaterTextField!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var finalCostTextField: UILabel!
    @IBOutlet weak var promoTextView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let invitedBy = contentDict[FireBaseConstant.inviterName] as! String
//        let date = Utility.getDateByTimeStamp(timeStamp: timeStamp)
        
        promoTextView.isHidden = true
        promoCodeTextField.keyboardType = .alphabet
        promoCodeTextField.autocapitalizationType = .allCharacters
        
        if contentDict["accept_offer"] != nil {
       //     let amount = (contentDict["proposed_amount"] as? String) ?? "0"
       //     let transactionFee = Utility.getValueFromUserDefaults(key: BootMeUpKeys.TransactionFee.value) as! Double
            contentImageView.image = UIImage(named: "accept_offer_popup")
            showTransactionDetails(isDriverAcceptOffer: false)
       //     contentTextLable.text = "\n\n\n\nYou will be charged $\(amount) + $\(transactionFee) transaction fee.\nAre you sure you want to accept this offer?"
        } else {
            Card.requestToServer(service: WebServicesConstant.GetCreditCard, filterObject: [:])
            { (object, message, active, status) in
                if let object = object {
                    var cards = Card.getCards(object)
                    cards = cards.filter({($0.is_default?.intValue ?? 0)==1})
                    if cards.count > 0 {
                        self.showTransactionDetails(card: Utility.getFormattedCardNumber(last_digits: cards.first?.last_digits), isDriverAcceptOffer: true)
                    }
                }
                
            }
            showTransactionDetails(isDriverAcceptOffer: true)
            //contentTextLable.text = "Driver has accepted your offer of $" + amount + "\n From: " + origin_text + "\n To: " + dest
        }
    }
    
    func showTransactionDetails(card: String? = nil, isDriverAcceptOffer: Bool){
        let amount = (contentDict["proposed_amount"] as? String) ?? "0"
        let transactionFee = Utility.getValueFromUserDefaults(key: BootMeUpKeys.TransactionFee.value) as! Double
        let transactionFeeLocal = Utility.getValueFromUserDefaults(key: BootMeUpKeys.TransactionFeeLocal.value) as! Double
        let dest = contentDict[FireBaseConstant.searchDataDestinationText] as! String
        let origin_text = contentDict[FireBaseConstant.searchDataOriginText] as! String
        let totalCost = transactionFee + Double(amount)!
        let date = (contentDict["date"] as? String ?? "")
        let driverName = (contentDict["driver_name"] as? String ?? "")
        
        var content = ""
        
        if isDriverAcceptOffer {
            
            content += "Driver has accepted your offer.\n\n"
            content += "Driver name: " + driverName
            content += "\nOrigin: " + origin_text + "\n"
            content += "Destination: " + dest + "\n"
            content += "Date: " + Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateTimeServerFormat, dateString: date)
            if let returnDate = contentDict["return_date"] as? String, !returnDate.isEmpty {
                content += "\nReturn Date: " + Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateTimeServerFormat, dateString: returnDate)
            }
            
        }
        
        content += "\n\n"
        content += "Confirm Transaction Details: "
        content += "\nTrip Fee: $\(amount)\n"
        content += "Transaction Fee*: $\(transactionFee)\n"
        content += "Total: $\(totalCost)"
        content += "\n\n"
        content += "*Note - Transaction fees are assessed as follows:\nOne-way = $\(transactionFee)\nRound-Trip = $\(transactionFee*2)"
        content += "\n\n"
        content += "CHARGE CARD?"
        if card != nil {
            content += "\nCard: \(card!)"
        }
        
        
        
        contentTextLable.text = content
    }
    
    //cancel
    @IBAction func leftButtonClicked(_ sender: Any) {
        var tripID :AnyObject?  = nil
        var driverID:AnyObject? = nil
        var bags :AnyObject? = nil
        var proposed_amount : AnyObject? = nil
        
        
        if let tripIdClone = contentDict["trip_id"] as? String{
            tripID = tripIdClone as AnyObject
        }
        
        if let tripIdCloneInt = contentDict["trip_id"] as? Int{
            tripID = tripIdCloneInt as AnyObject
        }
        
        if let tripIdClone = contentDict["trip_id"] as? String{
            tripID = tripIdClone as AnyObject
        }
        
        if let tripIdCloneInt = contentDict["trip_id"] as? Int{
            tripID = tripIdCloneInt as AnyObject
        }
        
        
        if let driverIDClone = contentDict["driver_id"] as? String{
            driverID = driverIDClone as AnyObject
        }
        
        if let driverIDCloneInt = contentDict["driver_id"] as? Int{
            driverID = driverIDCloneInt as AnyObject
        }
        
        if let bagsClone = contentDict["bags_quantity"] as? String{
            bags = bagsClone as AnyObject
        }
        
        if let bagsCloneInt = contentDict["bags_quantity"] as? Int{
            bags = bagsCloneInt as AnyObject
            
        }
        
        if let proposed_amountClone = contentDict["proposed_amount"] as? String{
            proposed_amount = proposed_amountClone as AnyObject
        }
        
        if let proposed_amountCloneInt = contentDict["proposed_amount"] as? Int{
            proposed_amount = proposed_amountCloneInt as AnyObject
        }

        
        let passengerObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"driver_id":driverID as Any,"price":proposed_amount as Any,"trip_id":tripID as Any]
        
        Trip.rejectOffer(param: passengerObject as [String : AnyObject]) { (object, message, active, status) in
            
            if status!{
                self.dismissView()
            }
            else{

                self.showAlertMessage(responderView: self.view, onContentView: self.view, message: message!["message"] as! String)
            }
        }
    }
    
    func dismissView(){
        self.close()
        doneButtonTapped?(selectedData)
        
    }

    func acceptOffer(){
        
        var tripID :AnyObject?  = nil
        var driverID:AnyObject? = nil
        var bags :AnyObject? = nil
        var proposed_amount : AnyObject? = nil
        
        
        if let tripIdClone = contentDict["trip_id"] as? String{
            tripID = tripIdClone as AnyObject
        }
        
        if let tripIdCloneInt = contentDict["trip_id"] as? Int{
            tripID = tripIdCloneInt as AnyObject
        }
        
        if let tripIdClone = contentDict["trip_id"] as? String{
            tripID = tripIdClone as AnyObject
        }
        
        if let tripIdCloneInt = contentDict["trip_id"] as? Int{
            tripID = tripIdCloneInt as AnyObject
        }


        if let driverIDClone = contentDict["driver_id"] as? String{
            driverID = driverIDClone as AnyObject
        }
        
        if let driverIDCloneInt = contentDict["driver_id"] as? Int{
            driverID = driverIDCloneInt as AnyObject
        }

        if let bagsClone = contentDict["bags_quantity"] as? String{
            bags = bagsClone as AnyObject
        }
        
        if let bagsCloneInt = contentDict["bags_quantity"] as? Int{
            bags = bagsCloneInt as AnyObject

        }

        if let proposed_amountClone = contentDict["proposed_amount"] as? String{
            proposed_amount = proposed_amountClone as AnyObject
        }
        
        if let proposed_amountCloneInt = contentDict["proposed_amount"] as? Int{
            proposed_amount = proposed_amountCloneInt as AnyObject
        }

        
        
        let promo_code = promoCodeTextField.text ?? ""
//        let passenger_id = contentDict["passenger_id"] as! String
        let passengerObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"driver_id":driverID as Any,"bags":bags as Any,"price":proposed_amount as Any,"trip_id":tripID as Any,"promo_code":promo_code]
        Trip.postAcceptOfferOnTrip(tripObject: passengerObject) { (object, message, active, status) in
            
            if self.contentDict["accept_offer"] != nil {
            
                
                self.selectedData["status"] = status as AnyObject
                self.selectedData["message"] = message!["message"] as AnyObject
                
               
                self.doneButtonTapped?(self.selectedData)
            }
            else {
                if let code = message!["error_code"] as? String{
                    if code == ErrorTypes.InvalidCCErrorCode{
                        self.selectedData = message as! [String : AnyObject]
                        self.showAlertMessage(responderView: self.view, onContentView: self.view, message: ApplicationConstants.NoCreditCardMessage)
                    }
                    else {
                        Utility.showAlertwithOkButton(message: code, controller: self)
                    }
                }
                else{
                    let message = message!["message"] as! String
                    self.showAlertMessage(responderView: self.view, onContentView: self.view, message: message)
                }
            }
        }
    }
    
//    let passengerObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":(trip.trip_id?.stringValue)!,"driver_id":(trip.driver?.user_id?.stringValue)!,"bags":numberOfBags,"price":object.price as Any]
//    tripDetails = passengerObject
    
    // submit
    @IBAction func rightButtonClicked(_ sender: Any) {
        acceptOffer()
    }

    @IBAction func onApplyPromoButtonClicked(_ sender: Any) {
        let promo_code = promoCodeTextField.text ?? ""
        
        if promo_code.isEmpty {
            Utility.showAlertwithOkButton(message: "Promo Code can't be empty", controller: self)
            self.promoTextView.isHidden = true
            return
        }
        
        let amount = (contentDict["proposed_amount"] as? String) ?? "0"
        let object :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"promo_code":promo_code, "amount":amount]

        Trip.applyPromoOnAmount(object: object) {
            (object, message, active, status) in
            if let object = object as? [String:Any], let after_discount = object["after_discount"] as? Double {
                self.promoTextView.isHidden = false
                self.finalCostTextField.text = "Final Cost: \(after_discount)"
            }
            else {
                self.promoTextView.isHidden = true
                if let message = message!["message"] as? String {
                    Utility.showAlertwithOkButton(message: message, controller: self)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
