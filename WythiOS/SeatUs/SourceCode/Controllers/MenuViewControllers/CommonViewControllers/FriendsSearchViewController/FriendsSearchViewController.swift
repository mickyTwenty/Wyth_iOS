//
//  FriendsSearchViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol FriendsSearchViewControllerDelegate: class {
    func addFriend(friend: FriendsConnected)
}

class FriendsSearchViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var searchTableView : UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Instance Var
    var searchActive : Bool = false
    var contentArray:[FriendsConnected] =  []
    var filtered:[FriendsConnected] = []
    weak var delegate : FriendsSearchViewControllerDelegate!
    var addingFreinds : AddingFreinds? = .isComingForDriverPassengerBoth
    var isManuallyAdded = false

    // MARK: - Controller Lifecyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentArray = DataPersister.sharedInstance.getAllConnectedFriends(addingFreinds: addingFreinds!, isManuallyAdded: isManuallyAdded)
        
        settingDelegates()
        registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Helper Methods
    func settingDelegates(){
        
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
    }
    
    func registerCell(){
        
        let cellNib = UINib(nibName: SearchCell.nameOfClass(), bundle: nil)
        searchTableView.register(cellNib, forCellReuseIdentifier: SearchCell.nameOfClass())
        searchTableView.tableFooterView = UIView()
    }
    
    
    // MARK: - SearchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.becomeFirstResponder()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        view.endEditing(true)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = contentArray.filter({ (freinds) -> Bool in
            let tmp: NSString = freinds.first_name! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        searchTableView.reloadData()
    }
    
    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return contentArray.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: SearchCell.nameOfClass(), for: indexPath) as! SearchCell
        let object :FriendsConnected
        if(searchActive && filtered.count > 0){
            object = filtered[indexPath.row]
        } else {
            object = contentArray[indexPath.row]
        }
        cell.setDetails(OfFriend: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object :FriendsConnected
        if(searchActive && filtered.count > 0){
            object = filtered[indexPath.row]
        } else {
            object = contentArray[indexPath.row]
        }
        
        if delegate != nil {
            delegate?.addFriend(friend: object)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            getLastInvitedTime(friend: object)
        }
        
    }
    
    func addFriend(friend: FriendsConnected){
        
        FireBaseManager.sharedInstance.addFriendToFireBase(friend: friend,friendType:addingFreinds!) { (error) in
            if !(error != nil){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    func getLastInvitedTime(friend:FriendsConnected){
        FireBaseManager.sharedInstance.getLastUpdatedTime { (objInvitedFriendTimeStatus) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                self.addFriend(friend: friend)
                break
                
            case InvitedFriendTimeStatus.InvitExpires?:
                FireBaseManager.sharedInstance.deleteCollection(completionHandler: { (isDeletd) in
                    if isDeletd!{
                        self.addFriend(friend: friend)
                    }
                })
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                self.addFriend(friend: friend)
                break
                
            case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                self.addFriend(friend: friend)
                break

                
            default:
                break
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
