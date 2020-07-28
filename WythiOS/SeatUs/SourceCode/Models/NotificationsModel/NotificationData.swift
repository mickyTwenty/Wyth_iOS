//
//  NotificationData.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 29/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class NotificationData: NSObject {
    @objc var trip_id : NSNumber?
    @objc var driver_id : NSNumber?
    @objc var passenger_id : NSNumber?
    @objc var trip_name : String?
    @objc var origin_text : String?
    @objc var destination_text : String?
    @objc var proposed_amount : NSNumber?
    @objc var bags_quantity : NSNumber?
    @objc var data_title : String?
    @objc var data_message : String?
    @objc var data_click_action : String?
    
    
    class func getNotificationData(_ object: AnyObject) -> NotificationData{
        var notificationData = NotificationData()
        if object is [String:Any] {
            notificationData = DynamicParser.setValuesOnClass(object: object as! [String : Any], classObj: NotificationData()) as! NotificationData
        }
        return notificationData
    }
    
}
