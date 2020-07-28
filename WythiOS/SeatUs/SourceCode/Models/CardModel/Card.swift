//
//  Card.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 25/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class Card: NSObject {
    @objc  var id : NSNumber?
    @objc  var last_digits : String?
    @objc  var is_default : NSNumber?
    
    var cardFormattedNumber : String {
        return ""
    }
    
    class func getCards(_ object: AnyObject) -> [Card]{
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
    
    class func requestToServer(service: String, filterObject: [String: Any],shouldShowHud:Bool = false, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()) {
        
        var filterObject = filterObject
        filterObject[ApplicationConstants.Token] = User.getUserAccessToken() as Any
        
        WebServices.sharedInstance.sendRequestToServer(urlString: service, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject],shouldShowHud:shouldShowHud) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }
}
