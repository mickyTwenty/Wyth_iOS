//
//  AddFriendsViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class AddFriendsViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    var contentArray : [Friend]! = []
    var listener : ListenerRegistration? = nil
    
    var cellName = InvitedFriendCell.nameOfClass()
    
    //MARK: - ViewController Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        getLastInvitedTime()
        addOberver()
        
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func invitePeopleButtonClicked(_ sender:UIButton){
        Utility.send(Message: ApplicationConstants.iTunesUrl, ToNumber: "")
//        let myWebsite = NSURL(string: ApplicationConstants.iTunesUrl)
//
//        // set up activity view controller
//        let textToShare = [myWebsite as Any] as [Any]
//        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
            if listener != nil{
            listener?.remove()
        }
    }


    //MARK: - Helper Methods
    func updateTableView(){

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func registerCell(){
        
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        tableView.tableFooterView = UIView()
    }

    //MARK: - Firebase - Methods
    func addOberver(){
        
     listener = FireBaseManager.sharedInstance.addListenerToInvitedMembersCollection { (array) in
            self.contentArray = array
            self.updateTableView()
        }
        
    }
    
    func getLastInvitedTime(){
        FireBaseManager.sharedInstance.getLastUpdatedTime { (objInvitedFriendTimeStatus) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                break

            case InvitedFriendTimeStatus.InvitExpires?:
                Utility.showAlertwithOkButton(message: ApplicationConstants.InviteExpireMessageOnFreindsScreen, controller: self)
                FireBaseManager.sharedInstance.deleteCollection(completionHandler: { (isDeletd) in
                    if isDeletd!{
                    }
                })

                break

            case InvitedFriendTimeStatus.InviteNotExpire?:
                break
                
            case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                self.showAlertForDiffrentTypeInvite()
                break

            default:
                break
            }
        }
    }
    
    
    //MARK: - Alert Controller
     func showAlertForDiffrentTypeInvite(){
        
        let alert = UIAlertController(title: ApplicationConstants.InvitePendingMessageTitle, message: ApplicationConstants.InvitePendingMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            FireBaseManager.sharedInstance.deleteCollection(completionHandler: { (status) in
            })
        })
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func showAlertForInviteDelete(atIndex:Int){
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the invitation", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action -> Void in
            
            
        })
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            
        })
        
        
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }


    //MARK: - IBActions - Methods
    @IBAction func searchFriendsButtomClicked(sender:UIButton){
    
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: FriendsSearchViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)

    }

    
    @IBAction func okButtonClicked(sender:UIButton){
        navigationController?.popViewController(animated: true)
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

extension AddFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            FireBaseManager.sharedInstance.deleteSelectedMember(object: self.contentArray[indexPath.row], completionHandler: { (status) in
            })

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        switch cell {
            
            case is InvitedFriendCell:
        
                let invitedFriendCell = cell as! InvitedFriendCell
                invitedFriendCell.setDetails(OfFriend: contentArray[indexPath.row])
                break
            
            case is ItineraryDetailsCell:
            
                let itineraryDetailsCell = cell as! ItineraryDetailsCell
                itineraryDetailsCell.setDetails(OfFriend: contentArray[indexPath.row])
                break
                
            default:
                break
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
}

