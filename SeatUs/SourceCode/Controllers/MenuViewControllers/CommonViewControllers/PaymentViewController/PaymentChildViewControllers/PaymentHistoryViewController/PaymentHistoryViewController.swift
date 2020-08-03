//
//  PaymentHistoryViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PaymentHistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteSep: UIView!
    
    var contentArray: [ [Payment] ]!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentArray = [ [Payment] ]()
        
        if Utility.getUserType() != UserType.UserDriver {
            noteLabel.isHidden = true
            noteLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            noteSep.isHidden = true
            noteSep.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        getPaymentHistory()
        registerCustomCell()
        setUpPullToReferesh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCustomCell(){
        
        for cell in [ LabelCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        
    }
    
    func updateTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func setUpPullToReferesh() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        updateTableView()
    }
    
    func getPaymentHistory(limit: Int = 20, page: Int = 1){
        let filterObject: [String: Any] = ["limit":limit,"page":page]
        PaymentHistory.getPaymentHistoryFromServer(filterObject: filterObject)
        { (object, message, active, status) in
            for paymentHistory in PaymentHistory.getPaymentsHistory(object!) {
                self.addPaymentCell(paymentHistory: paymentHistory)
            }
            self.updateTableView()
        }
    }
    
    func addPaymentCell(paymentHistory: PaymentHistory){
        
        var values = [paymentHistory.origin_title ?? "",paymentHistory.destination_title ?? "", paymentHistory.payment_datetime ?? "", Utility.getFormattedCardNumber(last_digits: paymentHistory.last_digits), "$ "+String(describing: paymentHistory.amount!)]
        
        var titleLabels = [ PaymentConstant.OriginHeading,
                            PaymentConstant.DestinationHeading,
                            PaymentConstant.DateHeading,
                            PaymentConstant.CardHeading,
                            PaymentConstant.AmountHeading,
                            PaymentConstant.TransactionFee,
                            PaymentConstant.TransactionFeeLocal]
        
        if Utility.getUserType() == UserType.UserDriver {
            
            titleLabels = [ PaymentConstant.OriginHeading,
                                PaymentConstant.DestinationHeading,
                                PaymentConstant.DateHeading,
                                PaymentConstant.CardHeading,
                                PaymentConstant.Earning ]
            
            values = [paymentHistory.origin_title ?? "",paymentHistory.destination_title ?? "", paymentHistory.payment_datetime ?? "", Utility.getFormattedCardNumber(last_digits: paymentHistory.last_digits), "$ "+String(describing: paymentHistory.earning!)+"*" ]

            
        }
        else{
            
            var tran_fee = ""
            if let temp =  paymentHistory.transaction_fee {
                tran_fee = temp
            }
            
            values = [paymentHistory.origin_title ?? "",paymentHistory.destination_title ?? "", paymentHistory.payment_datetime ?? "", Utility.getFormattedCardNumber(last_digits: paymentHistory.last_digits), "$ "+String(describing: paymentHistory.amount!), "$ " + tran_fee ]


        }
        
        
        
        var payments = [Payment]()
        
        for index in 0..<titleLabels.count {
            let payment = Payment()
            payment.placeholdertext = values[index]
            payment.title = titleLabels[index]
            payment.cellidentifier = LabelCell.nameOfClass()
            if (PaymentConstant.CardHeading.compare(payment.title) == .orderedSame || PaymentConstant.DateHeading.compare(payment.title) == .orderedSame){
                if Utility.getUserType() == UserType.UserNormal {
                    payments.append(payment)
                }
            }
            else{
                payments.append(payment)
            }
        }
        
        contentArray.append(payments)
    }
    
}

extension PaymentHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array =  contentArray[section] as [AnyObject]
       return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let paymentHistory = contentArray[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentHistory.cellidentifier , for: indexPath)
        cell.tag = indexPath.row
        
        
        switch (cell){
            
        case is LabelCell:
            let cell = cell as! LabelCell
            cell.initializeCell(paymentHistory, isMultiLineLable: true)
            if indexPath.row == contentArray[indexPath.section].count - 1 {
                cell.hideSeparatorView()
                cell.separatorViewBottom.isHidden = false
            }
            else {
                cell.separatorViewBottom.isHidden = true

                cell.showSeparatorView()
            }
            break
            
        default :
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
