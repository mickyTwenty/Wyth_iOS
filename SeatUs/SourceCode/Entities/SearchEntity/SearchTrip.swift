//
//  SearchTrip.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/28/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class GroupSearchTrip: NSObject {
    var group_id : NSNumber?
    var trips = [SearchTrip]()
}


class SearchTrip: NSObject {

    @objc var trip_name: String?
    @objc var trip_id: NSNumber?
    @objc var origin_title: String?
    @objc var destination_title: String?
    @objc var start_time: String?
    @objc var expected_start_time: String?
    @objc var expected_distance: String?
    @objc var estimates_format: String?
    @objc var expected_distance_format: String?
    @objc var ride_status: String?
    @objc var group_id : NSNumber?
    @objc var min_estimates : NSNumber?
    @objc var max_estimates : NSNumber?
    @objc var rides : [[String:Any]]?
    @objc var preferences : [[String:Any]]?
    @objc var seats_total : NSNumber?
    @objc var seats_available : NSNumber?
    
//    @objc  var time_range : NSNumber?
//    @objc  var conditions:[[String:Any]]!
    
    var drive: Driver? = Driver()
    var passenger: Passenger? = Passenger()
    
    
    class func search(byFilters filters: [PostTrip], onTrips trips: [GroupSearchTrip], filterKeys: [String:Int])-> [GroupSearchTrip] {
        
        var trips = trips
        
        for (key,value) in filterKeys {
            
            let object = filters[value]
            
            trips = SearchTrip.search(byFilter: object, onTrips: trips, filterKey: key)
            
            
        }
     
        return trips
        
    }
    
    class func search(byFilter filter: PostTrip, onTrips trips: [GroupSearchTrip], filterKey: String)-> [GroupSearchTrip] {
    
        var trips = trips
        var groups = trips.filter( { $0.group_id != nil  }  )
        var notGroups = trips.filter( { $0.group_id == nil  }  )
        
        switch filterKey {
            
        case "TripTime":
            
            for group in groups {
                
                var _trips = group.trips
                
                for trip in _trips {
                    
                    if let preferences = (trip.preferences as? [[String:Any]]) {
                        
                        var isSelected = filter.isselected.boolValue ?? false
                        var objs: [GroupSearchTrip] = []
                        
                        for preference in preferences {
                            
                            if let item = preference[filterKey] {
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            let _trips = trips.map( { $0.trips  }  )
 
            
     //       trips = trips.filter( { $0.trips.filter( $0.trips.filter(   ) ) } )
            
            break
            
        case "Gender":
            
          //  trips = trips.filter( { $0.trips.filter( $0.trips.filter(  ) ) } )
            
            break
            
        default:
            
            
            break
            
        }
        
        
        return trips
        
    }
    
    func getTripIdOrTripName()-> String {
        //   return trip_name ?? ""
        return trip_id?.stringValue ?? ""
    }
}
