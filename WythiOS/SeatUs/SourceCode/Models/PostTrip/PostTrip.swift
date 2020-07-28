//
//  PostEntity.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class PostTrip: NSObject {

    @objc  var placeholdertext:String!
    @objc  var hascustomaction:NSNumber!
    @objc  var issecured:NSNumber!
    @objc  var customactionname:String!
    @objc  var keyboardtype:NSNumber!
    @objc  var imagename:String!
    @objc  var text:String!
    @objc  var cellidentifier:String!
    @objc  var validationtype:NSNumber!
    @objc  var isselected:NSNumber!
    @objc  var docImage:UIImage!
    @objc  var title:String!
    @objc  var checkboxes:[[String:Any]]!
    @objc  var selectedimage:String!
    @objc  var conditions:[[String:Any]]!
    @objc  var address: String!
    @objc  var expected_start_time: String!
    
    var driver : Driver! = Driver()
    
    class func getPostTripData(name: String)->[PostTrip]{
        
        let objects =  PlistUtility.getPlistDataForPostTrip(name: name)
        var array = [PostTrip]()
        
        for (_, value) in objects.enumerated() {
            
            let castValue = value as![String:Any]
            let model = PostTrip()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! PostTrip)
        }
        return array
    }
    
    class func getPossibleRoutes(fromOrigin:String, toDestination:String,completionHandler: @escaping ([Route]?, ResponseAction?, Bool?, Error?) -> ()){
        var url = URLComponents()
        url.scheme = MatrixApiServices.scheme
        url.host = MatrixApiServices.getRouteApi
//        units=imperial
        //: ### Pass the query string parameters
        url.queryItems = [
            URLQueryItem(name: MatrixApiServices.originRouteKey, value: fromOrigin),
            URLQueryItem(name: MatrixApiServices.destinationRouteKey, value: toDestination),
            URLQueryItem(name: MatrixApiServices.alternateRouteKey, value: "true"),
            URLQueryItem(name: "units", value: "imperial"),

            URLQueryItem(name: MatrixApiServices.cleintIDKey, value: ApiKeys.MatrixApi)
        ]
        
        let urlString = url.string
        let encodeUrlString = urlString?.removingPercentEncoding
        
        WebServices.sharedInstance.sendRequestToThirdPartyServer(urlString: encodeUrlString!, methodType: .get) { (message, response, status, error) in
            
            if status!{
                
                let apiStatus = message!["status"] as! String
                var routesArr : [Route]? = []
                if (apiStatus.caseInsensitiveCompare("OK")==ComparisonResult.orderedSame){
                    let routesArray = message?["routes"] as? [[String:Any]]
                    
                    if let castRoutArr = routesArray{
                        for (_,routesObject) in castRoutArr.enumerated(){
                            
                            let routeObject = Route()
                            if let summary = routesObject["summary"] as? String{
                                routeObject.summary = summary
                            }
                            
                            let polyLineObject = routesObject["overview_polyline"] as? [String:Any]
                            
                            let polyLinePoints = polyLineObject?["points"] as? String
                            if let castPolyLinePoints = polyLinePoints{
                                routeObject.overViewPolyLine = castPolyLinePoints
                            }

                            
                            
                            routesArr?.append(routeObject)
                            
                            let legsArray = routesObject["legs"] as? [[String:Any]]
                            
                            if let legsCastArray = legsArray{
                                
                                for (_,legsObject) in legsCastArray.enumerated(){
                                    
                                    let leg = Legs()
                                    let distanceObject = legsObject["distance"] as? [String:Any]
                                    let durationObject = legsObject["duration"] as? [String:Any]
                                    
                                    let distance = distanceObject?["text"] as? String
                                    let distanceValue = distanceObject?["value"] as? Double
                                    
                                    if let castDistanceText = distance{
                                        leg.distanceText = castDistanceText
                                    }
                                    
                                    if let castdistanceValue = distanceValue{
                                        leg.distanceValue = castdistanceValue
                                    }
                                    
                                    let duration = durationObject?["text"] as? String
                                    let durationValue = durationObject?["value"] as? Double
                                    
                                    if let castDurationText = duration{
                                        leg.durationText = castDurationText
                                    }
                                    
                                    if let castDurationValue = durationValue{
                                        leg.durationValue = castDurationValue
                                    }
                                    
                                    routeObject.legsArray?.append(leg)
                                    
                                    let stepsArray = legsObject["steps"] as? [[String:Any]]
                                    
                                    if let castStepArray = stepsArray{
                                        
                                        for (_,stepObject) in castStepArray.enumerated(){
                                            
                                            let step = Steps()
                                            
                                            let startLocationObject = stepObject["start_location"] as? [String:Any]
                                            let endLocationObject = stepObject["end_location"] as? [String:Any]
                                            let longValueStartLoc = startLocationObject?["lng"] as? Double
                                            let latValueStartLoc = startLocationObject?["lat"] as? Double
                                            let longValueEndLoc = endLocationObject?["lng"] as? Double
                                            let latValueEndLoc = endLocationObject?["lat"] as? Double
                                            
                                            if let castlongValueStartLoc = longValueStartLoc{
                                                step.longStartValue = castlongValueStartLoc
                                            }
                                            
                                            if let castlatValueStartLoc = latValueStartLoc{
                                                step.latStartValue = castlatValueStartLoc
                                            }
                                            
                                            if let castlongValueStartLoc = longValueEndLoc{
                                                step.longEndValue = castlongValueStartLoc
                                            }
                                            
                                            if let castlatValueEndLoc = latValueEndLoc{
                                                step.latEndValue = castlatValueEndLoc
                                            }
                                            
                                            leg.stepsArray?.append(step)
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                    completionHandler(routesArr,ResponseAction.DoNotShowMesasgeAtRunTime,true,nil)
                }
                else{
                    completionHandler(routesArr,ResponseAction.ShowMesasgeOnAlert,true,nil)

                    print("apiStatus is false")
                }
            }
        }
    }

    
    class func calculateRoutePriceEstimation(fromOrigin:String, toDestination:String,shouldShowHud:Bool = true,completionHandler: @escaping (String?, [String:Any]?, ResponseAction?, Bool?, Error?) -> ()){
        
        var url = URLComponents()
        url.scheme = MatrixApiServices.scheme
        url.host = MatrixApiServices.getDistanceApi
        //: ### Pass the query string parameters
        url.queryItems = [
            URLQueryItem(name: MatrixApiServices.originKey, value: fromOrigin),
            URLQueryItem(name: MatrixApiServices.destinationKey, value: toDestination),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: MatrixApiServices.cleintIDKey, value: ApiKeys.MatrixApi)
        ]
        
        let urlString = url.string
        let encodeUrlString = urlString?.removingPercentEncoding
        
        WebServices.sharedInstance.sendRequestToThirdPartyServer(urlString: encodeUrlString!, methodType: .get,shouldShowHud:shouldShowHud) { (message, response, status, error) in
            
            if status!{
             
                let apiStatus = message!["status"] as! String
                if (apiStatus.caseInsensitiveCompare("OK")==ComparisonResult.orderedSame){
                    let rows = message?["rows"] as? NSArray
                    let elements  = rows?[0] as? NSDictionary
                    let elementArr = elements?["elements"] as? NSArray
                    let distanceParentObj = elementArr?[0] as? NSDictionary
                    let durationParentObj = elementArr?[0] as? NSDictionary

                    let distance = distanceParentObj?["distance"] as? NSDictionary
                    var valueString  = distance?["value"] as? NSNumber
                    if valueString != nil{
                        valueString = distance?["value"] as? NSNumber
                    }
                    else{
                        valueString = 0.0
                    }
                    var distanceText = distance?["text"] as? String
                    if distanceText == nil{
                        distanceText = ""
                    }
                    
                    let duration = durationParentObj?["duration"] as? NSDictionary
                    var durationText = duration?["text"] as? String
                    if durationText == nil{
                        durationText = ""
                    }

                    let object :[String:Any] = ["distance":distanceText! as Any,"duration":durationText! as Any]
                    let distanceValue = (valueString?.doubleValue)! * ApplicationConstants.MilesConversion
//                    let calulatedPriceLower = String(format: "$%.2f", distanceValue * ApplicationConstants.RatePerMileLower)
//                    let calulatedPriceUpper = String(format: "$%.2f", distanceValue * ApplicationConstants.RatePerMileUpper)
//                    let finalRange = calulatedPriceLower + " - " + calulatedPriceUpper
                   let finalRange = Utility.setEstimateRange(distanceValue: distanceValue)
                    completionHandler(finalRange   ,object,ResponseAction.DoNotShowMesasgeAtRunTime,true,nil)
                }
                else{
                    print("apiStatus is false")
                }
            }
        }
    }
    
    
    class func searchTrip(route:Route,shouldFetchMembers:Bool,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        if shouldFetchMembers{
            
            FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
                PostTrip.postSearchTrip(route: route,friendIds:ids, completionHandler: { (response, message, active, status) in
                    completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
                })
            })
        }else{
            PostTrip.postSearchTrip(route: route,friendIds:"", completionHandler: { (response, message, active, status) in
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime, status)
            })
        }
    }
    
    class func fetchInvitedMembers(completionHandler: @escaping (String) -> ()){
        FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
            completionHandler(ids)
        })
    }
    
    class func postSearchTrip(route:Route,friendIds:String, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let tripInfo = getTripObject(route: route, invitedFriendIds: friendIds)
        
        var servicePath = Utility.isDriver() ? (WebServicesConstant.SubscribedRoutes) : (WebServicesConstant.SearchTrip)
    //    servicePath += WebServicesConstant.SearchTrip
        
        WebServices.sharedInstance.sendRequestToServer(urlString: servicePath, methodType: HTTPMethods.post, param: tripInfo as [String : AnyObject]) {
            (response, message, status, error) in
            
            if status! {
                
                var searchTripsArr: [SearchTrip]! = []
                let serachTrips = response as! [[String:Any]]
                
                let objects:[GroupSearchTrip] = PostTrip.getSearchTrips(response!)

                
                for (_,value) in serachTrips.enumerated(){
                    
                    
                    if let driverInfo = value["driver"] {
                        
                        let info = driverInfo as! [String:Any]
                        var trip = SearchTrip()
                        trip = DynamicParser.setValuesOnClass(object: value, classObj: trip) as! SearchTrip
                        trip.drive = (DynamicParser.setValuesOnClass(object: info, classObj: trip.drive!) as! Driver)
                        searchTripsArr.append(trip)

                    }
                }
                completionHandler(objects as AnyObject,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }

    }
    
    class func createTrip(route:Route,shouldFetchMembers:Bool,paymentType:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        if shouldFetchMembers{
            
            FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
                
                if ids.compare(ApplicationConstants.InviteNotAcceptedMessage)==ComparisonResult.orderedSame{
                    let message = ["message":ApplicationConstants.InviteNotAcceptedMessage]
                    completionHandler(nil,message as NSDictionary,ResponseAction.ShowMesasgeOnAlert, true)
                }
                else{
                    PostTrip.postCreateTrip(route: route, friendIds: ids,paymentType:paymentType, completionHandler: { (response, message, active, status) in
                        completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
                    })
                }
            })
        }else{
            PostTrip.postCreateTrip(route: route, friendIds: "",paymentType:paymentType, completionHandler: { (response, message, active, status) in
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)

            })
        }
    }
    
    class func createTripByPassenger(route:Route,shouldFetchMembers:Bool,driverID:String?,seat:Int?, returnSeats:Int? = nil ,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        if shouldFetchMembers {
            
            FireBaseManager.sharedInstance.getInvitedMembersIds(completionHandler: { (ids) in
                
                if ids.compare(ApplicationConstants.InviteNotAcceptedMessage)==ComparisonResult.orderedSame{
                    let message = ["message":ApplicationConstants.InviteNotAcceptedMessage]
                    completionHandler(nil,message as NSDictionary,ResponseAction.ShowMesasgeOnAlert, true)
                }
                else{
                    PostTrip.postCreateTripPassenger(route: route, friendIds: ids, driverID: driverID,seat:seat, returnSeats: returnSeats, completionHandler: { (object, message, active, status) in
                        completionHandler(object,message,ResponseAction.ShowMesasgeOnAlert, status)
                    })
                }
            })
        }
        else{
            PostTrip.postCreateTripPassenger(route: route, friendIds: "", driverID: driverID,seat:seat, returnSeats: returnSeats, completionHandler: { (object, message, active, status) in
                completionHandler(object,message,ResponseAction.ShowMesasgeOnAlert, status)
            })
        }
    }
    
    
    class func postCreateTripPassenger(route:Route,friendIds:String,driverID:String?,seat:Int?, returnSeats:Int? = nil ,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let friendsCount = friendIds.components(separatedBy: "-,-").count
        if (seat! < friendsCount) && (seat)! > 0 {
            
            let message = ["message":ApplicationConstants.DriverSeatsErrorMessage] as [String:Any]
            completionHandler(nil,message as NSDictionary,ResponseAction.ShowMesasgeOnAlert, true)
            return
        }
        var tripInfo = getTripObject(route: route, invitedFriendIds: friendIds)
        tripInfo["driver_id"] = driverID
        tripInfo["is_enabled_booknow"] = true
        tripInfo["booknow_price"] = 5.00
        if seat != nil {
            tripInfo["seats_total"] = seat
        }
        
        if returnSeats != nil {
            tripInfo["seats_total_returning"] = returnSeats
        }
        if driverID == nil {
            tripInfo.removeValue(forKey: "seats_total")
            
        }
        print(tripInfo)
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.PassengerCreateTrip, methodType: HTTPMethods.post, param: tripInfo as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
        }
    }
    
    class func fixedPreRideTime(trip:Trip,param:[String:Any],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var serviceName = ""
        
        serviceName = WebServicesConstant.FixedPreRideTimeByDriver
        
        WebServices.sharedInstance.sendRequestToServer(urlString: serviceName, methodType: HTTPMethods.post, param: param as [String : AnyObject],shouldShowHud:false) {
            (response, message, status, error) in
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
        }
    }
    
    class func fixedRideTime(trip:Trip,param:[String:Any],fixedForcefully:Bool,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var serviceName = ""
        if fixedForcefully{
            serviceName = WebServicesConstant.FixedRideTimeForcefullyByDriver
        }
        else{
            serviceName = WebServicesConstant.FixedRideTimeByDriver
        }
        
        WebServices.sharedInstance.sendRequestToServer(urlString: serviceName, methodType: HTTPMethods.post, param: param as [String : AnyObject],shouldShowHud:false) {
            (response, message, status, error) in
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
        }
    }
    
    class func postCreateTrip(route:Route,friendIds:String,paymentType:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var tripInfo = getTripObject(route: route, invitedFriendIds: friendIds)
        //print(tripInfo)
        tripInfo["payout_type"] = paymentType
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.CreateTrip, methodType: HTTPMethods.post, param: tripInfo as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
        }
    }

    class func getTripObject(route:Route,invitedFriendIds:String)->([String:Any]){
        let pref = Utility.convertArrayToJson(array: Utility.getPreference()! as [NSDictionary])
        let latitude = (DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates) as! String).components(separatedBy: ",")[0] as Any
        let longitude = (DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates) as! String).components(separatedBy: ",")[1] as Any
        let destinationLatitude = (DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestinationCoordinates) as! String).components(separatedBy: ",")[0] as Any
        let destinationLongitude = (DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestinationCoordinates) as! String).components(separatedBy: ",")[1] as Any
        let expectedDistance = Utility.getFormatedDistance(distanceMiles: Route.getTotalDistance(object: route)) as Any
        let expectedTime = Utility.getFormatedTimeFromSeconds(seconds: Route.getTotalTime(object: route)) as Any
//        let seats = Utility.convertStringToNumber(value: DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoSeats) as! String) as Any
        let bookNow = true //DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoBookNow) as! Bool
        let bookNowPrice = 5.01
        //        let roundTrip = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoRoundTrip) as! Bool
        var roundTrip = false
        let _trip = DataPersister.sharedInstance.getTripInfo()
        if (_trip != nil) {
            roundTrip = (_trip?.roundTrip) ?? false
        }

        let expectedDistanceValue = String(Int(Route.getTotalDistance(object: route))) as Any
        var estimatesValue = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoEstimate) as! String
        estimatesValue = estimatesValue.replacingOccurrences(of: "$", with: "")
        
//        let gender = DataPersister.getTripInfo(forKey: CoreDataConstants.Gender) as! String
//        let genderValue = Utility.getGenderEnumValue(genderString: gender)
        
        var tripTime = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDate) as! String
        var returnDate = DataPersister.getTripInfo(forKey: CoreDataConstants.TripReturnDate) as? String
        
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        //MM/dd/yyyy HH:mm"
        tripTime = tripTime + " \(hour):" + "\(minutes)"
        
        let date = Utility.getDateFromString(date: tripTime , format: ApplicationConstants.DateTimeFormat)
        
        let timeStamp = "\(Utility.convertDateToTimeStamp(date: date))"
        var date_returning = ""
        
        if returnDate != nil {
            returnDate = returnDate! + " \(hour):" + "\(minutes)"
            let _date = Utility.getDateFromString(date: returnDate! , format: ApplicationConstants.DateTimeFormat)
            date_returning = "\(Utility.convertDateToTimeStamp(date: _date))"
        }
        
        //print(tripTime)
        //print(timeStamp)

        var tripNameClone = ""
        if let tripName = DataPersister.getTripInfo(forKey: CoreDataConstants.TripName) as? String{
            tripNameClone = tripName
        }

        //let time_range = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoTimeOfDay)
        
        let time_range = Utility.getTimeRange()
        
        var time_range_returning = 0
        
        if roundTrip {
            time_range_returning = Utility.getTimeRange(true)
        }
        
        let (minEstimate,maxEstimate) : (Double,Double) = Utility.getEstimates()
        var factor = 1.0
        if roundTrip {
            factor = 2.0
        }
        
        var min_estimates = String(format: "%.2f", factor * minEstimate)
        var max_estimates = String(format: "%.2f", factor * maxEstimate)
        
        if(maxEstimate < 2.5) {
            min_estimates = "$5.00"
            max_estimates = "$5.50"
        }
        
        let gender = Utility.getGender()
        let genderValue = Utility.getGenderEnumValue(genderString: gender)
        
        let seats = Utility.getSeats()
        
        let seats_total_returning = Utility.getSeats(true)
        //date_returning
        
        var tripInfo : [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"origin_latitude":latitude,"origin_longitude":longitude,"origin_title":DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin),"destination_longitude":destinationLongitude,"destination_latitude":destinationLatitude,"destination_title":DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination),"expected_distance_format":expectedDistance,"expected_duration":expectedTime,"expected_start_date":timeStamp,"time_range":time_range,"is_enabled_booknow":bookNow,"booknow_price":bookNowPrice,"stepped_route":route.overViewPolyLine!,"is_roundtrip":roundTrip,"invited_members":invitedFriendIds,"preferences":pref,"expected_distance":expectedDistanceValue,"trip_name":tripNameClone,"desired_gender":genderValue,"min_estimates":min_estimates,"max_estimates":max_estimates]
        
        if Utility.isDriver() {
            tripInfo["seats_total"] = seats
        }
        
        if roundTrip {
            tripInfo["time_range_returning"] = time_range_returning
            tripInfo["date_returning"] = date_returning
            if Utility.isDriver()
            {
                tripInfo["seats_total_returning"] = seats_total_returning
            }
        }
        
        
//        tripInfo["origin_latitude"] = "24.8820309"
//        tripInfo["origin_longitude"] = "67.0670115"
//        tripInfo["destination_latitude"] = "24.8624948"
//        tripInfo["destination_longitude"] = "67.0551319"
//        tripInfo["expected_start_date"] = "1520430884456"
//        tripInfo["date_returning"] = "1525516393456"
//        tripInfo["is_roundtrip"] = 1
        
        
//        let tripInfo : [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"origin_latitude":latitude,"origin_longitude":longitude,"origin_title":DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin),"destination_longitude":destinationLongitude,"destination_latitude":destinationLatitude,"destination_title":DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination),"expected_distance_format":expectedDistance,"expected_duration":expectedTime,"expected_start_date":timeStamp,"time_range":time_range,"seats_total":seats,"is_enabled_booknow":bookNow,"estimates_format":DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoEstimate),"stepped_route":route.overViewPolyLine!,"is_roundtrip":roundTrip,"invited_members":invitedFriendIds,"preferences":pref,"expected_distance":expectedDistanceValue,"estimates":estimatesValue,"trip_name":tripNameClone,"desired_gender":genderValue,"time_range_returning":time_range_returning,"min_estimates":min_estimates,"max_estimates":max_estimates,"date_returning":date_returning]
        
        unSetTripName()
        
//        CreateTripDetails.shared.clear()
        
        return tripInfo

    }
    
    class func unSetTripName (){
        let lastSavedTrip = PostTrip()
        lastSavedTrip.title = CoreDataConstants.TripName
        lastSavedTrip.placeholdertext = ""
        
        if DataPersister.sharedInstance.getTripInfo() != nil{
            _ = DataPersister.sharedInstance.updateOrCreateTrip(info: DataPersister.sharedInstance.getTripInfo()!, withDetails: lastSavedTrip)

        }
    }
    
    class func getSearchTrips(_ object: AnyObject) -> [GroupSearchTrip] {
        
        var tripsGr = [GroupSearchTrip]()
        
        var tripsInd = [SearchTrip]()
        
        if object is [Any] {
            
            let objectArray = (object as! [Any])
            
            for obj in objectArray {
                
                let obj = obj as! [String : Any]
                
                let trip = DynamicParser.setValuesOnClass(object: obj, classObj: SearchTrip()) as! SearchTrip
                
                if obj["driver"] != nil {
                    
                    let driver = obj["driver"] as! [String : Any]
                    trip.drive = DynamicParser.setValuesOnClass(object: driver, classObj: Driver()) as? Driver
                    
                }
                
                if obj["passenger"] != nil {
                    
                    let passenger = obj["passenger"] as! [String : Any]
                    trip.passenger = DynamicParser.setValuesOnClass(object: passenger, classObj: Passenger()) as? Passenger
                    if let gender = obj["gender"] as? String {
                        trip.passenger?.gender = gender
                    }
                }
                
                if trip.group_id == nil  {
                    
                    tripsInd.append(trip)
                    
                }
                else if let prTrip = tripsInd.first(where: { $0.group_id == trip.group_id }) {
                    
                    let groupTrip = GroupSearchTrip()
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
            let groupTrip = GroupSearchTrip()
            groupTrip.trips = tripsInd
            tripsGr.append(groupTrip)
        }
        
        return tripsGr
        
    }
    
    class func isTimeSlotPassed(hour:Int,thresholdTime:Int)->(Bool){
        
        var isPassed = false
        
        if ((thresholdTime) & 1) != 0 {
            if (hour > 11){
                isPassed = true
            }
        }
        
        if ((thresholdTime) & 2) != 0 {
            if (hour > 17){
                isPassed = true
            }
        }
        
        return isPassed
    }

    
    class func isTimeValid(hour:Int,trip:Trip)->(Bool){
        
        var valid = false
        
        if ((trip.time_range?.intValue)! & 1) != 0 {
            if (6 <= hour && hour <= 11){
                valid = true
            }
        }
        
        if ((trip.time_range?.intValue)! & 2) != 0 {
            if (12 <= hour && hour <= 17){
                valid = true
            }
        }

        if ((trip.time_range?.intValue)! & 4) != 0 {
            if (18 <= hour && hour <= 24){
                valid = true
            }
        }
        return valid
    }
    
    class func subscribeRideForPassenger(route:Route, completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        var tripInfo = getTripObject(route: route, invitedFriendIds: "")
      //  print(tripInfo)
        
        tripInfo = tripInfo.filter({ ["_token","origin_latitude","origin_longitude","origin_title","destination_latitude","destination_longitude","destination_title","is_roundtrip"].contains($0.key) })
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.PassengerSubscribeRide, methodType: HTTPMethods.post, param: tripInfo as [String : AnyObject]) {
            (response, message, status, error) in
            
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
        }
    }
    
}
