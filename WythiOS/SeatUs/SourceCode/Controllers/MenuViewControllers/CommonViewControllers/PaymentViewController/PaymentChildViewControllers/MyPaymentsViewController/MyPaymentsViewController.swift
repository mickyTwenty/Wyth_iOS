//
//  MyPaymentsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class MyPaymentsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contentArray: [Payment]!
    
    private let refreshControl = UIRefreshControl()
    
    var isComeFromRideDetailsScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCardCell()
        registerCustomCell()
        setUpPullToReferesh()
        getCards()
        updateTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.MyPaymentHelp
        
        present(controller, animated: true, completion: nil)
    }

    func registerCustomCell(){
        
        for cell in [LabelCheckBoxCell.nameOfClass(), SingleActionButtonCell.nameOfClass()] {
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
    
    func getCards(){
        addCardCell()
        Card.requestToServer(service: WebServicesConstant.GetCreditCard, filterObject: [:])
            { (object, message, active, status) in
                for card in Card.getCards(object!) {
                    self.addPaymentCell(card: card)
                }
                self.updateTableView()
        }
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
    
    func showAddCardPopUp(){
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: AddCardPopUpController.nameOfClass())
        cont.show(controller: self.parent!)
        cont.selectButtonTapped = { selectedData in
            if let selectedData = selectedData as? Bool, (self.isComeFromRideDetailsScreen && selectedData) {
                self.navigationController?.popViewController(animated: true)
            }
            self.getCards()
        }
        
    }
    
    func addCardCell(){
        contentArray = [Payment]()
//        if !Utility.isDriver() {
            let payment = Payment()
            payment.title = PaymentConstant.AddCardHeading
            payment.cellidentifier = SingleActionButtonCell.nameOfClass()
            payment.imagename = AssetsName.AddCardImage
            contentArray.append(payment)
//        }
    }
    
    func addPaymentCell(card: Card){
        let payment = Payment()
        payment.card = card
        payment.placeholdertext = Utility.getFormattedCardNumber(last_digits: card.last_digits)
        payment.title = "Card \(contentArray.count)"
        payment.cellidentifier = LabelCheckBoxCell.nameOfClass()
        contentArray.append(payment)
    }
    
    func removeCard(payment: Payment){
        let card = payment.card
        let filterObject: [String: Any] = ["card_id":(card?.id?.stringValue)!]
        Card.requestToServer(service: WebServicesConstant.RemoveCreditCard, filterObject: filterObject)
            { (object, message, active, status) in
                self.getCards()
        }
    }
    
    func makeDefaultCard(payment: Payment){
        let card = payment.card
        let filterObject: [String: Any] = ["card_id":(card?.id?.stringValue)!]
        Card.requestToServer(service: WebServicesConstant.DefaultCreditCard, filterObject: filterObject ,shouldShowHud:true)
        { (object, message, active, status) in
            self.getCards()
            Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
        }
    }
    
    func unCheckAll(tag: Int){
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows
        {
            if row == tag {
                continue
            }
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            switch (cell) {
            case is LabelCheckBoxCell:
                let cell = cell as! LabelCheckBoxCell
                cell.checkBoxView.setCheckBoxState(false)
                break
            default:
                break
            }
            
        }
    }
    
}

extension MyPaymentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contentArray[indexPath.row].cellidentifier , for: indexPath)
        cell.tag = indexPath.row
        
        switch (cell){
        
        case is LabelCheckBoxCell:
            let cell = cell as! LabelCheckBoxCell
            cell.initializeCell(contentArray[indexPath.row])
            cell.delegate = self
            if indexPath.row == (contentArray.count - 1) {
                cell.hideSeparatorView()
            }
            else {
                cell.showSeparatorView()
            }
            break
            
        case is SingleActionButtonCell:
            let cell = cell as! SingleActionButtonCell
            cell.button.titleLabel?.font = UIFont.init(name: (cell.button.titleLabel?.font.fontName)!, size: 20)
            cell.initializeCell(contentArray[indexPath.row])
            cell.delegate = self
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
        print("didSelectRowAt")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            if contentArray.indices.contains(indexPath.row) {
                let object = contentArray[indexPath.row]
                removeCard(payment: object)
            }
        }
    }

}

extension MyPaymentsViewController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        showAddCardPopUp()
    }
}

extension MyPaymentsViewController: LabelCheckBoxCellDelegate {
    func clickEvent(LabelCheckBoxIndex tag: Int, isSelected: Bool) {
        if contentArray.indices.contains(tag) {
            unCheckAll(tag: tag)
            makeDefaultCard(payment: contentArray[tag])
        }
    }
}
