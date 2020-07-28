//
//  Manager.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/2/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation

class Manager:NSObject {
    
    var transitionState:TransitionState!
    var inviteType :  String! = ""
    var currentTripInfo : Trip!
    var driver : [String:Any]? = nil
    
    static var sharedInstance = Manager()
    private override init() {
        self.currentTripInfo = Trip()
    }


}
