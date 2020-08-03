//
//  User.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import Foundation


class FriendProfile:NSObject {
    
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
    


    
    var signUpObjectArray: [SignUpEntity]!
    var signUpDetailsObjectArray: [SignUpEntity]!
    var fbUserInfo : [String:Any]! = [:]
    var contactNumbersToSubmit : String! = ""
    var fbFriendIsToSubmit : String! = ""
    
    
}
