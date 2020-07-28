//
//  SelectPaymentModalController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 15/01/2019.
//  Copyright © 2019 Qazi Naveed. All rights reserved.
//

import UIKit

class SelectPaymentModalController: ModalAlertBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedType = "Standard"
    var checkboxes = [CheckBoxView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = []
        contentArray.append(Passenger())
        contentArray.append(Passenger())
        contentArray.append(Passenger())
        contentDict = ["Expedited":ApplicationConstants.ExpidiatedMessage , "Standard":ApplicationConstants.StandardMessage]
        
        registerCustomCell()
        
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        self.close()
        selectButtonTapped?(selectedType.lowercased() as AnyObject)
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
         self.close()
    }
    
    func registerCustomCell(){
        
        let cellNib = UINib(nibName: DetailCell.nameOfClass(), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: DetailCell.nameOfClass())
        
        let cellNib1 = UINib(nibName: CheckboxCell.nameOfClass(), bundle: nil)
        tableView.register(cellNib1, forCellReuseIdentifier: CheckboxCell.nameOfClass())
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension SelectPaymentModalController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  let passenger = contentArray[indexPath.row]
        
        var title = indexPath.row == 0 ? "Standard" : "Expedited"
        var cellName = CheckboxCell.nameOfClass()
        if indexPath.row == 2 {
            title = contentDict[selectedType] as! String
            cellName = DetailCell.nameOfClass()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName , for: indexPath)
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        
        if let cell = cell as? CheckboxCell {
            cell.checkBoxView.titleLabel.text = title
            cell.delegate = self
            cell.checkBoxView.setCheckBoxState(selectedType==title)
        }
        else if let cell = cell as? DetailCell {
            cell.contentLable.text = title
            cell.contentLable.numberOfLines = 0
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

extension SelectPaymentModalController: CheckboxCellDelegate {
    func clickEvent(CheckboxIndex tag: Int, isSelected: Bool) {
        selectedType = (tag == 0) ? "Standard" : "Expedited"
        tableView.reloadData()
    }
}
