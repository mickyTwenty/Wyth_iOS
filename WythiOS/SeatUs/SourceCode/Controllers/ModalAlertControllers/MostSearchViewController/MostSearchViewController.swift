//
//  MostSearchViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 11/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class MostSearchViewController: ModalAlertBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contentArray.count > 5 {
           contentArray = contentArray[0..<5] as! [FriendsConnected]
        }
        
        registerCustomCell()
        
    }

    func registerCustomCell(){
        
        for cell in [LabelCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        widthConstraint.constant = UIScreen.main.bounds.size.width - 20
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        if contentArray.count > 0 {
            let frame = tableView.rectForRow(at: IndexPath.init(row: 0, section: 0))
            heightConstraint.constant = CGFloat(frame.size.height+50) * CGFloat(contentArray.count)
        }
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        
        self.close()

    }
    
    
}

extension MostSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.nameOfClass() , for: indexPath) as! LabelCell

        let friends = contentArray[indexPath.row] as? FriendsConnected
        
        cell.titleLabel.text = (friends?.first_name)! + " " + (friends?.last_name)!
        cell.contentLabel.text = ""
        cell.selectButton.isUserInteractionEnabled = false
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        close()
        selectButtonTapped!(contentArray[indexPath.row])
    }
    
}
