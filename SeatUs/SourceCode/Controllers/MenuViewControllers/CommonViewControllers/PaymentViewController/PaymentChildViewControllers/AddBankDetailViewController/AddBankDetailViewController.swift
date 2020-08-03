//
//  AddBankDetailViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 24/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class AddBankDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contentArray: [Payment]!
    
    private let refreshControl = UIRefreshControl()
    
    var isComeFromRouteSelectionScreen = false
    var status: Bool!
    var selectedStateID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentArray = Payment.getPaymentData(name: FileNames.BankInfoPlist)
        
        contentArray = contentArray.filter({!["Payment","Select Payment Type","Bank Name","Personal Id Number"].contains($0.placeholdertext)})
        
        getBankDetails()
        registerCustomCell()
        setUpPullToReferesh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCustomCell(){
        
        for cell in [ SingleActionButtonCell.nameOfClass(),EditProfileLabelCell.nameOfClass(),DetailCell.nameOfClass() ] {
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
    
    func getBankDetails(){
        BankDetail.requestToServer(service: WebServicesConstant.ReadBankDetails, filterObject: [:])
        { (object, message, active, status) in
            
            if let decrypt = CryptoHelper.aesDecrypt((object as? String) ?? "") as? String {
                let bankDetail = BankDetail.getBankDetails(Utility.convertJsonToDictionary(json: decrypt) as AnyObject)
                self.updateTableViewData(bankDetail: bankDetail)
                self.updateTableView()
            }
            
        }
    }
    
    func updateTableViewData(bankDetail: BankDetail) {
        
//        let objectBank = Utility.getModel(key: PaymentConstant.NameOfBankHeading , array: self.contentArray)
//        objectBank.text = bankDetail.bank_name
  
        let objectName = Utility.getModel(key: PaymentConstant.AccountNameHeading , array: self.contentArray)
        objectName.text = bankDetail.account_title
        
        let objectAccNumber = Utility.getModel(key: PaymentConstant.AccountNumberHeading , array: self.contentArray)
        objectAccNumber.text = bankDetail.account_number
        
        let objectRouting = Utility.getModel(key: PaymentConstant.BankRoutingHeading , array: self.contentArray)
        objectRouting.text = bankDetail.routing_number
        
//        let objectPersonalIdNumber = Utility.getModel(key: PaymentConstant.PersonalIdNumberHeading , array: self.contentArray)
//        objectPersonalIdNumber.text = bankDetail.personal_id_number
        
        let objectSSNLast4 = Utility.getModel(key: PaymentConstant.SSNLast4Heading , array: self.contentArray)
        objectSSNLast4.text = bankDetail.ssn_last_4

        let objectAddress = Utility.getModel(key: PaymentConstant.AddressHeading , array: self.contentArray)
        objectAddress.text = bankDetail.address
        
        let objectState = Utility.getModel(key: PaymentConstant.StateHeading , array: self.contentArray)
        selectedStateID = bankDetail.state?.stringValue
        
        if selectedStateID != nil {
            objectState.text = (WorldLocation.getStateBy(stateId: selectedStateID, countryID: ApplicationConstants.CountryIdUS)?["name"] as? String) ?? ""
            
            let objectCity = Utility.getModel(key: PaymentConstant.CityHeading , array: self.contentArray)
            objectCity.text = (WorldLocation.getCityBy(cityId: bankDetail.city?.stringValue ?? "", stateId: selectedStateID)?["name"] as? String) ?? ""
        }
        
        let objectPostalCode = Utility.getModel(key: PaymentConstant.PostalCodeHeading , array: self.contentArray)
        objectPostalCode.text = bankDetail.postal_code
        
        let objectBirthDate = Utility.getModel(key: PaymentConstant.BirthDateHeading , array: self.contentArray)
        objectBirthDate.text = bankDetail.birth_date
        
//        if bankDetail.period != nil {
//            let objectPaymnet = Utility.getModel(key: PaymentConstant.PaymentHeading , array: self.contentArray)
//            objectPaymnet.text = bankDetail.period.capitalized
//
//            let detailCell = Utility.getModel(key: PaymentConstant.DetailCellHeading , array: self.contentArray)
//            detailCell.text = detailCell.placeholdertext
//
//            if bankDetail.period.lowercased().compare("expedited") == .orderedSame {
//                detailCell.placeholdertext = ApplicationConstants.ExpidiatedMessage
//            }
//
//            if bankDetail.period.lowercased().compare("standard") == .orderedSame {
//                detailCell.placeholdertext = ApplicationConstants.StandardMessage
//            }
//
//
//        }
//
        //let objectAccount = Utility.getModel(key: PaymentConstant.CheckingAccountHeading , array: self.contentArray)
        //objectAccount.text = bankDetail.checking_account
        
        //let objectSwift = Utility.getModel(key: PaymentConstant.SwiftCodeHeading , array: self.contentArray)
        //objectSwift.text = bankDetail.swift_code
        
        //let objectAddress = Utility.getModel(key: PaymentConstant.BankAddressHeading , array: self.contentArray)
        //objectAddress.text = bankDetail.bank_address
        
    }
    
    func updateBankDetails(){
        var filterObject = [String: Any]()
        let keys = ["account_title","routing_number","account_number","ssn_last_4","address","state","city","postal_code","birth_date"]
        
//        let bank_name = Utility.getModel(key: PaymentConstant.NameOfBankHeading, array: self.contentArray)
//        filterObject["bank_name"] = bank_name.text ?? ""
        
        let account_title = Utility.getModel(key: PaymentConstant.AccountNameHeading , array: self.contentArray)
        filterObject["account_title"] = account_title.text ?? ""
        
        let routing_number = Utility.getModel(key: PaymentConstant.BankRoutingHeading , array: self.contentArray)
        filterObject["routing_number"] = routing_number.text ?? ""
        
        let account_number = Utility.getModel(key: PaymentConstant.AccountNumberHeading , array: self.contentArray)
        filterObject["account_number"] = account_number.text ?? ""
        
//        let personal_id_number = Utility.getModel(key: PaymentConstant.PersonalIdNumberHeading , array: self.contentArray)
//        filterObject["personal_id_number"] = personal_id_number.text ?? ""
        
        let ssn_last_4 = Utility.getModel(key: PaymentConstant.SSNLast4Heading , array: self.contentArray)
        if ssn_last_4.text != nil && ssn_last_4.text.count == 4 {
            filterObject["ssn_last_4"] = ssn_last_4.text ?? ""
        }
        else {
            Utility.showAlertwithOkButton(message: "SSN must be last 4 digits", controller: self)
            return
        }
        
        let address = Utility.getModel(key: PaymentConstant.AddressHeading , array: self.contentArray)
        filterObject["address"] = address.text ?? ""
        
        filterObject["state"] = Int(selectedStateID ?? "")
        
        let citiesList = WorldLocation.getCitiesList(stateId: selectedStateID ?? "")
        
        let city = Utility.getModel(key: PaymentConstant.CityHeading , array: self.contentArray)
        filterObject["city"] = Utility.getLocationID(stateName: city.text ?? "", array: citiesList) as AnyObject
        
        let postal_code = Utility.getModel(key: PaymentConstant.PostalCodeHeading , array: self.contentArray)
        filterObject["postal_code"] = postal_code.text ?? ""
        
        let birth_date = Utility.getModel(key: PaymentConstant.BirthDateHeading , array: self.contentArray)
        filterObject["birth_date"] = birth_date.text ?? ""
        
//        let payment_code = Utility.getModel(key: PaymentConstant.PaymentHeading , array: self.contentArray)
//        filterObject["period"] = payment_code.text.lowercased()
//
//
        
        if keys.filter({
            
            if let object = filterObject[$0] {
                
                if object is Int {
                    return false
                }

                return (object as? String)?.isEmpty ?? false
            }
            else {
                return false
            }
            
        }).count > 0 {
            let warningMsg = "Fields " + ValidationMessages.NotEmptyValidationMessage.lowercased()
            Utility.showAlertwithOkButton(message: warningMsg, controller: self)
            return
        }
        
        
        let encryptObject = ["body":CryptoHelper.aesEncrypt(Utility.convertObjectToJson(object: filterObject as NSDictionary))]
        
        BankDetail.requestToServer(service: WebServicesConstant.UpdateBankDetails, filterObject: encryptObject){ (object, message, active, status) in
            self.status = status
            Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
        }
    }
    
    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        let object = contentArray[index]
        
        let shouldCallCustomFunction = Bool(truncating: object.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = tableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath) as! EditProfileLabelCell
            
            switch object.customactionname{
                
            case DropDownOptions.SelectPayment.rawValue:
                selectPayment(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectState.rawValue:
                selectState(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectCity.rawValue:
                selectCity(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectDOB.rawValue:
                selectDOB(sender: cell.textField)
                break;
                
            default: break
            }
        }
    }
    
    @objc func selectPayment(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getPaymentOpitonsArray()
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
            
            let cell = self.tableView.cellForRow(at: NSIndexPath(item: sender.tag + 1, section: 0) as IndexPath) as! DetailCell
            
            if castTextField.text?.lowercased().compare("expedited") == .orderedSame {
                cell.contentLable.text = ApplicationConstants.ExpidiatedMessage
            }
            
            if castTextField.text?.lowercased().compare("standard") == .orderedSame {
                cell.contentLable.text = ApplicationConstants.StandardMessage

            }
            
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
    }
    
    @objc func selectState(sender: UITextField){
        
        let stateList = WorldLocation.getStatesList(countryID : ApplicationConstants.CountryIdUS)
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: stateList as! [[String : AnyObject]], typeStr: "State")
        searchPicker.show(vc: self.parent!)
        searchPicker.doneButtonTapped =  { selectedData in
            
            let selectedState = selectedData["name"] as? String
            self.selectedStateID = (selectedData["id"] as? NSNumber)?.stringValue
            sender.text=selectedState
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
            self.syncWithPlist(index: sender.tag, value: selectedState!)
            self.syncWithPlist(index: sender.tag + 1, value: "")
            self.tableView.reloadData()
            
        }
    }
    
    
    @objc func selectCity(sender: UITextField){
        
        if (!(selectedStateID != nil)){
            return
        }
        let citiesList = WorldLocation.getCitiesList(stateId: selectedStateID)
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: citiesList as! [[String : AnyObject]], typeStr: "City")
        searchPicker.show(vc: self.parent!)
        searchPicker.doneButtonTapped =  { selectedData in
            
            let selectedState = selectedData["name"] as? String
            sender.text=selectedState
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
            self.syncWithPlist(index: sender.tag, value: selectedState!)
        }
    }
    
    @objc func selectDOB(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            
            if (Utility.isDateValid(date: selectedData,isFutureDateAllowed: false)){
                sender.text = selectedData
                self.syncWithPlist(index: sender.tag, value: selectedData)
                let castTextField = sender as! ValidaterTextField
                castTextField.validate()
                
            }
            else{
                Utility.showAlertwithOkButton(message: ApplicationConstants.DOBMessage, controller: self)
            }
        }
    }
    
    func syncWithPlist(index:Int , value:String){
        
        let signUpObject = contentArray[index]
        signUpObject.text=value
    }
    
    override func alertOkButtonHandler() {
        if (status != nil) && (self.isComeFromRouteSelectionScreen && status) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddBankDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contentArray[indexPath.row].cellidentifier , for: indexPath)
        cell.tag = indexPath.row
        
        
        switch (cell){
            
        case is EditProfileLabelCell:
            let cell = cell as! EditProfileLabelCell
            cell.updateCellForEditProfile(model: contentArray[indexPath.row])
            cell.actionButton.tag=indexPath.row
            cell.textField.tag=indexPath.row
            cell.actionButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
            
        case is SingleActionButtonCell:
            let cell = cell as! SingleActionButtonCell
            cell.initializeCell(contentArray[indexPath.row])
            cell.delegate = self
            if indexPath.row == (contentArray.count - 1) {
                cell.topConstraint.constant = 20
            }
            break
            
        case is DetailCell:
            let cell = cell as! DetailCell
            cell.initializeCell(contentArray[indexPath.row])


            
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

extension AddBankDetailViewController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        self.view.endEditing(true)
        updateBankDetails()
    }
}
