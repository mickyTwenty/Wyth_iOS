//
//  PassengerTripController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/15/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker


class PassengerTripController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var addressView:UIView!
    @IBOutlet weak var originLable:UILabel!
    @IBOutlet weak var destinationLable:UILabel!
    @IBOutlet weak var dateLable:UILabel!
    @IBOutlet weak var roundTripCheckBoxImageView:UIImageView!
    @IBOutlet weak var rideEstimatesLable:UILabel!
    @IBOutlet weak var editEstimatesButton:UIButton!
    @IBOutlet weak var returnDataView:UIStackView!
    @IBOutlet weak var returnDataLable:UILabel!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var createRideButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var originHeading: UILabel!
    @IBOutlet weak var destinationHeading: UILabel!
    
    
    @IBOutlet weak var returnDateButton: UIButton!
    @IBOutlet weak var gmsMapView: GMSMapView!

    var placesClient: GMSPlacesClient!
    var slectedIndex : Int = -1
    var contentArray: [PostTrip]! = []
    var routeArray: [AnyObject]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.syncContacts()
        setVisibilityAddressView(false)
        self.rideEstimatesLable.text = "$0"
        
        
        gmsMapView.delegate = self
        gmsMapView.isMyLocationEnabled = true
        gmsMapView.settings.myLocationButton = true
        gmsMapView.setMinZoom(6, maxZoom: 14)
        
        switch (Utility.getUserType()){
            
        case UserType.UserDriver:
            originHeading.text = PlistPlaceHolderConstant.PostTripOrigin
            destinationHeading.text = PlistPlaceHolderConstant.PostTripDestination
            searchButton.setImage(UIImage(named: AssetsName.SearchRiderButtonImageName), for: .normal)
            //createRideButton.setImage(UIImage(named: AssetsName.PostRideButtonImageName), for: .normal)
            break
            
        case UserType.UserNormal:
            originHeading.text = PlistPlaceHolderConstant.PickUpHeading
            destinationHeading.text = PlistPlaceHolderConstant.DropOffHeading
            searchButton.setImage(UIImage(named: AssetsName.SearchDriverButtonImageName), for: .normal)
            break
            
        default :
            break
        }
        
        // Do any additional setup after loading the view.
        getDataInContentArray()
        getCacheData()
        settingUpShadow()
    }
    
    let infoMarker = GMSMarker()
    let geocoder = GMSGeocoder()
    
    func mapView(_ mapView: GMSMapView, didTapMyLocationButtonForMapView coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        let marker = GMSMarker(position: coordinate)
        marker.position = coordinate
        marker.opacity = 0;
        marker.infoWindowAnchor.y = 1
        marker.map = gmsMapView
        gmsMapView.selectedMarker = marker
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                
                marker.userData = address
                marker.title = address
                marker.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                
            }
        }
        
        let lat = marker.position.latitude + 0.025
        let lon = marker.position.longitude
        let markerCamera = GMSCameraPosition.camera(withLatitude: lat,
                                                    longitude: lon,
                                                    zoom: 12)
        gmsMapView.animate(to: markerCamera)
        //selectLocation(addressLable: destinationLable, addressTitle: "Selected Destination from Map", addressLocation: coordinate, isDestination: true)
    }
    
    // Attach an info window to the POI using the GMSMarker.
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        infoMarker.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = gmsMapView
        gmsMapView.selectedMarker = infoMarker
        
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            if let locations = response?.firstResult() {
                
                let lines = locations.lines! as [String]
                let address = lines.joined(separator: "\n")
                
                let fullAddress = name + " - " + address
                
                self.infoMarker.userData = fullAddress
                self.infoMarker.title = fullAddress
                
            }
        }
        
        let lat = infoMarker.position.latitude + 0.025
        let lon = infoMarker.position.longitude
        let markerCamera = GMSCameraPosition.camera(withLatitude: lat,
                                                    longitude: lon,
                                                    zoom: 12)
        gmsMapView.animate(to: markerCamera)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position)
        
        gmsMapView.selectedMarker = marker
        
        let lat = marker.position.latitude + 0.025
        let lon = marker.position.longitude
        let markerCamera = GMSCameraPosition.camera(withLatitude: lat,
                                 longitude: lon,
                                 zoom: 12)
        gmsMapView.animate(to: markerCamera)
        
        return true;
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print(marker.title!)
        print(marker.position)
        
        selectLocation(addressLable: originLable, addressTitle: marker.title!, addressLocation: marker.position, isDestination: false)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print(marker.title!)
        print(marker.position)
        
        selectLocation(addressLable: destinationLable, addressTitle: marker.title!, addressLocation: marker.position, isDestination: true)
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        
        switch (Utility.getUserType()){
            
        case UserType.UserDriver:
            controller.pageLink = WebViewLinks.CreateRideHelp
            break
            
        case UserType.UserNormal:
            controller.pageLink = WebViewLinks.FindRideHelp
            break
            
        default :
            break
        }

        
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func getDataInContentArray(){
        
        if Utility.isDriver(){
            contentArray = PostTrip.getPostTripData(name: FileNames.PostTripPlist)
        }
        else{
            contentArray = PostTrip.getPostTripData(name: FileNames.FindRidePlist)
        }
    }
    
    func settingUpShadow(){
        Utility.applyShadowOnView(view: addressView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    @IBAction func originButtonClicked(sender:UIButton){
        let alert = UIAlertController(title: "Choosing Locations", message: "Select Markers near you to choose an Origin and Destination", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Continue", style: .default, handler:{ action -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(action)
        
        present(alert, animated: false, completion: nil)
        //slectedIndex = 0
        //showPlacePicker(addressLable: originLable)
    }
    
    @IBAction func destinationButtonClicked(sender:UIButton){
        let alert = UIAlertController(title: "Choosing Locations", message: "Select Markers near you to choose an Origin and Destination", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Continue", style: .default, handler:{ action -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(action)
        
        present(alert, animated: false, completion: nil)
        //slectedIndex = 1
        //showPlacePicker(addressLable: destinationLable)
    }

    @IBAction func dateButtonClicked(sender:UIButton){
        let objectReturnTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDate, array: contentArray)
        let index = contentArray.index(of: objectReturnTrip)
        selectDOB(label: dateLable, index: index!)
    }
    
    @IBAction func returnDateButtonClicked(sender:UIButton){

        let objectReturnTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripReturnDate, array: contentArray)
        let index = contentArray.index(of: objectReturnTrip)
        selectDOB(label: returnDataLable, index: index!)
    }
    
    func isUserDetailsSubmitted() -> Bool {
//        if User.isUserDetailsNotSubmitted() || (User.isDriverDetailsNotSubmitted() && Utility.isDriver()) {
//            showAlertToDriverIfDetailsNotSubmitted()
//            return false
//        }
        if (User.isDriverDetailsNotSubmitted() && Utility.isDriver()) {
            showAlertToDriverIfDetailsNotSubmitted()
            return false
        }
        return true
    }
    
    @IBAction func searchRideButtonClicked(sender:UIButton){
        if isUserDetailsSubmitted() && applyValidation() {
            pushViewController(controllerIdentifier: SearchRidesViewController.nameOfClass(), navigationTitle: ApplicationConstants.SearchRideTitle, conditons: drawRoute.selectedRoute)
        }
    }
    
    @IBAction func goBackToDashboardController(segue:UIStoryboardSegue) {
        perform(#selector(createRideButtonClicked), with: nil, afterDelay: 0.5)
    }

    @IBAction func createRideButtonClicked(sender:UIButton?){
        if isUserDetailsSubmitted() && applyValidation() {
            var screenTitle = ""
            switch(Utility.getUserType()){
            
            case UserType.UserDriver:
                screenTitle = ApplicationConstants.CreateTripPostRideTitle
                break
                
            case UserType.UserNormal:
                screenTitle = ApplicationConstants.CreateTripTitle

                break
                
            default:
                break
            }
            pushViewController(controllerIdentifier: CreateTripModifiedController.nameOfClass(), navigationTitle: screenTitle, conditons: drawRoute.selectedRoute )
        }
    }
    
    func showAlertToDriverIfDetailsNotSubmitted(){
        let alert = UIAlertController(title: "" , message: ApplicationConstants.DriverDetailsNotSubmittedMessage , preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: { action -> Void in
        })
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action -> Void in
            let  controller = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.nameOfClass())
            self.navigationController?.pushViewController(controller!, animated: true)
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func roundTripButtonClicked(sender:UIButton){
        roundTripCheckBoxImageView.isHighlighted = !roundTripCheckBoxImageView.isHighlighted
        
        let objectRoundTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripRoundTrip, array: contentArray)
        objectRoundTrip.isselected = NSNumber(booleanLiteral: (roundTripCheckBoxImageView.isHighlighted))
        let index = contentArray.index(of: objectRoundTrip)
        syncWithPlist(index: index!, value: "")
        resizeReturnView()
    }
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    var buttonHeight: NSLayoutConstraint!
    func resizeReturnView(){
        buttonHeight = returnDateButton.heightAnchor.constraint(equalToConstant: 0)
        if returnDataView.isHidden {
            buttonHeightConstraint.constant = 0
          //  buttonHeight.isActive = true
        }
        else {
            buttonHeightConstraint.constant = 40
         //   buttonHeight.isActive = false
        }
    }
    
    func isRoundTrip() -> Bool {
        let trip = DataPersister.sharedInstance.getTripInfo()
        if (trip != nil) {
            return (trip?.roundTrip) ?? false
        }
        return false
    }
    
    func setOrUpdateEstimate(_ estimate: String? = ""){
        if isRoundTrip() {
            self.rideEstimatesLable.text = Utility.setEstimateRangeForRoundTrip()
        }
        else {
            self.rideEstimatesLable.text = estimate ?? "$0"
        }
    }
    
    @IBAction func bookNowButtonClicked(sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let objectBooknow = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripBookNow, array: contentArray)
        objectBooknow.isselected = NSNumber(booleanLiteral: (sender.isSelected))
        let index = contentArray.index(of: objectBooknow)
        syncWithPlist(index: index!, value: "")
    }
    
    @IBAction func editEstimatesButtonButtonClicked(sender:UIButton){
        
    }



    // MARK: - Helper functions

    func showPlacePicker(addressLable:UILabel ){
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func selectLocation(addressLable:UILabel, addressTitle:String,
                        addressLocation: CLLocationCoordinate2D, isDestination: Bool ){
        
        addressLable.text = addressTitle
        
        var object : PostTrip? = nil
        var index = 0
        
        if (isDestination) {
            object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: getContentArray())
        } else {
            object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: getContentArray())
        }
        
        index = contentArray.index(of: object!)!
        
        object?.address = Utility.getCoordinateString(byCLLocationCoordinate2D: addressLocation)
        syncWithPlist(index: index, value: addressTitle)
        
        calculateDistance()
    }
    
    func syncWithPlist(index:Int , value:String, address:String? = nil){
        
        var contentArray = getContentArray()
        let postTrip: PostTrip = contentArray[index]
        postTrip.placeholdertext = value
        if address != nil {
            postTrip.address = address
        }
        _ = (DataPersister.sharedInstance.saveTrip(trip: postTrip))
        getCacheData()
    }
    
    func applyValidation()->(Bool){
        var isVerified = true
        let alertMessage = isVerifiedFields()
        if alertMessage.isEmpty {
            
            if !(Utility.isDateValid(date: dateLable.text!)){
                Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
                return false
            }
            
            if self.routeArray.count == 0 ||  self.routeArray.isEmpty {
                Utility.showAlertwithOkButton(message: ApplicationConstants.InvalidRouteMessage, controller: self)
                return false
            }
            
            
            
            if roundTripCheckBoxImageView.isHighlighted {
                
                if (returnDataLable.text)!.compare("Select Date") == .orderedSame{
                    Utility.showAlertwithOkButton(message: ValidationMessages.SelectorMessageReturnDate, controller: self)
                    return false

                }
                if !(Utility.isDateValid(date: returnDataLable.text!)){
                    Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
                    return false
                }
                if !(Utility.validTwoDates(date1: dateLable.text!, date2: returnDataLable.text!)){
                    Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
                    return false
                }
            }
            
            let trip_origin = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin) as! String
            let trip_destination = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination) as! String
            
            if trip_origin.compare(trip_destination) == .orderedSame {
                Utility.showAlertwithOkButton(message: ApplicationConstants.SameAddressMessage, controller: self)
                return false
            }
            
        }else{
            isVerified = false
            Utility.showAlertwithOkButton(message: alertMessage, controller: self)
        }
        
        return isVerified
    }
    
    func getContentArray()->[PostTrip]{
        return contentArray
    }
    
    func selectDOB(label: UILabel, index: Int){
        
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            
            if (Utility.isDateValid(date: selectedData)){
                label.text = selectedData
                self.syncWithPlist(index: index, value: selectedData)
            }
            else{
                Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
            }
        }
    }
    
    func getCacheData(){
        
      
        let trip = DataPersister.sharedInstance.getTripInfo()
        if (trip != nil) {
            
            let object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: getContentArray())
            
            if trip?.origin != nil{
                object.placeholdertext = (trip?.origin)
                object.address = trip?.originCoordinates
                originLable.text = object.placeholdertext
            }
            
            
            let objectDest = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: getContentArray())
            
            if trip?.destination != nil{
                objectDest.placeholdertext = trip?.destination
                objectDest.address = trip?.destinationCoordinates
                destinationLable.text = objectDest.placeholdertext
            }
            else if trip?.origin != nil {
                if let coordinates = trip?.originCoordinates {
                    let latLong = coordinates.split(separator: ",")
                    self.setCameraPosition(latitude: String(latLong[0]), longitude: String(latLong[1]))
                }
            }
            
            let objectBooknow = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripBookNow, array: contentArray)
            objectBooknow.isselected = NSNumber(booleanLiteral: (trip?.bookNow)!)
        
            let objectRoundTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripRoundTrip, array: contentArray)
            objectRoundTrip.isselected = NSNumber(booleanLiteral: (trip?.roundTrip)!)
            roundTripCheckBoxImageView.isHighlighted = objectRoundTrip.isselected.boolValue
            
            if roundTripCheckBoxImageView.isHighlighted {
                returnDataView.isHidden = false
            }
            else{
                returnDataView.isHidden = true
                returnDataLable.text = ApplicationConstants.SelectRoundTripDate

            }
            resizeReturnView()
            
            let keyEstimates = Utility.getEstimatesKey()
            let estimateObject = Utility.getPostTripModel(key: keyEstimates, array: contentArray)
            if trip?.estimate != nil{
                estimateObject.placeholdertext = trip?.estimate
                setOrUpdateEstimate((trip?.estimate)!)
            }
            
            setOrUpdateDate(date: trip?.date)
            
        }
        else {

//            switch (Utility.getUserType()){
//            case UserType.UserDriver:
//                //update map location to New York
//                let sydney = GMSCameraPosition.camera(withLatitude: 40.713014,
//                                                      longitude: -74.000482,
//                                                      zoom: 6)
//                gmsMapView.camera = sydney
//                break
//
//            case UserType.UserNormal:
//                LocationService.shared.trackLocation { (latitude , longitude) in
//
//                    let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
//
//                    LocationService.fetchCountryAndCity(location: location)
//                    { (address, country, city, province, placename) in
//
//                        self.syncWithPlist(index: 0, value: address, address: latitude+","+longitude)
//                        let sydney = GMSCameraPosition.camera(withLatitude: Double(latitude)!,
//                                                              longitude: Double(longitude)!,
//                                                              zoom: 12)
//                        self.gmsMapView.camera = sydney
//
//                    }
//
//                    LocationService.shared.stopTrackingLocation()
//                }
//                break
//
//            default :
//                break
//            }
//
            
            LocationService.shared.trackLocation { (latitude , longitude) in
                
                let location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                
                LocationService.fetchCountryAndCity(location: location)
                { (address, country, city, province, placename) in
                    
                    let index = (Utility.getUserType() == UserType.UserDriver) ? 1 : 0
                    
                    self.syncWithPlist(index: index, value: address, address: latitude+","+longitude)
//                    let sydney = GMSCameraPosition.camera(withLatitude: Double(latitude)!,
//                                                          longitude: Double(longitude)!,
//                                                          zoom: 12)
//                    self.gmsMapView.camera = sydney
                    
                    self.setCameraPosition(latitude: latitude, longitude: longitude)
                    
                }
                
                LocationService.shared.stopTrackingLocation()
            }
            
            return
        }

        updateMarkers()
    }
    
    func setCameraPosition(latitude: String, longitude: String){
        let sydney = GMSCameraPosition.camera(withLatitude: Double(latitude)!,
                                              longitude: Double(longitude)!,
                                              zoom: 12)
        self.gmsMapView.camera = sydney
    }
    
    func setOrUpdateDate(date: String?){
        let objectReturnTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDate, array: contentArray)
        var correctDate = date
        if let date = date{
            if !Utility.isDateValid(date: date) {
                correctDate = Utility.getCurrentDate()
            }
        } else {
            correctDate = Utility.getCurrentDate()
        }
        self.dateLable.text = correctDate
        if date != correctDate {
            let index = contentArray.index(of: objectReturnTrip)
            self.syncWithPlist(index: index!, value: correctDate!)
        }
    }
    
    func isVerifiedFields() -> String {
        var emptyFields = [String]()
        
        if isEmpty(titleKey: originLable.text!, placeHolderText: PlistPlaceHolderConstant.PlaceHolderForMap) {
            emptyFields.append(PlistPlaceHolderConstant.PostTripOrigin)
        }
        
        if isEmpty(titleKey: destinationLable.text!, placeHolderText: PlistPlaceHolderConstant.PlaceHolderForMap) {
            emptyFields.append(PlistPlaceHolderConstant.PostTripDestination)
        }
     
        var message = ""
        
        if emptyFields.count > 0 {
            message = WarningMessage.PleaseSelectText
            message += emptyFields.joined(separator: ", ")
            message += WarningMessage.BeforeProceedingText
        }
        
        return message
    }
    
    func isEmpty(titleKey: String, placeHolderText: String) -> Bool{
        
        return titleKey.caseInsensitiveCompare(placeHolderText) == .orderedSame
//        let object = Utility.getPostTripModel(key: titleKey, array: getContentArray())
//        return (object.placeholdertext == placeHolderText)
    }
    
    func calculateDistance(){
        
        let tripOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: contentArray)
        let destinationOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: contentArray)
        
        if (!(tripOriginObject.address.isEmpty) && !(destinationOriginObject.address.isEmpty))
        {
            PostTrip.calculateRoutePriceEstimation(fromOrigin: tripOriginObject.address, toDestination: destinationOriginObject.address, completionHandler: { (object, message, active, status, error) in
                if status!{
                    
                    let keyEstimates = Utility.getEstimatesKey()
                    let estimateObject = Utility.getPostTripModel(key: keyEstimates, array: self.contentArray)
                    estimateObject.placeholdertext = object
                    self.setOrUpdateEstimate(object!)
                    _ = DataPersister.sharedInstance.saveTrip(trip: estimateObject)
                }
            })
        }
    }

    @IBAction func onShowAddressViewButtonClicked(_ sender: UIButton) {
        
      //  addressView.isHidden = !addressView.isHidden
        
        setVisibilityAddressView(!addressView.isHidden)
    }
    
    var drawRoute: DrawRoute!
    
    func updateMarkers(isHideAddressView: Bool = false){
    //    setVisibilityAddressView(isHideAddressView)
        gmsMapView.clear()
        if drawRoute == nil {
            drawRoute = DrawRoute()
            drawRoute.gmsMapView = gmsMapView
        }
        
        loadMarkers()
        
        drawRoute.getRoutes()
        { routes in
            self.routeArray = routes

            if (routes?.count ?? 0) > 0 {
//                self.routeArray = routes
//                self.setVisibilityAddressView(isHideAddressView)
            }
        }
        
    }
    
    func loadMarkers() {
        
        let geocoder = GMSGeocoder()
        
        // Lewis University
        let position1 = CLLocationCoordinate2D(latitude: 41.607505, longitude: -88.123169)
        let marker1 = GMSMarker(position: position1)
        geocoder.reverseGeocodeCoordinate(position1) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Walmart - "
                let fullAddress = addressName + address
                
                marker1.userData = fullAddress
                marker1.title = fullAddress
                marker1.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker1.icon = UIImage(named: "marker_walmart")
                
            }
        }
        marker1.map = gmsMapView
        
        let position2 = CLLocationCoordinate2D(latitude: 41.6026022, longitude: -88.0826332)
        let marker2 = GMSMarker(position: position2)
        geocoder.reverseGeocodeCoordinate(position2) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Lewis University Bookstore - "
                let fullAddress = addressName + address
                
                marker2.userData = fullAddress
                marker2.title = fullAddress
                marker2.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker2.icon = UIImage(named: "marker_school")
            }
        }
        marker2.map = gmsMapView
        
        // U of I
        let position3 = CLLocationCoordinate2D(latitude: 40.112070, longitude: -88.159980)
        let marker3 = GMSMarker(position: position3)
        geocoder.reverseGeocodeCoordinate(position3) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Walmart - "
                let fullAddress = addressName + address
                
                marker3.userData = fullAddress
                marker3.title = fullAddress
                marker3.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker3.icon = UIImage(named: "marker_walmart")
                
            }
        }
        marker3.map = gmsMapView
        
        let position4 = CLLocationCoordinate2D(latitude: 40.103531, longitude: -88.238302)
        let marker4 = GMSMarker(position: position4)
        geocoder.reverseGeocodeCoordinate(position4) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Wassaja Hall - "
                let fullAddress = addressName + address
                
                marker4.userData = fullAddress
                marker4.title = fullAddress
                marker4.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker4.icon = UIImage(named: "marker_school")
            }
        }
        marker4.map = gmsMapView
        
        // U of W
        let position5 = CLLocationCoordinate2D(latitude: 43.074992, longitude: -89.453643)
        let marker5 = GMSMarker(position: position5)
        geocoder.reverseGeocodeCoordinate(position5) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Target - "
                let fullAddress = addressName + address
                
                marker5.userData = fullAddress
                marker5.title = fullAddress
                marker5.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker5.icon = UIImage(named: "marker_target")
                
            }
        }
        marker5.map = gmsMapView
        
        let position6 = CLLocationCoordinate2D(latitude: 43.077484, longitude: -89.415662)
        let marker6 = GMSMarker(position: position6)
        geocoder.reverseGeocodeCoordinate(position6) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Sullivan Residence Hall - "
                let fullAddress = addressName + address
                
                marker6.userData = fullAddress
                marker6.title = fullAddress
                marker6.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker6.icon = UIImage(named: "marker_school")
            }
        }
        marker6.map = gmsMapView
        
        // NIU
        let position7 = CLLocationCoordinate2D(latitude: 41.949699, longitude: -88.722076)
        let marker7 = GMSMarker(position: position7)
        geocoder.reverseGeocodeCoordinate(position7) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Walmart - Market Square, Dekalb, IL 60115, USA"
                let fullAddress = addressName
                
                marker7.userData = fullAddress
                marker7.title = fullAddress
                marker7.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker7.icon = UIImage(named: "marker_walmart")
                
            }
        }
        marker7.map = gmsMapView
        
        let position8 = CLLocationCoordinate2D(latitude: 41.938502, longitude: -88.776738)
        let marker8 = GMSMarker(position: position8)
        geocoder.reverseGeocodeCoordinate(position8) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Grant Towers - "
                let fullAddress = addressName + address
                
                marker8.userData = fullAddress
                marker8.title = fullAddress
                marker8.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker8.icon = UIImage(named: "marker_school")
            }
        }
        marker8.map = gmsMapView
        
        let position9 = CLLocationCoordinate2D(latitude: 41.937801, longitude: -88.780960)
        let marker9 = GMSMarker(position: position9)
        geocoder.reverseGeocodeCoordinate(position9) { response, error in
            if let location = response?.firstResult() {
                
                let lines = location.lines! as [String]
                let address = lines.joined(separator: "\n")
                let addressName = "Stevenson Hall - "
                let fullAddress = addressName + address
                
                marker9.userData = fullAddress
                marker9.title = fullAddress
                marker9.snippet = "Tap HERE to set as Origin \nHOLD to set as Destination"
                marker9.icon = UIImage(named: "marker_school")
            }
        }
        marker9.map = gmsMapView
    }
    
//    func updateMarkers(isHideAddressView: Bool = false){
//
//        gmsMapView.clear()
//
//        var markers = [GMSMarker]()
//
//        let tripOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: contentArray)
//        let destinationOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: contentArray)
//
//        let tripOriginLatLon = tripOriginObject.address.split(separator: ",") .map( { String($0) } )
//
//        if let lat = tripOriginLatLon.first, let lon = tripOriginLatLon.last {
//
//            markers.append(Utility.drawPin(map: gmsMapView, lat:lat, lon: lon, isDropOff: nil))
//
//        }
//
//        let destination = destinationOriginObject.address.split(separator: ",") .map( { String($0) } )
//
//        if let lat = destination.first, let lon = destination.last {
//
//            markers.append(Utility.drawPin(map: gmsMapView, lat:lat, lon: lon, isDropOff: nil))
//
//        }
//
//        var bounds = GMSCoordinateBounds()
//        for marker in markers
//        {
//            marker.icon = nil
//            bounds = bounds.includingCoordinate(marker.position)
//        }
//
//        if (markers.count > 0){
//            let update = GMSCameraUpdate.fit(bounds)
//            gmsMapView.animate(with: update)
//            gmsMapView.moveCamera(update)
//        }
//
//        if (markers.count == 2){
//          //  addressView.isHidden = isHideAddressView
//            setVisibilityAddressView(isHideAddressView)
//        }
//    }
    
    func setVisibilityAddressView(_ isHidden: Bool){
        addressView.isHidden = isHidden
        floatingButton.isSelected = !isHidden
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

extension PassengerTripController : GMSPlacePickerViewControllerDelegate {
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//        let model = getContentArray()[slectedIndex]
        var object : PostTrip? = nil
        var index = 0
        if slectedIndex == 0 {
            object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: getContentArray())
            index = contentArray.index(of: object!)!
        }
        else{
            object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: getContentArray())
            index = contentArray.index(of: object!)!


        }

        if (place.formattedAddress != nil){
            object?.address = Utility.getCoordinateString(byCLLocationCoordinate2D: place.coordinate)
            syncWithPlist(index: index, value: place.formattedAddress!)
        }
            
        else{
            placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(place.placeID ?? "", callback: { (objGMSPlace, error) in
                if (objGMSPlace != nil){
                    object?.address = Utility.getCoordinateString(byCLLocationCoordinate2D: place.coordinate)
                    self.syncWithPlist(index: index, value: (objGMSPlace?.formattedAddress)!)
                    self.calculateDistance()
                   // self.updateMarkers(isHideAddressView: false)
                }
            })
        }
        calculateDistance()
       // self.updateMarkers(isHideAddressView: false)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}
