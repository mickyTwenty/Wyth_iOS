//
//  ContactsUtility.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/25/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import ContactsUI
import UIKit


class ContactsUtility{
    
    class func applyForContactsPermission(completionHandler: @escaping (String?, Bool?) -> ()){
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus{
            
        case .denied:
            print("denied")
            print("/*! The user explicitly denied access to contact data for the application. */")
            showDeniedContactAlert()
            completionHandler(nil,false)
            break
            
        case .authorized:
            print("authorized")
            askForPermission(completionHandler: { (numbers, status) in
                completionHandler(numbers,status)
            })
            break
            
        case .notDetermined:
            print("notDetermined")
            askForPermission(completionHandler: { (numbers, status) in
                completionHandler(numbers,status)
            })
            break
            
        case .restricted:
            completionHandler(nil,false)
            print("/*! The application is not authorized to access contact data.The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place. */")
            break
        }
    }
    
    class func askForPermission(completionHandler: @escaping (String?, Bool?) -> ()){
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (isGranted, error) in
            if isGranted{
                print(error?.localizedDescription as Any)

                print("isGranted")
                completionHandler(nil,true)

//                retrieveContactsWithStore(store: store, completionHandler: { (numbers, status) in
//                    completionHandler(numbers,status)
//                })
            }
            else{
                print(error?.localizedDescription as Any)
                completionHandler(nil,false)
            }
        }
    }

    class func retrieveContactsWithStore(completionHandler: @escaping (String?, Bool?) -> ()) {
        
//        let storeObj = CNContactStore()

        var numbersString: String = ""
        let req = CNContactFetchRequest(keysToFetch: [
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            ])
        try! CNContactStore().enumerateContacts(with: req) {
            contact, stop in
            for phoneNumber in contact.phoneNumbers{
        
                let structPhoneNumber: CNPhoneNumber = phoneNumber.value
                let numberString = structPhoneNumber.stringValue
                numbersString = numbersString + "-,-" + numberString
            }
        }
        // save numbers to post on server
        User.sharedInstance.contactNumbersToSubmit = numbersString
        completionHandler(numbersString,true)
    }
    
    class func showDeniedContactAlert(){
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
            }
        }
    }
}
