//
//  SideMenuOption.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/22/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SideMenuOption: NSObject {

    @objc  var title:String!
    @objc  var shouldshow:NSNumber!
    @objc  var controllerid:String!
    @objc  var icon:String!
    @objc  var chatCount:String!
    @objc  var notifCount:String!
    @objc  var navigationtitle:String!
    @objc  var cellidentifier:String!
    @objc  var subCatArray:[SubMenuDetail]!
    
    class func getSideMenuData(userType:String)->[SideMenuOption]{
        
        var objects = [Any]()
        switch userType {
            
        case UserType.UserNormal:
            objects  = PlistUtility.getPlistDataForPassengerSideMenuList()
            break
            
        case UserType.UserDriver:
            objects  = PlistUtility.getPlistDataForDriverSideMenuList()
            break
            
        default:
            break
        }
        
        
        var array = [SideMenuOption]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value as![String:Any]
            var modelSideMenuOption = SideMenuOption()
            modelSideMenuOption =  DynamicParser.setValuesOnClass(object: castValue, classObj: modelSideMenuOption) as! SideMenuOption
            
            let subCat = castValue["subCategories"] as! [NSDictionary]
            
            if (subCat.count > 0) {
                modelSideMenuOption.subCatArray = [SubMenuDetail]()
                for (_, value) in subCat.enumerated() {
                    
                    
                    let castValue = value as![String:Any]
                    let model = SubMenuDetail()
                    let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
                    modelSideMenuOption.subCatArray.append(obj as! SubMenuDetail)
                }
            }
            array.append(modelSideMenuOption )
        }
        return array
    }
}
