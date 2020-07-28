//
//  BankDetail.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 26/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class BankDetail: NSObject {
    @objc var bank_name: String!
    @objc var account_title: String!
    @objc var routing_number: String!
    @objc var account_number: String!
    @objc var checking_account: String!
    @objc var swift_code: String!
    @objc var bank_address: String!
    @objc var period: String!
//    @objc var personal_id_number: String!
    @objc var city: NSNumber?
    @objc var birth_date: String!
    @objc var state: NSNumber?
    @objc var address: String!
    @objc var ssn_last_4: String!
    @objc var postal_code: String!
    
    class func requestToServer(service: String, filterObject: [String: Any], completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()) {
        
        var filterObject = filterObject
        filterObject[ApplicationConstants.Token] = User.getUserAccessToken() as Any
        
        WebServices.sharedInstance.sendRequestToServer(urlString: service, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }
    
    class func getBankDetails(_ object: AnyObject) -> BankDetail{
        var bankDetail = BankDetail()
        if object is [String:Any] {
                bankDetail = DynamicParser.setValuesOnClass(object: object as! [String : Any], classObj: BankDetail()) as! BankDetail
        }
        return bankDetail
    }
    
}
