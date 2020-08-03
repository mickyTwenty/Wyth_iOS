//
//  CheckboxState.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 14/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class CheckboxState: NSObject {
    @objc  var text:String!
    @objc  var isselected:NSNumber!
    @objc  var id:NSNumber!
    @objc var refrencevalue : String!
    
    class func getCheckboxState(_ objects: [[String:Any]] )->[CheckboxState]{
        
        var array = [CheckboxState]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value
            let model = CheckboxState()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! CheckboxState)
        }
        return array
    }
}
