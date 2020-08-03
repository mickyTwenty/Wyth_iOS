//
//  TrackCustomEventsHelper.swift
//  JumpIn
//
//  Created by Syed Muhammad Muzzammil on 18/07/2018.
//  Copyright © 2018 CheckIn. All rights reserved.
//

import UIKit
import FirebaseAnalytics

struct AnalyticsConstant {
    static let CreatePassenger = "creat_user_ios"
    static let CreateDriver    = "creat_driver_ios"

    static let OpenNextScreen = "Open Next Screen"
    static let MapScreen = "Map"
    
    static let UtilityButton = "Utility"
    static let TopMenuButton = "Top Menu"
    static let SearchButton = "Search"
    static let LogOutButton = "Log Out"
    static let LogInButton = "Log In"
    static let SignUpButton = "Sign Up"
    
    static let EventsListEvent = "Events List"
    static let CalledForMoreEvent = "called for more Events list"
    static let ProfileDataEvent = "Profile Data"
    static let SearchEventsEvent = "Search Events"
    static let EventsFoundEvent = "Events Found"
    static let NoEventsFoundEvent = "No Events Found"
    static let EventCreatedEvent = "Event Created"
    
}

struct SignAnalytics {
    static let SignIn = "Sign In"
    static let SignUp = "Sign Up"
    static let SignOut = "Sign Out"
}

class AnalyticsHelper: NSObject {
    
    class func registerAnalytics(){
        //FirebaseApp.configure()  Already called in appdelegate
    }
    
    class func track(button: String, message: String? = nil, parameters: [String:Any]? = nil )
    {
        var text = "\(button) clicked"
        if let message = message {
            text += ", \(message)"
        }
        if let parameters = parameters {
            print(text,parameters)
        }
        else {
            print(text)
        }
        
        AnalyticsHelper.logEvent(eventName: "", parameters: [ "button":button , "message":"clicked" ] )
    }
    
    class func track(event: String, message: String? = nil, parameters: [String:Any]? = nil )
    {
        var text = "\(event)"
        if let message = message {
            text += ", \(message)"
        }
        if let parameters = parameters {
            print(text,parameters)
        }
        else {
            print(text)
        }
        
        AnalyticsHelper.logEvent(eventName: "", parameters: [ "event":event , "message":message ?? "success" ] )
    }
    
    class func track(screen: String, message: String? = nil, parameters: [String:Any]? = nil, isopen: Bool = true )
    {
        var text = "\(screen) screen is"
        if isopen {
            text += " opened"
        }
        else {
            text += " closed"
        }
        if let message = message {
            text += ", \(message)"
        }
        if let parameters = parameters {
            print(text,parameters)
        }
        else {
            print(text)
        }
        
        AnalyticsHelper.logEvent(eventName: "", parameters: [ "screen":screen , "message": isopen ? "opened": "closed" ] )
    }
    
    class func track(sign: String, issuccess: Bool = true, parameters: [String:Any]? = nil)
    {
        var text = sign
        if issuccess {
            text += " success"
        }
        else {
            text += " failed"
        }
        if let parameters = parameters {
            print(text,parameters)
        }
        else {
            print(text)
        }
        
        AnalyticsHelper.logEvent(eventName: "", parameters: [ "sign":sign , "message": issuccess ? "success": "failed" ] )
    }
    
    class func logEvent(eventName : String, parameters: [String:String] ){
        Analytics.logEvent(eventName, parameters:parameters)
    }
}
