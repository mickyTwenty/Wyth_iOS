//
//  PersistantBaseController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 11/12/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class PersistantBaseController: NSObject {

    
    let moduleName = "SeatUs"
    var context     : NSManagedObjectContext!
    var model       : NSManagedObjectModel!
    var persistant  : NSPersistentStoreCoordinator!

    // The managed object model for the application. This property is not optional.
    // It is a fatal error for the application not to be able to find and load its model.
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // The directory the application uses to store the Core Data store file.
    // This code uses a directory named "com.supercarehealth.Video_Library" in
    // the application's documents Application Support directory.
    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    // The persistent store coordinator for the application.
    // This implementation creates and returns a coordinator, having added the store for the application to it.
    // This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistentStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            //* Replace this with code to handle the error appropriately.
            //* abort() causes the application to generate a crash log and terminate.
            //* We should not use this function in a shipping application,
            //* although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            //* If you encounter schema incompatibility errors during development,
            //* we can reduce their frequency by:
            //* Simply deleting the existing store:
            do {
                try FileManager.default.removeItem(at: persistentStoreURL)
            } catch {
                NSLog("Unresolved error \(error)")
            }
            fatalError("Persistent store error! \(error)")
        }
        return coordinator
    }()
    
    // Returns the managed object context for the application
    // (which is already bound to the persistent store coordinator for the application.)
    // This property is optional since there are legitimate error conditions that
    // could cause the creation of the context to fail.
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    
    var TimeStamp: TimeInterval {
        // return NSDate().timeIntervalSince1970
        return Foundation.Date.timeIntervalSinceReferenceDate
    }
    
}
