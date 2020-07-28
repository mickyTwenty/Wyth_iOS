//
//  ChatViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 08/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var textField: UITextField!
    var trip: Trip!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        Utility.resignKeyboardWhenTouchOutside()
        
        if Utility.isDeviceIphoneX() {
        }
        else{
            textField.keyboardDistanceFromTextField = -10
        }
        textField.inputAccessoryView = UIView()
//        textField.autocorrectionType = .default
        addListener()
    }
    
    func addListener(){
    
      _ =  FireBaseManager.sharedInstance.addListenerToChatCollection(trip: trip) { (object) in
            self.content = object
            self.tableView.reloadData()
            self.scrollToLastIndex()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func registerCustomCell(){
        
        for cell in [SenderCell.nameOfClass(), ReceiverCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        scrollToLastIndex()
        
    }
    
    var content: [Chat]! = []

    @IBAction func onClick(_ sender: Any) {
        
        if !(textField.text?.isEmpty)! {
            
            let chatObject : [String:Any] = ["first_name":(User.sharedInstance.first_name)!,"last_name":(User.sharedInstance.last_name)!,"message_text":(textField.text)!,"user_id":(User.getUserID()!)]
            FireBaseManager.sharedInstance.addMessageToChatCollection(trip: trip, param:chatObject)
            
            textField.text = ""
            textField.resignFirstResponder()
            
            scrollToLastIndex()
        }
        
    }
    
    func scrollToLastIndex() {
        let rows: Int = tableView.numberOfRows(inSection: 0)
        if rows > 0 {
            tableView.scrollToRow(at: IndexPath(row: rows - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = content[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: object.cellIdentifier! , for: indexPath)

        switch(cell){
            
        case is SenderCell:
            
            let senderCell = cell as! SenderCell
            senderCell.initializeCell(content[indexPath.row])
            break
            
        case is ReceiverCell:
            
            let receiverCell = cell as! ReceiverCell
            receiverCell.initializeCell(content[indexPath.row])
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

