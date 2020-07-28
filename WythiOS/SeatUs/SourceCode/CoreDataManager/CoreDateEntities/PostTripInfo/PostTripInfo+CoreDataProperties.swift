//
//  PostTripInfo+CoreDataProperties.swift
//  
//
//  Created by Qazi Naveed on 11/20/17.
//
//

import Foundation
import CoreData


extension PostTripInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostTripInfo> {
        return NSFetchRequest<PostTripInfo>(entityName: "PostTripInfo")
    }

    @NSManaged public var date: String?
    @NSManaged public var returnDate: String?
    @NSManaged public var destination: String?
    @NSManaged public var destinationCoordinates: String?
    @NSManaged public var estimate: String?
    @NSManaged public var origin: String?
    @NSManaged public var originCoordinates: String?
    @NSManaged public var bookNow: Bool
    @NSManaged public var timeOfDay: String?
    @NSManaged public var seats: String?
    @NSManaged public var roundTrip: Bool
    @NSManaged public var rating: String?
    @NSManaged public var trip_name: String?
    @NSManaged public var gender: String?
    
//    override public func awakeFromInsert()
//    {
//        super.awakeFromInsert()
//        self.trip_name = ""
//    }

}
