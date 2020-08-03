//
//  ItineraryDetailsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 29/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ItineraryDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cellName = ItineraryDetailsCell.nameOfClass()
    var contentArray : [FriendsConnected]! = []
    var trip: Trip?
    var sharedItinerary : [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        if let itinerary_shared = trip?.itinerary_shared {
            sharedItinerary = itinerary_shared
            showSharedItineraryDetails()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCell(){
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        tableView.tableFooterView = UIView()
    }
    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func searchFriendsButtomClicked(_ sender: Any) {
        
        let delegate: FriendsSearchViewControllerDelegate = self
        
        pushViewController(controllerIdentifier: FriendsSearchViewController.nameOfClass(), navigationTitle: "", conditons: [ "delegate":delegate, "isManuallyAdded":true ])
        
    }
    
    @IBAction func searchRecentlySelectedFriendsButtonClicked(_ sender: Any) {
        
        var friends = DataPersister.sharedInstance.getAllRecentlySelectedFriends()
         friends = friends.sorted(by: { ($0.search_count!.intValue ) > ($1.search_count!.intValue) } )
        
        if friends.count > 0 {
            let cont = ModalAlertBaseViewController.createAlertController(storyboardId: MostSearchViewController.nameOfClass())
            cont.contentArray = friends
            cont.show(controller: self)
            cont.selectButtonTapped = { friend in
                self.updateFriends(friend: friend as! FriendsConnected)
            }
        }
        else{
                Utility.showAlertwithOkButton(message: ValidationMessages.ShareItenaryValidation   , controller: self)
        }
    }
    
    func addFriendInDataPersister(friend: Friend){
        
        if DataPersister.sharedInstance.saveFriends(friend: [friend], isManuallyAdded: true) {
            
            addManuallyFriend(friend: friend)
            
        }
        
    }
    
    func addManuallyFriend(friend: Friend){
        
        var friends = DataPersister.sharedInstance.getAllConnectedFriends(addingFreinds: .isComingForDriverPassengerBoth, isManuallyAdded: true)
        
        let friendConnected = friends.filter({ $0.email == friend.email || $0.phone == friend.phone }).first
        
        if friendConnected == nil {
            
            addFriendInDataPersister(friend: friend)
            
        }
        else {
            
            updateFriends(friend: friendConnected!)
            
        }
        
    }
    
    func updateFriends(friend: FriendsConnected){
        contentArray = contentArray.filter { $0.email != friend.email }
        var search_count = friend.search_count?.intValue ?? 0
        search_count += 1
        friend.search_count = NSNumber.init(integerLiteral: search_count)
        contentArray.append(friend)
        DataPersister.sharedInstance.saveToContext()
        updateTableView()
    }
    
    func showSharedItineraryDetails(){
        let shareDetails = Friend.getFriendsArray(friendsArray: sharedItinerary)
        let saveFriends = DataPersister.sharedInstance.getAllConnectedFriends(addingFreinds: .isComingForDriverPassengerBoth, isManuallyAdded: true)
        contentArray = saveFriends.filter( {  shareDetails.compactMap({$0.email}).contains($0.email)  } )
        updateTableView()
    }
    
    @IBAction func onOkButtonClicked(_ sender: UIButton) {
        
        let shareDetails = Friend.getFriendsArray(friendsArray: sharedItinerary)
        contentArray = contentArray.filter( {  !shareDetails.compactMap({$0.email}).contains($0.email)  } )
        
        var friendArray: [[String:String]] = []
        
        for friend in contentArray {
            
            friendArray.append( [ "first_name":friend.first_name ?? "", "last_name":friend.last_name  ?? "", "email":friend.email  ?? "" ,"mobile":friend.phone  ?? "" ] )
            
            
        }
        
        let json = Utility.convertArrayToJson(array: friendArray as [NSDictionary])
        
        let shareItenerary = [ "trip_id":trip?.trip_id?.stringValue ?? "" ,
                           "invitee":json ] as [String : Any]
        
        Trip.shareIteneraryTrip(object: shareItenerary)
            { (object, message, active, status) in
                
                if status! {
                    
                    self.performSegue(withIdentifier: "unwindFromItineraryDetailsVC", sender: self)
                    
             //       self.navigationController?.popViewController(animated: true)
                    
                }
                else{
                    Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                }
                
        }

    }
    
    @IBAction func onAddFriendButtonClicked(_ sender: Any) {
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: AddFriendModalController.nameOfClass())
        cont.show(controller: self)
        cont.selectButtonTapped = { friend in
            self.addManuallyFriend(friend: friend as! Friend)
        }
    }
}

extension ItineraryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            contentArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ItineraryDetailsCell
        
        let friend = Friend()
        let friendObj = contentArray[indexPath.row]
        friend.full_name = friendObj.first_name! + " " + friendObj.last_name!
        friend.phone = friendObj.phone
        friend.email = friendObj.email
        cell.setDetails(OfFriend: friend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
}

extension ItineraryDetailsViewController: FriendsSearchViewControllerDelegate {
    func addFriend(friend: FriendsConnected) {
        self.updateFriends(friend: friend)
    }
}
