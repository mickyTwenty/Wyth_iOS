//
//  PastTrip.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 05/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class GroupTrip: NSObject {
    var group_id : String?
    var trips = [Trip]()
}

class Trip: NSObject {
    
    @objc  var trip_id : NSNumber?
    @objc  var trip_name : String?
    @objc  var time_range : NSNumber?
    @objc  var origin_latitude : String?
    @objc  var origin_longitude : String?
    @objc  var origin_title : String?
    @objc  var destination_latitude : String?
    @objc  var destination_longitude : String?
    @objc  var destination_title : String?
    @objc  var seats_available : NSNumber?
    @objc  var seats_total : NSNumber?
    @objc  var started_at : String?
    @objc  var ended_at : String?
    @objc  var date : String?
    @objc  var ride_status : String?
    @objc  var rating : NSNumber?
    @objc  var individual_cost : NSNumber?
    @objc  var total_distance : String?
    @objc  var expected_distance_format : String?
    @objc  var driver : Driver? = nil
    @objc  var is_roundtrip : NSNumber?
    @objc  var passengers : [Passenger]?
    @objc  var offer_id : NSNumber?
    @objc  var estimates : String?
    @objc  var route_polyline : String?
    @objc  var group_id : String?
    @objc  var has_initiated_offer : NSNumber?
    @objc  var has_made_offer : NSNumber?
    @objc  var is_member : NSNumber?
    @objc  var is_driver : NSNumber?
    @objc  var is_request : NSNumber?
    @objc  var is_enabled_booknow : NSNumber?
    @objc  var expected_start_time: String!
    @objc  var passenger : Passenger? = nil
    @objc  var needs_payment : NSNumber?
    @objc var min_estimates : NSNumber?
    @objc var max_estimates : NSNumber?
    @objc var return_trip : [String:Any]?
    @objc var itinerary_shared : [[String:Any]]?
    @objc var start_time : String?
    @objc var payout_type : String?
    
    class func getRideDetailsPlistData(name: String)->[TripPlistEntity]{
        
        let objects =  PlistUtility.getPlistDataForPostTrip(name: name)
        var array = [TripPlistEntity]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value as![String:Any]
            let model = TripPlistEntity()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! TripPlistEntity)
        }
        return array
    }

    
    class func getOffersCollectionName(trip:Trip)->(String){
        
        //        offers_96_172 : sample collection name format
        var collectionName = ""
        let driverID = (trip.driver?.user_id?.intValue)!
        let passengerID = (trip.passenger?.user_id?.intValue)!
        
        if driverID > passengerID{
            collectionName = "offers_" + "\(passengerID)_" + "\(driverID)"
        }
        else{
            collectionName = "offers_" + "\(driverID)_" + "\(passengerID)"
        }
        return collectionName
    }

    class func getTripsFromSever(filterObject:[String: Any], rideService: Int, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        
        switch rideService {
        case MyTripsConstant.Offers:
            servicePath += WebServicesConstant.Offers
            break
        case MyTripsConstant.Past:
            servicePath += WebServicesConstant.PastTrips
            break
        case MyTripsConstant.Upcoming:
            servicePath += WebServicesConstant.UpcomingTrips
            break
        default:
            break
        }
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject], shouldShowHud: false) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            
        }
    }
    
    class func getTripDetailsFromSever(filterObject:[String: Any], rideService: String,tripId:String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += rideService + "/" + tripId
        
        var filterObject = filterObject
        filterObject["fetch_return"] = "true"
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(Trip.getTrip(response!) as AnyObject,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }
    
    
    class func updateTripSeats(filterObject:[String: Any],tripId:String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let servicePath = (WebServicesConstant.EditSeatService)  + tripId
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: filterObject as [String : AnyObject], shouldShowHud: false) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }


        
    }
        
    
    class func bookedTrip(tripObject:[String: Any],shouldFetchMembers:Bool,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        if shouldFetchMembers{
            
            FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
                
                if ids.compare(ApplicationConstants.InviteNotAcceptedMessage) == ComparisonResult.orderedSame{
                    let message = ["message":ApplicationConstants.InviteNotAcceptedMessage]
                    completionHandler(nil,message as NSDictionary,ResponseAction.ShowMesasgeAtRunTime, true)
                }
                else{
                    Trip.postBookedTrip(tripObject: tripObject, freindIds: ids, completionHandler: { (object, message, active, status) in
                        completionHandler(object,message,active,status)
                    })
                }
            })
        }
        else{
            Trip.postBookedTrip(tripObject: tripObject, freindIds: "", completionHandler: { (object, message, active, status) in
                completionHandler(object,message,active,status)
            })
        }
    }
    
    
    class func makeOfferOnTrip(tripObject:[String: Any],shouldFetchMembers:Bool,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        if shouldFetchMembers{
            
            FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
                
                if ids.compare(ApplicationConstants.InviteNotAcceptedMessage) == ComparisonResult.orderedSame{
                    let message = ["message":ApplicationConstants.InviteNotAcceptedMessage]
                    completionHandler(nil,message as NSDictionary,ResponseAction.ShowMesasgeAtRunTime, true)
                }
                else{
                    Trip.postMakeOfferOnTrip(tripObject: tripObject,showHud:true, freindIds: ids, completionHandler: { (object, message, active, status) in
                        completionHandler(object,message,active,status)
                    })
                }
            })
        }
        else{
            Trip.postMakeOfferOnTrip(tripObject: tripObject,showHud:true, freindIds: "", completionHandler: { (object, message, active, status) in
                completionHandler(object,message,active,status)
            })
        }
    }
    
    class func postMakeOfferOnTrip(tripObject:[String: Any],showHud:Bool = false,freindIds:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.MakeOffer
        
        var object = tripObject
        object["invited_members"] = freindIds
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: showHud) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
    class func postAcceptOfferOnTrip(tripObject:[String: Any],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.AcceptOffer
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: tripObject as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }

    }
    
    class func eliminateUserFromTrip(userObject:[String: Any],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.EliminateUser
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: userObject as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
        }
    }

    class func postBookedTrip(tripObject:[String: Any],freindIds:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.BookNow
        
        var object = tripObject
        object["invited_members"] = freindIds

        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }

    }
}

//    class func rateTrip(rateObject:[String: Any], tripId: String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
//
//        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
//        servicePath += WebServicesConstant.RateTripService + tripId
//
//        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: rateObject as [String : AnyObject], shouldShowHud: true) {
//            (response, message, status, error) in
//
//            if status!{
//                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
//            }
//            else{
//                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
//            }
//
//        }
//    }
    
    class func rateTrip(rateArray:[[String:String]], isDriver: Bool, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){

        var servicePath = Utility.isDriver() ? (WebServicesConstant.DriverRatePassengersTripService) : (WebServicesConstant.PassengerRateDriversTripService)


        
        let json = Utility.convertArrayToJson(array: rateArray as [NSDictionary])
        
        let rateObject = ["rating_data":json, ApplicationConstants.Token:User.getUserAccessToken()]
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: rateObject as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
            
        }
    }
    
    class func rejectOffer(param:[String:AnyObject], completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let servicePath = WebServicesConstant.RejectOfferByPassenger
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: param, shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
            
        }

    }
    
    
    class func startRideByDriver(isComingForResume : Bool = false, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        
        var servicePath: String? = nil
        
        if isComingForResume {
            servicePath = WebServicesConstant.DriverResumeTrip
        }
        else{
            servicePath = WebServicesConstant.DriverStartTrip
        }
        
        let tripObject = Manager.sharedInstance.currentTripInfo
        let param = [ApplicationConstants.Token:User.getUserAccessToken()!,"trip_id":(tripObject?.trip_id?.stringValue)!]
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath!, methodType: HTTPMethods.post, param: param as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
        
            if status!{
                completionHandler(Trip.getTrip(response!) as AnyObject,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }
    class func endRideByDriver(completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath: String? = nil
        servicePath = WebServicesConstant.DriverEndRide

        let tripObject = Manager.sharedInstance.currentTripInfo
        let param = [ApplicationConstants.Token:User.getUserAccessToken()!,"trip_id":(tripObject?.trip_id?.stringValue)!]
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath!, methodType: HTTPMethods.post, param: param as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(Trip.getTrip(response!) as AnyObject,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }

    class func markTrip(passenger_ids:[String], tripId: String, tripService: MarkTripsConstant,coordinates:String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let servicePath = WebServicesConstant.Driver + WebServicesConstant.MarkTripService + tripService.value
        
        let markObject = [ ApplicationConstants.Token:User.getUserAccessToken() as Any , "trip_id":tripId , "passenger_ids":passenger_ids.joined(separator: "-,-"),"coordinates":coordinates ]
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: markObject as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
            
        }
    }
    
    class func savePaymentStatus(completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let servicePath = ""
        let object = [ ApplicationConstants.Token:User.getUserAccessToken() as Any ]
            
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: false) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }

    }
    
    class func cancelTrip(trip_id: String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.TripCancelService
        
        let object = [ ApplicationConstants.Token:User.getUserAccessToken() as Any, "trip_id":trip_id ]
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
        
    }
    
    class func needPayment(trip_id: String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let servicePath = WebServicesConstant.NeedPaymentService
        
        let object = [ ApplicationConstants.Token:User.getUserAccessToken() as Any, "trip_id":trip_id ]
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
        
    }


    class func shareIteneraryTrip(object: [String : Any], completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.Driver) : (WebServicesConstant.Passenger)
        servicePath += WebServicesConstant.ShareIteneraryService
        
        var object = object
        object[ ApplicationConstants.Token] = User.getUserAccessToken() as Any
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
        
    }
    
    class func getTrip(_ object: AnyObject) -> Trip{
        
        var trip = Trip()
        
        let obj = object as! [String : Any]
        
        trip = DynamicParser.setValuesOnClass(object: obj, classObj: trip) as! Trip
        
        if obj["driver"] != nil {
            
            let driver = obj["driver"] as! [String : Any]
            trip.driver = DynamicParser.setValuesOnClass(object: driver, classObj: Driver()) as? Driver
        }
        
        if obj["passenger"] != nil {
            
            let passenger = obj["passenger"] as! [String : Any]
            trip.passenger = DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as? Passenger
        }
        
        if obj["passengers"] != nil {
            
            let passengersObject = obj["passengers"] as! [[String : Any]]
            var passengers = [Passenger]()
            for passenger in passengersObject {
                passengers.append(DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as! Passenger)
            }
            trip.passengers = passengers
        }
        
        return trip
    }

    class func getTrips(_ object: AnyObject) -> [Trip]{
        var trips = [Trip]()
        if object is [Any] {
            
            let objectArray = (object as! [Any])
            
            for obj in objectArray {
                
                let obj = obj as! [String : Any]
                
                let trip = DynamicParser.setValuesOnClass(object: obj, classObj: Trip()) as! Trip
                
                if obj["driver"] != nil {
                    
                    let driver = obj["driver"] as! [String : Any]
                    trip.driver = DynamicParser.setValuesOnClass(object: driver, classObj: Driver()) as? Driver
                    
                }
                
                if obj["passenger"] != nil {
                    
                    let passenger = obj["passenger"] as! [String : Any]
                    trip.passenger = DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as? Passenger
                    
                }
                
                if obj["passengers"] != nil {
                    
                    let passengersObject = obj["passengers"] as! [[String : Any]]
                    var passengers = [Passenger]()
                    for passenger in passengersObject {
                        passengers.append(DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as! Passenger)
                    }
                    trip.passengers = passengers
                
                }
                
                trips.append(trip)
            }
        }
        return trips
    }
    
    class func getTrips(_ object: AnyObject) -> [GroupTrip] {
        
        var tripsGr = [GroupTrip]()
        
        var tripsInd = [Trip]()
            
        if object is [Any] {
            
            let objectArray = (object as! [Any])
            
            for obj in objectArray {
                
                let obj = obj as! [String : Any]
                
                let trip = DynamicParser.setValuesOnClass(object: obj, classObj: Trip()) as! Trip
                
                if obj["driver"] != nil {
                    
                    let driver = obj["driver"] as! [String : Any]
                    trip.driver = DynamicParser.setValuesOnClass(object: driver, classObj: Driver()) as? Driver
                    
                }
                
                if obj["passenger"] != nil {
                    
                    let passenger = obj["passenger"] as! [String : Any]
                    trip.passenger = DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as? Passenger
                    
                }
                
                if obj["passengers"] != nil {
                    
                    let passengersObject = obj["passengers"] as! [[String : Any]]
                    var passengers = [Passenger]()
                    for passenger in passengersObject {
                        passengers.append(DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as! Passenger)
                    }
                    trip.passengers = passengers
                    
                }
                
                if trip.group_id == nil || (trip.group_id?.isEmpty)! {
                    
                    tripsInd.append(trip)
                    
                }
                else if let prTrip = tripsInd.first(where: { $0.group_id == trip.group_id }) {
                    
                    let groupTrip = GroupTrip()
                    groupTrip.group_id = trip.group_id
                    groupTrip.trips.append(prTrip)
                    groupTrip.trips.append(trip)
                    tripsInd = tripsInd.filter { $0.group_id != trip.group_id }
                    tripsGr.append(groupTrip)
                    
                }
                else if let grTrip = tripsGr.first(where: { $0.group_id == trip.group_id }) {
                    
                    grTrip.trips.append(trip)
                    
                }
                else {
                    
                    tripsInd.append(trip)
        
                }
                
            }
            
        }
        
        if tripsInd.count > 0 {
            let groupTrip = GroupTrip()
            groupTrip.trips = tripsInd
            tripsGr.append(groupTrip)
        }
        
        return tripsGr
        
    }
    
    func getTripIdOrTripName()-> String {
     //   return trip_name ?? ""
        return trip_id?.stringValue ?? ""
    }
    
    class func isOfferAcceptable(price: Any, vc: AnyObject)-> Bool {
        if let price = price as? String, (Double(price) ?? 0) >= 5 {
            return true
        }
        Utility.showAlertwithOkButton(message: ApplicationConstants.MinimumOfferAmountMessage, controller: vc)
        return false
    }
    
    class func applyPromoOnAmount(object:[String: Any],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.ApplyPromo, methodType: HTTPMethods.post, param: object as [String : AnyObject], shouldShowHud: true) {
            (response, message, status, error) in
            
            if status!{
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
        
    }
}
