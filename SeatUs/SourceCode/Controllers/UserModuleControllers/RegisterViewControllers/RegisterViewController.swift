//
//  RegisterViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/10/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol LoginTransitionDelegate: class {
    func setupLoginView(sender:UIButton)
    func accountCreated()
}

class RegisterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AccountCreationDelegate  {
    
    weak var delegateLogin: LoginTransitionDelegate?
    var signUpRowsArray: [SignUpEntity]!
    var regDetailsObject : RegistrationDetailsViewController?
    var applyValidation: Bool! = false
    var isAllFieldsValidatedSucessfully: Bool! = true

    
    @IBOutlet weak var leadingConstraintFromSignUpButton: NSLayoutConstraint!
    @IBOutlet weak var signUpTableView: UITableView!

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var contentView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCustomCellOnUitableView()
        reloadData()
        signUpTableView.delegate=self
        signUpTableView.dataSource=self
        perform(#selector(addConfirmPasswordValidation), with: nil, afterDelay: 0.5)
    }

    func reloadDataForFBSignUp(){
        print("reloadForFB")
        let fbObject = User.sharedInstance.fbUserInfo
        let plistObject = signUpRowsArray[0]
        plistObject.text = fbObject!["name"] as! String
        signUpTableView.reloadData()
    }
    func reloadData(){
        applyValidation = false
        signUpRowsArray = User.sharedInstance.getSignUpData()
        signUpRowsArray = signUpRowsArray.filter {!["continue_btn"].contains($0.placeholdertext)}
        
        // reload form 2
        signUpTableView.reloadData()
        
        // reload from 3
        //regDetailsObject?.signUpDetailRowsArray = User.sharedInstance.getSignUpDetailsData()
        
        //regDetailsObject?.applyValidation = false
        
        //regDetailsObject?.signUpDetailsTableView.reloadData()
        
        //regDetailsObject?.addConfirmPasswordValidation()
    }
    
    func resetPasswordRows(){
        let array = regDetailsObject?.signUpDetailRowsArray
        
        let signUpPassModel = array![4] as SignUpEntity
        signUpPassModel.text = ""
        
        let signUpConfirmPassModel = array![5] as SignUpEntity
        signUpConfirmPassModel.text = ""
        
        let agreementModel = array![6] as SignUpEntity
        agreementModel.isselected=NSNumber(booleanLiteral: false)
        
        regDetailsObject?.applyValidation = false

        regDetailsObject?.signUpDetailsTableView.reloadRows(at: [IndexPath(item: 4, section: 0)], with: .none)
        regDetailsObject?.signUpDetailsTableView.reloadRows(at: [IndexPath(item: 5, section: 0)], with: .none)
        regDetailsObject?.signUpDetailsTableView.reloadRows(at: [IndexPath(item: 6, section: 0)], with: .none)
        
        regDetailsObject?.addConfirmPasswordValidation()

    }

    func setupCustomCellOnUitableView(){
        
        let cellNib = UINib(nibName: SignUpTableViewCell.nameOfClass(), bundle: nil)
        let cellCountinueNib = UINib(nibName: SignUpCountinueCell.nameOfClass(), bundle: nil)
        let cellDriverNib = UINib(nibName: SignUpDriverCell.nameOfClass(), bundle: nil)
        
        signUpTableView.register(cellNib, forCellReuseIdentifier: SignUpTableViewCell.nameOfClass())
        signUpTableView.register(cellCountinueNib, forCellReuseIdentifier: SignUpCountinueCell.nameOfClass())
        signUpTableView.register(cellDriverNib, forCellReuseIdentifier: SignUpDriverCell.nameOfClass())

        signUpTableView.tableFooterView = UIView()
    }
    
    @IBAction func countinueButtonClicked(_ sender: Any) {
        applyValidation = true
        signUpTableView.reloadData()
        self.perform(#selector(applyValidationOnTableView), with: nil, afterDelay: 0.2)
    }

    @objc func applyValidationOnTableView(userType:String ){
    
//        if self.isAllFieldsValidatedSucessfully {
//            Manager.sharedInstance.transitionState=TransitionState.GoingToSignUpDetailScreen
//            User.sharedInstance.signUpObjectArray=signUpRowsArray
//            registerButtonClicked(signUpButton)
//        }
//        isAllFieldsValidatedSucessfully=true
        
        
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
    
    func showAggrementPopUp(userType:String){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: AgrementViewController.nameOfClass()) as! AgrementViewController
        
        cont.userType = userType
        
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            
            User.sharedInstance.signUpObjectArray = self.signUpRowsArray
            User.sharedInstance.signUpDetailsObjectArray = self.signUpRowsArray
            self.postDataToServer(userType: userType)
        }
    }
    
    @objc func addConfirmPasswordValidation(){
        
        let indexPassword = signUpRowsArray.index(where: { $0.placeholdertext == "Password" })!
        let indexConfirmPassword = signUpRowsArray.index(where: { $0.placeholdertext == "Confirm Password" })!
        
        let passFieldIndexPath = IndexPath(item: indexPassword, section: 0)
        let passConfirmFieldIndexPath = IndexPath(item: indexConfirmPassword, section: 0)
        
        if (indexConfirmPassword < signUpTableView.numberOfRows(inSection: 0)), let signUpPassCell =  signUpTableView.cellForRow(at: passFieldIndexPath) as? SignUpTableViewCell,
            let signUpConfrimPassCell = signUpTableView.cellForRow(at: passConfirmFieldIndexPath) as? SignUpTableViewCell{
            signUpConfrimPassCell.textField.addConfirmValidation(to: signUpPassCell.textField, withMsg: ValidationMessages.PasswordMismatchMessage)
        }
        else {
            perform(#selector(addConfirmPasswordValidation), with: nil, afterDelay: 0.5)
        }

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return signUpRowsArray.count
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
        
        let object = signUpRowsArray[indexPath.row]        
        let cell   = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
    
        switch cell {
            
        case is SignUpTableViewCell:
            
            let signupCell = cell as! SignUpTableViewCell
            signupCell.updateCellWithObject(model: object)
            signupCell.actionButton.tag = indexPath.row
            signupCell.textField.tag = indexPath.row
            signupCell.actionButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)

            if applyValidation{
                if signupCell.textField.isMandatory && signupCell.textField.tag == indexPath.row{
                    if !(signupCell.textField.validate()) {
                        isAllFieldsValidatedSucessfully = false
                    }
                }
            }
            break
            
        case is SignUpCountinueCell:
            
//            let signUpCountinueCell = cell as! SignUpCountinueCell
//            signUpCountinueCell.countinueButton.setImage(UIImage(named: object.imagename), for: .normal)
//            signUpCountinueCell.countinueButton.addTarget(self, action: #selector(countinueButtonClicked), for: .touchUpInside)
            let signUpCountinueCell = cell as! SignUpCountinueCell
            signUpCountinueCell.countinueButton.setImage(UIImage(named: object.imagename), for: .normal)
            signUpCountinueCell.countinueButton.addTarget(self, action: #selector(signUpAsUserButtonClicked), for: .touchUpInside)
            
            break
            
        case is SignUpDriverCell:
            let signUpDriverCell = cell as! SignUpDriverCell
            signUpDriverCell.driverSignUpButton.addTarget(self, action: #selector(signUpAsDriverButtonClicked), for: .touchUpInside)
            signUpDriverCell.driverSignUpButton.setImage(UIImage(named: object.imagename), for: .normal)
            break
            
        default: break
        }
        
        return cell
    }
    
    @objc func signUpAsUserButtonClicked() {
        print("signUpAsUserButtonClicked")
        performValidation(userType: UserType.UserNormal)
    }
    
    @objc func signUpAsDriverButtonClicked() {
        print("signUpAsDriverButtonClicked")
        performValidation(userType: UserType.UserDriver)
    }
    
    @objc func performValidation(userType:String){
        applyValidation = true
        signUpTableView.reloadData()
        self.perform(#selector(applyValidationOnTableView), with: userType, afterDelay: 0.2)
    }

    
    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        let signUpObject: SignUpEntity = signUpRowsArray[index]
        
        let shouldCallCustomFunction = Bool(truncating: signUpObject.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = signUpTableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath) as! SignUpTableViewCell
            
            switch signUpObject.customactionname{
            case DropDownOptions.SelectSchool.rawValue:
                selectSchool(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectGender.rawValue:
                selectGender(sender: cell.textField)
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

    
    @objc func selectSchool(sender: UITextField){
        
        view.endEditing(true)
       
        let schoolArray = Utility.getSchoolName()
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: schoolArray as [[String : AnyObject]], typeStr: ApplicationConstants.CollegeNameConstant)
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            sender.text=selectedData["school"] as? String
            self.syncWithPlist(index: sender.tag, value: (selectedData["school"] as? String)!)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectGender(sender: UITextField){
        
        view.endEditing(true)
        let array = Utility.getGenderArray()
        let actionSheet = UIAlertController.init(title: "Gender", message: nil, preferredStyle: .actionSheet)
        
        for (_, value) in array.enumerated() {
            actionSheet.addAction(UIAlertAction.init(title: value, style: UIAlertAction.Style.default, handler: { (action) in
                sender.text=value
                self.syncWithPlist(index: sender.tag, value: value)
                let castTextField = sender as! ValidaterTextField
                castTextField.validate()
            }))
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func selectGraduationYear(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getYearsArray()
        controller.show(controller: self)
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
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
        
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        self.view.endEditing(true)

        switch Manager.sharedInstance.transitionState! {
            
        case .IsOnLoginScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            reloadData()
            delegateLogin?.setupLoginView(sender: signUpButton)
            break
            
        case .GoingBackToLoginScreen:
            if isDataAvailableToLost() {
                showDataLossMessage()
            }
            else{
                Manager.sharedInstance.transitionState=TransitionState.IsOnLoginScreen
                delegateLogin?.setupLoginView(sender: signUpButton)
            }
            break
            
        case .GoingToSignUpDetailScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToSignupScreen
            performAnimationToSignUpDetailsScreen()
            break

        case .GoingBackToSignupScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            resetPasswordRows()
            performAnimationToSignUpDetailsScreen()
            break
            
        case .ComingFromFBSignUp:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            reloadDataForFBSignUp()
            delegateLogin?.setupLoginView(sender: signUpButton)
            break


        default: break
        }
    }
    
    func actionOnTransitionState(){
        self.view.endEditing(true)
        
        switch Manager.sharedInstance.transitionState! {
            
        case .IsOnLoginScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            reloadData()
            delegateLogin?.setupLoginView(sender: signUpButton)
            break
            
        case .GoingBackToLoginScreen:
            if isDataAvailableToLost() {
                showDataLossMessage()
            }
            else{
                Manager.sharedInstance.transitionState=TransitionState.IsOnLoginScreen
                delegateLogin?.setupLoginView(sender: signUpButton)
            }
            break
            
        case .GoingToSignUpDetailScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToSignupScreen
            performAnimationToSignUpDetailsScreen()
            break
            
        case .GoingBackToSignupScreen:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            resetPasswordRows()
            performAnimationToSignUpDetailsScreen()
            break
            
        case .ComingFromFBSignUp:
            Manager.sharedInstance.transitionState=TransitionState.GoingBackToLoginScreen
            reloadDataForFBSignUp()
            delegateLogin?.setupLoginView(sender: signUpButton)
            break
            
            
        default: break
        }
    }
    
        func isDataAvailableToLost()->(Bool){
        var flag =  false
        
        for (_,value) in signUpRowsArray.enumerated(){
            
            let object = value
            if let text = object.text {
                if text.count > 0 {
                    flag = true
                }
            }
        }
        return flag
    }
    
    func performAnimationToSignUpDetailsScreen(){
     
        if self.leadingConstraintFromSignUpButton.constant >= 0 {
            
            self.leadingConstraintFromSignUpButton.constant = -(contentView.frame.size.width)
            
            // animate view to RegistrationDetailsController
            UIView.animate(withDuration: TimeInterval(ApplicationConstants.AnimationDuration), delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.manageStateOnSignupScreen(sender: self.signUpButton)
            }
        }
        else{
            
            // animate back to RegistrationController
            self.leadingConstraintFromSignUpButton.constant = 0.0

            UIView.animate(withDuration: TimeInterval(ApplicationConstants.AnimationDuration), delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.manageStateOnSignupScreen(sender: self.signUpButton)
            }
        }
    }
    
    func manageStateOnSignupScreen(sender:UIButton){
        
        switch Manager.sharedInstance.transitionState! {
            
        case .GoingBackToSignupScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenBackButtonImageName), for: .normal)

            break
            
        case .GoingBackToLoginScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenLoginButtonImageName), for: .normal)
            break
            
        default: break
        }
    }
    
    
    func accountCreated() {
        
        // skip RegistrationDetails Screen transition
        self.leadingConstraintFromSignUpButton.constant = 0.0
        self.view.layoutIfNeeded()

        // Show Number Verifivation Screen
        Manager.sharedInstance.transitionState=TransitionState.ShowNumberVerifivationScreen
        delegateLogin?.setupLoginView(sender: signUpButton)

    }
    
    func syncWithPlist(index:Int , value:String){
        
        let signUpObject: SignUpEntity = signUpRowsArray[index]
        signUpObject.text=value
        print(signUpObject.text)
    }
    
     func showDataLossMessage(){
        
        let alert = UIAlertController(title: "", message: ApplicationConstants.DataLossMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            
        })
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
//            Manager.sharedInstance.transitionState=TransitionState.IsOnLoginScreen
//            self.delegateLogin?.setupLoginView(sender: self.signUpButton)

            self.dismiss(animated: true, completion: nil)
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }


    @IBAction func onBackButtonClicked(_ sender: Any) {
        if isDataAvailableToLost() {
            showDataLossMessage()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue .destination.isKind(of: RegistrationDetailsViewController.self){
            regDetailsObject = segue .destination as? RegistrationDetailsViewController
            regDetailsObject?.accountCreationDelegate = self
        }

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
                self.dismiss(animated: true, completion: nil)
                self.delegateLogin?.accountCreated()
              // self.accountCreationDelegate?.accountCreated()
                break
            case .ShowMesasgeOnAlert?:
                Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                break
                
            default:
                break
            }
            
        }
    }

}
