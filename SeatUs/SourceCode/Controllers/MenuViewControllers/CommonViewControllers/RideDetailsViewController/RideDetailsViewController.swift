//
//  RideDetailsViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 12/12/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol RideDetailsViewControllerDelegate: class {
    func onDestroyRide()
    func onRideCompleted()
}

class RideDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContentView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet  var allWidthRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet  var widthEqualLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var decideTripTimeView: UIView!
    
    weak var delegate: RideDetailsViewControllerDelegate?
    
    var contentArray : [TripPlistEntity]! = []
    var tripID:String!
    var tripInfo :Trip!
    var hieghtConstraintClone : NSLayoutConstraint? = nil

    var isFromSearchScreen = false
    var isRoundTripButSingle = false
    var isRoundTrip = false
    
    var isGoingForCreditCard = false
    let SharedItineraryWith = "Share Itinerary"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCustomCell()
        getTripDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isGoingForCreditCard {
            isGoingForCreditCard = false
            showMakeOfferPopup()
        }
        
    }
    
    @IBAction func goBackToRideDetailsViewController(segue:UIStoryboardSegue) {
        
        if segue.identifier?.compare("comingFromOfferDetailsVC_RD") == ComparisonResult.orderedSame{
            self.perform(#selector(self.getTripDetails), with: nil, afterDelay: 0.3)

            //getTripDetails()
        }
        
        if segue.identifier?.compare("comingFromSeatDetails_RD") == ComparisonResult.orderedSame{
            self.perform(#selector(self.getTripDetails), with: nil, afterDelay: 0.3)

            //getTripDetails()
        }
        
        if segue.identifier?.compare("BackToRideDetailScreen") == ComparisonResult.orderedSame{
            self.delegate?.onRideCompleted()
            self.perform(#selector(self.getTripDetails), with: nil, afterDelay: 0.3)
            //getTripDetails()
        }

    }
    
    @IBAction func leftButtonClicked(sender:UIButton){
        showBookNowPopup()
    }
    
    @IBAction func rightButtonClicked(sender:UIButton){
        
        
        switch (sender.title(for: .normal)){
            
        case ApplicationConstants.MakeOfferTitle?:
            let miles = Int(tripInfo.expected_distance_format?.components(separatedBy: " ").first ?? "")
            if(miles ?? 11 <= 10 ) && !tripInfo.expected_start_time.contains("00:00:00"){
                showBookNowPopup()
            }
            else {
                showMakeOfferPopup()
            }
            break
            
        case ApplicationConstants.ViewOfferTitle?:
            pushViewController(controllerIdentifier: OffersDetailViewController.nameOfClass(), navigationTitle: ApplicationConstants.OfferDetailsScreenTitle, conditons: tripInfo)
            break

        case ApplicationConstants.StartRideTitle?:
            pushTrackingComtrollers()
            break
            
            
        case ApplicationConstants.StartRoundTripTitle?:
            pushTrackingComtrollers()
            break

            
            
        case ApplicationConstants.ResumeRide?:
            pushTrackingComtrollers()
            break

            
        case ApplicationConstants.TrackRide?:
            pushTrackingControllerForPassenger()
            break
            
            
        case ApplicationConstants.NeedToPaymentTitle?:
            setPaymentStatus()
            break
            
        default:
            break
        }
    }
    
    
    @IBAction func onDecideTripTimeButtonClicked(_ sender: Any) {
        if (self.tripInfo.seats_available?.intValue)! > 0 &&
          ((self.tripInfo.seats_total?.intValue)! - (self.tripInfo.seats_available?.intValue)! > 0) {
            self.showAlertForForcefullyStartRide()
        }
        else{
            showTimePicker()
        }
    }
    
    func pushTrackingControllerForPassenger(){
        pushViewController(controllerIdentifier: PassengerTrackingViewController.nameOfClass(), navigationTitle: "Tracking")
    }

    func startTrackLocationForDriver(){
        
        
        switch LocationService.shared.getLocationServiceStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            print("notDetermined")
            break
            
        case .restricted, .denied:
            // Disable location features
            LocationService.shared.locationNotEnableAlertMessage(onController: self)
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            print("authorizedWhenInUse")
            LocationService.shared.escalateLocationServiceAuthorization()
            LocationService.shared.startTrackingLocation()
            
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            print("authorizedAlways")
            LocationService.shared.escalateLocationServiceAuthorization()
            LocationService.shared.startTrackingLocation()
            
            break
        }
        
    }
    func pushTrackingComtrollers(){
        
        if Utility.isDriver() {
            startTrackLocationForDriver()
        }

        pushViewController(controllerIdentifier: TripTrackingViewController.nameOfClass(), navigationTitle: ApplicationConstants.TrackingControllerTitle)

    }

    func geRideActualTimeObject()->(TripPlistEntity){
        let entity = TripPlistEntity()
        entity.title = PlistPlaceHolderConstant.PostTripTimeOfDay
        entity.cellidentifier = LabelCell.nameOfClass()
        entity.placeholdertext = Utility.getFormatedDate(sourceDate: tripInfo.expected_start_time, sourceDateFormat: ApplicationConstants.DateTimeServerFormat, destinationDateFormat: ApplicationConstants.TimeFormat_12)
        return entity
    }
    
    func getTripCancelObject()->(TripPlistEntity){
        let entity = TripPlistEntity()
        entity.title = PlistPlaceHolderConstant.RideStatus
        entity.cellidentifier = LabelCell.nameOfClass()
        return entity
    }
    func getShareItenaryButton()->(TripPlistEntity){
        let entity = TripPlistEntity()
        entity.title = "ShareItinaryCell"
        entity.imagename = "share_btn_trip"
        entity.cellidentifier = SingleActionButtonCell.nameOfClass()
        return entity
    }
    
    func removeObjectFromArray(key: String){
        if let object = Utility.getPostTripModel(key: key, array: contentArray) as? TripPlistEntity {
            let index = contentArray.index(of: object)
            contentArray.remove(at: index!)
        }
    }
    
    func updateView(){
        
        if (!Utility.isDriver() && (tripInfo.is_member?.boolValue)! && ( tripInfo.needs_payment?.boolValue != nil ) && (tripInfo.needs_payment?.boolValue)!) {
            
            buttonContentView.isHidden = false

            widthEqualLeftButtonConstraint.isActive = false

            // set right button width to fill parent
            allWidthRightButtonConstraint.isActive = true
            rightButton.setTitle(ApplicationConstants.NeedToPaymentTitle, for: .normal)

            return

        }
        
        var pretentNotA_Member = true
        if let isMember = tripInfo.is_member?.boolValue{
            pretentNotA_Member = isMember
        }
        

        if let isDriver = tripInfo.is_driver?.boolValue{
            pretentNotA_Member = isDriver
        }

        
        //if !(tripInfo.is_enabled_booknow?.boolValue)!{
            
            // remove constraint of equal width with left button
            widthEqualLeftButtonConstraint.isActive = false
            
            // set right button width to fill parent
            allWidthRightButtonConstraint.isActive = true
        //}
        if (pretentNotA_Member){
            // if user is  member of trip
            buttonContentView.isHidden = true
            //let hieghtConstraint:NSLayoutConstraint = buttonContentView.heightAnchor.constraint(equalToConstant: 0)
            //hieghtConstraintClone = hieghtConstraint
            //NSLayoutConstraint.activate([hieghtConstraint])

        }
        else{
            // if user is not member of trip
            buttonContentView.isHidden = false
            
            let widthConstraintBookNowButton:NSLayoutConstraint = leftButton.widthAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([widthConstraintBookNowButton])

            let objectGroupChatCell = Utility.getPostTripModel(key: PlistPlaceHolderConstant.GroupChatCell, array: contentArray)
            
            let objectShareItenariCell = Utility.getPostTripModel(key: PlistPlaceHolderConstant.ShareItenariCell, array: contentArray)
            
            
            let indexChat = contentArray.index(of: objectGroupChatCell as! TripPlistEntity)
            let indexItenary = contentArray.index(of: objectShareItenariCell as! TripPlistEntity)

            contentArray.remove(at: indexChat!)
            contentArray.remove(at: (indexItenary!-1))

            tableView.reloadData()
            
            if (tripInfo.has_initiated_offer?.boolValue)!{
                
                // if user initiated offer
                rightButton.setTitle(ApplicationConstants.ViewOfferTitle, for: .normal)
            }
            else{
                // if user not initiated offer
                rightButton.setTitle(ApplicationConstants.MakeOfferTitle, for: .normal)
            }

        }

        switch tripInfo.ride_status {
        case RideStaus.CONFIRMED?:
            
            if Utility.isDriver() {
                buttonContentView.isHidden = false
                
                widthEqualLeftButtonConstraint.isActive = false
                
                // set right button width to fill parent
                allWidthRightButtonConstraint.isActive = true

                rightButton.setTitle(ApplicationConstants.StartRideTitle, for: .normal)
            }
            break
            
        case RideStaus.STARTED?:
            
            if Utility.isDriver() {
                
                buttonContentView.isHidden = false
                
                widthEqualLeftButtonConstraint.isActive = false
                
                // set right button width to fill parent
                allWidthRightButtonConstraint.isActive = true
                rightButton.setTitle(ApplicationConstants.ResumeRide, for: .normal)
            }
            else{
                
                buttonContentView.isHidden = false
                
                widthEqualLeftButtonConstraint.isActive = false
                
                // set right button width to fill parent
                allWidthRightButtonConstraint.isActive = true
                
                rightButton.setTitle(ApplicationConstants.TrackRide, for: .normal)
                
                rightButton.isHidden = Passenger.isPassengerDropped(passengers: tripInfo.passengers!)
                leftButton.isHidden = rightButton.isHidden

            }
            break
            
            
        case RideStaus.RETURN_CONFIRMED?:
            
            if Utility.isDriver() {

            buttonContentView.isHidden = false
            
            widthEqualLeftButtonConstraint.isActive = false
            
            // set right button width to fill parent
            allWidthRightButtonConstraint.isActive = true
            rightButton.setTitle(ApplicationConstants.StartRoundTripTitle, for: .normal)
            }

            break
            
        case RideStaus.CANCELED?:
            
            let cancelTrip = getTripCancelObject()
            
//            if Utility.isDriver() {
//
//                cancelTrip.placeholdertext = ApplicationConstants.RideLeftTitle
//
//            } else {
//
//                cancelTrip.placeholdertext = ApplicationConstants.RideCanceledTitle
//            }
            
            cancelTrip.placeholdertext = ApplicationConstants.RideCanceledTitle
            contentArray.append(cancelTrip)
            
            removeObjectFromArray(key: PlistPlaceHolderConstant.SeatsTitle)
            removeObjectFromArray(key: PlistPlaceHolderConstant.ViewMapCell)
            removeObjectFromArray(key: PlistPlaceHolderConstant.GroupChatCell)
            removeObjectFromArray(key: PlistPlaceHolderConstant.ShareItenariCell)
            
            tableView.reloadData()
            
            break
            
        default:
            break
        }
    
        // ( tripInfo.needs_payment?.boolValue != nil ) && (tripInfo.needs_payment?.boolValue)!
    }
    
    func loadTableViewData(object: Trip!){
        contentArray = Trip.getRideDetailsPlistData(name: FileNames.RideDetailsPlist)
        
        if Utility.isDriver() || object.driver?.first_name == nil {
            contentArray.remove(at: 0)
        }
        
       
        
        
        tripInfo = object
        
        if !isFromSearchScreen || isRoundTripButSingle || !isRoundTrip || !(tripInfo.is_roundtrip?.boolValue ?? false) {
            removeObjectFromArray(key: "Return Date")
            removeObjectFromArray(key: "Time of Day (Returning)")
            removeObjectFromArray(key: "Return Seats")
        }
        
        let isRequestedTrip = object?.is_request?.boolValue
        
        if !Utility.isDriver() && isRequestedTrip! {
            removeObjectFromArray(key: PlistPlaceHolderConstant.PostTripSeatsLabel)
            removeObjectFromArray(key: "Return Seats")
        }
        
        if let shared = object.itinerary_shared, shared.count <= 0 {
            removeObjectFromArray(key: SharedItineraryWith)
        }
        
        Manager.sharedInstance.currentTripInfo = tripInfo
        updateView()
        
        let trip = object
        
        if (trip != nil) {
            let object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: contentArray)
            
            if !Utility.isDriver() {
                removeObjectFromArray(key: PlistPlaceHolderConstant.TotalBagsPlaceHoilder)
            }
            else{
                let bagsObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.TotalBagsPlaceHoilder, array: contentArray)
                bagsObject.placeholdertext = Passenger.getTotalBags(passengers: (trip?.passengers)!)
            }
            
            if trip?.origin_title != nil{
                object.placeholdertext = (trip?.origin_title)
            }
        
            let objectDist = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDistance, array: contentArray)
            if trip?.expected_distance_format != nil{
                objectDist.placeholdertext = trip?.expected_distance_format
            }
            
            let objectTripName = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripId, array: contentArray)
            if trip?.trip_id != nil{
                objectTripName.placeholdertext = trip?.getTripIdOrTripName()
            }

            let objectDest = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: contentArray)
            if trip?.destination_title != nil{
                objectDest.placeholdertext = trip?.destination_title
             }
            
            //Utility.getFormattedEstimate(factor: 2, minEstimate: trip?.min_estimates?.doubleValue, maxEstimate: trip?.max_estimates?.doubleValue)
            let objectEstimates = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripEstimates, array: contentArray)
            if let min = trip?.min_estimates, let max = trip?.max_estimates {
                var estimate = "$0"
                var factor = 1.0
                if isFromSearchScreen {
                    if isRoundTripButSingle {
                        factor = 1.0
                    }
                    else if isRoundTrip {
                        factor = 2.0
                    }
                    else {
                        factor = 1.0
                    }
                }
                else {
                    factor = 1.0
//                    if trip?.is_roundtrip != nil {
//                        if trip?.is_roundtrip?.boolValue {
//                            factor
//                        }
//                    }
                }
                
                estimate = Utility.getFormattedEstimate(factor: factor, minEstimate: min.doubleValue, maxEstimate: max.doubleValue)
                objectEstimates.placeholdertext = estimate
             }
            
            let objectDate = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDate, array: contentArray)
            if trip?.date != nil{
                objectDate.placeholdertext = trip?.date
             }
            
            let returnDate = Utility.getPostTripModel(key: "Return Date", array: contentArray)
            if (returnDate.title != nil) , let returnTrip = trip?.return_trip {
                if let date = returnTrip["date"] as? String {
                    returnDate.placeholdertext = date
                }
                else {
                    returnDate.placeholdertext = ""
                }
            }
            else {
                removeObjectFromArray(key: "Return Date")
            }
            
            let payoutObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripPaymentOption, array: contentArray)
            if trip?.payout_type != nil{
                payoutObject.placeholdertext = trip?.payout_type?.capitalized
            }
            
            let tripType = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripType, array: contentArray)
            
            if isFromSearchScreen {
                if isRoundTrip && !isRoundTripButSingle {
                    tripType.placeholdertext = ApplicationConstants.TripTypeRound
                }
                else{
                    tripType.placeholdertext = ApplicationConstants.TripTypeSingle
                }
            }
            else {
                removeObjectFromArray(key: PlistPlaceHolderConstant.PostTripType)
            }
            
            //                if let isRoundTrip = trip?.is_roundtrip?.boolValue{
            //                    if (isRoundTrip){
            //                        tripType.placeholdertext = ApplicationConstants.TripTypeRound
            //                    }
            //                    else{
            //                        tripType.placeholdertext = ApplicationConstants.TripTypeSingle
            //                    }
            //                }
            //                else{
            //                    tripType.placeholdertext = ApplicationConstants.TripTypeSingle
            //                }
            
            var objectTimeOfDay = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripTimeOfDay, array: contentArray)
            var refrenceValueString = ""
            if trip?.time_range?.stringValue != nil{
                refrenceValueString = (trip?.time_range?.stringValue)!
             }
            
            objectTimeOfDay =  Utility.setTimeOfDay(trip: objectTimeOfDay, thresholdDay: refrenceValueString) as! TripPlistEntity
            
            var returnTimeOfDay = Utility.getPostTripModel(key: "Time of Day (Returning)", array: contentArray)
            if (returnTimeOfDay.title != nil) , let returnTrip = trip?.return_trip {
                var refrenceValueString = ""
                if let date = returnTrip["time_range"] as? NSNumber {
                    refrenceValueString = date.stringValue
                }
                if !refrenceValueString.isEmpty {
                    returnTimeOfDay =  Utility.setTimeOfDay(trip: returnTimeOfDay, thresholdDay: refrenceValueString) as! TripPlistEntity
                }
            }
            else {
                removeObjectFromArray(key: "Time of Day (Returning)")
            }
            
            switch (tripInfo.ride_status){
                
            case RideStaus.ACTIVE?, RideStaus.FILLED?, RideStaus.PENDING?:
                if !tripInfo.expected_start_time.contains("00:00:00") {
                    contentArray[4] = geRideActualTimeObject()
                }
                break

            case RideStaus.CONFIRMED?,RideStaus.STARTED?,RideStaus.ENDED?,RideStaus.RETURN_CONFIRMED?:
                contentArray[4] = geRideActualTimeObject()
                contentArray[contentArray.count-1] = getShareItenaryButton()

                break
                
            case RideStaus.STARTED?,RideStaus.ENDED?,RideStaus.CANCELED?,RideStaus.FAILED?,RideStaus.EXPIRED?:
                //contentArray.remove(at: contentArray.count-1)
                break
                
            default :
                break
            }


            let objectSeats = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripSeatsLabel, array: contentArray)
            
            var seatsCountText = ""
            if Utility.isDriver() && isRequestedTrip!{
                seatsCountText = "Required " + String(trip?.passengers?.count ?? 0)
            }
            else {
                seatsCountText = String(Passenger.getAvailableSeats(passengers: (trip?.passengers)!)) + " of " +  (trip?.seats_total?.stringValue)! + " seats filled"
            }
            
            objectSeats.placeholdertext = seatsCountText
            if (objectSeats.conditions != nil) && (trip?.seats_available?.stringValue != nil){
                let conditions = SeatsCondition.getSeatsCondition(objectSeats.conditions)[0]
                
//                if let isRequestExist = trip?.is_request?.boolValue{
//                    isRequestFromDriver = isRequestExist
//                }
                if Utility.isDriver() && isRequestedTrip!{
                    
                    conditions.text = ApplicationConstants.SeatRequiredStatus
                    conditions.circleimage = AssetsName.CircleImageAvailable
                    conditions.backgroundimage = AssetsName.BGImageAvailable
                    conditions.seatscount = "\((trip?.passengers?.count)!)"

                }
                else{
                    if (trip?.seats_available?.intValue)! > 0 {
                        
                        conditions.text = ApplicationConstants.SeatAvailableStatus
                        conditions.circleimage = AssetsName.CircleImageAvailable
                        conditions.backgroundimage = AssetsName.BGImageAvailable
                        conditions.seatscount = (trip?.seats_available?.stringValue)!
                    }
                    else{
                        conditions.text = ApplicationConstants.SeatFilledStatus
                        conditions.circleimage = AssetsName.CircleImageFilled
                        conditions.backgroundimage = AssetsName.BGImageFilled
                        conditions.seatscount = ""
                    }

                }
                
                objectSeats.conditions = [["text":conditions.text,"seatscount":conditions.seatscount,"circleimage":conditions.circleimage,"backgroundimage":conditions.backgroundimage]]
            }
        }
        
    
        
        seatsForReturn(trip: trip)
        
        let sharedItineary = Utility.getPostTripModel(key: SharedItineraryWith, array: contentArray)
        
        if let sharedCount = trip?.itinerary_shared?.count {
            sharedItineary.placeholdertext = String(sharedCount)
//           sharedItineary.placeholdertext = String(sharedCount) + " people"
//            if sharedCount > 1 {
//                sharedItineary.placeholdertext! += "s"
//            }
        }
        
   //     if ( tripInfo.needs_payment?.boolValue == nil ) || !(tripInfo.needs_payment?.boolValue)! {

//            let needtoPayementObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.NeedToPayment, array: contentArray)
//
//            contentArray.remove(at: contentArray.index(of: needtoPayementObject as! TripPlistEntity)!)
            
    //    }
    
    }
    
    func seatsForReturn(trip: Trip?){
        if trip?.return_trip == nil || (trip?.return_trip?.isEmpty)!   {
            return
        }
        let objectSeats = Utility.getPostTripModel(key: "Return Seats", array: contentArray)
        
        
        let seats_total = (trip?.return_trip!["seats_total"] as! NSNumber).intValue
        let seats_available = (trip?.return_trip!["seats_available"] as! NSNumber).intValue

        let seatAvaialableTrip = seats_total - seats_available
        
        let isRequestedTrip = trip?.is_request?.boolValue
        var seatsCountText = ""
        if Utility.isDriver() && isRequestedTrip!{
            seatsCountText = "Required " + String(seatAvaialableTrip)
        }
        else {
            seatsCountText = String(seatAvaialableTrip) + " of " + String(seats_total) + " seats filled"
        }
        
        objectSeats.placeholdertext = seatsCountText

        if (objectSeats.conditions != nil) && (trip?.seats_available?.stringValue != nil){
            let conditions = SeatsCondition.getSeatsCondition(objectSeats.conditions)[0]
            
            let total = trip?.return_trip!["seats_total"] as? NSNumber

            let available = trip?.return_trip!["seats_available"] as? NSNumber
            
            let isRequestedTrip = trip?.is_request?.boolValue
            if Utility.isDriver() && isRequestedTrip!{
                
                conditions.text = ApplicationConstants.SeatRequiredStatus
                conditions.circleimage = AssetsName.CircleImageAvailable
                conditions.backgroundimage = AssetsName.BGImageAvailable
                if let _total = total, let _available = available {
                    conditions.seatscount = "\((_total.intValue - _available.intValue))"
                }
                
            }
            else{
                if (trip?.seats_available?.intValue)! > 0 {
                    
                    conditions.text = ApplicationConstants.SeatAvailableStatus
                    conditions.circleimage = AssetsName.CircleImageAvailable
                    conditions.backgroundimage = AssetsName.BGImageAvailable
                    if let _available = available {
                        conditions.seatscount = "\((_available.intValue))"
                    }
                }
                else{
                    conditions.text = ApplicationConstants.SeatFilledStatus
                    conditions.circleimage = AssetsName.CircleImageFilled
                    conditions.backgroundimage = AssetsName.BGImageFilled
                    conditions.seatscount = ""
                }
                
            }
            
            objectSeats.conditions = [["text":conditions.text,"seatscount":conditions.seatscount,"circleimage":conditions.circleimage,"backgroundimage":conditions.backgroundimage]]
        }
    }
    
    
    @objc func getTripDetails(){
        let filterObject: [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any]
        Trip.getTripDetailsFromSever(filterObject: filterObject, rideService: WebServicesConstant.Details, tripId: tripID) { (object, message, active, status) in
            if status! {
                self.decideTripTimeView.isHidden = true
                let tripDetails = object as! Trip
                self.loadTableViewData(object: tripDetails)
                self.tableView.reloadData()
            }
            else{
                Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
            }
        }
    }
    
    
    func setPaymentStatus(){
        
        let tripId = (tripInfo.trip_id?.stringValue)!
        Trip.needPayment(trip_id: tripId) { (object, message, active, status) in
            if status! {
                    self.getTripDetails()
            }
            else{
                Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
            }
        }
        
    }
    
    func registerCustomCell(){
        
        for cell in [OffersDetailCell.nameOfClass(), LabelCell.nameOfClass(),MultipleCheckboxCell.nameOfClass(),SeatsCell.nameOfClass(),ViewMapCell.nameOfClass(),GroupChatCell.nameOfClass(),ShareItinaryCell.nameOfClass(), SingleActionButtonCell.nameOfClass(), MultiLabelCell.nameOfClass(), SingleActionButtonCell.nameOfClass() ] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    
    func showBookNowPopup(){
        //let recentTrip = PostTrip.getPostTripData(name: FileNames.PastTripsPlist)
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: BookNowViewController.nameOfClass())
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            self.getTripDetails()
        }
        
    }
    
    func showMakeOfferPopup(){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: MakeOfferViewController.nameOfClass())
        
        if isFromSearchScreen {
            if let cont = cont as? MakeOfferViewController {
                cont.isRoundTrip = isRoundTrip
                cont.isRoundTripButSingle = isRoundTripButSingle
                cont.estimates = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripEstimates, array: contentArray).placeholdertext ?? ""
            }
        }
    
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            
            if let code = selectedData["error_code"] as? String{
                if code == ErrorTypes.InvalidCCErrorCode{
                    self.isGoingForCreditCard = true
                    self.pushViewController(controllerIdentifier: MyPaymentsViewController.nameOfClass(), navigationTitle: "ADD CREDIT CARD", conditons: true)
                  //  self.pushController(controllerIdentifier: PaymentViewController.nameOfClass(), navigationTitle: ApplicationConstants.MyPaymentScreenTitle)
                }
            }
            else{
                self.getTripDetails()
            }
        }
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
    
    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        let postTrip: PostTrip = contentArray[index]
        
        if postTrip.hascustomaction == nil {
            return
        }
        
        let shouldCallCustomFunction = Bool(truncating: postTrip.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            switch postTrip.customactionname {
                
            case "clickShared":
                pushViewController(controllerIdentifier: SharedItineraryListViewController.nameOfClass() , navigationTitle: "Shared Itinerary Details", conditons: tripInfo.itinerary_shared ?? false)
                break;
                
            default: break
            }
        }
    }

}

extension RideDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = contentArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier , for: indexPath)
        
        switch cell {
            
        case is OffersDetailCell:
            
            let offersDetailCell = cell as! OffersDetailCell
            offersDetailCell.state = .isComingFromUpcomingTrips
            offersDetailCell.showCancelledView = true
            offersDetailCell.initiliazeCell(object: tripInfo)
            
        case is LabelCell:
            
            let labelCell = cell as! LabelCell
            labelCell.initializeCell(contentArray[indexPath.row], isMultiLineLable: true)
            labelCell.selectButton.tag = indexPath.row
            labelCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            
            if contentArray[indexPath.row].title == SharedItineraryWith {
                let attributes = [ NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 13.0), NSAttributedString.Key.foregroundColor: ApplicationConstants.PassengerThemeColor ]
                let content = NSMutableAttributedString(string: contentArray[indexPath.row].placeholdertext)
                let attributedContent = NSAttributedString(string: " (View)", attributes: attributes )
                content.append(attributedContent)
                labelCell.contentLabel.attributedText = content
            }
            
            break
            
        case is DateButtonCell:
            
            let dateCell = cell as! DateButtonCell
//            dateCell.initializeCell(contentArray[indexPath.row])
            dateCell.selectButton.tag = indexPath.row
            //            dateCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
            
        case is MultipleCheckboxCell:
            
            let multipleCheckboxCell = cell as! MultipleCheckboxCell
            multipleCheckboxCell.isSelectAllOption = true
            multipleCheckboxCell.initializeCell(contentArray[indexPath.row])
            multipleCheckboxCell.tag = indexPath.row
            multipleCheckboxCell.isEnabled = false
            multipleCheckboxCell.delegate = self
            
//            if Utility.isDriver() && ((tripInfo.ride_status == RideStaus.FILLED) || (tripInfo.ride_status == RideStaus.GOING_COMPLETED))
//            if Utility.isDriver() && ((Passenger.isAnySeatBooked(passengers: tripInfo.passengers!)) || (tripInfo.ride_status == RideStaus.GOING_COMPLETED))
            if Utility.isDriver() &&
                ((tripInfo.ride_status == RideStaus.FILLED) ||
                 (tripInfo.ride_status == RideStaus.ACTIVE))
            {
                decideTripTimeView.isHidden = false
                
                if ((self.tripInfo.seats_total?.intValue)! - (self.tripInfo.seats_available?.intValue)! == 0) &&
                    !self.tripInfo.expected_start_time.contains("00:00:00") {
                    decideTripTimeView.isHidden = true
                }
              //  multipleCheckboxCell.rideTimeButton.isHidden = false
            }
            else
            {
                decideTripTimeView.isHidden = true
            }
            multipleCheckboxCell.rideTimeButton.isHidden = true
            break
            
        case is SeatsCell:
            
            let seatsCellCell = cell as! SeatsCell
            seatsCellCell.initializeCell(contentArray[indexPath.row])
            seatsCellCell.tag = indexPath.row
            break
            
            
        case is SingleActionButtonCell:
            
            
            let singleActionButtonCell = cell as! SingleActionButtonCell
            singleActionButtonCell.delegate = self
            singleActionButtonCell.tag = indexPath.row

            if (contentArray[indexPath.row].title == "ShareItinaryCell"){
                singleActionButtonCell.button.setImage(UIImage(named: contentArray[indexPath.row].imagename) , for: .normal)
            }
            else{
                singleActionButtonCell.button.setTitle(contentArray[indexPath.row].title, for: .normal)
                singleActionButtonCell.button.setImage(UIImage() , for: .normal)
                singleActionButtonCell.button.setBackgroundImage(UIImage(), for: .normal)
            }
            break
            
        case is ActionDetailsCell:
            
            _ = cell as! ActionDetailsCell
//            actionDetailsCell.delegate = self
            break
            
        case is ViewMapCell:
            
            let viewMapCell = cell as! ViewMapCell
            viewMapCell.mapButton.addTarget(self, action: #selector(showMapScreen), for: .touchUpInside)
            break
            

        case is ShareItinaryCell:
            let shareItinaryCell = cell as! ShareItinaryCell
            shareItinaryCell.delegate = self
            break
            
            
        case is OffersDetailCell:
            break
            
        case is GroupChatCell:
            
            let groupChatCell = cell as! GroupChatCell
            groupChatCell.delegate = self
            break
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc func showMapScreen(){
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: MapPreviewViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    
    func showAlertForForcefullyStartRide(){
        
        let alert = UIAlertController(title: "", message: ApplicationConstants.ForefullyStartRideMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action -> Void in
        })
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            self.showTimePicker()
        })
        
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func showTimePicker(){
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.mode = 0
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            let hour = Int(selectedData.components(separatedBy: ":").first!)
            
            let tripWithTime = self.tripInfo.date! + " " + selectedData

            let tripDate = Utility.getDateFromString(date: tripWithTime, format: ApplicationConstants.DateTimeFormat)
            
            let isTimePassed = Utility.isTimePassed(onDate: tripDate)
            
            if !isTimePassed {
                let isTimeValid =  PostTrip.isTimeValid(hour: hour!, trip: self.tripInfo)
                
                if isTimeValid {
                    
                    let tripWithTime = self.tripInfo.date! + " " + selectedData
                    let date = Utility.getDateFromString(date: tripWithTime, format: ApplicationConstants.DateTimeFormat)
                    var adjustedDate = date.addingTimeInterval(1)
                    
                    let seconds = -TimeZone.current.secondsFromGMT()
                    adjustedDate.addTimeInterval(TimeInterval(seconds))
                    
                    let tripId = "\((self.tripInfo.trip_id?.intValue)!)"
                    let timeStamp = "\(Utility.convertDateToTimeStamp(date: adjustedDate))"
                    
                    let param :[String:Any] = ["trip_id":tripId,"pickup_time":timeStamp,ApplicationConstants.Token:User.getUserAccessToken() as Any]
                    
                    var isForcefully = false
                    
                    if (self.tripInfo.seats_available?.intValue)! > 0 {
                        isForcefully = true
                    }
                    
                    if(self.tripInfo.seats_total?.intValue)! - (self.tripInfo.seats_available?.intValue)! != 0 {
                        PostTrip.fixedRideTime(trip: self.tripInfo, param: param,fixedForcefully: isForcefully, completionHandler: { (object, message, active, status) in
                            
                            Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                            if status! {
                                self.getTripDetails()
                            }
                        })
                    } else {
                        PostTrip.fixedPreRideTime(trip: self.tripInfo, param: param, completionHandler: { (object, message, active, status) in
                            
                            Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                            if status! {
                                self.getTripDetails()
                            }
                        })
                    }
                    
                }
                else{
                    Utility.showAlertwithOkButton(message: "Selected time does not belong in the Trip TimeZone", controller: self)
                }
                
            }
            else{
                Utility.showAlertwithOkButton(message: "Please Select Future Time", controller: self)

            }
        }
    }
    
     func showCancelRideAlert(controller:BaseViewController){
        
        
        var alertTitle = ""
        var alertMessage = ""
        
        if Utility.isDriver(){
            alertTitle = ApplicationConstants.CancelRideTitleMessage
            alertMessage = ApplicationConstants.CancelRideMessage
        }
        else{
            alertTitle = ApplicationConstants.LeavRideTitleMessage
            alertMessage = ApplicationConstants.LeavRideMessage

        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            
        })
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            
            
            Trip.cancelTrip(trip_id: (self.tripInfo.trip_id?.stringValue)!) { (object, message, active, status) in
                self.perform(#selector(self.getTripDetails), with: nil, afterDelay: 0.5)
                if let messageText = message!["message"] as? String{
                    if messageText.count > 0 {
                        self.delegate?.onDestroyRide()
                        self.navigationController?.popViewController(animated: true)
                        Utility.showAlertwithOkButton(message: messageText, controller: self)
                    }
                }
            }
 
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func unwindFromItineraryDetailsVC(_ sender: UIStoryboardSegue) {
        getTripDetails()
    }
    
}

extension RideDetailsViewController: GroupChatCellDelegate {
    func viewSeatButtonClicked(_ sender: Any) {
        pushViewController(controllerIdentifier: RideSeatsDetailViewController.nameOfClass(), navigationTitle: ApplicationConstants.RideSeatsDetailTitle)
    }
    
    func groupChatButtonClicked(_ sender: Any) {
        pushViewController(controllerIdentifier: ChatViewController.nameOfClass(), navigationTitle: ApplicationConstants.GroupChatTitle, conditons: tripInfo)
    }
}

extension RideDetailsViewController: ShareItinaryCellDelegate {
    func onClickCancelOrLeaveTrip(_ sender: Any) {
        showCancelRideAlert(controller: self)
        
    }
    
    func onClickShare(_ sender: Any) {
        pushViewController(controllerIdentifier: ItineraryDetailsViewController.nameOfClass() , navigationTitle: "Itinerary Details", conditons: tripInfo)
    }
}

extension RideDetailsViewController: MultipleCheckboxCellDelegate {
    
    func clickEvent(_ tag: Int, CheckboxStates checkboxStates: [CheckboxState]) {
        print("called")
    }
    
    func rideTimeButtonClicked(){
        
        if (self.tripInfo.seats_available?.intValue)! > 0 &&
          ((self.tripInfo.seats_total?.intValue)! - (self.tripInfo.seats_available?.intValue)! > 0) {
            self.showAlertForForcefullyStartRide()
        }
        else{
            showTimePicker()
        }

    }
}

extension RideDetailsViewController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        
        if tag == contentArray.count-1{
            pushViewController(controllerIdentifier: ItineraryDetailsViewController.nameOfClass() , navigationTitle: "Itinerary Details", conditons: tripInfo)
        }
        else{
            Trip.savePaymentStatus() { (object, message, active, status) in
                self.getTripDetails()
            }
        }
    }
}

