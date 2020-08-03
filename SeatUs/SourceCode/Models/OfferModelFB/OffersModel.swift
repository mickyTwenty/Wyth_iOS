//
//  OffersModel.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/19/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class OffersModel: NSObject {

    @objc  var bags : NSNumber?
    @objc  var driver_id : NSNumber?
    @objc  var passenger_id : NSNumber?
    @objc  var first_name : String?
    @objc  var last_name : String?
    @objc  var price : String?
    @objc  var sender : String?
    @objc  var trip_id : String?
    @objc  var cell_identifier : String?
    @objc  var timestamp : Date?

    //@objc  var trip_id : String?
    
    class func parseOffersObject(object:[String:Any])->(OffersModel){
        
        let obj =  DynamicParser.setValuesOnClass(object: object, classObj: OffersModel()) as! OffersModel
        return obj
    }
}
