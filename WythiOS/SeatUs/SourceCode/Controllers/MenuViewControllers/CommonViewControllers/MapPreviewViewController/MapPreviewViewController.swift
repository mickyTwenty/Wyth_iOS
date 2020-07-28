//
//  MapPreviewViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/14/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import GoogleMaps


class MapPreviewViewController: BaseViewController {

    @IBOutlet weak var gmsMapView: GMSMapView!
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRouteOnMapWithObject()
    }
    
    func startAnimation(){
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        self.path = GMSPath(fromEncodedPath: (trip?.route_polyline!)!)!
        self.polyline.path = path
        self.polyline.strokeColor = ApplicationConstants.GreenColorBright
        self.polyline.strokeWidth = CGFloat(ApplicationConstants.strokeWidth)
        
        self.polyline.map = gmsMapView
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        
    }

    
    func drawRouteOnMapWithObject(){
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        // clear old poly line
        gmsMapView.clear()
        startAnimation()
        focusMapToShowAllMarkersZoomValue()
        Utility.drawPin(map: gmsMapView, lat: (trip?.origin_latitude)!, lon: (trip?.origin_longitude)!, isDropOff: false)
        Utility.drawPin(map: gmsMapView, lat: (trip?.destination_latitude)!, lon: (trip?.destination_longitude)!, isDropOff: true)
        
        //Utility.drawDriverPin(lat: ("41.607505"), lon: ("-88.123169"))
        //Utility.drawDriverPin(lat: ("41.6026022"), lon: ("-88.0826332"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        invalidateTimer()
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
    
    func invalidateTimer(){
        
        if (self.timer != nil){
            if (self.timer.isValid){
                self.timer.invalidate()
            }
        }
    }
    
    
    func focusMapToShowAllMarkersZoomValue(){
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        let bounds = GMSCoordinateBounds(path: self.path)
        let update = GMSCameraUpdate.fit(bounds)
        gmsMapView.moveCamera(update)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
