//
//  FacebookUtility.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/23/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import Foundation
//import FacebookCore
//import FacebookLogin

struct FacebookConstant {
    static let FBLoginFailed        = "Facebook login failed"

    static let ParamString : String = "id, name, first_name, last_name, age_range, link, gender, locale, timezone, updated_time, verified"
    static let FriendsParamString : String = "id, first_name, last_name, name, email, picture"
    static let FBProfileparams :[String:Any] = ["fields" : ParamString]
    static let FBFriendsParams = ["fields": FriendsParamString]
}

class FacebookUtility:NSObject{

//    class func loginToFB(controller: UIViewController, completionHandler:@escaping (LoginResult?) -> ()){
//
//        let loginManager = LoginManager()
//        loginManager.loginBehavior = .native
//
//        loginManager.logIn(readPermissions: [ReadPermission.publicProfile/*, ReadPermission.userAboutMe*/, ReadPermission.userFriends], viewController: controller) { (results) in
//            completionHandler(results)
//        }
//    }
//
//    class func getUserFriends(completionHandler:@escaping ([String:Any]?, String?) -> ())
//    {
//        let graphRequest = GraphRequest(graphPath: "/me/friends", parameters: FacebookConstant.FBFriendsParams)
//        graphRequest.start {
//            (urlResponse, requestResult) in
//
//            switch requestResult {
//            case .failed(let error):
//                    print("error in graph request:", error)
//                    completionHandler(nil,error.localizedDescription)
//                    break
//            case .success(let graphResponse):
//                if let responseDictionary = graphResponse.dictionaryValue {
//                    completionHandler(responseDictionary,nil)
//                }
//            }
//        }
//    }
//
//    class func getProfileMeInfo(completionHandler:@escaping ([String:Any]?, String?) -> ())
//    {
//        let graphRequest = GraphRequest(graphPath: "me", parameters: FacebookConstant.FBProfileparams)
//        graphRequest.start {
//            (urlResponse, requestResult) in
//
//            switch requestResult {
//            case .failed(let error):
//                print("error in graph request:", error)
//                completionHandler(nil,error.localizedDescription)
//                break
//            case .success(let graphResponse):
//                if let responseDictionary = graphResponse.dictionaryValue {
//                    completionHandler(responseDictionary,nil)
//                }
//            }
//        }
//    }
//
//    class func isFacebookUserLoggedIn()->Bool{
//        return (AccessToken.current != nil)
//    }
//    class func getFaceebookToken()->(String){
//        return (AccessToken.current?.authenticationToken)!
//    }
//
//    class func gettingFriends(controller:BaseViewController,compilationHandler:@escaping(Bool?)->()){
//
//        if !isFacebookUserLoggedIn() {
//
//            // if user is not currently logged in
//            loginToFB(controller: controller, completionHandler: { (results) in
//
//                switch results{
//
//                case .cancelled?:
//                    print("cancelled")
//                    compilationHandler(false)
//                    break
//
//                case .failed( _)?:
////                    Utility.showAlertwithOkButton(message: FacebookConstant.FBLoginFailed, controller: controller)
//                    compilationHandler(false)
//                    print("failed")
//                    break
//
//                case .success(grantedPermissions: _, declinedPermissions: _, token: _)?:
//                    fetchFriends(controller: controller, compilationHandler: { (status) in
//                        compilationHandler(status)
//                    })
//                    break
//
//                default:
//                    break
//                }
//            })
//        }
//        else{
//            // if user is already logged in
//            fetchFriends(controller: controller, compilationHandler: { (status) in
//                compilationHandler(status)
//            })
//        }
//    }
//
//    class func fetchFriends(controller:BaseViewController,compilationHandler:@escaping(Bool?)->()){
//
//        var fbFreindsIds:String = ""
//        getUserFriends(completionHandler: { (object, message) in
//
//            let array = object!["data"] as! [[String:Any]]
//
//            for (_,element) in array.enumerated(){
//                let freindId: String = element["id"] as! String
//                if fbFreindsIds.isEmpty{
//                    fbFreindsIds = freindId
//                }
//                else{
//                    fbFreindsIds = fbFreindsIds + "-,-" + freindId
//                }
//            }
//            User.sharedInstance.fbFriendIsToSubmit = fbFreindsIds
//            compilationHandler(true)
//        })
//    }

}
