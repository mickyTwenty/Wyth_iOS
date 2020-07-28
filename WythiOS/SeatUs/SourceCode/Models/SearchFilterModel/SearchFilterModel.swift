//
//  SearchFilterModel.swift
//  SeatUs
//
//  Created by Qazi Naveed on 4/10/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
//class SearchFilter: NSObject{
//    var groupid: NSNumber?
//    var tripid: NSNumber?
//    var key: String?
//    var value: Any?
//}

class SearchFilterModel {

//    var tripArray: [GroupSearchTrip]! = []
    
//    var preferencesFilter: [SearchFilter] = []
//
//    var preferencesDict: [[String:Any]] = []
//
//    func breakInParts(tripsArray: [GroupSearchTrip]){
//
//        self.tripArray = tripsArray
//        var trips = tripsArray
//
//        var groups = trips.filter( { $0.group_id != nil  }  )
//        var notGroups = trips.filter( { $0.group_id == nil  }  )
//
//        for grouptrip in trips {
//
//            for trip in grouptrip.trips {
//
//                if let preferences = trip.preferences {
//
//                    for preference in preferences {
//
////                        let searchFilter = SearchFilter()
////
////                        searchFilter.key = preference["title"] as? String
////                        searchFilter.value = preference["checked"] as? NSNumber
////                        searchFilter.tripid = trip.trip_id
////                        searchFilter.groupid = trip.group_id
////
////                        preferencesFilter.append(searchFilter)
//
//                        var searchFilter = [String:Any]()
//
//                        searchFilter["key"] = preference["title"] as? String
//                        searchFilter["value"] = preference["checked"] as? NSNumber
//                        searchFilter["tripid"] = trip.trip_id
//                        searchFilter["groupid"] = trip.group_id
//
//
//                   //     preferencesDict.append(searchFilter)
//
//                    }
//
//                }
//
//            }
//
//
//
//        }
//
//    }
    
//    func search(byFilter filter: [String:Any]){
//
//        if let preferences = filter["preferences"] as? [String:Any] {
//
//            var grouped = preferencesFilter.filter( { $0.groupid != nil } )
//            var notGrouped = preferencesFilter.filter( { $0.groupid == nil } )
//
//            for preference in preferences {
//
//                if let value = preference.value as? NSNumber {
//
//                    let searchFilter = notGrouped.filter( { ($0.key == preference.key) && (($0.value as? NSNumber) == value)  }  )
//
//                    for filter in searchFilter {
//
//
//
//
//
//
//                    }
//
//                }
//
//
//            }
//
//        }
//
//
//    }
    
    //preferencesDict.filter( { NSPredicate(format: "%K == %@ && %K == %d", "key" , "Smoking", "value", 1).evaluate(with: $0) } )
    // notGroups.filter{ NSPredicate(format: "(%K == %d)", "trip_id" , 566).evaluate(with: $0 ) }
    
//    func filterContent(forSearchFilter filter: [String:Any]) {
//
//        var filtersGrp: [[String:Any]] = []
//
//        if let prefs = filter["preferences"] as? [String:Any] {
//
//            for pref in prefs {
//
//          //      filtersGrp = preferencesDict.filter( { NSPredicate(format: "%K == %@ && %K == %f", "key" , pref.key , "value", pref.value as! NSNumber ).evaluate(with: $0) } )
//
//            }
//
//        }
    
        //preferencesDict.filter( { NSPredicate(format: "%K == %@ && %K == %d", "key" , pref.key , "value", 1 ).evaluate(with: $0) } )
        
        // filtersGrp.flatMap( { $0.filter( { $0.key == "tripid"  } )  } )
        
//        if let fk = filtersGrp.flatMap( { $0.filter( { $0.key == "tripid"  } )  } ).flatMap({$0.value}) as? [NSNumber] {
//
//            tripArray.first?.trips = (tripArray.first?.trips.filter( { fk.contains($0.trip_id!) } ))!
//
//        }
        
        
//        let me = "Smoking" //Example value
//
//        let test = [
//            "first": [["createdBy":1124,"name":"Fred"],["createdBy":1123,"name":"Jane"]] ,
//            "second": [["created":1125,"name":"High"],["created":1129,"name":"Light"]]
//            ]
//
//       // let test = (preferencesFilter as! NSArray)
//        let lhs = NSExpression(forKeyPath: "key")
//        let rhs = NSExpression(forConstantValue: me)
//
//        let predicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.equalTo, options: [])
        
 //       let results = test.filtered(using: predicate)
 //       print("Results: \(results)")
        
//        var groups = tripArray.filter( { $0.group_id != nil  }  )
//        var notGroups = tripArray.filter( { $0.group_id == nil  } ).flatMap( { $0.trips } )
//        var preferences = notGroups.flatMap( { $0.preferences } )
//        let resultPredicate = NSPredicate(format: "key = %@", "Smoking")
//        let searchResults = preferencesFilter.filter{resultPredicate.evaluate(with: $0)}
//        print(searchResults)
//    }
    
    var unGroupedTrip: [NSNumber:SearchTrip] = [:]
    var groupedTrip: [NSNumber:GroupSearchTrip] = [:]
    
    var tripArray: [GroupSearchTrip]! = []
    var searchIds = [Double:[NSNumber]]()
    var groupIds = [NSNumber:Double]()
    var tripIds = [NSNumber:[NSNumber]]()
    var filterPreferences = [ String: [ Bool: [ Double ] ] ] ()
    var filterArray: [GroupSearchTrip]! = []
    
    var filterGender: [String:[Double]] = ["Male":[],"Female":[]]
    
    var filterTimeRange: [String:[Double]] =
        [
            "7":[],"6":[],"5":[],"4":[],"3":[],"2":[],"1":[]
    ]
    
    var returnfilterTimeRange: [String:[Double]] =
        [
            "7":[],"6":[],"5":[],"4":[],"3":[],"2":[],"1":[]
    ]
    
    final var thresholdDayStates:[String: [Int]] =
        [
            "7":[0,1,2],
            "6":[1,2],
            "5":[0,2],
            "4":[2],
            "3":[0,1],
            "2":[1],
            "1":[0]
    ]
    
    func createFilters(){

        var searchId = 0.0
        var currentSid = 0.0
        
        for groupTrip in tripArray {
            
            var _tripIds = [NSNumber]()
            var prefArray = [String:[Bool]]()
            var genders = [String]()
            var timeRangeGroups = [String]()
            
            for trip in groupTrip.trips {
                
                currentSid = searchId
                
                // search ids
                if let groupid = groupTrip.group_id {
                    if let id = groupIds[groupid] {
                        searchIds[id] = searchIds[id]! + [trip.trip_id!]
                    }
                    else {
                        groupIds[groupid] = searchId
                        searchIds[searchId] = [trip.trip_id!]
                    }
                }
                else {
                    searchIds[searchId] = [trip.trip_id!]
                }
                
                if groupTrip.group_id == nil {
                    searchId += 1
                    unGroupedTrip[trip.trip_id!] = trip
                }
                _tripIds.append(trip.trip_id!)
                
                
                // preferences
                
                if let prefs = trip.preferences {
                    
                    for pref in prefs {
                        
                        let title = pref["title"] as! String
                        
                        if let checked = pref["checked"] as? Bool {
                            
                            if groupTrip.group_id != nil {
                                if prefArray[title] != nil {
                                    prefArray[title] = prefArray[title]! + [checked]
                                }
                                else {
                                    prefArray[title] = [checked]
                                }
                            }
                            else {
                                addInPref(key: title, val: checked, searchId: currentSid)
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                 // gender
                
                if let gender = trip.drive?.gender {
                    
                    if groupTrip.group_id != nil {
                        genders.append(gender)
                    }
                    else {
                        filterGender[gender] = filterGender[gender]! + [currentSid]
                    }
                    
                }
                else if let gender = trip.passenger?.gender {
                    
                    if groupTrip.group_id != nil {
                        genders.append(gender)
                    }
                    else {
                        filterGender[gender] = filterGender[gender]! + [currentSid]
                    }
                    
                }
                
                // timerange
                
                if let ride = trip.rides {
                    
                    if ride.count > 0 {
                        
                        let fRide = ride[0]
                        
                        if let timeRange = fRide["time_range"] as? Int {
                            
                            let val = String(timeRange)
                            
                            if groupTrip.group_id != nil {
                                timeRangeGroups.append(val)
                            }
                            else {
                                filterTimeRange[val] = filterTimeRange[val]! + [currentSid]
                            }
                            
                        }
                        
                    }
                    
                    if ride.count > 1 {
                        
                        let rRide = ride[1]
                        
                        if let timeRange = rRide["time_range"] as? Int {
                            
                            let val = String(timeRange)
                            
                            returnfilterTimeRange[val] = returnfilterTimeRange[val]! + [currentSid]
                            
                            
                        }
                        
                    }
                    
                }
                
            }

            if groupTrip.group_id != nil {
                
                searchId += 1
                tripIds[groupTrip.group_id!] = _tripIds
                groupedTrip[groupTrip.group_id!] = groupTrip
                
                for group in prefArray {
                    
                    let value = Set(group.value)
                    
                    if value.count == 1 {
                        
                        if let val = value.first {
                            
                            addInPref(key: group.key, val: val, searchId: currentSid)
                            
                        }
                        
                    }
                    
                }
                
                let value = Set(genders)
                if value.count == 1 {
                    if let val = value.first {
                        filterGender[val] = filterGender[val]! + [currentSid]
                    }
                }
                
                let fir = timeRangeGroups[0]
                let ret = timeRangeGroups[1]
                filterTimeRange[fir] = filterTimeRange[fir]! + [currentSid]
                returnfilterTimeRange[ret] = returnfilterTimeRange[ret]! + [currentSid]

                
            }
            
        }
        
        
    }
    
    func createSearchIds(){
        
        var searchId = 0.0
        
        for groupTrip in tripArray {
            
            var _tripIds = [NSNumber]()
            
            for trip in groupTrip.trips {
                
                if let groupid = groupTrip.group_id {
                    if let id = groupIds[groupid] {
                        searchIds[id] = searchIds[id]! + [trip.trip_id!]
                    }
                    else {
                        groupIds[groupid] = searchId
                        searchIds[searchId] = [trip.trip_id!]
                    }
                }
                else {
                    searchIds[searchId] = [trip.trip_id!]
                }
                
                if groupTrip.group_id == nil {
                    searchId += 1
                }
                
                _tripIds.append(trip.trip_id!)
                
            }
            
            
            if groupTrip.group_id != nil {
                searchId += 1
                tripIds[groupTrip.group_id!] = _tripIds
            }
            
        }
        
    }
    
//    var smokingPref = [Bool:[Double]]()
//    var petPref = [Bool:[Double]]()
   
    func createPreferences(){

        for groupTrip in tripArray {
            
            var prefArray = [String:[Bool]]()
            var searchId: Double!
            
            for trip in groupTrip.trips {
                
                searchId =  searchIds.filter( { $0.value.contains(trip.trip_id!) } ).first?.key
                
                if let prefs = trip.preferences {
                    
                    for pref in prefs {
                        
                        let title = pref["title"] as! String
                        
                        if let checked = pref["checked"] as? Bool {
                            
                            if groupTrip.group_id != nil {
                                if prefArray[title] != nil {
                                    prefArray[title] = prefArray[title]! + [checked]
                                }
                                else {
                                    prefArray[title] = [checked]
                                }
                            }
                            else {
                                addInPref(key: title, val: checked, searchId: searchId)
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
            if groupTrip.group_id != nil {

                for group in prefArray {
                    
                    let value = Set(group.value)
                    
                    if value.count == 1 {
                        
                        if let val = value.first {
                            
                            addInPref(key: group.key, val: val, searchId: searchId)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        
    }
    
    func addInPref(key: String, val: Bool, searchId: Double){
        
        if filterPreferences[key] == nil {
            filterPreferences[key] = [:]
        }
        
        if var pref = filterPreferences[key] {
            
            if pref[val] != nil {
                pref[val] = pref[val]! + [searchId]
            }
            else {
                pref[val] = [searchId]
            }
            
            filterPreferences[key] = pref
        }
        
    }
    
    
//    func createPreferences(){
//
//        smokingPref[true] = []
//        smokingPref[false] = []
//
//        for groupTrip in tripArray {
//
//            var isSmokings = [Bool]()
//            var searchId: Double!
//
//            for trip in groupTrip.trips {
//
//                searchId =  searchIds.filter( { $0.value.contains(trip.trip_id!) } ).first?.key
//
//                if let prefs = trip.preferences {
//
//                    for pref in prefs {
//
//                        if (pref["title"] as! String) == "Smoking" {
//
//                            if let checked = pref["checked"] as? Bool {
//
//                                if groupTrip.group_id != nil {
//                                    isSmokings.append(checked)
//                                }
//                                else {
//                                    smokingPref[checked] = smokingPref[checked]! + [searchId!]
//                                }
//
//                            }
//                            else {
//
//                                if groupTrip.group_id != nil {
//                                    isSmokings.append(false)
//                                }
//                                else {
//                                    smokingPref[false] = smokingPref[false]! + [searchId!]
//                                }
//
//
//                            }
//
//                        }
//
//                    }
//
//                }
//
//
//
//
//
//            }
//
//            if groupTrip.group_id != nil {
//                let value = Set(isSmokings)
//                if value.count == 1 {
//                    if let val = value.first {
//                        smokingPref[val] = smokingPref[val]! + [searchId!]
//                    }
//                }
//            }
//
//
//        }
//
//
//
//    }
    
    func createGenderFilters(){
        
        for groupTrip in tripArray {
            
            var genders = [String]()
            var searchId: Double!
            
            for trip in groupTrip.trips {
                
                searchId =  searchIds.filter( { $0.value.contains(trip.trip_id!) } ).first?.key
                
                if let gender = trip.drive?.gender {
                    
                    if groupTrip.group_id != nil {
                        genders.append(gender)
                    }
                    else {
                        filterGender[gender] = filterGender[gender]! + [searchId!]
                    }
                    
                }
                
            }
            
            if groupTrip.group_id != nil {
                let value = Set(genders)
                if value.count == 1 {
                    if let val = value.first {
                        filterGender[val] = filterGender[val]! + [searchId!]
                    }
                }
            }
            
        }
        
    }

    // 7 for all
    // 6 for 2 , 3 , 4 , 5 , 6
    // 5 for 1 , 3 , 4 , 5
    // 4 for 4
    // 3 for 1 , 2 , 3
    // 2 for 2
    // 1 for 1
    
    func getPassStates(state: String) -> [String]{
        let i = [1,2,3,4,5,6,7]
        let intState = Int(state)!
        var allows = [String]()
        for k in i {
            if (k & intState) != 0 {
                allows.append(String(k))
            }
        }
        return allows
    }
    
    func getTripsMeetsThresholdDayStates(state: String, isReturn: Bool = false) -> [Double] {
        
        var passStates = [String]()
        passStates = getPassStates(state: state)
        
//        switch state {
//        case "7":
//            passStates = ["7","6","5","4","3","2","1"]
//            break
//        case "6":
//            passStates = ["6","5","4","3","2"]
//            break
//        case "5":
//            passStates = ["5","4","3","1"]
//            break
//        case "4":
//            passStates = ["4"]
//            break
//        case "3":
//            passStates = ["3","2","1"]
//            break
//        case "2":
//            passStates = ["2"]
//            break
//        case "1":
//            passStates = ["1"]
//            break
//        default:
//            break
//        }
        
        var allowIds = [Double]()
        
        for id in passStates {
        
            if isReturn {
            
                allowIds = allowIds + returnfilterTimeRange[id]!
            
            }
            else {
                
                allowIds = allowIds + filterTimeRange[id]!
                
            }
        
        }
        
        return allowIds
    }
    
    func createTimeRangeFilters(){
        
        for groupTrip in tripArray {
            
            var timeRangeGroups = [String]()
            var searchId: Double!
            
            for trip in groupTrip.trips {
                
                searchId =  searchIds.filter( { $0.value.contains(trip.trip_id!) } ).first?.key
                
                if let ride = trip.rides {
                    
                    if ride.count > 0 {
                        
                        let fRide = ride[0]
                        
                        if let timeRange = fRide["time_range"] as? Int {
                            
                            let val = String(timeRange)
                            
                            if groupTrip.group_id != nil {
                                timeRangeGroups.append(val)
                            }
                            else {
                                filterTimeRange[val] = filterTimeRange[val]! + [searchId!]
                            }
                            
                        }
                        
                    }
                    
                    if ride.count > 1 {
                        
                        let rRide = ride[1]
                        
                        if let timeRange = rRide["time_range"] as? Int {
                            
                            let val = String(timeRange)
                            
                            returnfilterTimeRange[val] = returnfilterTimeRange[val]! + [searchId!]
                            
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
            if groupTrip.group_id != nil {
                let fir = timeRangeGroups[0]
                let ret = timeRangeGroups[1]
                filterTimeRange[fir] = filterTimeRange[fir]! + [searchId!]
                returnfilterTimeRange[ret] = returnfilterTimeRange[ret]! + [searchId!]
            }
            
        }
        
        
        
    }
    
    
    
    func search(byFilter filter: [String:Any]){
        
        if tripArray.count <= 0 {
            print("return not found")
            return
        }
        
        var allows = [[Double]]()
        print("All End")
        for obj in filter {
            
            let value = obj.value
                
            switch obj.key {
                
            case "timeRange":
                
                if let value = value as? String {
                    
                    if value != "0" {
                        
                        print(obj.key, " : " , value , " : " , getTripsMeetsThresholdDayStates(state: value, isReturn: false))
//                        allows.append(filterTimeRange[value]!)
                        allows.append(getTripsMeetsThresholdDayStates(state: value))
                        
                    }
                    else {
                        print(obj.key, " : " , value , " : " , " [] ")
                        allows.append([])
                    }
                    
                }
                
                break
                
            case "timeRangeReturning":
                
                if let value = value as? String {
                    
                    if value != "0" {
                        
                        print(obj.key, " : " , value , " : " , getTripsMeetsThresholdDayStates(state: value, isReturn: true))
//                        allows.append(returnfilterTimeRange[value]!)
                        allows.append(getTripsMeetsThresholdDayStates(state: value, isReturn: true))
                        
                    }
                    else {
                        print(obj.key, " : " , value , " : " , " [] ")
                        allows.append([])
                    }
                    
                }
                
                break
                
            case "preferences":
                
                if let values = value as? [String:Any] {
                    
                    for val in values {
                        
                        if let obj = val.value as? NSNumber {
                            
                            if let pref = filterPreferences[val.key] {
                                
                                if let prefValue = pref[obj.boolValue] {
                                
                                    print(val.key, " : " , obj , " : " , pref[obj.boolValue]!)
                                    allows.append(prefValue)
                                
                                }
                                else {
                                    print(val.key, " : " , obj , " : " , " [] ")
                                    allows.append([])
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                break
                
            case "Gender":
                
                if let value = value as? String {
                
                    if value ==  "Both" {
                        print(value , " : " , "[]")
                    }
                    else {
                        print(obj.key, " : " , value , " : " , filterGender[value]!)
                        allows.append(filterGender[value]!)
                    }
                
                }
                
                break
                
                
            default: break
                
            }
            
            
        }
        
        print(allows)
        print("All Call")
        var uniques = allows.first ?? []
        
        if allows.count > 1 {
            for i in (1..<allows.count)
            {
                uniques = Set(uniques).filter(Set(allows[i]).contains)
            }
        }
      //  uniques = [0.0]
        print(uniques)
        print("All Uniques")
        
        filterArray = []
        let unGrouped = GroupSearchTrip()
        var grouped = [GroupSearchTrip]()
        
        for unique in uniques {
            
            let _tripIds = searchIds[unique] ?? []
            
            if _tripIds.count == 1 {
                
                if let _trip = unGroupedTrip[_tripIds.first!] {
                    unGrouped.trips.append(_trip)
                }
                
//                if let _trip = tripArray.filter( { $0.group_id == nil } ).first {
//
//                    if let trip = _trip.trips.filter( { $0.trip_id == _tripIds.first } ).first {
//
//                        unGrouped.trips.append(trip)
//
//                    }
//
//                }

                
            } else if _tripIds.count > 1 {
                
                if let grpTripId = groupIds.first(where: { $0.value == unique } ) {
                    
                    if let grpTrip = groupedTrip[grpTripId.key] {
                        grouped.append(grpTrip)
                    }
                    
//                    if let grpTrip = tripArray.first(where: { $0.group_id == grpTripId.key } ) {
//
//                        grouped.append(grpTrip)
//
//                    }
                    
                }
                
//                if let grpTripId = groupIds.first(where: { $0.value == unique } ) {
//
//                    if let grpTrip = tripArray.first(where: { $0.group_id == grpTripId.key } ) {
//
//                        grouped.append(grpTrip)
//
//                    }
//
//                }
                
            }
            
            print(_tripIds)
            
            
        }
        
        if unGrouped.trips.count > 0 {
            filterArray.append(unGrouped)
        }
        
        if grouped.count > 0 {
            filterArray.append(contentsOf: grouped)
        }
        
    }
    
}
