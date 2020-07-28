//
//  Passenger.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 11/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class Passenger: NSObject {

    @objc var first_name: String?
    @objc var last_name: String?
    @objc var user_id: NSNumber?
    @objc var profile_picture: String?
    @objc var promo_code: String?
    @objc var proposed_amount: String?
    @objc var fare: NSNumber?
    @objc var gender: String?
    var isDriver: Bool? = false

    @objc var rating: NSNumber?
    @objc var is_confirmed: NSNumber?
    @objc var time_range: NSNumber?
    @objc var has_payment_made: NSNumber?
    @objc var bags_quantity : NSNumber?
    @objc var has_accepted: NSNumber?
    @objc var dropoff_latitude: String?
    @objc var dropoff_longitude: String?
    @objc var pickup_latitude: String?
    @objc var pickup_longitude: String?
    @objc var trips_canceled : NSNumber?
    @objc var is_picked : NSNumber?
    @objc var is_dropped : NSNumber?
    @objc var pickup_title : String?
    @objc var dropoff_title : String?

    
    
    class func getPassengersToPickUp(passengers:[Passenger]) ->[Passenger]?{
        
        var passengerToPickUp:[Passenger]? = []
        passengerToPickUp  = passengers.filter({($0.is_picked)! == NSNumber(booleanLiteral: false)})
        return passengerToPickUp
    }
    
    
    class func getPassengersToDropOff(passengers:[Passenger]) ->[Passenger]?{
        
        var passengerToPickUp:[Passenger]? = []
        passengerToPickUp  = passengers.filter({($0.is_picked)! == NSNumber(booleanLiteral: true) && (($0.is_dropped)! == NSNumber(booleanLiteral: false))})
        return passengerToPickUp
    }
    
    class func isAnySeatBooked(passengers:[Passenger])->(Bool){
        var isBooked : Bool = false
        for (_,object) in passengers.enumerated(){
            if ((object.is_confirmed?.boolValue)! && (object.has_payment_made?.boolValue)!){
                isBooked = true
                break
            }
        }
        return isBooked
    }
    
    class func getAvailableSeats(passengers:[Passenger])->(Int){
        var noOfBookedSeats : Int = 0
        for (_,object) in passengers.enumerated(){
            if ((object.is_confirmed?.boolValue)! && (object.has_payment_made?.boolValue)!){
                noOfBookedSeats = noOfBookedSeats + 1
            }
        }
        return noOfBookedSeats
    }
    
    class func isPassengerDropped(passengers:[Passenger])->Bool{
        
        let userID = NSNumber(integerLiteral: Int(User.getUserID()!)!)
        var isDroppped:Bool = false
        for (_,object) in passengers.enumerated(){
            
            if object.user_id == userID {
                
                if ((object.is_dropped)!).boolValue{
                    isDroppped = true
                    break
                }
            }
        }
        return isDroppped
    }
    
    class func getTotalBags(passengers:[Passenger])->(String){
        var totalBags : Int = 0
        
        for (_,object) in passengers.enumerated(){
            totalBags += (object.bags_quantity?.intValue)!
        }
        return String(totalBags)
    }
}
