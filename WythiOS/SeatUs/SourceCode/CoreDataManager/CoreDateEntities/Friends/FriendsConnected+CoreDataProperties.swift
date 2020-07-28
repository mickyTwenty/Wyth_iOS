//
//  FriendsConnected+CoreDataProperties.swift
//  
//
//  Created by Qazi Naveed on 1/10/18.
//
//

import Foundation
import CoreData


extension FriendsConnected {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsConnected> {
        return NSFetchRequest<FriendsConnected>(entityName: "FriendsConnected")
    }

    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var full_name: String?
    @NSManaged public var is_blocked: Bool
    @NSManaged public var is_self: Bool
    @NSManaged public var last_name: String?
    @NSManaged public var phone: String?
    @NSManaged public var profile_picture: String?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var role_id: String?
    @NSManaged public var search_count: NSNumber?
    @NSManaged public var user_id: String?
    @NSManaged public var vehicle_type: String?
    @NSManaged public var manually_add: Bool

}
