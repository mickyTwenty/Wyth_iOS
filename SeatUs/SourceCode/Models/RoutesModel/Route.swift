//
//  Route.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/21/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class Route: NSObject {

    @objc  var summary:String? = ""
    @objc  var overViewPolyLine:String? = ""
    @objc  var popularity:Int = 0
    @objc  var legsArray:[Legs]? = []
    
    
    class func getTotalDistance(object:Route)->(Double){
        
        var distance: Double = 0.0
        for (_,routeObject) in (object.legsArray?.enumerated())!{
            distance = distance + routeObject.distanceValue!
        }
        
        return distance
    }
    
    class func getTotalTime(object:Route)->(Double){
        
        var time: Double = 0.0
        for (_,routeObject) in (object.legsArray?.enumerated())!{
            time = time + routeObject.durationValue!
        }
        
        return time
    }

    class func getRoutesInfo(routeArray:[Route], completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var routeInfo : [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any]
        
        for (index, route) in routeArray.enumerated() {
            routeInfo["route[\(index)]"] = route.overViewPolyLine
        }
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.GetRoutes, methodType: HTTPMethods.post, param: routeInfo as [String : AnyObject], shouldShowHud: false) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }

}
