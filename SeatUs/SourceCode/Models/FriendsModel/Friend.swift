//
//  Friends.swift
//  Friends
//
//  Created by Syed Muhammad Muzzammil on 27/10/2017.
//  Copyright © 2017 Syed Muhammad Muzzammil. All rights reserved.
//

import UIKit


class Friend: NSObject {
    var name: String?
    var profilePic: UIImage?
    var mutualFriends: String?
    @objc var full_name: String?
    @objc var is_blocked: NSNumber?
    @objc var is_self: NSNumber?
    @objc var profile_picture: String?
    @objc var user_id: NSNumber?
    @objc var status: NSNumber?
    @objc var email: String?
    @objc var phone: String?
    @objc var last_name: String?
    @objc var first_name: String?
    @objc var rating: NSNumber?
    @objc var role_id: String!
    


    class  func getFriends(param:[String:AnyObject],completionHandler: @escaping ([Friend?]?, NSDictionary?, ResponseAction?, Bool?) -> ()){
        
        WebServices.sharedInstance.sendRequestToServer(urlString: WebServicesConstant.FollowerFriendsService, methodType: .post, param: param, shouldShowHud: false){
            (response, message, status, error) in
            
            if status!{
                var friendsObjectArray = [Friend?]()
                
                if let arrayVersion = response as? NSArray {
                    
                    for (_,value) in arrayVersion.enumerated() {
                        let friendObj = Friend()
                       _ = DynamicParser.setValuesOnClass(object: value as! [String : Any], classObj: friendObj)
                        friendsObjectArray.append(friendObj)
                    }
                    
                    if DataPersister.sharedInstance.saveFriends(friend: friendsObjectArray as! [Friend]){
                    }

                }
                completionHandler(friendsObjectArray,message,ResponseAction.DoNotShowMesasgeAtRunTime,status)
            }
            else{
                completionHandler(nil,message,ResponseAction.ShowMesasgeOnAlert,status)
            }
        }
    }

    class func getFriendsArray(friendsArray: [[String:Any]]) -> [Friend] {
        var friends = [Friend]()
        for obj in friendsArray {
            let friend = Friend()
            friend.first_name = obj["first_name"] as? String
            friend.last_name = obj["last_name"] as? String
            friend.full_name = friend.first_name! + " " + friend.last_name!
            friend.email = obj["email"] as? String
            friend.phone = obj["mobile"] as? String
            friends.append(friend)
        }
        return friends
    }
    
}


/*
var friendsArr: [Friend] {
    let names = ["Harry Potter","Ron Weasely","King Aragorn","Gandalf Dumbeldore","Jack Sparrow","Barbossa"]
    var _friends = [Friend]()
    for name in names{
        let index = names.index(of: name)! + 1
        let friend = Friend()
        friend.full_name = name
        friend.profilePic = UIImage.init(named: "img\(index)")
        friend.mutualFriends = "\(index * 3)"
        friend.phone = "\(index * 3)3423423"
        friend.email = name.lowercased().replacingOccurrences(of: " ", with: "") + "@seatus.com"
        _friends.append(friend)
    }
    return _friends
}
*/

