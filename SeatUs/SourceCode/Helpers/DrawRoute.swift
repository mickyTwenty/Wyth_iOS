//
//  DrawRoute.swift
//  SeatUs
//
//  Created by Qazi Naveed on 4/4/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import GoogleMaps

class DrawRoute: NSObject {
    
    var selectedRoute : Route! = Route()
    var serviceStatus: Bool! = false
    var gmsMapView: GMSMapView!
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    var addingFreinds : AddingFreinds? = .isComingForDriverPassengerBoth
    
    var contentArray : [Route]? = []
    
    func getRoutes(completionHandler: @escaping (_ contentArray : [Route]?) -> ()){
        
        let originCoordinates = DataPersister.getOriginCoordinates()
        let destinationCoordinates = DataPersister.getDestinationCoordinates()
        
        if !((originCoordinates?.isEmpty)!) && !((destinationCoordinates?.isEmpty)!){
            
            PostTrip.getPossibleRoutes(fromOrigin: originCoordinates!, toDestination: destinationCoordinates!, completionHandler: { (routeArr, active, status, error) in
                
                self.contentArray = routeArr
                if (self.contentArray?.count)! > 0 {
                    self.drawRouteOnMapWithObject(route: self.contentArray![0])
                }
                else{
                    self.invalidateTimer()
                }
                
                completionHandler(self.contentArray)
                
            })
        }
        
        
    }
    
    func drawRouteOnMapWithObject(route:Route){
        
        // clear old poly line
        invalidateTimer()
        selectedRoute = route
        
        draw()
    }
    
    func invalidateTimer(){
        
        if (self.timer != nil){
            if (self.timer.isValid){
                self.timer.invalidate()
                //gmsMapView.clear()
                self.path = GMSPath()
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
                self.i = 0
            }
        }
    }
    
    @objc func draw(){
        
        startAnimation()
        
        focusMapToShowAllMarkersZoomValue(route: selectedRoute)
        
    }
    
    func startAnimation(){
        
        self.path = GMSPath(fromEncodedPath: (selectedRoute.overViewPolyLine!))!
        self.polyline.path = path
        self.polyline.strokeColor = ApplicationConstants.GreenColorBright
        self.polyline.strokeWidth = CGFloat(ApplicationConstants.strokeWidth)
        
        
        self.polyline.map = gmsMapView
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        
    }
    
    func focusMapToShowAllMarkersZoomValue(route:Route){
        
        let bounds = GMSCoordinateBounds(path: self.path)
        let update = GMSCameraUpdate.fit(bounds)
        gmsMapView.moveCamera(update)
        
        let legs = route.legsArray![0]
        let steps =  legs.stepsArray![0]
        
        let legsEnd = (route.legsArray?.last)!
        let stepsEnd =  (legsEnd.stepsArray?.last)!
        
        Utility.drawPin(map: gmsMapView, lat:String(steps.latStartValue!), lon: String(steps.longStartValue!), isDropOff: false)
        Utility.drawPin(map: gmsMapView, lat:String(stepsEnd.latEndValue!), lon: String(stepsEnd.longEndValue!), isDropOff: true)
        
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = ApplicationConstants.GreenColor
            self.animationPolyline.strokeWidth = CGFloat(ApplicationConstants.strokeWidth)
            self.animationPolyline.map = self.gmsMapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
}
