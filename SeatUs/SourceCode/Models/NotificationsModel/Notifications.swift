//
//  Notifications.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 29/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class Notifications: NSObject {
    @objc var id : NSNumber?
    @objc var receiver_type : String?
    @objc var notification : String?
    @objc var notification_type : String?
    @objc var datetime : String?
    @objc var unix_timestamp : NSNumber?
    @objc var rfc_2822 : String?
    @objc var iso_8601 : String?
    @objc var data : NotificationData?
    @objc var josnNotifData : [String:Any]? = nil
    
    class func requestToServer(service: String, filterObject: [String: Any], completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()) {
        
        var filterObject = filterObject
        filterObject[ApplicationConstants.Token] = User.getUserAccessToken() as Any
        
        switch (Utility.getUserType()){
            
        case UserType.UserNormal:
            filterObject["user_type"] = "passenger"
            break
            
        case UserType.UserDriver:
            filterObject["user_type"] = "driver"
            break
            
        default :
            break
        }
        
        WebServices.sharedInstance.sendRequestToServer(urlString: service, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }
    
    class func getNotifications(_ object: AnyObject) -> [Notifications]{
        var notifications = [Notifications]()
        if object is [Any] {
            for obj in (object as! [Any]) {
                let obj = obj as! [String : Any]
                let notification = DynamicParser.setValuesOnClass(object: obj, classObj: Notifications()) as! Notifications
                if obj["payload"] != nil {                    
                    let payload = obj["payload"]  as! [String : Any]
                    if payload["data"] != nil {
                        notification.data = NotificationData.getNotificationData(payload["data"] as AnyObject)
                        notification.josnNotifData = obj
                    }
                }
                notifications.append(notification)
            }
        }
        return notifications
    }
}
