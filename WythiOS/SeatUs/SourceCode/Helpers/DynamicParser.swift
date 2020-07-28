//
//  DynamicParser.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import UIKit

class DynamicParser{
    
    class func setVlauesOfArrayObjectsOnNSObjectClass(objects:NSArray, ObjectClass: NSObject)->NSObject{
        
        objects.enumerateObjects { (object, index, Bool) in
            
            let objDict = object as! NSDictionary
            
            for (key,value) in objDict {
                if !(value is NSNull){
                    let keyString: String = key as!String
                    var upperCaseKeyString: String = (keyString as NSString).substring(to: 1)
                    upperCaseKeyString = upperCaseKeyString.uppercased()
                    var lowerCaseKeyString = (keyString as NSString).substring(from: 1)
                    lowerCaseKeyString = lowerCaseKeyString.lowercased()
                    
                    let selectorString = "set" + upperCaseKeyString + lowerCaseKeyString + ":"
                    let selector: Selector = NSSelectorFromString(selectorString)
                    
                    if ObjectClass.responds(to: selector){
                        ObjectClass.perform(selector, with: value)
                    }
                }
            }
        }
        
        return ObjectClass
    }
    
    
    class func setValuesOnClass(object:[String:Any] ,classObj:NSObject)->NSObject{
        
        for (key,value) in object {
            if !(value is NSNull){
                
                let selector: Selector = NSSelectorFromString(getSelectorString(key: key))
//                print(getSelectorString(key: key))
                if classObj.responds(to: selector){
                    classObj.perform(selector, with: value)
                }
            }
        }
        return classObj
    }
    
    class func getSelectorString(key:String)->String{
        
        var upperCaseKeyString: String = (key as NSString).substring(to: 1)
        upperCaseKeyString = upperCaseKeyString.uppercased()
        var lowerCaseKeyString = (key as NSString).substring(from: 1)
        lowerCaseKeyString = lowerCaseKeyString.lowercased()
        
        let selectorString = "set" + upperCaseKeyString + lowerCaseKeyString + ":"
        return selectorString
    }
}

