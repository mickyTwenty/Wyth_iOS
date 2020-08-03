//
//  PendingRatingModel.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 09/02/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PendingModel: NSObject {
    @objc var trip: Trip!
    @objc var passenger = Passenger()
    @objc var driver = Driver()
}

class PendingRatingModel: NSObject {
    
    @objc var driver = [PendingModel]()
    @objc var passenger = [PendingModel]()
    
    class func getPendingRating(_ object: AnyObject) -> PendingRatingModel{
        
        var object = (object as! [String : Any])
        
        let pendingRatingModel = PendingRatingModel()
        
        for obj in object["driver"] as! [Any] {
            
            let pendingModel = PendingModel()
            
            let tripObj = (obj as! [String:Any])["trip"] as! [String : Any]
            
            pendingModel.trip = (DynamicParser.setValuesOnClass(object: tripObj, classObj: Trip()) as! Trip)
            
            let userObj = (obj as! [String:Any])["user"] as! [String : Any]
            
            pendingModel.driver = (DynamicParser.setValuesOnClass(object: userObj, classObj: Driver()) as! Driver)
            
            pendingRatingModel.driver.append(pendingModel)
            
            
        }
        
        for obj in object["passenger"] as! [Any] {
            
            let pendingModel = PendingModel()
            
            let tripObj = (obj as! [String:Any])["trip"] as! [String : Any]
            
            pendingModel.trip = (DynamicParser.setValuesOnClass(object: tripObj, classObj: Trip()) as! Trip)
            
            let userObj = (obj as! [String:Any])["user"] as! [String : Any]
            
            pendingModel.passenger = (DynamicParser.setValuesOnClass(object: userObj, classObj: Passenger()) as! Passenger)
            
            pendingRatingModel.passenger.append(pendingModel)
            
        }

        return pendingRatingModel
    }
    
    class func getPendingRatingsFromSever(completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let object = [ ApplicationConstants.Token:User.getUserAccessToken() as Any ]
       //POST /account/list/pending-ratings
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.PendingRatingsService , methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: false) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(PendingRatingModel.getPendingRating(response!) as AnyObject,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
}
