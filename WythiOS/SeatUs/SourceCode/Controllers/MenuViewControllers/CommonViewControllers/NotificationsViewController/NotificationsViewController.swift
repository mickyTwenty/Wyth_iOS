//
//  NotificationsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 29/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var contentArray: [Notifications]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        getNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerCustomCell(){
        
        for cell in [NotificationCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        
    }
    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getNotifications(){
        Notifications.requestToServer(service: WebServicesConstant.GetNotifications, filterObject: [:])
        { (object, message, active, status) in
            self.contentArray = [Notifications]()
            for notifications in Notifications.getNotifications(object!) {
                self.contentArray.append(notifications)
            }
            self.updateTableView()
        }
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.nameOfClass() , for: indexPath) as! NotificationCell
        cell.tag = indexPath.row
        
        cell.initializeCell(contentArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = contentArray[indexPath.row]
        Utility.handleBackgroundPushNotifications(object: &object.josnNotifData!, rootController: self, isComingFromBackgroundNotif: false)
    }
    
}

