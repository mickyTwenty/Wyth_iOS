//
//  CreateTripEntity.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/29/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class CreateTripEntity: NSObject {
    
    var objectIdentifier : String!
    var sectionTitle : String!
    var rowsArray : [PostTrip]! = []
}

final class CreateTripDetails {
    
    private init() { }
    static let shared = CreateTripDetails()
    var postArray : [CreateTripEntity] = []
    var searchArray : [PostTrip]! = []
    
    func clear(){
        postArray = []
        searchArray = []
    }

}
