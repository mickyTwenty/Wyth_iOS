//
//  Payment.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class Payment: SignUpEntity {

//    @objc  var placeholdertext:String!
    @objc var title: String!
    @objc var card: Card!
    
//    @objc  var cellidentifier:String!
//    @objc  var imagename:String!
//    @objc  var text:String!
//
    class func getPaymentData(name: String)->[Payment]{
        
        let objects =  PlistUtility.getPlistDataForPayment(name: name)
        var array = [Payment]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value as![String:Any]
            let model = Payment()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! Payment)
        }
        return array
    }
    
    class func getPaymentHistory(_ object: AnyObject) -> [Card]{
        var cards = [Card]()
        if object is [Any] {
            for obj in (object as! [Any]) {
                let card = DynamicParser.setValuesOnClass(object: obj as! [String : Any], classObj: Card())
                if card is Card {
                    cards.append(card as! Card)
                }
            }
        }
        return cards
    }
    
}
