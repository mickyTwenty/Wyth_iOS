//
//  RegistrationDetailsViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol AccountCreationDelegate: class {
    func accountCreated()
}


class RegistrationDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,DatePickerDelegate {
    
    @IBOutlet weak var signUpDetailsTableView: UITableView!
    
    weak var accountCreationDelegate:AccountCreationDelegate?
    var signUpDetailRowsArray: [SignUpEntity]!
    var applyValidation: Bool! = false
    var isAllFieldsValidatedSucessfully: Bool! = true
    var selectedStateID:String!
    var passwordTxtField : ValidaterTextField!
    var confirmPasswordTxtField : ValidaterTextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCustomCellOnUitableView()
        signUpDetailRowsArray = User.sharedInstance.getSignUpDetailsData()
        signUpDetailsTableView.delegate=self
        signUpDetailsTableView.dataSource=self
        //perform(#selector(addConfirmPasswordValidation), with: nil, afterDelay: 0.2)
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func addConfirmPasswordValidation(){
        
        let passFieldIndexPath = IndexPath(item: 5, section: 0)
        let passConfirmFieldIndexPath = IndexPath(item: 6, section: 0)

        let signUpPassCell =  signUpDetailsTableView.cellForRow(at: passFieldIndexPath) as! SignUpTableViewCell
        let signUpConfrimPassCell =  signUpDetailsTableView.cellForRow(at: passConfirmFieldIndexPath) as! SignUpTableViewCell
        
        signUpConfrimPassCell.textField.addConfirmValidation(to: signUpPassCell.textField, withMsg: ValidationMessages.PasswordMismatchMessage)

    }
    
    func setupCustomCellOnUitableView(){
        
        let cellNib = UINib(nibName: SignUpTableViewCell.nameOfClass(), bundle: nil)
        let cellCountinueNib = UINib(nibName: SignUpCountinueCell.nameOfClass(), bundle: nil)
        let cellDriverNib = UINib(nibName: SignUpDriverCell.nameOfClass(), bundle: nil)
        let cellAgreementNib = UINib(nibName: AgreementCell.nameOfClass(), bundle: nil)

        signUpDetailsTableView.register(cellNib, forCellReuseIdentifier: SignUpTableViewCell.nameOfClass())
        signUpDetailsTableView.register(cellCountinueNib, forCellReuseIdentifier: SignUpCountinueCell.nameOfClass())
        signUpDetailsTableView.register(cellDriverNib, forCellReuseIdentifier: SignUpDriverCell.nameOfClass())
        signUpDetailsTableView.register(cellAgreementNib, forCellReuseIdentifier: AgreementCell.nameOfClass())

        signUpDetailsTableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signUpDetailRowsArray.count
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
        
        let object = signUpDetailRowsArray[indexPath.row]
        let cell   = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
        
        switch cell {
            
        case is SignUpTableViewCell:
            
            let signupCell = cell as! SignUpTableViewCell
            signupCell.updateCellWithObject(model: object)
            signupCell.actionButton.tag=indexPath.row
            signupCell.textField.tag=indexPath.row
            
            signupCell.actionButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            if applyValidation{
                if signupCell.textField.isMandatory && signupCell.textField.tag == indexPath.row{
                    print(object.placeholdertext)
                    if !(signupCell.textField.validate()) {
                        isAllFieldsValidatedSucessfully = false
                    }
                }
            }
            break
            
        case is SignUpCountinueCell:
            
            let signUpCountinueCell = cell as! SignUpCountinueCell
            signUpCountinueCell.countinueButton.setImage(UIImage(named: object.imagename), for: .normal)
            signUpCountinueCell.countinueButton.addTarget(self, action: #selector(signUpAsUserButtonClicked), for: .touchUpInside)
            break
            
        case is SignUpDriverCell:
            let signUpDriverCell = cell as! SignUpDriverCell
            signUpDriverCell.driverSignUpButton.addTarget(self, action: #selector(signUpAsDriverButtonClicked), for: .touchUpInside)
            signUpDriverCell.driverSignUpButton.setImage(UIImage(named: object.imagename), for: .normal)
            break
            
        case is AgreementCell:
            let agreementCell = cell as! AgreementCell
            
            agreementCell.checkMarkButton.tag=indexPath.row

            agreementCell.checkMarkButton.addTarget(self, action: #selector(userAgreementButtonClicked(sender:)), for: .touchUpInside)
            let isSelected = Bool(truncating: object.isselected as NSNumber)
            agreementCell.checkMarkButton.isSelected=isSelected
            agreementCell.placeHolderLabel.text=object.placeholdertext
            break

        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("didSelectRowAt")
    }

    @objc func dropDownButtonPressed(sender:UIButton!) {

        let index = sender.tag
        let signUpObject: SignUpEntity = signUpDetailRowsArray[index]
        
        let shouldCallCustomFunction = Bool(truncating: signUpObject.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = signUpDetailsTableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath) as! SignUpTableViewCell

            switch signUpObject.customactionname{
                case DropDownOptions.SelectState.rawValue:
                    selectState(sender: cell.textField)
                    break;
                
                case DropDownOptions.SelectCity.rawValue:
                    selectCity(sender: cell.textField)
                    break;
                
                case DropDownOptions.SelectGraduationYear.rawValue:
                    selectGraduationYear(sender: cell.textField)
                    break
                
                case DropDownOptions.SelectHearingSource.rawValue:
                    selectHearingSource(sender: cell.textField)
                    break
                
                
                default: break
            }
        }
    }
    
    
    func showAggrementPopUp(userType:String){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: AgrementViewController.nameOfClass()) as! AgrementViewController
        
        cont.userType = userType
        
        cont.show(controller: self.parent!)
        cont.doneButtonTapped = { selectedData in
            
            User.sharedInstance.signUpDetailsObjectArray=self.signUpDetailRowsArray
            self.postDataToServer(userType: userType)
        }
    }
    
    
    @objc func applyValidationOnTableView(userType:String){
        
        if self.isAllFieldsValidatedSucessfully{
            
            showAggrementPopUp(userType: userType)
            
    
            /*
            // Hide User Agreemnet - Use Case
            let agreementModel = signUpDetailRowsArray![6] as SignUpEntity
            
            let isSelected = Bool(truncating: agreementModel.isselected as NSNumber)

            if isSelected {
                User.sharedInstance.signUpDetailsObjectArray=signUpDetailRowsArray
                postDataToServer(userType: userType)
            }
            else{
                weak var weakSelf = self
                print("Validation Sucessfull but Terms & Condition Not Accepted")
                Utility.showAlertwithOkButton(message: ApplicationConstants.UserAgreementMessage, controller: weakSelf!)
            }
 */

        }
        isAllFieldsValidatedSucessfully=true
    }
    
    @objc func reloadWithDealy(){
        signUpDetailsTableView.reloadData()
    }

    @objc func signUpAsUserButtonClicked() {
        print("signUpAsUserButtonClicked")
        performValidation(userType: UserType.UserNormal)
    }
    
    @objc func performValidation(userType:String){
        applyValidation = true
        signUpDetailsTableView.reloadData()
        self.perform(#selector(applyValidationOnTableView), with: userType, afterDelay: 0.2)
    }

    @objc func signUpAsDriverButtonClicked() {
        print("signUpAsDriverButtonClicked")
        performValidation(userType: UserType.UserDriver)
    }

    @objc func userAgreementButtonClicked(sender: UIButton) {
        
        let index = sender.tag
        let signUpObject: SignUpEntity = signUpDetailRowsArray[index]
    
        sender.isSelected = !sender.isSelected
        signUpObject.isselected=NSNumber(booleanLiteral: sender.isSelected)
    }

    func postDataToServer(userType: String)->(){
        weak var weakSelf = self

        User.createUser(userType: userType) { (userObject, message, action, status, error) in
            
            let stringMessage = message!["message"] as! String
            
            switch action{
            case .ShowMesasgeAtRunTime?:
                break
            case .DoNotShowMesasgeAtRunTime?:
                Utility.setRememberState(isRemember: false)
                Utility.setUserType(type: userType)
                self.accountCreationDelegate?.accountCreated()
                break
            case .ShowMesasgeOnAlert?:
                Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                break
                
            default:
                break
            }

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
            self.signUpDetailsTableView.reloadData()

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
    
    @objc func selectGraduationYear(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getYearsArray()
        controller.show(controller: self.parent!)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }

    }
    
    @objc func selectHearingSource(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getHearingSourceContent() as! [String]
        controller.show(controller: self.parent!)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
        
    }
    func syncWithPlist(index:Int , value:String){
        
        let signUpObject: SignUpEntity = signUpDetailRowsArray[index]
        signUpObject.text=value
    }
    
    
    func datePickerViewController(_ datePicker: UIDatePicker, date: Date, sourceView: UIView) {
        let txtField = sourceView as! ValidaterTextField
        self.syncWithPlist(index: sourceView.tag, value: txtField.text!)
        txtField.validate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
