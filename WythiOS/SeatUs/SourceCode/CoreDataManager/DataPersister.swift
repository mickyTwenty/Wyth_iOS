//
//  DataPersister.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 11/11/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class DataPersister: PersistantBaseController {
    
    //MARK: - Singelton Instance
    static var sharedInstance = DataPersister()
    
    //MARK: - Private Instance
    private override init() {
        super.init()
        self.context = self.managedObjectContext
        self.model = self.managedObjectModel
        self.persistant = self.persistentStoreCoordinator
    }
    
    
    // MARK: - Entity Friends
    func getAllConnectedFriends(addingFreinds:AddingFreinds, isManuallyAdded: Bool = false)->[FriendsConnected]{
        
        let request: NSFetchRequest<FriendsConnected> = FriendsConnected.fetchRequest()

        switch (addingFreinds){
            
        case .isComingForDriverPassengerBoth:
            break
            
        case .isComingForDriverOnly:
            let name = "driver"
            request.predicate = NSPredicate(format: "role_id = %@", name)
            break
            
        default:
            break
            
        }
        
        if !isManuallyAdded {
            let predicate = NSPredicate(format: "manually_add == %@", NSNumber(booleanLiteral: false))
            request.predicate = predicate
        }
        let freindsObject =  fetchRequest(request: request as! NSFetchRequest<NSFetchRequestResult>)
        return freindsObject as! [FriendsConnected]
    }
    
    func getAllRecentlySelectedFriends()->[FriendsConnected]{
     
        let request: NSFetchRequest<FriendsConnected> = FriendsConnected.fetchRequest()
        let predicate = NSPredicate(format: CoreDataConstants.FriendsSearchCount + " > %d", 0)
        request.predicate = predicate
        request.fetchLimit = CoreDataConstants.FriendsFetchLimit
        request.sortDescriptors = [NSSortDescriptor(key: CoreDataConstants.FriendsSearchCount, ascending: false)]
        let freindsObject =  fetchRequest(request: request as! NSFetchRequest<NSFetchRequestResult>)
        return freindsObject as! [FriendsConnected]
        
    }
    
    func saveFriends(friend:[Friend], isManuallyAdded: Bool = false)->(Bool){
        
        var status : Bool = true

        for i in 0..<friend.count{
            
            let object = friend[i]
            
            if isManuallyAdded {
                let entityManagedObject = getEntityManagedObject(name: FriendsConnected.nameOfClass())
                entityManagedObject.setValue(object.first_name, forKey: "first_name")
                entityManagedObject.setValue(object.last_name, forKey: "last_name")
                entityManagedObject.setValue(object.email, forKey: "email")
                entityManagedObject.setValue(object.phone, forKey: "phone")
                entityManagedObject.setValue(isManuallyAdded, forKey: "manually_add")
                entityManagedObject.setValue("", forKey: "profile_picture")
                status = saveToContext()
            }
            else if !checkIfRecordExist(entityName: FriendsConnected.nameOfClass(), key: "user_id", value: (object.user_id?.stringValue)!)
            {
                let entityManagedObject = getEntityManagedObject(name: FriendsConnected.nameOfClass())
                entityManagedObject.setValue(object.first_name, forKey: "first_name")
                entityManagedObject.setValue(object.last_name, forKey: "last_name")
                entityManagedObject.setValue((object.user_id?.stringValue)!, forKey: "user_id")
                entityManagedObject.setValue(object.is_blocked, forKey: "is_blocked")
                entityManagedObject.setValue(object.is_self, forKey: "is_self")
                entityManagedObject.setValue(object.profile_picture, forKey: "profile_picture")
                entityManagedObject.setValue(object.role_id, forKey: "role_id")
                entityManagedObject.setValue(object.email, forKey: "email")
                entityManagedObject.setValue(object.phone, forKey: "phone")
                entityManagedObject.setValue(isManuallyAdded, forKey: "manually_add")
                status = saveToContext()
            }
        }

        return status
    }
    
    func deleteAllFriends(){
        
        let friendsObject = getAllConnectedFriends(addingFreinds: .isComingForDriverPassengerBoth)
        
        for (_,value) in friendsObject.enumerated(){
            deleteRecord(object: value)
        }
    }
    
    
    
    // MARK: - Entity PostTrip
    func saveTrip(trip:PostTrip)->(Bool){
        
        var entityManagedObject : PostTripInfo?
        entityManagedObject = getTripInfo()
        if entityManagedObject == nil {
            entityManagedObject = getEntityManagedObject(name: PostTripInfo.nameOfClass()) as? PostTripInfo
        }
        
        return updateOrCreateTrip(info: entityManagedObject!, withDetails: trip)
    }
    
    func getTripInfo()->(PostTripInfo?){
        
        var entityManagedObject : PostTripInfo? = nil
        let request: NSFetchRequest<PostTripInfo> = PostTripInfo.fetchRequest()
        let postTripObject =  fetchRequest(request: request as! NSFetchRequest<NSFetchRequestResult>)
        if postTripObject.count > 0 {
            entityManagedObject = postTripObject[0] as? PostTripInfo
        }
        return entityManagedObject
    }
    
    class func getOriginCoordinates()->(String? ){
        
        let trip = DataPersister.sharedInstance.getTripInfo()
        
        var coordinatesPoints = ""
        if let coordinates = trip?.originCoordinates{
            coordinatesPoints = coordinates
        }
        return coordinatesPoints

    }
    
    class func getDestinationCoordinates()->(String? ){
        
        let trip = DataPersister.sharedInstance.getTripInfo()
        
        var coordinatesPoints = ""
        if let coordinates = trip?.destinationCoordinates{
            coordinatesPoints = coordinates
        }
        return coordinatesPoints
        
    }
    
    class func getTripInfo(forKey:String)->(Any){
        
        let trip = DataPersister.sharedInstance.getTripInfo()
        var value :Any?
        if let getter = trip?.value(forKey: forKey){
            value = getter
        }
        return value as Any
    }
    
    
    
    

    func updateOrCreateTrip(info: PostTripInfo,withDetails:PostTrip)->(Bool){
        
        switch (withDetails.title){
            
        case PlistPlaceHolderConstant.genderPlaceHolder?:
            info.gender = withDetails.placeholdertext
            break
            
        case PlistPlaceHolderConstant.PostTripName?:
            info.trip_name = withDetails.placeholdertext
            break
        
        case PlistPlaceHolderConstant.PostTripOrigin?:
            info.origin = withDetails.placeholdertext
            info.originCoordinates = withDetails.address
            break
            
        case PlistPlaceHolderConstant.PostTripDestination?:
            info.destination = withDetails.placeholdertext
            info.destinationCoordinates = withDetails.address
            break

        case PlistPlaceHolderConstant.PostTripTimeOfDay?:
            
            var refrenceValue = 0
            for (_,value) in withDetails.checkboxes.enumerated(){
                
                let object = value as [String:Any]
                let isSelected = object["isselected"] as! NSNumber
                if isSelected.boolValue{
                    let refValue = Int(object["refrencevalue"] as! String)
                    refrenceValue = refrenceValue + refValue!
                }
            }
            info.timeOfDay = "\(refrenceValue)"

            break
            
        case PlistPlaceHolderConstant.PostTripEstimates?:
            info.estimate = withDetails.placeholdertext
            break
            
        case PlistPlaceHolderConstant.PostTripReturnDate?:
            info.returnDate = withDetails.placeholdertext
            break
            
        case PlistPlaceHolderConstant.FindRidesEstimates:
            info.estimate = withDetails.placeholdertext
            break

        case PlistPlaceHolderConstant.PostTripDate?:
            info.date = withDetails.placeholdertext
            break

        case PlistPlaceHolderConstant.PostTripBookNow?:
            info.bookNow = Bool(truncating: withDetails.isselected)
            break

            
        case PlistPlaceHolderConstant.PostTripSeats?:
            info.seats = withDetails.placeholdertext
            break
            
        case PlistPlaceHolderConstant.PostTripRoundTrip?:
            info.roundTrip = Bool(truncating: withDetails.isselected)
            break
            
        case PlistPlaceHolderConstant.FindRidesRating?:
            info.rating = withDetails.placeholdertext.replacingOccurrences(of: "+", with: "")
            break

        default: break
        }
        
        return saveToContext()
    }

    //MARK: - CoreData Methods
    func saveToContext()->(Bool){
        
        var isSaved:Bool = true
        do {
            try context.save()
        } catch let error as NSError {
            isSaved = false
            print("Could not save. \(error), \(error.userInfo)")
        }
        return isSaved
    }
    
    func deleteRecord(object:NSManagedObject){
        context.delete(object)
    }
    
    func getEntityManagedObject(name:String)->(NSManagedObject){
        
        let entity =
            NSEntityDescription.entity(forEntityName: name,
                                       in: context)!
    
        let entityContext = NSManagedObject(entity: entity,
                                     insertInto: context)
        
        return entityContext
    }
    
    func fetchRequest(request:NSFetchRequest<NSFetchRequestResult>)->[NSManagedObject]{
        var objects : [NSManagedObject] = []
        request.returnsObjectsAsFaults = false
        do {
            objects = try context.fetch(request) as! [NSManagedObject]
            
        } catch {
            print("Failed on fetchRequest[DataPersister:Class]")
        }
        return objects
    }
    
    func checkIfRecordExist(entityName:String,key:String,value:String)->(Bool){
        
        var isRecordExist : Bool = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "%K == %@",key,value )

        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let count = try context.count(for: request)

            if(count == 0){
                // no matching object
                isRecordExist = false
            }
            else{
                // at least one matching object exists
                isRecordExist = true
            }
        }
            
        catch let error as NSError {
            isRecordExist = false
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return isRecordExist
    }
}
