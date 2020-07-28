//
//  PlistUtility.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation

class PlistUtility: NSObject {
    
    class func getPlistDataForSignUp()->[Any]{
        return getContentOfFile(name: FileNames.SignUpPlist)
    }

    
    class func getPlistDataForSignUpDetails()->[Any]{
        return getContentOfFile(name: FileNames.SignUpDetailsPlist)
    }
    
    class func getPlistDataForPassengerSideMenuList()->[Any]{
        return getContentOfFile(name: FileNames.PassengerSideMenuPlist)
    }
    
    class func getScreenTitle(userType:String,screenIndex:Int=0)->String{
        let model = SideMenuOption.getSideMenuData(userType: userType) [screenIndex]
        return model.navigationtitle
    }

    class func getPlistDataForDriverSideMenuList()->[Any]{
        return getContentOfFile(name: FileNames.DriverSideMenuPlist)
    }
    
    class func getPlistDataForEditDriverProfile()->[Any]{
        return getContentOfFile(name: FileNames.DriverEditProfilePlist)
    }

    
    class func getPlistDataForEditPassengerProfile()->[Any]{
        return getContentOfFile(name: FileNames.PassengerEditProfilePlist)
    }
    
    class func getPlistDataForPostTrip(name: String)->[Any]{
        return getContentOfFile(name: name)
    }
    
    class func getPlistDataForPayment(name: String)->[Any]{
        return getContentOfFile(name: name)
    }

    class  func getContentOfFile(name: String, fileType:String = FileTypes.Plist)->[Any]{
        
        if let path = Bundle.main.path(forResource:name , ofType: fileType) {
            
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path) as? [Any] {
                return array as [Any]
            }
        }
        return []
    }
}

