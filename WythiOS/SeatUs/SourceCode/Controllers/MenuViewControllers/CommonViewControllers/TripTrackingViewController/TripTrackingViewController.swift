                          //
//  TripTrackingViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 2/2/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import GoogleMaps

class TripTrackingViewController: BaseViewController {

    var tripInfo : Trip! = Trip()
    var serviceStatus: Bool = true
    var timer: Timer? = nil
    var driverMarker :GMSMarker?


    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    @IBOutlet  var allWidthRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet  var allWidthLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet  var widthEqualLeftButtonConstraint: NSLayoutConstraint!
    var currentLatitude : String = ""
    var currentLongitude : String = ""


    var path = GMSPath()
    var polyline = GMSPolyline()

    override func viewDidLoad() {
        super.viewDidLoad()

        gmsMapView.delegate = self
        
        if let currentLocation = LocationService.shared.currentLocation {
            self.currentLatitude = String(currentLocation.latitude)
            self.currentLongitude = String(currentLocation.longitude)
        }
        
        // Do any additional setup after loading the view.
        trackLocation()
        showDestinationPin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableTimer()
    }
    
    func disableTimer(){
        
        if timer != nil{
            timer?.invalidate()
            timer = nil
        }

    }
    func callTimer(){
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.callDistanceMatrix), userInfo: nil, repeats: true)
    }
    
    func showDriverPin(lat:String,lon:String){
        self.driverMarker?.map = nil
        self.driverMarker = Utility.drawDriverPin(lat: lat, lon: lon)
        self.driverMarker?.map = self.gmsMapView

    }
    
    func trackLocation(){
        
        LocationService.shared.trackLocation { (latitude , longitude) in
            
            FireBaseManager.sharedInstance.postLocation(coordinates: latitude + "," + longitude)
            self.currentLatitude = latitude
            self.currentLongitude = longitude
            
            self.showDriverPin(lat: latitude, lon: longitude)

            //self.clearAllMarkupsAndRoute()
            //self.drawRouteOnMapWithObject()
            if (self.leftLabel.text?.isEmpty)!{
                self.callDistanceMatrix()
            }
            //Utility.drawPin(map: self.gmsMapView, lat: latitude, lon: longitude, isDropOff: nil)
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        postTripData()
    }
    
    @IBAction func leftButtonClicked(sender:UIButton){
        
        let objMarkTripSelectionController = self.storyboard?.instantiateViewController(withIdentifier: MarkTripSelectionController.nameOfClass()) as? MarkTripSelectionController
        objMarkTripSelectionController?.contentArray = Passenger.getPassengersToPickUp(passengers: (tripInfo?.passengers)!)
        objMarkTripSelectionController?.trip_id = tripInfo.trip_id?.stringValue
        objMarkTripSelectionController?.tripService = MarkTripsConstant.PickUp
        objMarkTripSelectionController?.modalPresentationStyle = .overCurrentContext
        present(objMarkTripSelectionController!, animated: true, completion: nil)
    }

    @IBAction func rightButtonClicked(sender:UIButton){
        
        switch (sender.title(for: .normal)){
            
        case ApplicationConstants.MarkDropOffTitle?:
            showMarkTripSelectionController(contentArray: Passenger.getPassengersToDropOff(passengers: (tripInfo?.passengers)!)! , tripService: MarkTripsConstant.DropOff)
            break
            
        case ApplicationConstants.EndRideTitle?:
            stopTracking()
            Trip.endRideByDriver(completionHandler: { (object, message, action, status) in
                if status! {
                    self.setRating()
                }
            })
            break
            
        case ApplicationConstants.MarkPickupTitle?:
            showMarkTripSelectionController(contentArray: Passenger.getPassengersToPickUp(passengers: (tripInfo?.passengers)!)! , tripService: MarkTripsConstant.PickUp)
            break
            
        default:
            break
        }
    }
    
    func stopTracking(){
        disableTimer()
        LocationService.shared.stopTrackingLocation()
    }
    
    @objc func updateView(){
        
        self.markPassengersPickupDropoff()

        var isPickupPassengersExist = false
        let arrayPassengersToPickUp = Passenger.getPassengersToPickUp(passengers: (tripInfo?.passengers)!)
        let arrayPassengersToDropOff = Passenger.getPassengersToDropOff(passengers: (tripInfo?.passengers)!)
        
        if let pickPassengers = arrayPassengersToPickUp {
            if pickPassengers.count > 0 {
                isPickupPassengersExist = true
                 breakRightButtonTitle(title: ApplicationConstants.MarkDropOffTitle)
            }
            else{
                setRightButtonTitle(title: ApplicationConstants.MarkDropOffTitle)
            }
        }
        else{
            setRightButtonTitle(title: ApplicationConstants.MarkDropOffTitle)
        }
        
        if let dropPassengers = arrayPassengersToDropOff {
            
            if dropPassengers.count > 0 {
                
                if !isPickupPassengersExist {
                    setRightButtonTitle(title: ApplicationConstants.MarkDropOffTitle)
                }
            }
            else{
                    setTitlefNoPassengerExistToPickAndDrop(isPickupPassengersExist: isPickupPassengersExist)
            }
        }
        else{
            setTitlefNoPassengerExistToPickAndDrop(isPickupPassengersExist: isPickupPassengersExist)

        }
    }
    
    func setTitlefNoPassengerExistToPickAndDrop(isPickupPassengersExist:Bool){
        if isPickupPassengersExist {
            setRightButtonTitle(title: ApplicationConstants.MarkPickupTitle)
        }
        else{
            setRightButtonTitle(title: ApplicationConstants.EndRideTitle)
        }

    }
    func setRightButtonTitle(title:String){
        
        // remove constraint of equal width with left button
        widthEqualLeftButtonConstraint.isActive = false
        
        // set right button width to fill parent
        allWidthRightButtonConstraint.isActive = true
        
        self.rightButton.setTitle(title, for: .normal)

    }
    
    func breakRightButtonTitle(title:String){
        
        // remove constraint of equal width with left button
        widthEqualLeftButtonConstraint.isActive = true
        
        // set right button width to fill parent
        allWidthRightButtonConstraint.isActive = false
        
        self.rightButton.setTitle(title, for: .normal)
        
    }

    
    func postTripData(){
        
        
        var isComingForResume = false
        if Utility.isDriver() {
            
            let info = Manager.sharedInstance.currentTripInfo
            if info?.ride_status == RideStaus.STARTED {
                isComingForResume = true
            }
            
            Trip.startRideByDriver(isComingForResume: isComingForResume,  completionHandler: { (object, message, active, status) in
                
                self.serviceStatus = status!
                switch (active){
                    
                case ResponseAction.ShowMesasgeOnAlert?:
                    Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                    break
                    
                default:
                    self.tripInfo = object as! Trip
                    Manager.sharedInstance.currentTripInfo.ride_status = self.tripInfo.ride_status
                    self.clearAllMarkupsAndRoute()
                    //self.drawRouteOnMapWithObject()
                    self.updateView()
                    //self.dropPinOnDriverLocation()
                    break
                }
            })
        }
    }
    
    func dropPinOnDriverLocation(){
        
        let lat = "\(LocationService.shared.currentLocation.latitude)"
        let lon = "\(LocationService.shared.currentLocation.longitude)"
        Utility.drawPin(map: gmsMapView, lat: lat, lon: lon, isDropOff: nil)
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

    func clearAllMarkupsAndRoute(){
        gmsMapView.clear()
        showDestinationPin()
    }
    
    func markPassengersPickupDropoff(){
        clearAllMarkupsAndRoute()
        showDriverPin(lat: self.currentLatitude, lon: self.currentLongitude)
        drawRouteOnMapWithObject()
        let arrayPassengersToPickUp = Passenger.getPassengersToPickUp(passengers: (tripInfo?.passengers)!)
        let arrayPassengersToDropOff = Passenger.getPassengersToDropOff(passengers: (tripInfo?.passengers)!)
        
        if let arrayPassengersToPickUpClone = arrayPassengersToPickUp {
            for (_, value ) in (arrayPassengersToPickUpClone.enumerated()){
                if let marker = Utility.drawPin(map: gmsMapView, lat: (value.pickup_latitude)!, lon: (value.pickup_longitude)!, isDropOff: false) {
                    marker.title = (value.first_name!) + " " + (value.last_name!)
                    marker.snippet = value.pickup_title
                }
                
            }
        }
        
        if let arrayPassengersToDropOffClone = arrayPassengersToDropOff {
            for (_, value ) in (arrayPassengersToDropOffClone.enumerated()){
                if let marker = Utility.drawPin(map: gmsMapView, lat: (value.dropoff_latitude)!, lon: (value.dropoff_longitude)!, isDropOff: true){
                    marker.title = (value.first_name!) + " " + (value.last_name!)
                    marker.snippet = value.dropoff_title
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func alertOkButtonHandler(){
        if serviceStatus{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showMarkTripSelectionController(contentArray: [Passenger], tripService: MarkTripsConstant ){
        let objMarkTripSelectionController = self.storyboard?.instantiateViewController(withIdentifier: MarkTripSelectionController.nameOfClass()) as? MarkTripSelectionController
        objMarkTripSelectionController?.contentArray = contentArray
        objMarkTripSelectionController?.trip_id = tripInfo.trip_id?.stringValue
        if tripService == .DropOff {
            objMarkTripSelectionController?.coordinates = self.currentLatitude + "," + self.currentLongitude
        }
        objMarkTripSelectionController?.tripService = tripService
        objMarkTripSelectionController?.delegate = self
        objMarkTripSelectionController?.modalPresentationStyle = .overCurrentContext

        present(objMarkTripSelectionController!, animated: true, completion: nil)
    }
    
    func setRating() {
        if Utility.isDriver() {
            pushViewController(controllerIdentifier: PassengerRatingViewController.nameOfClass(), navigationTitle: ApplicationConstants.PassengerRatingScreenName, conditons: tripInfo)
        }
        else {
            User.setPendingRatings(hasPending: true)
            let cont = ModalAlertBaseViewController.createAlertController(storyboardId: RatingCommentsViewController.nameOfClass()) as! RatingCommentsViewController
            cont.hideRatingField = true
            cont.date = tripInfo.date
            cont.name = (tripInfo.driver?.first_name ?? "") + " " + (tripInfo.driver?.last_name ?? "")
            cont.show(controller: self)
            cont.selectButtonTapped = { selectedData in
                
                let rate = selectedData as! RateModel
                rate.trip_id = self.tripInfo.trip_id?.stringValue
                rate.user_id = self.tripInfo.driver?.user_id?.stringValue
                
                var rateArray: [[String:String]] = []
                
                rateArray.append([ "rating":rate.rating , "trip_id":rate.trip_id, "feedback":rate.feedback, "user_id":rate.user_id ])
                                
                Trip.rateTrip(rateArray: rateArray, isDriver: false)
                { (object, message, active, status) in
                    
                    User.setPendingRatings(hasPending: false)
                    self.navigationController?.popViewController(animated: false)
                    
                }

            }
        }
    }

    func showDestinationPin(){
        let trip = Manager.sharedInstance.currentTripInfo
        if let marker = Utility.drawPin(map: gmsMapView, lat: (trip?.destination_latitude)!, lon: (trip?.destination_longitude)!, isDropOff: nil) {
            marker.snippet = trip?.destination_title
        }
    }
}
                          
extension TripTrackingViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow = MarkerInfoView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40 , height: 45))
        customInfoWindow.addressLabel.text = marker.snippet
        customInfoWindow.nameLabel.text = marker.title
        return customInfoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let url = NSURL(string:
            "comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving") as URL? {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
}
                          

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
