//
//  FireBaseManager.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/15/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import MBProgressHUD



class FireBaseManager: NSObject {

    static var sharedInstance = FireBaseManager()
    var fireStore : Firestore!
    //var hudView : MBProgressHUD!
    var alertWindow : UIWindow!


    private override init() {
        //self.hudView = MBProgressHUD()
        self.fireStore = Firestore.firestore()
    }
    
    func addFriendToFireBase(friend:FriendsConnected,friendType:AddingFreinds = AddingFreinds.isComingForDriverPassengerBoth ,completionHandler: @escaping (Error?) -> ()){
    
        self.setLastInvitedTimeFromFireBase()
        
       showHud(message: "")
       let refrenceDoc =  fireStore.collection(FireBaseConstant.usersCollection).document(friend.user_id!)
        
        let friendDic : [String:Any] = ["user_id":friend.user_id as Any, "profile_picture":friend.profile_picture as Any, "first_name":friend.first_name as Any,"last_name":friend.last_name as Any,"ref":refrenceDoc]
        
        switch (friendType){
            
        case AddingFreinds.isComingForDriverOnly:
            
            
            fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).setData([
                FireBaseConstant.driverNode:friendDic], options: SetOptions.merge()) { err in
                    
                    self.hideHud()

                    if let err = err {
                        print("Error updating document: \(err)")
                        self.showAlertController(message: (err.localizedDescription))

                        
                    } else {
                        completionHandler(err)
                        print("Document successfully updated")
                    }
            }
            break
            
        default:
            
            fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection).document(friend.user_id!).setData(friendDic, options: SetOptions.merge()) { (error) in
                
                self.hideHud()
                completionHandler(error)
            }

            break
        }
        
//        self.setLastInvitedTimeFromFireBase()

    }
    
    func addListenerToInvitedMembersCollection(completionHandler: @escaping ([Friend]?) -> ())->(ListenerRegistration){
            
       let listener = fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection).addSnapshotListener { documentSnapshot, error in
            guard documentSnapshot != nil else {
                    print("Error fetching document: \(error!)")
                    return
                }
            
            var friendsArr:[Friend]! = []

            for (_,value ) in (documentSnapshot?.documents.enumerated())!{
                
                if value.data().count > 0{
                    var friend = Friend()
                    friend = DynamicParser.setValuesOnClass(object: value.data(), classObj: friend) as! Friend
                    friendsArr.append(friend)
                }
            }
            completionHandler(friendsArr)

        }
        
        return listener
    }
    
    
    func addListenerToChatCollection(trip:Trip,completionHandler: @escaping ([Chat]?) -> ())->(ListenerRegistration){
        
        let listener = fireStore.collection(FireBaseConstant.offersCollection).document((trip.trip_id?.stringValue)!).collection(FireBaseConstant.chatCollection).order(by: "timestamp").addSnapshotListener { documentSnapshot, error in
            guard documentSnapshot != nil else {
                print("Error fetching document: \(error!)")
                return
            }
            
            var chatArr:[Chat]! = []
            
            for (_,value ) in (documentSnapshot?.documents.enumerated())!{
                
                if value.data().count > 0{
                    print(value.data())
                    var chat = Chat()
                    chat = DynamicParser.setValuesOnClass(object: value.data(), classObj: chat) as! Chat
                
                    if (chat.user_id?.compare(User.getUserID()!) == ComparisonResult.orderedSame){
                        chat.cellIdentifier = SenderCell.nameOfClass()
                    }
                    else{
                        chat.cellIdentifier = ReceiverCell.nameOfClass()
                    }
                    chatArr.append(chat)
                }
            }
            completionHandler(chatArr)
        }
        return listener
    }

    
    func addListenerOffersCollection(trip:Trip,completionHandler: @escaping ([OffersModel]?) -> ())->(ListenerRegistration){
        
        let listener = fireStore.collection(FireBaseConstant.offersCollection).document((trip.trip_id?.stringValue)!).collection(Trip.getOffersCollectionName(trip: trip)).order(by: "timestamp").addSnapshotListener { documentSnapshot, error in
            guard documentSnapshot != nil else {
                print("Error fetching document: \(error!)")
                return
            }
            
            var offersArr:[OffersModel]! = []
            for (_,value ) in (documentSnapshot?.documents.enumerated())!{
                
                if value.data().count > 0{
                    let offers = OffersModel.parseOffersObject(object: value.data())
                    if Utility.isDriver(){
                        if offers.sender?.compare(FireBaseConstant.senderPassenger) == .orderedSame{
                            offers.cell_identifier = AcceptOfferRecieverCell.nameOfClass()
                        }
                        else{
                            offers.cell_identifier = SenderCell.nameOfClass()
                        }
                    }
                    else{
                        if offers.sender?.compare(FireBaseConstant.senderPassenger) == .orderedSame{
                            offers.cell_identifier = SenderCell.nameOfClass()
                        }
                        else{
                            offers.cell_identifier = AcceptOfferRecieverCell.nameOfClass()
                        }
                    }
                    
                    
                    offersArr.append(offers)
                }
            }
            completionHandler(offersArr)
        }
        return listener
    }
    
    func addListenerToChatCount(completionHandler: @escaping ([String:Any]) -> ())->(ListenerRegistration){
        
        let listener = fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).addSnapshotListener { documentSnapshot, error in
            guard documentSnapshot != nil else {
                print("Error fetching document: \(error!)")
                return
            }
            
            if !(documentSnapshot?.exists)! {
                return
            }
            
            let userObject : [String: Any] = (documentSnapshot?.data())!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ApplicationConstants.DriverUpdatedNotification), object: nil, userInfo: userObject)

            completionHandler(userObject)
        }
        
        return listener
    }
    
    func resetChatCount(){
        
        var chatCountObject: [String:Any] = [:]
        chatCountObject[FireBaseConstant.unreadChatCount] = NSNumber(integerLiteral: 0)
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).updateData(chatCountObject) { (error) in
        }
    }

    func resetNotifCount(){
        
        var chatCountObject: [String:Any] = [:]
        chatCountObject[FireBaseConstant.unreadNotificationCount] = NSNumber(integerLiteral: 0)
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).updateData(chatCountObject) { (error) in
        }
    }

    
    func addMessageToChatCollection(trip:Trip,param:[String:Any]){
        
        var object = param
        object[FireBaseConstant.chatMessageTimeStamp] = FieldValue.serverTimestamp()
    
        var ref: DocumentReference? = nil
      ref =  fireStore.collection(FireBaseConstant.offersCollection).document((trip.trip_id?.stringValue)!).collection(FireBaseConstant.chatCollection).addDocument(data: object) { (error) in
            
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func setLastInvitedTimeFromFireBase(){
        
        let dateString = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDate) as? String
        let date = Utility.getDateFromString(sourceDate:dateString! , inputDateFormat: ApplicationConstants.DateFormatClient, outputDateFormat: ApplicationConstants.DateFormatClient)
        
        let timeOfDay = "7"
//            Utility.convertStringToNumber(value: DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoTimeOfDay) as! String)
        
//        let dict = [FireBaseConstant.searchDataOriginText:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin),FireBaseConstant.searchDataOriginGeo:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates),FireBaseConstant.searchDataDestinationText:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination),FireBaseConstant.searchDataDestinationGeo:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates),FireBaseConstant.searchDataTimezone:Utility.convertStringToNumber(value: DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoTimeOfDay) as! String),FireBaseConstant.searchDataDate:date,FireBaseConstant.userID:User.getUserID()!,FireBaseConstant.inviterName:User.getUserName() as Any]
        
//        let isRoundTrip = ,FireBaseConstant.isRoundTrip: String(describing: (DataPersister.getTripInfo(forKey: "roundTrip") as? Bool)) ?? "false"
        
        let dict = [FireBaseConstant.searchDataOriginText:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin),FireBaseConstant.searchDataOriginGeo:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates),FireBaseConstant.searchDataDestinationText:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination),FireBaseConstant.searchDataDestinationGeo:DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOriginCoordinates),FireBaseConstant.searchDataDate:date,FireBaseConstant.userID:User.getUserID()!,FireBaseConstant.inviterName:User.getUserName() as Any,FireBaseConstant.searchDataTimezone:timeOfDay,FireBaseConstant.isRoundTrip:"\((DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoRoundTrip) as? Bool) ?? false)" ]
        
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).setData([
            FireBaseConstant.invitedMemberTimeStamp: FieldValue.serverTimestamp(),FireBaseConstant.tripSearchData:dict,FireBaseConstant.inviteType:Manager.sharedInstance.inviteType], options: SetOptions.merge()) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
    }
    
    
    func deleteFreindInvites(){
        deleteDriverPassengerData { (status) in
        }
    }
    
    func addListenerLocationCollection(completionHandler: @escaping (String,String) -> ())->(ListenerRegistration){
        
        let trip = Manager.sharedInstance.currentTripInfo

        let listener = fireStore.collection(FireBaseConstant.LocationCollection).document((trip?.trip_id?.stringValue)!).addSnapshotListener { documentSnapshot, error in
            guard documentSnapshot != nil else {
                print("Error fetching document: \(error!)")
                return
            }
            
            if !(documentSnapshot?.exists)! {
                return
            }
            
            if let locationObject = (documentSnapshot?.data()) {
                if let coordinate = locationObject[FireBaseConstant.Coordinates] as? String {
                    let lat = coordinate.components(separatedBy: ",")[0]
                    let lon = coordinate.components(separatedBy: ",")[1]
                    completionHandler(lat,lon)
                }
            }
        }
        return listener
    }
    
    func deleteCollection(completionHandler: @escaping (Bool?) -> ()){
       
        showHud(message: "")
        let collectionRefrence = fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection)
        delete(collection: collectionRefrence) { (error) in
            self.hideHud()
            if (error != nil){
                print(error?.localizedDescription as Any)
                completionHandler(false)
            }
            else{
                print("Collection Deleted")
                completionHandler(true)

            }
        }
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).updateData([FireBaseConstant.invitedMemberTimeStamp : FieldValue.delete(),FireBaseConstant.inviteType:FieldValue.delete(),FireBaseConstant.tripSearchData:FieldValue.delete()]) { (error) in
            
            if let error = error {
                print("Error Deleting document Field: \(error)")
            } else {
                print("Deleting document Field completed")
            }
        }
    }
    
    func deleteDriverData(completionHandler: @escaping (Bool?) -> ()){
        
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).updateData([FireBaseConstant.driverNode:FieldValue.delete()]) { (error) in
            if (error != nil){
                print(error?.localizedDescription as Any)
                completionHandler(false)
            }
            else{
                print("Collection Deleted")
                completionHandler(true)
            }
        }
    }
    
    func deleteDriverPassengerData(completionHandler: @escaping (Bool?) -> ()){
        
        
        let collectionRefrence = fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection)
        delete(collection: collectionRefrence) { (error) in
            self.hideHud()
            if (error != nil){
                print(error?.localizedDescription as Any)
            }
            else{
                print("deleteDriverPassengerData Collection Deleted")
                completionHandler(true)
            }
        }
                
                
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).updateData([FireBaseConstant.invitedMemberTimeStamp : FieldValue.delete(),FireBaseConstant.inviteType:FieldValue.delete(),FireBaseConstant.tripSearchData:FieldValue.delete(),FireBaseConstant.driverNode:FieldValue.delete()]) { (error) in
            
            if let error = error {
                print("Error Deleting document Field: \(error)")
            } else {
                print("Deleting document Field completed")
            }
        }
    }

    
    func deleteSelectedMember(object:Friend,completionHandler: @escaping (Bool?) -> ()){
        
        showHud(message: "")
        let friendUserId = String(describing: object.user_id!)
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection).document(friendUserId).delete() { err in

            self.hideHud()
            if let err = err {
                print("Error removing freind: \(err)")
                completionHandler(false)
            } else {
                completionHandler(true)
                print("Invitation successfully removed!")
            }
        }
    }
    
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            guard let docset = docset else {
                completion(error)
                return
            }
            // There's nothing to delete.
            guard docset.count > 0 else {
                completion(nil)
                return
            }
            
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    // Stop the deletion process and handle the error. Some elements
                    // may have been deleted.
                    completion(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
    
    func getLastUpdatedTime(isForDriver:Bool = false, completionHandler: @escaping (InvitedFriendTimeStatus?) -> ()){
        
        showHud(message: "")

        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).getDocument { (docSnapShoot, error) in
            self.hideHud()

            if !(error != nil) {
                
                guard docSnapShoot != nil else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let details = docSnapShoot?.data()
                let date = details![FireBaseConstant.invitedMemberTimeStamp] as? Date
                let inviteType = details![FireBaseConstant.inviteType] as? String
                let driverObject = details![FireBaseConstant.driverNode] as? [String:Any]
                
                if !isForDriver {
                    
                    if (date == nil){
                        completionHandler(InvitedFriendTimeStatus.InviteNotExist)
                    }
                    else{
                        let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date!)
                        completionHandler(self.getInviteStatus(status: status, inviteType: inviteType!, OnDate: date!))
                    }
                }
                else{
                    
                    if driverObject == nil {
                        completionHandler(InvitedFriendTimeStatus.InviteNotExist)
                    }
                    else{
                        let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date!)
                        completionHandler(self.getInviteStatus(status: status, inviteType: inviteType!, OnDate: date!))
                    }
                }
            }
            else {
                self.showAlertController(message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    func getLastUpdatedTimeForBothDriverPaseenger(completionHandler: @escaping (InvitedFriendTimeStatus?,String?,Int?,Int? ) -> ()){
        
        showHud(message: "")
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).getDocument { (docSnapShoot, error) in
            self.hideHud()

            if !(error != nil){
                let details = docSnapShoot?.data()
                let date = details![FireBaseConstant.invitedMemberTimeStamp] as? Date
                let driverObject = details![FireBaseConstant.driverNode] as? [String:Any]
                
                // if date is nil : None of the invites exist on FB
                if (date == nil){
                    completionHandler(InvitedFriendTimeStatus.InviteNotExist,nil,0, nil)
                }
                else{
                    // if invite exist check for its expiration
                    let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date!)
                    if status{
                        // Invite do exist but expired
                        completionHandler(InvitedFriendTimeStatus.InvitExpires,nil,0,nil)
                        
                    }
                    else{
                        // Invites are not expired
                        //Check for driver
                        if driverObject == nil {
                            // Driver not exist
                            completionHandler(InvitedFriendTimeStatus.InviteNotExpire,nil,0,nil)
                        }
                        else{
                            
                            let driveStatus = driverObject![FireBaseConstant.driverStatus] as? NSNumber
                            let driveID = driverObject![FireBaseConstant.driverID] as? String
                            let seat = driverObject!["seats"] as? NSNumber
                            var seatsReturns: Int?
                            if let seats_returning = driverObject!["seats_returning"] as? NSNumber {
                                seatsReturns = seats_returning.intValue
                            }

                            if (driveStatus != nil) || driveStatus?.intValue == 1 {
                            // driver is valid
                                completionHandler(InvitedFriendTimeStatus.InviteNotExpireAndDriverAccepted,driveID,seat?.intValue,seatsReturns)
                            }
                            else{
                                // driver not accpeted yet
                                completionHandler(InvitedFriendTimeStatus.InviteNotExpireButDriverPending,ApplicationConstants.InviteNotAcceptedMessage,0,seatsReturns)

                            }
                        }
                    }
                }
            }
            else{
                self.showAlertController(message: (error?.localizedDescription)!)
            }
        }
    }
    func getInviteStatus(status:Bool, inviteType:String, OnDate:Date)->(InvitedFriendTimeStatus){
        
        let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: OnDate)
        if (inviteType.compare(Manager.sharedInstance.inviteType) == ComparisonResult.orderedSame){
            
            if status{
                return (InvitedFriendTimeStatus.InvitExpires)
            }
            else {
                return (InvitedFriendTimeStatus.InviteNotExpire)
            }
        }
        else{
            return (InvitedFriendTimeStatus.InviteExistForDifferentType)
        }
    }
    
    func getInvityLastUpdatedTime(object:[String:Any],completionHandler: @escaping (InvitedFriendTimeStatus?,[String:Any]?) -> ()){
        
        showHud(message: "")
        
        let userID = object[FireBaseConstant.userID]
        
        fireStore.collection(FireBaseConstant.usersCollection).document(userID as! String).getDocument { (docSnapShoot, error) in
            
            self.hideHud()

            if !(error != nil){
                let details = docSnapShoot?.data()
                let date = details![FireBaseConstant.invitedMemberTimeStamp] as? Date
                
                if (date == nil){
                    completionHandler(InvitedFriendTimeStatus.InviteNotExist,details)
                }
                else{
                    let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date!)
                    if status{
                        completionHandler(InvitedFriendTimeStatus.InvitExpires,details)
                    }
                    else {
                        completionHandler(InvitedFriendTimeStatus.InviteNotExpire,details)
                    }
                }
            }
            else{
                self.showAlertController(message: (error?.localizedDescription)!)
            }
            
        }
    }

    
    func getInvitedMembersIds(completionHandler: @escaping (String) -> ()){
        
        showHud(message: "")

        var friendIds : String = ""
        fireStore.collection(FireBaseConstant.usersCollection).document(User.getUserID()!).collection(FireBaseConstant.invitedMembersCollection).getDocuments { (snapShot, error) in
            
            self.hideHud()

            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in snapShot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let status = document.data()["status"] as? NSNumber
                    if (status == nil || status?.intValue == 0){
                        friendIds = ApplicationConstants.InviteNotAcceptedMessage
                        break
                    }
                    
                    if status?.intValue == 1{
                        let currentFriendId = document.data()["user_id"] as! String
                        if (friendIds.isEmpty){
                            friendIds = currentFriendId
                        }
                        else{
                            friendIds = friendIds + "-,-" + currentFriendId
                        }

                    }
                }
                completionHandler(friendIds)
            }
        }
        
    }
    
    
    func updateInviteStatus(object:[String:Any],status:Int){
        
        let userID = object[FireBaseConstant.userID]
        fireStore.collection(FireBaseConstant.usersCollection).document(userID as! String).collection(FireBaseConstant.invitedMembersCollection).document(User.getUserID()!).updateData(["status":NSNumber(integerLiteral: status)]) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    
    func updateDriverInviteStatus(object:[String:Any],driverObject:[String:Any],status:Int,seats:Int = 0, returningSeats:Int = 0){
        
        let userID = object[FireBaseConstant.userID]
        var statusObject: [String:Any] = [:]

        statusObject["invited_driver.status"] = NSNumber(integerLiteral: status)

        if seats != 0 {
            statusObject["invited_driver.seats"] = NSNumber(integerLiteral: seats)
        }
        
        if returningSeats != 0 {
            statusObject["invited_driver.seats_returning"] = NSNumber(integerLiteral: returningSeats
            )
        }
        
        fireStore.collection(FireBaseConstant.usersCollection).document(userID as! String).updateData(statusObject) { (error) in
            
        }
    }
    
    func postLocation(coordinates:String){
        
        let trip = Manager.sharedInstance.currentTripInfo
        fireStore.collection(FireBaseConstant.LocationCollection).document((trip?.trip_id?.stringValue)!).setData([
            FireBaseConstant.Coordinates:coordinates], options: SetOptions.merge()) { err in
                
                if let err = err {
                    print("Error updating document: \(err)")
                    
                } else {
                    print("Location successfully updated")
                }
        }
    }
    
    func showHud(message:String){
        let window: UIView =  UIApplication.shared.keyWindow!

        DispatchQueue.global(qos: .background).async {
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                print("adding hud on Firbase")
//                self.hudView = MBProgressHUD.showAdded(to: window, animated: true)
                MBProgressHUD.showAdded(to: window, animated: true)
                

            }
        }

    }
    
    func hideHud(){
        
        let window: UIView =  UIApplication.shared.keyWindow!
        DispatchQueue.global(qos: .background).async {
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                print("removing hud on Firbase")
                MBProgressHUD.hide(for: window, animated: true)
                //MBProgressHUD.hideAllHUDs(for: window, animated: true)
            }
        }
    }
    //MARK:- Firebase - Messaging
    class func getFCMToken()->(String?){
        var token = ""
        if (Messaging.messaging().fcmToken != nil){
            token = Messaging.messaging().fcmToken!
        }
        else{
            token = "12345678901223"
        }
        return token
    }
    
    class func getUserChanel()->(String){
        return  FireBaseConstant.notificationChanelUser + User.getUserID()!

    }
    
    class func subscribeForTopic(){
        Messaging.messaging().subscribe(toTopic: FireBaseConstant.notificationChaneliOS)
        Messaging.messaging().subscribe(toTopic: getUserChanel())
    }
    
    class func unSubscribeForTopic(){
        Messaging.messaging().unsubscribe(fromTopic: FireBaseConstant.notificationChaneliOS)
        Messaging.messaging().unsubscribe(fromTopic: getUserChanel())
    }
    
    func showAlertController(message:String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            alert.dismiss(animated: true, completion: nil)
            self.alertWindow=nil
        })
        alert.addAction(okAction)
        
        self.alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        self.alertWindow.rootViewController = UIViewController()
        self.alertWindow.windowLevel = UIWindow.Level.alert + 1
        self.alertWindow.makeKeyAndVisible()
        self.alertWindow.rootViewController?.present(alert, animated: false, completion: nil)
    }



}


/*
 if (date == nil){
 completionHandler(InvitedFriendTimeStatus.InviteNotExist)
 }
 else{
 let status = Utility.isDiffrenceMoreThanInvitedReqTimeOut(toInvitedTime: date!)
 if (inviteType?.compare(Manager.sharedInstance.inviteType) == ComparisonResult.orderedSame){
 
 if status{
 completionHandler(InvitedFriendTimeStatus.InvitExpires)
 }
 else {
 completionHandler(InvitedFriendTimeStatus.InviteNotExpire)
 }
 }
 else{
 completionHandler(InvitedFriendTimeStatus.InviteExistForDifferentType)
 }
 }
 */

/*
 documentSnapshot?.documentChanges.forEach { diff in
 if (diff.type == .added) {
 print("Friend added: \(diff.document.data())")
 
 }
 if (diff.type == .modified) {
 print("Friend modified: \(diff.document.data())")
 }
 if (diff.type == .removed) {
 print("Friend removed: \(diff.document.data())")
 }
 }*/
