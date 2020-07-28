//
//  SeatsConditions.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SeatsCondition: NSObject {

    @objc  var text:String!
    @objc  var circleimage:String!
    @objc  var backgroundimage:String!
    @objc  var seatscount:String!    
    
    class func getSeatsCondition(_ objects: [[String:Any]] )->[SeatsCondition]{
        
        var array = [SeatsCondition]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value
            let model = SeatsCondition()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! SeatsCondition)
        }
        return array
    }
    
    
}
