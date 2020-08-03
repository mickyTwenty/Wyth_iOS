//
//  PassengerTrackingViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 2/9/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import GoogleMaps

class PassengerTrackingViewController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var gmsMapView: GMSMapView!
    var path = GMSPath()
    var polyline = GMSPolyline()
    var driverMarker :GMSMarker?

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    var timer: Timer? = nil
    var currentLatitude : String = ""
    var currentLongitude : String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        gmsMapView.delegate = self
        gmsMapView.settings.myLocationButton = true
        
        // Do any additional setup after loading the view.
        addLocationListener()
        performActions()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.opacity = 0
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        callTimer()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }
    }

    
    func addLocationListener(){
        _ =  FireBaseManager.sharedInstance.addListenerLocationCollection { (lat, lon) in
            
            //self.performActions()
            self.currentLatitude = lat
            self.currentLongitude = lon
            
            self.driverMarker?.map = nil
            self.driverMarker = Utility.drawDriverPin(lat: lat, lon: lon)
            self.driverMarker?.map = self.gmsMapView
            
           
            if (self.leftLabel.text?.isEmpty)!{
                self.callDistanceMatrix()
            }
 
        }
    }
    
    func callTimer(){
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.callDistanceMatrix), userInfo: nil, repeats: true)
    }

    
    
    @objc func callDistanceMatrix(){
        let trip = Manager.sharedInstance.currentTripInfo
        
        let driverCoordinates = currentLatitude + "," + currentLongitude
        let tripCoordinate = (trip?.destination_latitude)! + "," + (trip?.destination_longitude)!
        
        PostTrip.calculateRoutePriceEstimation(fromOrigin: driverCoordinates, toDestination: tripCoordinate,shouldShowHud:false, completionHandler: { (object, message, active, status, error) in
            if status!{
                self.leftLabel.text  = "Distance : " + "\(String(describing: message!["distance"]!))"
                self.rightLabel.text  = "Time : " + "\(String(describing: message!["duration"]!))"
            }
        })
    }
    
    func performActions(){
        
        clearAllMarkupsAndRoute()
        drawRouteOnMapWithObject()
    }
    
    func clearAllMarkupsAndRoute(){
        //gmsMapView.clear()
    }

    
    func drawRouteOnMapWithObject(){
        // clear old poly line
        //gmsMapView.clear()
        
        let trip = Manager.sharedInstance.currentTripInfo
        
        self.path = GMSPath(fromEncodedPath: (trip?.route_polyline!)!)!
        self.polyline.path = path
        self.polyline.strokeColor = ApplicationConstants.GreenColor
        self.polyline.strokeWidth = CGFloat(ApplicationConstants.strokeWidth)
        
        self.polyline.map = gmsMapView
        
        focusMapToShowAllMarkersZoomValue()
    }

    func focusMapToShowAllMarkersZoomValue(){
        
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
