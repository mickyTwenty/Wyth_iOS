//
//  User.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import Foundation


class User:NSObject,NSCoding {
    
    // singelton instance
    static var sharedInstance = User()
    
    // variables
//    var transitionState:TransitionState!
    @objc var _token:String?
    @objc var email:String?
    @objc var full_name:String?
    @objc var first_name:String?
    @objc var last_name:String?
    @objc var city:NSNumber?
    @objc var birth_date:String?
    @objc var city_text:String?
    @objc var gender:String?
    @objc var graduation_year:String?
    @objc var phone:String?
    @objc var postal_code:String?
    @objc var profile_picture:String?
    @objc var school_name:String?
    @objc var state:NSNumber?
    @objc var state_text:String?
    @objc var student_organization:String?
    @objc var user_id:NSNumber?
    @objc var has_sync_friends:NSNumber?
    @objc var has_facebook_integrated:NSNumber?
    @objc var user_type:String?
    @objc var vehicle_type:String?
    @objc var driving_license_no:String?
    @objc var follower_count:NSNumber?
    @objc var has_pending_ratings:NSNumber?
    @objc var rating:String?

    @objc var vehicle_make:String?
    @objc var vehicle_model:String?
    @objc var vehicle_year:String?
    @objc var vehicle_id_number:String?
    @objc var trips_canceled:NSNumber?
    @objc var trips_canceled_driver:NSNumber?
    
    var signUpObjectArray: [SignUpEntity]!
    var signUpDetailsObjectArray: [SignUpEntity]!
    var fbUserInfo : [String:Any]! = [:]
    var contactNumbersToSubmit : String! = ""
    var fbFriendIsToSubmit : String! = ""

    @objc var ssn:String?

    private override init() {
    }
    
    required init(coder decoder: NSCoder) {
        self._token = decoder.decodeObject(forKey: ApplicationConstants.Token) as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.full_name = decoder.decodeObject(forKey: "full_name") as? String ?? ""
        self.city = decoder.decodeObject(forKey: "city") as? NSNumber
        self.birth_date = decoder.decodeObject(forKey: "birth_date") as? String ?? ""
        self.city_text = decoder.decodeObject(forKey: "city_text") as? String ?? ""
        self.gender = decoder.decodeObject(forKey: "gender") as? String ?? ""
        self.phone = decoder.decodeObject(forKey: "phone") as? String ?? ""
        self.postal_code = decoder.decodeObject(forKey: "postal_code") as? String ?? ""
        self.profile_picture = decoder.decodeObject(forKey: "profile_picture") as? String ?? ""
        self.school_name = decoder.decodeObject(forKey: "school_name") as? String ?? ""
        self.state = decoder.decodeObject(forKey: "state") as? NSNumber
        self.state_text = decoder.decodeObject(forKey: "state_text") as? String ?? ""
        self.student_organization = decoder.decodeObject(forKey: "student_organization") as? String ?? ""
        self.user_id = decoder.decodeObject(forKey: "user_id") as? NSNumber
        self.has_sync_friends = decoder.decodeObject(forKey: "has_sync_friends") as? NSNumber
        self.has_facebook_integrated = decoder.decodeObject(forKey: "has_facebook_integrated") as? NSNumber
//        self.friend_count = decoder.decodeObject(forKey: "friend_count")as? NSNumber
        self.follower_count = decoder.decodeObject(forKey: "follower_count")as? NSNumber

        self.graduation_year = decoder.decodeObject(forKey: "graduation_year") as? String ?? ""
        self.user_type = decoder.decodeObject(forKey: "user_type") as? String ?? ""
        self.first_name = decoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.last_name = decoder.decodeObject(forKey: "last_name") as? String ?? ""
        self.vehicle_type = decoder.decodeObject(forKey: "vehicle_type") as? String ?? ""
        self.vehicle_id_number = decoder.decodeObject(forKey: "vehicle_id_number") as? String ?? ""
        self.vehicle_model = decoder.decodeObject(forKey: "vehicle_model") as? String ?? ""
        
        self.vehicle_year = decoder.decodeObject(forKey: "vehicle_year") as? String ?? ""



        
        self.driving_license_no = decoder.decodeObject(forKey: "driving_license_no") as? String ?? ""
        self.has_pending_ratings = decoder.decodeObject(forKey: "has_pending_ratings") as? NSNumber
        self.vehicle_make = decoder.decodeObject(forKey: "vehicle_make") as? String ?? ""
        self.rating = decoder.decodeObject(forKey: "rating") as? String
        self.trips_canceled = decoder.decodeObject(forKey: "trips_canceled") as? NSNumber
        self.trips_canceled_driver = decoder.decodeObject(forKey: "trips_canceled_driver") as? NSNumber

        self.ssn = decoder.decodeObject(forKey: "ssn") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_token, forKey: ApplicationConstants.Token)
        coder.encode(email, forKey: "email")
        coder.encode(full_name, forKey: "full_name")
        coder.encode(city, forKey: "city")
        coder.encode(birth_date, forKey: "birth_date")
        coder.encode(city_text, forKey: "city_text")
        coder.encode(gender, forKey: "gender")
        coder.encode(phone, forKey: "phone")
        coder.encode(postal_code, forKey: "postal_code")
        coder.encode(profile_picture, forKey: "profile_picture")
        coder.encode(school_name, forKey: "school_name")
        coder.encode(state, forKey: "state")
        coder.encode(state_text, forKey: "state_text")
        coder.encode(student_organization, forKey: "student_organization")
        coder.encode(user_id, forKey: "user_id")
        coder.encode(has_sync_friends, forKey: "has_sync_friends")
        coder.encode(has_facebook_integrated, forKey: "has_facebook_integrated")
        coder.encode(user_type, forKey: "user_type")
//        coder.encode(friend_count, forKey: "friend_count")
        coder.encode(follower_count, forKey: "follower_count")
        coder.encode(graduation_year, forKey: "graduation_year")
        coder.encode(vehicle_type, forKey: "vehicle_type")
        coder.encode(driving_license_no, forKey: "driving_license_no")
        coder.encode(first_name, forKey: "first_name")
        coder.encode(last_name, forKey: "last_name")
        coder.encode(has_pending_ratings, forKey: "has_pending_ratings")
        coder.encode(rating, forKey: "rating")

        coder.encode(vehicle_id_number, forKey: "vehicle_id_number")
        coder.encode(vehicle_make, forKey: "vehicle_make")
        coder.encode(vehicle_model, forKey: "vehicle_model")
        coder.encode(vehicle_year, forKey: "vehicle_year")
        coder.encode(trips_canceled, forKey: "trips_canceled")
        coder.encode(trips_canceled_driver, forKey: "trips_canceled_driver")
        coder.encode(ssn, forKey: "ssn")
    }

    
    class func archiveUserObject(){
        
        let user = User.sharedInstance
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: ApplicationConstants.UserObject)
        userDefaults.synchronize()
        _ = getArchiveObject()
    }
    
    class func getArchiveObject()->Bool{
        
        if let data = UserDefaults.standard.data(forKey: ApplicationConstants.UserObject){
            let user = NSKeyedUnarchiver.unarchiveObject(with: data ) as! User
            User.sharedInstance = user
            return true
        }else{
            return false
        }
    }
    
    
    class func removeArchiveObject(){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: ApplicationConstants.UserObject)
        userDefaults.synchronize()
        User.sharedInstance = User()
        getArchiveObject()

    }

    class func getUserName()->String?{
        return User.sharedInstance.first_name! + " "  + User.sharedInstance.last_name!
//        return User.sharedInstance.full_name
    }
    

    class func getUserAccessToken()->String?{
        return User.sharedInstance._token
    }

    class func getProfilePictureUrl()->String?{
        return User.sharedInstance.profile_picture
    }
    
    class func getUserRating()->Float?{
        return Float(User.sharedInstance.rating ?? "0")
    }

    class func getUserAddress()->String?{
        
        var address:String = ""
        if let city = User.sharedInstance.city_text, let state = User.sharedInstance.state_text{
            address = city + "" + ", " + state
        }
        return address
    }
    
    class func getUserType()-> String?{
        
        var typeString: String = ""
        if let type = User.sharedInstance.user_type{
            typeString = type
        }
        return typeString
    }

    class func getUserID()-> String?{
        return User.sharedInstance.user_id?.stringValue
    }

    class func hasSyncedFreinds()->Bool{
        
        var flag : Bool = false
        if let number = User.sharedInstance.has_sync_friends{
            flag = Utility.convertNumberToInt(number: number)
        }
        
        return flag
    }

    class  func loginUser(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?, Error?) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.LoginService, methodType: HTTPMethods.post, param: param) {
            (response, objectInfo, status, networkError) in
            
            if !(networkError != nil){
                
                if status!{

                    let user = User.sharedInstance
                    let obj =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                    
                    Utility.saveCacheEmailAddress(email: param["email"] as! String)
                    if Utility.isUserRemembered() {
                        Utility.rememberUser(email: user.email!, password: param["password"] as! String)
                    }
                    archiveUserObject()
                    Utility.setUserType(type: User.sharedInstance.user_type!)
                    FireBaseManager.subscribeForTopic()
                    completionHandler(obj,objectInfo,ResponseAction.DoNotShowMesasgeAtRunTime,status,networkError)
                    let dict: [String:AnyObject] = [ApplicationConstants.Token:User.getUserAccessToken() as AnyObject]
                    Friend.getFriends(param: dict as [String : AnyObject]) { (object, message, action, status) in
                    }
                }
                else{
                    completionHandler(response,objectInfo,ResponseAction.ShowMesasgeOnAlert,status,networkError)
                }
            }
            else{
                completionHandler(response,objectInfo,ResponseAction.ShowMesasgeOnAlert,status,networkError)
            }
        }
    }
    
    class func logoutUser(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.LogoutService, methodType: HTTPMethods.post, param: param) {
            (response, message, status, error) in
            completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
        }
    }
    
    class func resetPassword(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.ResetPasswordService, methodType: HTTPMethods.post, param: param as [String : AnyObject]) {
            (response, message, status, error) in
            
            if status! {
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
    class func deleteAccount(param:[String:AnyObject]?,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.DeleteAccountService, methodType: HTTPMethods.post, param: (param as? [String : AnyObject])) {
            (response, message, status, error) in
            
            if status! {
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
    class func resendCode(email:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let param:[String:Any] = ["email":email]
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.ResendVerificationCode, methodType: HTTPMethods.post, param: param as [String : AnyObject]) {
            (response, message, status, error) in
            
            if status! {
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
    class func verifyUser(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.VerifyUserService, methodType: HTTPMethods.post, param: param as [String : AnyObject]) {
            (response, message, status, error) in
            
            if status! {
                
                let user = User.sharedInstance
                _ =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                
                if Utility.isUserRemembered() {
                    Utility.rememberUser(email: user.email!, password: param["password"] as! String)
                }
                archiveUserObject()
                Utility.setUserType(type: User.sharedInstance.user_type!)
                FireBaseManager.subscribeForTopic()
                
                let dict: [String:AnyObject] = [ApplicationConstants.Token:User.getUserAccessToken() as AnyObject]
                Friend.getFriends(param: dict as [String : AnyObject]) { (object, message, action, status) in
                }
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeAtRunTime, status)
            }
        }
    }
    
    class func loginToFacebook(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.FbLoginService, methodType: HTTPMethods.post, param: param as [String : AnyObject]) {
            (response, message, status, error) in
            if status!{
                let user = User.sharedInstance
                let obj =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                completionHandler(obj,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }
    
    class func aboutMe(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.AboutMeService, methodType: .post, param: param as [String : AnyObject], shouldShowHud: false){
                (response, message, status, error) in
            
            if status!{
                let user = User.sharedInstance
                let obj =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                archiveUserObject()
                completionHandler(obj,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }
    
    class func friendProfile(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let userId = param["user_id"] as! String
        let service = WebServicesConstant.FriendProfileService + userId
        WebServices.sharedInstance.sendRequestToServer(urlString: service, methodType: .post, param: param as [String : AnyObject], shouldShowHud: true){
            (response, message, status, error) in
            
            if status!{
                let obj =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: FriendProfile())
                completionHandler(obj,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }
    
    class func removePicture(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.UpdateUserService, methodType: .post, param: param as [String : AnyObject], shouldShowHud: false){
            (response, message, status, error) in
            
            if status!{
                let user = User.sharedInstance
                let obj =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                archiveUserObject()
                completionHandler(obj,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert, status)
            }
        }
    }


    
    class func changePassword(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.UpdateUserService, methodType: HTTPMethods.post, param: param) {
            (response, message, status, error) in
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert,status)            
        }
    }
    
    class func syncUserFreinds(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.SyncUserFriendsService, methodType: .post, param: param, shouldShowHud: false) { (response, message, status, error) in
            User.sharedInstance.has_sync_friends = true
            archiveUserObject()
            completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
        }
    }
    
    class func createUser(userType:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?, Error?) -> ()){
        
        let array = User.sharedInstance.signUpObjectArray
        let arrayDetails = User.sharedInstance.signUpDetailsObjectArray
    
        let name = Utility.getValueFromModel(key: PlistPlaceHolderConstant.FullNamePlaceHolder, array: array!) as AnyObject
        let firstName = Utility.getValueFromModel(key: PlistPlaceHolderConstant.PlaceHoldeFirstName, array: array!) as AnyObject
        let lastName = Utility.getValueFromModel(key: PlistPlaceHolderConstant.PlaceHoldeLastName, array: array!) as AnyObject

        let school = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SchoolNamePlaceHolder, array: array!) as AnyObject
        let email = Utility.getValueFromModel(key: PlistPlaceHolderConstant.EmailPlaceHolder, array: array!) as AnyObject
        Utility.saveCacheEmailAddress(email: email as! String)

        var phoneNumber = Utility.getValueFromModel(key: PlistPlaceHolderConstant.PhoneNumberPlaceHolder, array: array!) as AnyObject
        phoneNumber = Utility.removeAllNonDigits(phoneNumber as! String) as AnyObject
        let organization = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SchoolOrganizationPlaceHolder, array: array!) as AnyObject
        let state = Utility.getValueFromModel(key: PlistPlaceHolderConstant.StatePlaceHolder, array: arrayDetails!) as AnyObject
        let city = Utility.getValueFromModel(key: PlistPlaceHolderConstant.CityPlaceHolder, array: arrayDetails!) as AnyObject
        let zip = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ZipPlaceHolder, array: arrayDetails!) as AnyObject
        let grad_year = Utility.getValueFromModel(key: PlistPlaceHolderConstant.GraduationPlaceHolder, array: arrayDetails!) as AnyObject
        let password = Utility.getValueFromModel(key: PlistPlaceHolderConstant.PasswordPlaceHolder, array: arrayDetails!) as AnyObject
        let stateID = Utility.getLocationID(stateName: state as! String, array: WorldLocation.getStatesList(countryID : ApplicationConstants.CountryIdUS)) as AnyObject
        let citiesList = WorldLocation.getCitiesList(stateId: stateID as! String)
        let cityID = Utility.getLocationID(stateName: city as! String, array: citiesList) as AnyObject
        
        let gender = Utility.getValueFromModel(key: PlistPlaceHolderConstant.genderPlaceHolder, array: array!) as AnyObject
        
        let license = Utility.getValueFromModel(key: PlistPlaceHolderConstant.LicencePlaceHolder, array: array!) as AnyObject
        
        let vehicleID = Utility.getValueFromModel(key: PlistPlaceHolderConstant.VehicleIDPlaceHolder, array: array!) as AnyObject
        
        let make = Utility.getValueFromModel(key: PlistPlaceHolderConstant.MakePlaceHolder, array: array!) as AnyObject
        
        let model = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ModelPlaceHolder, array: array!) as AnyObject


        let year = Utility.getValueFromModel(key: PlistPlaceHolderConstant.YearPlaceHolder, array: array!) as AnyObject
        
        let company = Utility.getValueFromModel(key: PlistPlaceHolderConstant.CompanyPlaceHolder, array: array!) as AnyObject
        
        
        let effectiveDate = Utility.getValueFromModel(key: PlistPlaceHolderConstant.EffectivePlaceHolder, array: array!) as AnyObject
        let expiryDate = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ExpiryPlaceHolder, array: array!) as AnyObject

        let source = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SourceHearingMessage, array: arrayDetails!) as AnyObject


        let userTypeString = userType as AnyObject
    
        let castNumber = phoneNumber as! String
        
        var validatedNumber : String = ""
        
        validatedNumber = castNumber
        
        
        
        var dictionary : [String:AnyObject] = ["first_name":firstName,"last_name":lastName ,"school_name":school,"email":email,"phone":validatedNumber as AnyObject,"student_organization":organization,"state":stateID,"city":cityID,"postal_code":zip,"graduation_year":grad_year,"password":password,"user_type":userTypeString,"device_token":FireBaseManager.getFCMToken() as Any as AnyObject,"gender":gender,"driving_license_no":license,"vehicle_make":make,"vehicle_model":model,"vehicle_year":year,"vehicle_id_number":vehicleID,"reference_source":source]
        var token:String? =  nil
        if (User.sharedInstance.fbUserInfo!["token"] != nil){
            token = User.sharedInstance.fbUserInfo!["token"] as? String
            dictionary["facebook_token"] = token as AnyObject
        }

        // remove key if empty
        for key in ["state","city","postal_code"] {
            if let val = dictionary[key] as? String, val.isEmpty {
                dictionary.removeValue(forKey: key)
            }
        }
        
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.RegistrationService, methodType: .post, param: dictionary) { (response, message, status, error) in
            if status!{
                
                dictionary.removeValue(forKey: ApplicationConstants.Token)

                switch (userType){
                    
                case UserType.UserNormal:
                    AnalyticsHelper.logEvent(eventName: AnalyticsConstant.CreatePassenger, parameters: dictionary as! [String : String])
                    
                    break
                    
                case UserType.UserDriver:
                    AnalyticsHelper.logEvent(eventName: AnalyticsConstant.CreateDriver, parameters: dictionary as! [String : String])
                    
                    break
                    
                default : break
                }
                completionHandler(response,message,ResponseAction.DoNotShowMesasgeAtRunTime,status,error)
            }
            else{
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert,status,error)
            }

        }
    }
    
    class func updateUser(userType:String,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let dic = getUserInfoObject()
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.UpdateUserService, methodType: .post, param: dic) { (response, message, status, error) in
            if status! {
                let user = User.sharedInstance
                _  =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                archiveUserObject()
                completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert,status)
            }
        }
    }
    
    class func bindWithFacebook(param:[String:AnyObject],completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.BindAccountWithFaceebookService, methodType: .put, param: param, shouldShowHud: false) { (respobse, message, status, eror) in
            
        }
    }
    
    class func postDataWithPicture(userType:String,imageParam:[[String : AnyObject]]? = nil,isUpgrading:Bool = false ,completionHandler: @escaping (AnyObject?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        let paramDict = getUserInfoObject()
        var serviceUrl : String = ""
        if isUpgrading {
            serviceUrl = WebServicesConstant.UpgradeDriverService

        }
        else{
            serviceUrl = WebServicesConstant.UpdateUserService
        }
        
        WebServices.sharedInstance.postRequestWithImage(urlString: serviceUrl, controllerView: nil, paramDict: paramDict, imageParams: imageParam) { (response, message, status) in
            
            if status!{
                
                // if user is updating profile
                if !isUpgrading{
                    let user = User.sharedInstance
                    _  =  DynamicParser.setValuesOnClass(object: response as! [String : Any], classObj: user)
                    archiveUserObject()
                }
                else{
                    // if user is upgrading
                }
            }
            completionHandler(response,message,ResponseAction.ShowMesasgeOnAlert,status)
        }
    }
    
    
    
    
    
   class func getUserInfoObject()->[String:AnyObject]{
        
        let arrayDetails = User.sharedInstance.signUpDetailsObjectArray
        
        var phoneNumber = Utility.getValueFromModel(key: PlistPlaceHolderConstant.PhoneNumberPlaceHolder, array: arrayDetails!) as AnyObject
        phoneNumber = Utility.removeAllNonDigits(phoneNumber as! String) as AnyObject
        let school = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SchoolNamePlaceHolder, array: arrayDetails!) as AnyObject
        let organization = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SchoolOrganizationPlaceHolder, array: arrayDetails!) as AnyObject
        let state = Utility.getValueFromModel(key: PlistPlaceHolderConstant.StatePlaceHolder, array: arrayDetails!) as AnyObject
        let city = Utility.getValueFromModel(key: PlistPlaceHolderConstant.CityPlaceHolder, array: arrayDetails!) as AnyObject
        let zip = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ZipPlaceHolder, array: arrayDetails!) as AnyObject
        let grad_year = Utility.getValueFromModel(key: PlistPlaceHolderConstant.GraduationPlaceHolder, array: arrayDetails!) as AnyObject
    var stateID = Utility.getLocationID(stateName: state as! String, array: WorldLocation.getStatesList(countryID : ApplicationConstants.CountryIdUS)) as AnyObject
        let citiesList = WorldLocation.getCitiesList(stateId: stateID as! String)
        var cityID = Utility.getLocationID(stateName: city as! String, array: citiesList) as AnyObject
        let dob = Utility.getValueFromModel(key: PlistPlaceHolderConstant.DobPlaceHolder, array: arrayDetails!) as AnyObject
        let dobServerFormat = Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateFormatClient, dateString: dob as! String)
    
        let gender = Utility.getValueFromModel(key: PlistPlaceHolderConstant.genderPlaceHolder, array: arrayDetails!) as AnyObject
        let token  = User.getUserAccessToken() as AnyObject
        let vehicleID = Utility.getValueFromModel(key: PlistPlaceHolderConstant.VehicleIDPlaceHolder, array: arrayDetails!) as AnyObject
        let make = Utility.getValueFromModel(key: PlistPlaceHolderConstant.MakePlaceHolder, array: arrayDetails!) as AnyObject
        let model = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ModelPlaceHolder, array: arrayDetails!) as AnyObject
        let year = Utility.getValueFromModel(key: PlistPlaceHolderConstant.YearPlaceHolder, array: arrayDetails!) as AnyObject
        let company = Utility.getValueFromModel(key: PlistPlaceHolderConstant.CompanyPlaceHolder, array: arrayDetails!) as AnyObject
        let effectiveDate = Utility.getValueFromModel(key: PlistPlaceHolderConstant.EffectivePlaceHolder, array: arrayDetails!) as AnyObject
        let expiryDate = Utility.getValueFromModel(key: PlistPlaceHolderConstant.ExpiryPlaceHolder, array: arrayDetails!) as AnyObject
    
    if (stateID as! String).isEmpty {
        stateID = "0" as AnyObject
    }
    
    if (cityID as! String).isEmpty {
        cityID = "0" as AnyObject
    }

        let vehicle = Utility.getValueFromModel(key: PlistPlaceHolderConstant.VehiclePlaceHolder, array: arrayDetails!) as AnyObject
        let licence = Utility.getValueFromModel(key: PlistPlaceHolderConstant.LicencePlaceHolder, array: arrayDetails!) as AnyObject
        let ssn = Utility.getValueFromModel(key: PlistPlaceHolderConstant.SSNPlaceHolder, array: arrayDetails!) as AnyObject
    
    var dictionary : [String:AnyObject] = ["school_name":school,"phone":phoneNumber,"student_organization":organization,
                                           "state":stateID,"city":cityID,"postal_code":zip,"graduation_year":grad_year,"birth_date":dobServerFormat as AnyObject,"gender":gender,ApplicationConstants.Token:token,"vehicle_type":vehicle,"driving_license_no":licence,"vehicle_make":make,"vehicle_model":model,"vehicle_year":year,"vehicle_id_number":vehicleID,"ssn":ssn]
    
    

    if !(dobServerFormat.count > 0) {
        dictionary.removeValue(forKey: "birth_date")
    }


        return dictionary
    }
    
    class func bootMeUp(completionHandler: @escaping (AnyObject? , NSDictionary? , ResponseAction? , Bool? ) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.BootMeUp, methodType: .get, param: nil, shouldShowHud: false) { (response, message, status, eror) in
            
            if status!{
                
                for object in (response as? [String:Any])! {
                    if let key = BootMeUpKeys(rawValue : object.key) {
                        //print(key)
                        Utility.saveToUserDeafults(object: object.value as AnyObject, key: key.value)
                    }
                }
                
   //             Utility.savePreference(object: response as! [String:Any])
//                Utility.saveToUserDeafults(object: response!["vehicle_type"] as AnyObject, key: UserDefaultsKeys.VehicleTypeKey)
                //Utility.saveToUserDeafults(object: response!["schools"] as AnyObject, key: UserDefaultsKeys.SchoolKey)
            }
        }
    }
    
    class func getSchoolData(completionHandler: @escaping (AnyObject? , NSDictionary? , ResponseAction? , Bool? ) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.SchoolNamesService, methodType: .get, param: nil, shouldShowHud: false) { (response, message, status, eror) in
            
            if status!{
                Utility.saveToUserDeafults(object: response as AnyObject, key: UserDefaultsKeys.SchoolKey)
            }
        }
    }



    func getSignUpData()->[SignUpEntity]{
        
        let objetcts =  PlistUtility.getPlistDataForSignUp()
        var array = [SignUpEntity]()
        
        for (_, value) in objetcts.enumerated() {
         
            let castValue = value as![String:Any]
            let model = SignUpEntity()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! SignUpEntity)
        }
        return array
    }
    
    func getSignUpDetailsData()->[SignUpEntity]{
        
        let objetcts =  PlistUtility.getPlistDataForSignUpDetails()
        var array = [SignUpEntity]()
        
        for (_, value) in objetcts.enumerated() {
            
            let castValue = value as![String:Any]
            let model = SignUpEntity()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! SignUpEntity)
        }
        return array
    }
    
    func getDriverEditProfileData()->[SignUpEntity]{
        
        let objetcts =  PlistUtility.getPlistDataForEditDriverProfile()
        var array = [SignUpEntity]()
        
        for (_, value) in objetcts.enumerated() {
            
            let castValue = value as![String:Any]
            let model = SignUpEntity()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! SignUpEntity)
        }
        return array
    }
    
    func getPassengerEditProfileData()->[SignUpEntity]{
        
        let objetcts =  PlistUtility.getPlistDataForEditPassengerProfile()
        var array = [SignUpEntity]()
        
        for (_, value) in objetcts.enumerated() {
            
            let castValue = value as![String:Any]
            let model = SignUpEntity()
            let obj =  DynamicParser.setValuesOnClass(object: castValue, classObj: model)
            array.append(obj as! SignUpEntity)
        }
        return array
    }

    class func hasPendingRatings()->Bool{
        print("hasPendingRatings",User.sharedInstance.has_pending_ratings as Any)
        return User.sharedInstance.has_pending_ratings?.boolValue ?? false
    }
    
    class func setPendingRatings(hasPending: Bool) {
        return User.sharedInstance.has_pending_ratings = hasPending as NSNumber
    }
    
    class func isDriverDetailsNotSubmitted()-> Bool {
        
        if (User.sharedInstance.vehicle_type ?? "").isEmpty {
            return true
        }
        else if (User.sharedInstance.vehicle_id_number ?? "").isEmpty {
            return true
        }
        else if (User.sharedInstance.vehicle_make ?? "").isEmpty {
            return true
        }
        else if (User.sharedInstance.vehicle_model ?? "").isEmpty {
            return true
        }
        else if (User.sharedInstance.vehicle_year ?? "").isEmpty {
            return true
        }
//        else if (User.sharedInstance.ssn ?? "").isEmpty {
//            return true
//        }

        return false
    }
    
    class func isUserDetailsNotSubmitted()-> Bool {

        if ( User.sharedInstance.city_text ?? "").isEmpty {
            return true
        }
        else if ( User.sharedInstance.state_text ?? "").isEmpty {
            return true
        }
        else if ( User.sharedInstance.postal_code ?? "").isEmpty {
            return true
        }

        return false
    }

}
