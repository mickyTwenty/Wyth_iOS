//
//  PaymentHistory.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 26/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PaymentHistory: NSObject {
    @objc var trip_id : NSNumber!
    @objc var origin_title : String!
    @objc var destination_title : String!
    @objc var last_digits : String!
    @objc var amount : NSNumber!
    @objc var earning : NSNumber!
    @objc var transaction_fee : String!
    @objc var transaction_fee_local : String!
    @objc var payment_datetime : String!
    
    class func getPaymentHistoryFromServer(filterObject: [String: Any],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        //"limit":"99"
        var filterObject = filterObject
        filterObject[ApplicationConstants.Token] = User.getUserAccessToken() as Any
        filterObject["limit"] = "999"
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.PaymentHistory

        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }
    
    class func getPaymentsHistory(_ object: AnyObject) -> [PaymentHistory]{
        var payments = [PaymentHistory]()
        if object is [Any] {
            for obj in (object as! [Any]) {
                let payment = DynamicParser.setValuesOnClass(object: obj as! [String : Any], classObj: PaymentHistory())
                if payment is PaymentHistory {
                    payments.append(payment as! PaymentHistory)
                }
            }
        }
        return payments
    }
    
}
