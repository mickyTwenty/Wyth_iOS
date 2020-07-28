//
//  FriendsViewController.swift
//  Friends
//
//  Created by Syed Muhammad Muzzammil on 27/10/2017.
//  Copyright © 2017 Syed Muhammad Muzzammil. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendsTableView: UITableView!
    var friendsArr: [FriendsConnected?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self

        let freindsArray  = DataPersister.sharedInstance.getAllConnectedFriends(addingFreinds: .isComingForDriverPassengerBoth)
        
        if freindsArray.count == 0 {
            Utility.showContactSyncAlert(controller: weakSelf!)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        registerCellAndCustomizeTableView()
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: Notification.Name(ApplicationConstants.SyncedFriendNotification), object: nil)

    }

    @IBAction func syncedFriendsButtonClicked(sender:UIButton){
        proceedWithSyncing()
    }
    
    func registerCellAndCustomizeTableView(){
        
        friendsTableView.register(UINib(nibName: FriendsTableViewCell.nameOfClass(), bundle: nil), forCellReuseIdentifier: FriendsTableViewCell.nameOfClass())
        friendsTableView.separatorColor = UIColor.clear
    }
    
    @objc func getData(){
        
        reloadTableViewData()
        
        let dict: [String:AnyObject] = [ApplicationConstants.Token:User.getUserAccessToken() as AnyObject]
    
        Friend.getFriends(param: dict as [String : AnyObject]) { (object, message, action, status) in
            self.reloadTableViewData()
        }
    }

    func reloadTableViewData(){
        
        weak var weakSelf = self

        friendsArr = DataPersister.sharedInstance.getAllConnectedFriends(addingFreinds: .isComingForDriverPassengerBoth)
        
        self.friendsTableView.reloadData()
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self

    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableViewMethods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.nameOfClass(), for: indexPath) as! FriendsTableViewCell
        
        cell.setDetails(OfFriend: friendsArr![indexPath.row]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    

}

