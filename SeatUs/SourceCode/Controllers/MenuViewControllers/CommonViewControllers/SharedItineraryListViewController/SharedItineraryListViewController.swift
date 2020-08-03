//
//  SharedItineraryListViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 16/07/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class SharedItineraryListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var cellName = ItineraryDetailsCell.nameOfClass()
    var contentArray : [Friend]! = []
    var sharedItinerary : [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        contentArray = Friend.getFriendsArray(friendsArray: sharedItinerary)
        updateTableView()
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

}

extension SharedItineraryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ItineraryDetailsCell
        
        let friend = contentArray[indexPath.row]
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
