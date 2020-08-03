                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       //
//  Utility.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//
//
import Foundation
import UIKit
import IQKeyboardManagerSwift
import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker


class Utility{
    
    class func getDateInString(_ date : Date, format : String)->String{
     
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    class func getDateFromString(date:String,format:String)->(Date){
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format

        return formatter.date(from: date)!
    }
   
    class func getTimeInString(_ date : Date,format:String = "hh:mm a" )->String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    class func getFormatedDate(sourceDate:String,sourceDateFormat:String,destinationDateFormat:String)->(String){
        
        let sourceFormatter = DateFormatter()
        sourceFormatter.dateFormat = sourceDateFormat
        var date = sourceFormatter.date(from: sourceDate)
        
        let seconds = TimeZone.current.secondsFromGMT()
        date?.addTimeInterval(TimeInterval(seconds))

        let destinationFormatter = DateFormatter()
        destinationFormatter.dateFormat = destinationDateFormat
        
        let dateString = destinationFormatter.string(from: date!)

        return dateString
    }
    
    class func getValueFromModel(key:String, array:[SignUpEntity])->(String){
        
        var value:String = ""
        let obj = array.filter({ (model:SignUpEntity) -> Bool in
            if model.placeholdertext.compare(key)==ComparisonResult.orderedSame{
                return (model.text != nil)
            }
            else{
                return false
            }
        }).first
        
        if ((obj?.text) != nil){
            value = (obj?.text)!
        }
        return value
    }

    
    class func getModel(key:String, array:[SignUpEntity])->(SignUpEntity){
        
        var value:SignUpEntity = SignUpEntity()
        let obj = array.filter({ (model:SignUpEntity) -> Bool in
            if model.placeholdertext != nil && model.placeholdertext.compare(key)==ComparisonResult.orderedSame {
                return (model.text != nil)
            }
            else{
                return false
            }
        }).first
        
        if ((obj) != nil){
            value = (obj)!
        }
        return value
    }
    
    class func getPostTripModel(key:String, array:[PostTrip])->(PostTrip){
        
        var value:PostTrip = PostTrip()
        let obj = array.filter({ (model:PostTrip) -> Bool in
//            print(model.title)
//            print(key)
            if model.title.compare(key)==ComparisonResult.orderedSame{
                return (model.text != nil)
            }
            else{
                return false
            }
        }).first
        
        if ((obj) != nil){
            value = (obj)!
        }
        return value
    }


    class func getLocationID(stateName:String, array:[NSDictionary])->(String){
        
        var stateId:String! = ""
        let stateObject = array.filter { (dict) -> Bool in
            
            let currentStateName =  dict["name"] as! String
            if currentStateName.compare(stateName) == ComparisonResult.orderedSame{
                return (true)
            }
            return false
            }.last
        
        if (stateObject != nil){
           stateId = (stateObject!["id"] as? NSNumber)?.stringValue
        }
        return stateId
    }
    
    
    class func showAlertwithOkButton(message: String , controller: AnyObject){
        
        
        var genericController = controller
        
        switch controller{
        case is SignInViewController:
            genericController  = controller as! SignInViewController
            break
            
        case is RegisterViewController:
            genericController  = controller as! RegisterViewController
            break

        case is RegistrationDetailsViewController:
            genericController  = controller as! RegistrationDetailsViewController
            break

        case is ForgotPasswordController:
            genericController  = controller as! ForgotPasswordController
            break

        case is ModalAlertBaseViewController:
            genericController  = controller as! ModalAlertBaseViewController
            break

        default:
            genericController  = controller as! BaseViewController
            break
        }
 
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            let selector: Selector = NSSelectorFromString("alertOkButtonHandler")
            if genericController.responds(to: selector){
                _ = genericController.perform(selector)
            }
        })
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }
    
    class func showCreateAnotherTripAlert(controller:BaseViewController){
        
        let alert = UIAlertController(title: ApplicationConstants.CreateAnotherRideTitleMessage, message: ApplicationConstants.CreateAnotherRideMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Create Another Trip", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            let selector: Selector = NSSelectorFromString("createAnotherTrip")
            if controller.responds(to: selector){
                _ = controller.perform(selector)
            }
            
        })
        
        let okAction = UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            let selector: Selector = NSSelectorFromString("alertOkButtonHandler")
            if controller.responds(to: selector){
                _ = controller.perform(selector)
            }
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }
    
    
    class func showContactSyncAlert(controller:BaseViewController){
        
        let alert = UIAlertController(title: ApplicationConstants.ContactSyncAlertTitle, message: ApplicationConstants.ContactSyncAlertMessage, preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            let selector: Selector = NSSelectorFromString("proceedWithCancelSyncing")
            if controller.responds(to: selector){
                _ = controller.perform(selector)
            }

        })

        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            let selector: Selector = NSSelectorFromString("proceedWithSyncing")
            if controller.responds(to: selector){
                _ = controller.perform(selector)
            }
        })
        

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }
    
    class func convertNumberToInt(number:NSNumber)->(Bool){
       return Bool(truncating: number)
    }
    
    class func resignKeyboardWhenTouchOutside(){
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    class func getGenderArray()->[String]{
        return ["Male","Female"]
    }
    
    class func getGenderArrayForRidePrephences()->[String]{
        return ["Both","Male","Female"]
    }

    
    class func getVehicles()->[String]{
        
        return getValueFromUserDefaults(key: UserDefaultsKeys.VehicleTypeKey) as! [String]
    }
    
    class func getVehicleMake()->[AnyObject]{
        
        return getValueFromUserDefaults(key: UserDefaultsKeys.VehicleMakeKey) as! [AnyObject]
    }
    
    class func getHearingSourceContent()->[AnyObject]{
        
        return getValueFromUserDefaults(key: UserDefaultsKeys.RefrenceSource) as! [AnyObject]
    }
    
    class func getVehicleMakeName()->[[String:AnyObject]]{
        
        var makeObjectsArray : [[String:AnyObject]] = [[:]]
        let objects = getValueFromUserDefaults(key: UserDefaultsKeys.VehicleMakeKey) as! [[String:AnyObject]]
        for (_,value) in objects.enumerated() {
            
            let makeObject = value
            makeObjectsArray.append(makeObject)
        }
        return makeObjectsArray
    }
    
    class func getSelectedVehicleMakeObject(makeName:String)->[String:AnyObject]{
        
        var makeObjectDict : [String:AnyObject] = [:]
        let objects = getValueFromUserDefaults(key: UserDefaultsKeys.VehicleMakeKey) as! [[String:AnyObject]]
        for (_,value) in objects.enumerated() {
            
            let makeObject = value
            if (makeObject["name"]?.isEqual(makeName))!{
                makeObjectDict = makeObject
            }
        }
        return makeObjectDict
    }
    
    class func getModelNameArray(modelNames:[String]) ->[[String:AnyObject]]{
        var modelObjectsArray : [[String:AnyObject]] = [[:]]
        for (_,value) in modelNames.enumerated() {
            
            let currentModel :[String:AnyObject] = ["name":value as AnyObject]
            modelObjectsArray.append(currentModel)
        }
        return modelObjectsArray
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    
    class func getSchoolName()->[[String:Any]]{
        
        var schoolObjects : [[String:Any]] = [[:]]
        if  let objects  = getValueFromUserDefaults(key: UserDefaultsKeys.SchoolKey) as? [[String: Any]]{
            print("Getting School from service cache")
            schoolObjects = objects
        }
        else{
            
            print("Getting School from json file")
            schoolObjects = getSchoolList() as! [[String : Any]]
        }
        return schoolObjects
    }
    
    class func getSchoolList()-> [NSDictionary] {
        
        
        var countriesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "schools", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    countriesInfo = jsonResult["body"] as! [NSDictionary]
                } catch {}
            } catch {}
        }
        
        return countriesInfo
    }
    
    class func pasrseSchoolNames()->([[String:Any]]){
        
      let schoolNameArray =  getSchoolName()
      var schoolObjectArray : [[String:Any]] = [[:]]
        for (index,value) in schoolNameArray.enumerated(){
            let schoolObject :[String:Any] = ["id":NSNumber(integerLiteral: index),"name":value]
            schoolObjectArray.append(schoolObject)
        }
        return schoolObjectArray
    }

    
    class func convertArrayToJson(array:[NSDictionary])->(String){
        var json:String = ""
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: array , options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                json = JSONString
            }
            
        } catch {
            print("catch on document json array")
        }
        return json
    }
    
    class func convertObjectToJson(object: NSDictionary)->(String){
        var json:String = ""
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: object , options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                json = JSONString
            }
            
        } catch {
            print("catch on document json array")
        }
        return json
    }
    
    class func setUserType(type:String){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(type, forKey: "userState")
        userDefaults.synchronize()
    }
    
    class func getUserType()->(String){
        var type : String = ""
        let userDefaults: UserDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "userState") != nil){
            type  = userDefaults.value(forKey: "userState") as! String
        }
        else{
            type = UserType.UserNormal
        }
        return type
    }
    
    class func dateFormater(clientFormat: String, serverFormat:String, dateString:String)->String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = serverFormat
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = clientFormat
        
        let date: NSDate? = dateFormatterGet.date(from: dateString) as NSDate?
        
        var formatedDateString : String = ""
        
        if (date != nil){
          formatedDateString = dateFormatterPrint.string(from: date! as Date)
        }
        return formatedDateString
    }
    
    class func changePlaceHolderColor(textField:UITextField, color:UIColor){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: color])

    }
    
    class func removeValidation(textField:ValidaterTextField){
        
        textField.restorationIdentifier = ""
        textField.validateOnCharacterChanged = false
        textField.isMandatory=false
        textField.validateOnResign = false
    }
    
    class func getCoordinateString(byCLLocationCoordinate2D:CLLocationCoordinate2D )->(String){
        
        return String(byCLLocationCoordinate2D.latitude) + "," + String(byCLLocationCoordinate2D.longitude)
    }
    
    class func isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: Date,isFromFriendInviteTime:Bool = true)->(Bool){
        var flag : Bool = false
        let currentDate = Date()
        if isFromFriendInviteTime{
            let terminationDuration = currentDate.timeIntervalSince(toInvitedTime as Date)/60
            if terminationDuration > FireBaseConstant.invitedReqTimeOut {
                flag = true
            }
        }
        else{
            let terminationDuration = currentDate.timeIntervalSince(toInvitedTime as Date)/60
            if terminationDuration > 60.0 {
                flag = true
            }
        }
        return flag
    }
    
    class func convertTimeStampToDate(timeStamp:Int)->(Date){
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return date
    }
    
    
    class func savePreference(object:[String:Any]){
        
        var object = object
        
        if var preferenceObjectList = Utility.getPreference() {
            let objectList = object[ApplicationConstants.PreferencesArrayKey] as! [[String:Any]]
            
            for newObject in objectList{
                if preferenceObjectList.filter({($0["id"] as! NSNumber) == (newObject["id"] as! NSNumber) }).count <= 0 {
                    preferenceObjectList.append(newObject)
                }
            }
            
            object[ApplicationConstants.PreferencesArrayKey] = preferenceObjectList
            
        }
        
        saveToUserDeafults(object: object as AnyObject, key: UserDefaultsKeys.PreferenceKey)
        
    }
    
    class func updatePreference(itemTag: Int, selectedStates: [Int : Bool]){
        
        var preferenceObjectList = Utility.getPreference()
        
        var preferenceObject = preferenceObjectList?[itemTag]
        
        let optionsArray = preferenceObject!["options"] as! [[String:Any]]
        
        var optionsDict_1 = optionsArray[0]
        optionsDict_1["checked"] = selectedStates[5]
        
        var optionsDict_2 = optionsArray[1]
        optionsDict_2["checked"] = selectedStates[10]
        
        preferenceObject!["options"] = [optionsDict_1,optionsDict_2]
        preferenceObjectList?.remove(at: itemTag)
        preferenceObjectList?.insert(preferenceObject!, at: itemTag)
        
        var preferences = [String:Any]()
        preferences[ApplicationConstants.PreferencesArrayKey] = preferenceObjectList
        
        saveToUserDeafults(object: preferences as AnyObject, key: UserDefaultsKeys.PreferenceKey)
    }
    
    class func getPreference()->([[String:Any]]?){
        
//        let prefrenceObject = getValueFromUserDefaults(key: UserDefaultsKeys.PreferenceKey)
//        return prefrenceObject?.value(forKey: ApplicationConstants.PreferencesArrayKey) as? [[String:Any]]
        
        var preferences = [[String:Any]]()
        let preferencesSelectByUser = CreateTripDetails.shared.postArray.filter( { ($0.objectIdentifier ?? "") == CreateTripEntityConstant.sectionTwoEntity } ).first
        
        
        if let prefrenceObject = getValueFromUserDefaults(key: BootMeUpKeys.PreferenceKey.value) as? [[String:Any]] {
            
            for object in prefrenceObject {
                
                var obj = object
                let identifer = obj["identifier"] as? String
                
                if identifer != nil {
                    if let items = preferencesSelectByUser?.rowsArray.filter( { ($0.customactionname ?? "") == identifer } ) {
                        
                        if let item = items.first {
                            
                            let isSelected = item.isselected ?? 0
                            
                            obj["checked"] = isSelected.boolValue
                            
                        }

                    }
                }
                
                preferences.append(obj)
                
            }
            
            
        }

        return preferences
    }
        
    class func saveToUserDeafults(object:AnyObject,key:String){
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(object, forKey: key)
        userDefaults.synchronize()
    }
    
    class func getValueFromUserDefaults(key:String)->(AnyObject?){
        
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.value(forKey: key) as (AnyObject)
    }
    class func getRatings()->[String]{
        return ["1+","2+","3+","4+","5"]
    }
    
    class func setTimeOfDay(trip:PostTrip,thresholdDay:String)->(PostTrip){
        
        var tempTrip : PostTrip = PostTrip()
        switch thresholdDay {
        case "7":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Night | Morningn | Afternoon")
            break

        case "6":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Night | Afternoon")
            break

        case "5":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Night | Morning")
            break

        case "4":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Night")

        case "3":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Morning | Afternoon")
            break
            
        case "2":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Afternoon")

            break
            
        case "1":
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "Morning")

            break
            
        default:
            
            tempTrip = checkTimeSlot(onTrip: trip, withTimeSlot: "")

            break
        }
        return tempTrip

    }
    
  
    class func checkTimeSlot(onTrip:PostTrip, withTimeSlot:String)->(PostTrip){
        
        var arrayOfCheckboxes : [[String:Any]] = []
        for (_,value) in onTrip.checkboxes.enumerated(){
            var dict = value as [String:Any]
            let textKey =  dict["text"] as! String
            print(textKey)
            if (withTimeSlot.contains(textKey)){
            
                dict["isSelected"] = NSNumber(booleanLiteral: true)
                arrayOfCheckboxes.append(dict)
            }
            else{
                dict["isSelected"] = NSNumber(booleanLiteral: false)
                arrayOfCheckboxes.append(dict)
            }
        }
        onTrip.checkboxes = arrayOfCheckboxes
        return onTrip
    }
    
    
    class func getFormatedTimeFromSeconds(seconds:Double)->(String){
        
        let hours = seconds / 3600
        let min = (seconds.truncatingRemainder(dividingBy: 3600))/60
//        let sec = (seconds.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)
        
        var formatedTime = ""
        if hours >= 1 {
            formatedTime = String(format: "%02.0f",hours) + " hour " + String(format: "%02.0f",min) + " Min"
        }
        else{
            formatedTime = String(format: "%02.0f",min) + " Min"
        }
        
        return formatedTime
    }
    
    class func getFormatedDistance(distanceMiles:Double)->(String){
        
    
//        var durationText = ""
//        if (miles >= 1){
//            durationText = String(format: "%02.0f miles %02.0f meters",miles,metersOverMiles)
//        }
//        else{
//            durationText = String(format: "%02.0f meters",metersOverMiles)
//        }
        
        
        let miles = (distanceMiles / 1609.34)
        
        _ = distanceMiles.truncatingRemainder(dividingBy: 1000)
        let metersOverMiles = (distanceMiles.truncatingRemainder(dividingBy: 1609.34) )
        let feetsOverMiles = (metersOverMiles / 3.2808);

        var durationText = ""
        if (miles >= 1){
//            durationText = String(format: "%02.0f miles %02.0f feets",miles,feetsOverMiles)
            durationText = String(format: "%0.0f miles",miles)
        }
        else{
            durationText = "Less then a mile"
//            durationText = String(format: "%02.0f meters",feetsOverMiles)
        }
        return durationText
    }
    
    class func convertStringToNumber(value:String)->(NSNumber){
        var myNumber = 0
        let someString = value
        if let myInteger = Int(someString) {
            myNumber = Int(truncating: NSNumber(value:myInteger))
        }
        return myNumber as NSNumber
        
    }
    
    class func getDateFromString(sourceDate:String,inputDateFormat:String,outputDateFormat:String)->(Date){
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        let date = dateFormatter.date(from: sourceDate)!
        return date
    }
    
    
    class func getTimeStamp(byDate:Date)->(String){
        var dateString = ""
        let currentDate = Date()
        let diffMinutes = currentDate.timeIntervalSince(byDate)/60
        let diffHours = diffMinutes/60
        if diffHours >= 24  {
            dateString = getDateInString(byDate, format: ApplicationConstants.DateFormatClient)
        }
        else{
            dateString = getTimeInString(byDate)
        }

        return dateString
    }
    
    class func isDateValid(date:String,isFutureDateAllowed:Bool = true)->(Bool){
        var isValid = false
        
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        
        let date2 = calendar.startOfDay(for: Utility.getDateFromString(sourceDate: date, inputDateFormat: ApplicationConstants.DateFormatClient, outputDateFormat: ApplicationConstants.DateFormatClient))
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if (components.day!) >= 0{
            isValid = true
        }
        
        if !isFutureDateAllowed {
            if (components.day!) > 0{
                isValid = false
            }
            else {
                isValid = true
            }
        }
        return isValid
    }
    
    class func handleBackgroundPushNotifications( object: inout [String:Any],rootController:UIViewController,isComingFromBackgroundNotif:Bool = true){

        print("BG Notification JSON: \(object)")
        var dict : [AnyHashable:Any] = [:]
        var pushDict :[AnyHashable:Any] = [:]
        var notifActionKey = ""
        if isComingFromBackgroundNotif {
            dict = object["aps"] as! [AnyHashable : Any]
            pushDict = object
            notifActionKey = dict["category"] as! String
        }
        else{
            
            dict = (object["payload"] as! [String : Any])["data"] as! [String:Any]
            pushDict = dict
            notifActionKey = dict["data_click_action"] as! String
        }
        
        switch notifActionKey{
            
        case PushNotificationCategory.FriendInvitationPush:
            
            if isComingFromBackgroundNotif {
                showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: FriendInvitNotifiAlertController.nameOfClass(), controller: rootController)
            }
            else{
                let timeStamp = Int(object["unix_timestamp"]! as! String)
                let date = Utility.convertTimeStampToDate(timeStamp: timeStamp!)
                if !Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date, isFromFriendInviteTime: false){
                    
                    getLastInvitedTime(object: pushDict as! [String : Any], completionHandler: { (status) in
                        showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: FriendInvitNotifiAlertController.nameOfClass(), controller: rootController)
                    })
                    
                }
            }
            
            break
            
        case PushNotificationCategory.OfferAcceptedByDriver:
            if isComingFromBackgroundNotif {
                showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: DriverAcceptedRideViewController.nameOfClass(), controller: rootController)
            }
            else{
                let timeStamp = Int(object["unix_timestamp"]! as! String)
                let date = Utility.convertTimeStampToDate(timeStamp: timeStamp!)
                if !Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date, isFromFriendInviteTime: false){
                    showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: DriverAcceptedRideViewController.nameOfClass(), controller: rootController)
                }
            }
            break
            
            
        case PushNotificationCategory.NewTripOffer:
            
            if  let navControllerClone = rootController.parent{
                
                var contentObject :[String:Any] = [:]
                if isComingFromBackgroundNotif {
                    print("isComingFromBackgroundNotif")
                    contentObject = object

                }
                else{
                    print("isComingFromBackgroundNotif not")
                    contentObject = pushDict as! [String : Any]

                }

                let navController = navControllerClone as! UINavigationController
                let controller = getController(byIdentifier: OffersDetailViewController.nameOfClass(),title: ApplicationConstants.OfferDetailsScreenTitle) as! OffersDetailViewController
                let passengerID = NSNumber(integerLiteral: Int(contentObject["passenger_id"] as! String)!)
                let driverID = NSNumber(integerLiteral: Int(contentObject["driver_id"]as! String)!)
                let tripID = NSNumber(integerLiteral: Int(contentObject["trip_id"]as! String)!)
                
                let trip = Trip()
                trip.passenger = Passenger()
                trip.driver = Driver()
                
                trip.trip_id = tripID
                trip.passenger?.user_id = passengerID
                trip.driver?.user_id = driverID
                controller.trip = trip
                if !isComingFromBackgroundNotif {
                    navController.pushViewController(controller, animated: true)
                }
                else{
                    navController.setViewControllers([controller], animated: false)
                }
            }
            
            break
            
        case PushNotificationCategory.DriverInvitation:
            if isComingFromBackgroundNotif {
                showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: InviteDriverModalController.nameOfClass(), controller: rootController)
            }
            else{
                let timeStamp = Int(object["unix_timestamp"]! as! String)
                let date = Utility.convertTimeStampToDate(timeStamp: timeStamp!)
                if !Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date, isFromFriendInviteTime: false){
                    
                    getLastInvitedTimeForDriver(object: pushDict as! [String : Any], completionHandler: { (status) in
                        showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: InviteDriverModalController.nameOfClass(), controller: rootController)
                    })
                }
            }

            
            break
            
            
        case PushNotificationCategory.ChatNotification:
            if  let navControllerClone = rootController.parent{
                
                var contentObject :[String:Any] = [:]
                if isComingFromBackgroundNotif {
                    print("isComingFromBackgroundNotif")
                    contentObject = object
                    
                }
                else{
                    print("isComingFromBackgroundNotif not")
                    contentObject = pushDict as! [String : Any]
                    
                }
                let navController = navControllerClone as! UINavigationController
                let controller = getController(byIdentifier: ChatViewController.nameOfClass(),title: ApplicationConstants.GroupChatTitle) as! ChatViewController
                let tripID = NSNumber(integerLiteral: Int(contentObject["trip_id"]as! String)!)
                
                let trip = Trip()
                trip.trip_id = tripID
                
                controller.trip = trip
                
                if !isComingFromBackgroundNotif {
                    navController.pushViewController(controller, animated: true)
                }
                else{
                    navController.setViewControllers([controller], animated: false)
                }
            }
            
            break
            
        case PushNotificationCategory.MarkDropOFF:
            
            if isComingFromBackgroundNotif{
                showNotificationInPopup(object: pushDict as! [String : Any], controllerIdentifier: RatingCommentsViewController.nameOfClass(), controller: rootController)
                
            }
            else{
                
                if let tripIDClone = dict["trip_id"] as? Int{
                    
                    if  let navControllerClone = rootController.parent{
                        let navController = navControllerClone as! UINavigationController
                        let controller = getController(byIdentifier: RideDetailsViewController.nameOfClass(),title: ApplicationConstants.RideDetailsTitle) as! RideDetailsViewController
                        controller.tripID = "\(tripIDClone)"
                        navController.pushViewController(controller, animated: true)
                    }
                }
            }
            break
            
            
        default :
            
            if isNotShowRideDetailScreen(notifActionKey: notifActionKey) {
                break
            }
            
            if let tripIDClone = dict["trip_id"] as? Int{
                
                if  let navControllerClone = rootController.parent{
                    let navController = navControllerClone as! UINavigationController
                    let controller = getController(byIdentifier: RideDetailsViewController.nameOfClass(),title: ApplicationConstants.RideDetailsTitle) as! RideDetailsViewController
                    controller.tripID = "\(tripIDClone)"
                    
                    if !isComingFromBackgroundNotif {
                        navController.pushViewController(controller, animated: true)
                    }
                    else{
                        navController.setViewControllers([controller], animated: false)
                    }
                }
            }
            break
        }
    }
    
    class func getLastInvitedTime(object:[String:Any],completionHandler: @escaping (InvitedFriendTimeStatus?) -> ()){
        
        FireBaseManager.sharedInstance.getInvityLastUpdatedTime(object:object) { (objInvitedFriendTimeStatus,deatils) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InvitExpires?:
                break
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                completionHandler(InvitedFriendTimeStatus.InviteNotExpire)
                break
                
            default:
                break
            }
        }
    }
    
    class func getLastInvitedTimeForDriver(object:[String:Any],completionHandler: @escaping (InvitedFriendTimeStatus?) -> ()){
        
        FireBaseManager.sharedInstance.getInvityLastUpdatedTime(object:object) { (objInvitedFriendTimeStatus,details) in
            
            let driverDetails = object
            if  let driverObject = driverDetails[FireBaseConstant.driverNode]{
                
                let driverNode = driverObject as? [String:Any]
                
                let driveStatus = driverNode![FireBaseConstant.driverStatus] as? NSNumber
                
                if (driveStatus == nil || driveStatus?.intValue == 0) {
                    
                    switch objInvitedFriendTimeStatus{
                        
                    case InvitedFriendTimeStatus.InvitExpires?:
                        break
                        
                    case InvitedFriendTimeStatus.InviteNotExpire?:
                        completionHandler(InvitedFriendTimeStatus.InviteNotExpire)
                        break
                        
                    default:
                        break
                    }
                }
                else{
                }
            }
            else{
            }
        }
        
    }

    
    class func handleForegroundPushNotifications(object:[String:Any],rootController:UIViewController){
        
        print("FG Notification JSON: \(object)")
        let dict = object["aps"] as! [AnyHashable:Any]
        
        switch dict["category"] as! String{
            
        case PushNotificationCategory.FriendInvitationPush:
            showNotificationInPopup(object: object, controllerIdentifier: FriendInvitNotifiAlertController.nameOfClass(), controller: rootController)
            break
            
        case PushNotificationCategory.OfferAcceptedByDriver:
            showNotificationInPopup(object: object, controllerIdentifier: DriverAcceptedRideViewController.nameOfClass(), controller: rootController)
            break
            
        case PushNotificationCategory.NewTripOffer:
            break
            
            
        case PushNotificationCategory.DriverInvitation:
            showNotificationInPopup(object: object, controllerIdentifier: InviteDriverModalController.nameOfClass(), controller: rootController)
            break
            
        case PushNotificationCategory.MarkDropOFF:
            showNotificationInPopup(object: object , controllerIdentifier: RatingCommentsViewController.nameOfClass(), controller: rootController)
            break

        default :
            break
            
            
        }
    }

    class func getController(byIdentifier:String,title:String) -> (UIViewController){
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: byIdentifier)
        controller.navigationItem.title = title
        return controller
    }
    
    class func showNotificationInPopup(object:[String:Any],controllerIdentifier:String,controller:UIViewController){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: controllerIdentifier)
        if let cont = cont as? RatingCommentsViewController {
            cont.hideRatingField = false
        }
        cont.contentDict = object
//        controller.navigationItem.rightBarButtonItem?.isEnabled = false
//        controller.navigationItem.leftBarButtonItem?.isEnabled = false
        
        cont.show(controller: controller)
        cont.doneButtonTapped = { selectedData in
            
            if cont is DriverAcceptedRideViewController {
                
                if let code = selectedData["error_code"] as? String{
                    if code == ErrorTypes.InvalidCCErrorCode{
                        if  let navControllerClone = controller.parent as? UINavigationController{
                            
                            let controller  =  getController(byIdentifier: PaymentViewController.nameOfClass(), title: ApplicationConstants.MyPaymentScreenTitle) as! PaymentViewController
                            navControllerClone.setViewControllers([controller], animated: false)
                            
                        }
                    }
                }
            }

        }
        
        cont.selectButtonTapped = { selectedData in
            
            let rate = selectedData as! RateModel
            
            if let trip_id = object["trip_id"] as? NSString {
                rate.trip_id = trip_id as String!
            }
            else if let trip_id = object["trip_id"] as? NSNumber {
                rate.trip_id = trip_id.stringValue
            }
            
            if let driver_id = object["driver_id"] as? String {
                rate.user_id = driver_id
            }
            
            if let driver_idINT = object["driver_id"] as? Int {
                rate.user_id = String(driver_idINT)
            }

            
            var rateArray: [[String:String]] = []
            
            rateArray.append([ "rating":rate.rating , "trip_id":rate.trip_id, "feedback":rate.feedback, "user_id":rate.user_id ])
            
            Trip.rateTrip(rateArray: rateArray, isDriver: false)
            { (object, message, active, status) in
                
            }
            
        }
    }
    
    class func loadLastSelectedStateOfUser()->(String){
        
        var title:String = ""
        switch Utility.getUserType(){
            
        case UserType.UserNormal:
            title = PlistUtility.getScreenTitle(userType: UserType.UserNormal)
            break
            
        case UserType.UserDriver:
            title = PlistUtility.getScreenTitle(userType: UserType.UserDriver, screenIndex: 0)
            break
            
        default:
            break
        }
        
        return title
    }
    
    class func getDriverController()->(UIViewController){
//        let driverController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PostTripViewController.nameOfClass())
        let driverController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PassengerTripController.nameOfClass())
//        let _ = driverController.view //force to load the view to initialize the IBOutlets
        driverController.navigationItem.title = Utility.loadLastSelectedStateOfUser()
        return driverController
    }
    
    class func getPassengerController()->(UIViewController){
//        let userController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: FindRidesViewController.nameOfClass())
        let userController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PassengerTripController.nameOfClass())
//        let _ = userController.view //force to load the view to initialize the IBOutlets
        userController.navigationItem.title = Utility.loadLastSelectedStateOfUser()
        return userController
    }
    
    class func getDateByTimeStamp(timeStamp:String, isFireBase: Bool = true, dateFormat: String = ApplicationConstants.DateFormatClient)->(String){
        var divisor = 1
        if isFireBase {
            divisor = 1000
        }
        let unixTimestamp = (Int(timeStamp))!/divisor
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    class func getYearsArray()->([String]){
        
        var years = [String]()
        for i in (2018..<2100) {
            years.append("\(i)")
        }
        return years
    }
    
    class func getCarModelYearsArray()->([String]){
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let leastYear = year! - 15
        var years = [String]()
        
        for i in leastYear...year! {
            years.append("\(i)")
        }
        
        return years.reversed()
    }
    
    class func formatPhoneNumber(textField: UITextField,range: NSRange, string: String) -> Bool{
        let phoneNumber : String = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        textField.text = getFormatedNumber(phoneNumber: phoneNumber)
        return false
    }
    
    class func getFormatedNumber(phoneNumber:String)->(String){
        var phoneNumber = phoneNumber
        let phoneNumberFormatChars = ["(",")"," ","-"]
        var phoneNumberArray = Array(phoneNumber.characters)
        for char in phoneNumberFormatChars {
            phoneNumberArray = phoneNumberArray.filter { String($0) != char }
        }
        if phoneNumberArray.count == 10 {
            phoneNumber = "(" + phoneNumberArray[0..<3].map { String($0) }.joined() + ") "
            phoneNumber += phoneNumberArray[3..<6].map { String($0) }.joined() + "-"
            phoneNumber += phoneNumberArray[6..<10].map { String($0) }.joined()
        }
        else if phoneNumberArray.count == 12 && phoneNumberArray[0] == "+" {
            phoneNumber = phoneNumberArray[0..<2].map { String($0) }.joined() + "-"
            phoneNumber += phoneNumberArray[2..<5].map { String($0) }.joined() + "-"
            phoneNumber += phoneNumberArray[5..<8].map { String($0) }.joined() + "-"
            phoneNumber += phoneNumberArray[8..<12].map { String($0) }.joined()
        }
        else {
            phoneNumber = phoneNumberArray.map { String($0) }.joined()
        }
        return phoneNumber
    }
    
    class func removeAllNonDigits(_ phoneNumber: String)-> String{
        var phoneNumberArray = phoneNumber.characters
        let phoneNumberFormatChars = ["(",")"," ","-"]
        for char in phoneNumberFormatChars {
            phoneNumberArray = phoneNumberArray.filter { String($0) != char }
        }
        return phoneNumberArray.map { String($0) }.joined()
    }
    
    class func printIt(optionalText:String, logText:String){
        NSLog("%@ %@",optionalText, logText)
    }
    
    class func loadLastSelectedStateOfCurrentUser()->(String){
        
        var currentUserType = ""
        switch User.sharedInstance.user_type {
        case UserType.UserNormal?:
            currentUserType = UserType.UserNormal
            break
            
        case UserType.UserDriver?:
            
            switch Utility.getUserType(){
                
            case UserType.UserNormal:
                currentUserType = UserType.UserNormal
                break
                
            case UserType.UserDriver:
                currentUserType = UserType.UserDriver
                
                break
                
            default:
                currentUserType = UserType.UserNormal
                break
                
            }
            break
            
        default:
            currentUserType = UserType.UserNormal
            break
        }
        return currentUserType
    }
    
    class func isDriver() -> Bool {
        return loadLastSelectedStateOfCurrentUser() == UserType.UserDriver
    }
    
    class func drawPin(map:GMSMapView,lat:String,lon:String,isDropOff:Bool?)->(GMSMarker?){
        
        if let latitude = Double(lat) , let longitude = Double(lon) {
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            
            if let isDropOffClone = isDropOff{
                if isDropOff! {
                    marker.icon = UIImage(named: AssetsName.AnnotaionDropOff)
                }
                else{
                    marker.icon = UIImage(named: AssetsName.AnnotaionPickUp)
                }
            }
            else{
                marker.icon = UIImage(named: AssetsName.AnnotaionDriver)
            }
            marker.map = map
            
            return marker
        }
        else {
            return nil
        }
        
    }
    
    class func drawDriverPin(lat:String,lon:String)->(GMSMarker?){
        
        if let latitude = Double(lat) , let longitude = Double(lon) {
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: AssetsName.AnnotaionDriver)
            return marker
        }
        else {
            return nil
        }
        
    }
    
    class func goToApplicationSettings(){
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    class func getGenderEnumValue(genderString:String)->(Int){
        
        var gender = 0
        
        switch (genderString){
            
        case "Both":
            gender = 3
            break
            
        case "Female":
            gender = 2
            break
            
        case "Male":
            gender = 1
            break

        default:
            break
        }
        return gender
    }
    
    class func resetBadgeCount (){
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
    }
    
    
    class func convertDateToTimeStamp(date:Date)->(Int){
        let secondsGMT = TimeZone.current.secondsFromGMT()
        let dateWithOffset = date.addingTimeInterval(TimeInterval(secondsGMT))
        let timeInterval = dateWithOffset.timeIntervalSince1970
        // convert to Integer
        let timeStamp = Int(timeInterval) * 1000
        return timeStamp
    }
    
    class func getFormattedCardNumber(last_digits: String?) -> String{
        return "**** **** \(last_digits ?? "")"
    }
    
    class func convertNSObjectToJSON(prederenceEntity:Any)->[String:Any]{
        
        let preference = prederenceEntity
        let dictionary =  (preference as AnyObject).dictionaryRepresentation()
        return dictionary
    }
    
    class func isNotShowRideDetailScreen( notifActionKey: String ) -> Bool {
        let rideDetailsKey =
        [
            PushNotificationCategory.PassengersConfirmed,
            PushNotificationCategory.TripCancelled,
            PushNotificationCategory.MarkDropOFF,
            PushNotificationCategory.PassengerRemoved,
            PushNotificationCategory.MarkPickup,
            PushNotificationCategory.UpdateReturningRideTime,
            PushNotificationCategory.TripStartedPAssenger,
            PushNotificationCategory.PickkUpTimeUpdated,
            PushNotificationCategory.PaymentFailed,
            PushNotificationCategory.NewTripSuggestion,
            PushNotificationCategory.OfferAcceptedPassenger,
            PushNotificationCategory.PassengerLeft
        ]
        return !rideDetailsKey.contains(notifActionKey)
    }
    
    class func isUserRemembered()->(Bool){
        var isRemeber = false
        let userDefaults: UserDefaults = UserDefaults.standard
        if let flag =  userDefaults.value(forKey: "isUserRemembered") {
            isRemeber = flag as! Bool
        }
        return isRemeber
        
    }
    
    class func setRememberState(isRemember:Bool){
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(isRemember, forKey: "isUserRemembered")
        userDefaults.synchronize()
    }
    
    class func rememberUser(email:String,password:String){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(email, forKey: "user_email")
        userDefaults.set(password, forKey: "user_password")
        userDefaults.synchronize()
    }
    
    class func getUserCredentails()->(String,String){
        let userDefaults: UserDefaults = UserDefaults.standard
        var emailClone : String = ""
        var passClone : String = ""

        if let email = userDefaults.value(forKey: "user_email") {
            emailClone = email as! String
        }
        if let password = userDefaults.value(forKey: "user_password"){
            passClone = password as! String
        }
        
        return (emailClone,passClone)

    }
    
    class func shouldCallService()->(Bool){
        var shouldCall = false
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        let dateString = formatter.string(from: date)
        let defaults = UserDefaults.standard
        let changedDate = defaults.object(forKey: "date") as? String
        if changedDate != nil {
            
            if dateString.compare(changedDate!) == .orderedSame {
                shouldCall = false
            }
            else{
                shouldCall = true
                defaults.set(dateString, forKey: "date")
                defaults.synchronize()
            }
            
        }
        else{
            defaults.set(dateString, forKey: "date")
            defaults.synchronize()

            shouldCall = true

        }
        
        return shouldCall
    }
    
    class func applyShadowOnView(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    class func getCurrentDate()->(String){
        let date = Utility.getDateInString(Date(), format: ApplicationConstants.DateFormatClient)
        return date
    }
    
    class func getEstimatesKey()->(String){
        var keyEstimates = ""
        if   Utility.isDriver(){
            keyEstimates = PlistPlaceHolderConstant.PostTripEstimates
        }
        else{
            keyEstimates = PlistPlaceHolderConstant.FindRidesEstimates
        }
        
        return keyEstimates
    }
    
    class func selectDropDown(label: UILabel, array: [String], title: String, vc: UIViewController, object: PostTrip){
        
        vc.view.endEditing(true)
        let actionSheet = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for (_, value) in array.enumerated() {
            actionSheet.addAction(UIAlertAction.init(title: value, style: UIAlertAction.Style.default, handler: { (action) in
                label.text = value
                object.placeholdertext = value
            }))
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        
        //Present the controller
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    class func setEstimateRange(distanceValue: Double)-> String {
        
        let ratePerMileLower = getValueFromUserDefaults(key: BootMeUpKeys.MinEstimateKey.value)?.doubleValue ?? 1
        let ratePerMileUpper = getValueFromUserDefaults(key: BootMeUpKeys.MaxEstimateKey.value)?.doubleValue ?? 1
        
//        let calulatedPriceLower = String(format: "$%.2f", distanceValue * ratePerMileLower)
//        let calulatedPriceUpper = String(format: "$%.2f", distanceValue * ratePerMileUpper)
//        let finalRange = calulatedPriceLower + " - " + calulatedPriceUpper
//        return finalRange
        return getFormattedEstimate(factor: distanceValue, minEstimate: ratePerMileLower, maxEstimate: ratePerMileUpper)
    }
    
    class func setEstimateRangeForRoundTrip()-> String {
        
        let (minEstimate,maxEstimate) : (Double,Double) = Utility.getEstimates()
        return getFormattedEstimate(factor: 2, minEstimate: minEstimate, maxEstimate: maxEstimate)
        
//        let estimate = DataPersister.sharedInstance.getTripInfo()?.estimate ?? ""
//        let estimates = estimate.split(separator: "-")
//
//        if estimates.count > 0 {
//
//            if let minEstimate = Double(Utility.removeAlphaNumericFromString(text: String(estimates[0]))),
//            let maxEstimate = Double(Utility.removeAlphaNumericFromString(text: String(estimates[1])))
//            {
//
//                let calulatedPriceLower = String(format: "$%.2f", 2 * minEstimate)
//                let calulatedPriceUpper = String(format: "$%.2f", 2 * maxEstimate)
//                let finalRange = calulatedPriceLower + " - " + calulatedPriceUpper
//                return finalRange
//
//            }
//
//        }
//
//        return estimate
        
    }
    
    class func removeAlphaNumericFromString(text: String)-> String{
        return text.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
    }
    
    class func getTimeRange(_ isForReturn: Bool = false)-> Int {
        let sections = CreateTripDetails.shared.postArray.filter( { ($0.objectIdentifier ?? "") == CreateTripEntityConstant.sectionOneEntity } ).first
        
        let rows = sections?.rowsArray ?? []
        var timerange = 0
        
        if rows.count > 0 {
            
            if isForReturn {
                
                timerange = Int(rows.first?.title ?? "0")!
                
            } else {
                
                timerange = Int(rows.first?.text ?? "0")!
                
            }
            
        }
        return timerange
        
    }
    
    class func getEstimates()-> (Double,Double) {
        
        let estimate = DataPersister.sharedInstance.getTripInfo()?.estimate ?? ""
        let estimates = estimate.split(separator: "-")
        
        if estimates.count > 0 {
            
            if let minEstimate = Double(Utility.removeAlphaNumericFromString(text: String(estimates[0]))),
                let maxEstimate = Double(Utility.removeAlphaNumericFromString(text: String(estimates[1])))
            {
                return (minEstimate,maxEstimate)
            }
            
        }
        
        return (0.0,0.0)
        
        
    }
    
    class func getFormattedEstimate(factor: Double, minEstimate: Double, maxEstimate: Double) -> String{
        
        if(maxEstimate < 2.5) {
            return "$5.00 - $5.00"
        }
        
        let calulatedPriceLower = String(format: "$%.2f", factor * minEstimate)
        let calulatedPriceUpper = String(format: "$%.2f", factor * maxEstimate)
        let finalRange = calulatedPriceLower + " - " + calulatedPriceUpper
        return finalRange
    }
    
    class func getGender()-> String{
        let section = CreateTripDetails.shared.postArray.filter( { ($0.objectIdentifier ?? "") == CreateTripEntityConstant.sectionTwoEntity } ).first
        
        let row = section?.rowsArray.filter( { ( ($0.title != nil) && ($0.title == "Gender")) } ).first
        
        return row?.placeholdertext ?? "Both"
        
    }
    
    class func getSeats(_ isForReturn: Bool = false)-> Int {
        let sections = CreateTripDetails.shared.postArray.filter( { ($0.objectIdentifier ?? "") == CreateTripEntityConstant.sectionOneEntity } ).first
        
        let rows = sections?.rowsArray ?? []
        var seats = 0
        
        if rows.count > 0 {
            
            if isForReturn {
                
                seats = Int(rows.first?.expected_start_time ?? "0")!
                
            } else {
                
                seats = Int(rows.first?.placeholdertext ?? "0")!
                
            }
            
        }
        return seats
        
    }
    
    class func validTwoDates(date1: String, date2: String, format: String = ApplicationConstants.DateFormatClient) -> Bool {
        
        let formatedDate1 = Utility.getDateFromString(date: date1, format: format)
        let formatedDate2 = Utility.getDateFromString(date: date2, format: format)
        
        if formatedDate1 <= formatedDate2 {
            return true
        }
        
        return false
        
    }
    
    class func saveCacheEmailAddress(email:String){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(email, forKey: "cache_email")
        userDefaults.synchronize()
    }
    
    
    class func getCacheEmail()->(String){
        var type : String = ""
        let userDefaults: UserDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "cache_email") != nil){
            type  = userDefaults.value(forKey: "cache_email") as! String
        }
        return type
    }
    
    
    class func isTimePassed(onDate:Date)->(Bool){
        
        var isPassed = true
        let currentDateString = Utility.getDateInString(Date(), format: ApplicationConstants.DateTimeFormat)
        let currentDate = Utility.getDateFromString(date: currentDateString, format: ApplicationConstants.DateTimeFormat)

        let diff = onDate.timeIntervalSince(currentDate)
        if diff >= ApplicationConstants.ThresholdOnFixedRideTime {
            isPassed = false
        }

        return isPassed
    }
    
    class func send(Message msg: String, ToNumber number: String) {
//        let body = "Hello Abc How are You I am ios developer.".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let sms: String = "sms:+1234567890&body=" + body!
        if let body = msg.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let sms: String = "sms:\(number)&body=" + body
            if let url = URL.init(string: sms), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    class func getPaymentOpitonsArray()->([String]){
//        return ["Expedited Payment within 24 hours","Standard Payment"]
        return ["Expedited","Standard"]
    }
    
    class func isDeviceIphoneX()->(Bool){
        
        var isIphoneX = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
                isIphoneX = true
            default:
                print("unknown")
            }
        }
        
        return isIphoneX
    }
    
//    class func getLastLocation(latitude: String,longitude: String) -> (String,String) {
//
//        var latitude = latitude
//        var longitude = longitude
//
//        if latitude.isEmpty || longitude.isEmpty {
//
//            if let lat = UserDefaults.standard.string(forKey: "trackLat") {
//                latitude = lat
//            }
//
//            if let lon = UserDefaults.standard.string(forKey: "trackLon") {
//                longitude = lon
//            }
//
//        }
//        else {
//
//
//
//        }
//
//    }
//
//     UserDefaults.standard.set(1, forKey: "Key")
//     UserDefaults.standard.integer(forKey: "Key")
    
    class func convertJsonToDictionary(json: String) -> [String:Any] {
        
        let data = json.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
            {
                return jsonArray
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        return [:]
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
