//
//  UpgradeToDriverViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/2/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class UpgradeToDriverViewController: CameraViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var editProfileObjects: [SignUpEntity]! = []
    var applyValidation: Bool! = false
    var serviceStatus : Bool = false
    var isAllFieldsValidatedSucessfully: Bool! = true
    var indexForInsertImage = 10
    var selectedMakeObject:[String:AnyObject]! = [:]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCustomCell()
        loadTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func updateButtonClicked(sender: UIButton){

        applyValidation = true
        tableView.reloadData()
        self.perform(#selector(applyValidationOnTableView), with: nil, afterDelay: 0.2)
    }
    
    func showAggrementPopUp(){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: AgrementViewController.nameOfClass()) as! AgrementViewController
        
        cont.userType = UserType.UserDriver
        
        cont.show(controller: self.parent!)
        cont.doneButtonTapped = { selectedData in
            self.upgradeDriver()
        }
    }
    
    @objc func applyValidationOnTableView(){
        
        
        if self.isAllFieldsValidatedSucessfully {
            showAggrementPopUp()
        }
        isAllFieldsValidatedSucessfully=true
    }
    
    func upgradeDriver(){
        
        weak var weakSelf = self

        
        User.sharedInstance.signUpDetailsObjectArray = editProfileObjects
        
        var array : [[String: AnyObject]?]? = []
        
        // getting new images which are not posted on server
        for (_,value) in editProfileObjects.enumerated(){
            
            let signUpObject = value
            if (signUpObject.docImage != nil){
                
//                let docImageInfo = ["image" : signUpObject.docImage!,
//                                    "image_key" : ApplicationConstants.UserDocsImageKey,
//                                    "image_type" : ImageType.jpeg.rawValue as AnyObject ,
//                                    "image_compression" : ApplicationConstants.DocImageCompression as AnyObject ]
//                array?.append(docImageInfo)
            }
        }
        
        User.postDataWithPicture(userType: User.getUserType()!, imageParam: (array as? [[String : AnyObject]]), isUpgrading: true, completionHandler:{ (object, message, action, status) in
            
            self.serviceStatus = status!
            let stringMessage = message!["message"] as! String
            
            switch action{
            case .ShowMesasgeAtRunTime?:
                break
            case .DoNotShowMesasgeAtRunTime?:
                break
                
            case .ShowMesasgeOnAlert?:
                Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                break
                
            default:
                break
            }
            
        })
    }


    
    @IBAction func cancelButtonClicked(sender: UIButton){
        navigationController?.popViewController(animated: true)
    }

    func registerCustomCell(){
        
        let cellNib = UINib(nibName: EditProfileLabelCell.nameOfClass(), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: EditProfileLabelCell.nameOfClass())
        
        let cellDocCell = UINib(nibName: DocumentsCell.nameOfClass(), bundle: nil)
        tableView.register(cellDocCell, forCellReuseIdentifier: DocumentsCell.nameOfClass())
        
        let cellAddDoc = UINib(nibName: AddDocumentCell.nameOfClass(), bundle: nil)
        tableView.register(cellAddDoc, forCellReuseIdentifier: AddDocumentCell.nameOfClass())

        let cellUpgradeUserCell = UINib(nibName: UpgradeUserCell.nameOfClass(), bundle: nil)
        tableView.register(cellUpgradeUserCell, forCellReuseIdentifier: UpgradeUserCell.nameOfClass())
        
        let cellSaveChanges = UINib(nibName: SaveChangesCell.nameOfClass(), bundle: nil)
        tableView.register(cellSaveChanges, forCellReuseIdentifier: SaveChangesCell.nameOfClass())
        
        let cellHeading = UINib(nibName: ProfileHeadingCell.nameOfClass(), bundle: nil)
        tableView.register(cellHeading, forCellReuseIdentifier: ProfileHeadingCell.nameOfClass())

        tableView.tableFooterView = UIView()
        
    }
    func loadTableViewData(){
        
        let entity = SignUpEntity.getModel()
        entity.cellidentifier = UpgradeUserCell.nameOfClass()
        
        editProfileObjects.append(entity)
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[10])
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[11])
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[12])
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[13])
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[14])
        
        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[15])
        //editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[16])
        //editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[17])
        //editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[18])
        //editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[19])
        //editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[20])
       // editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[21])
//        editProfileObjects.append(User.sharedInstance.getDriverEditProfileData()[22])
        
        indexForInsertImage = editProfileObjects.count
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editProfileObjects.count
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
        
        let object = editProfileObjects[indexPath.row]
        let cell   = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
        
        switch cell {
            
        case is SignUpTableViewCell:
            
            let signupCell = cell as! SignUpTableViewCell
            signupCell.actionButton.tag=indexPath.row
            signupCell.textField.tag=indexPath.row
            signupCell.updateCellForEditProfile(model: object)
            signupCell.actionButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            
            if applyValidation{
                if !(signupCell.textField.validate()) {
                    isAllFieldsValidatedSucessfully = false
                }
                else{
                    signupCell.textField.rightView = nil
                }
            }
            break
            
        case is ProfileHeadingCell:
            
            let profileHeadingCell = cell as! ProfileHeadingCell
            profileHeadingCell.headingLable.text = object.placeholdertext
            break
            
        case is DocumentsCell:
            
            let cellDocuments = cell as! DocumentsCell
            cellDocuments.addDocumentButton.addTarget(self, action: #selector(addDocumentButtonClicked(sender:)), for: .touchUpInside)
            
            
            break
            
            
        case is AddDocumentCell:
            let cellAddDocumentCell = cell as! AddDocumentCell
            cellAddDocumentCell.docDeleteButton.tag = indexPath.row
            cellAddDocumentCell.docDeleteButton.addTarget(self, action: #selector(deleteButtonClicked(sender:)), for: .touchUpInside)
            if !object.text.isEmpty {
                cellAddDocumentCell.docImageView.af_setImage(withURL: URL(string: object.text)!)
            }
            else{
                cellAddDocumentCell.docImageView.image = object.docImage
            }
            break
            
            
        default: break
        }
        return cell
    }

    
    
    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        let signUpObject: SignUpEntity = editProfileObjects[index]
        
        let shouldCallCustomFunction = Bool(truncating: signUpObject.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = tableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath) as! SignUpTableViewCell
            
            switch signUpObject.customactionname{
                
            case DropDownOptions.SelectVehicleType.rawValue:
                selectVehicle(sender: cell.textField)
                break
                
            case DropDownOptions.SelectCarModelYear.rawValue:
                selectCarModelYear(sender: cell.textField)
                break
                
            case DropDownOptions.SelectEffectiveDate.rawValue:
                selectEffectiveDate(sender: cell.textField)
                break
                
            case DropDownOptions.SelectExpiryDate.rawValue:
                selectExpiryDate(sender: cell.textField)
                break
                
            case DropDownOptions.SelectModel.rawValue:
                selectModel(sender: cell.textField)
                
                break
                
            case DropDownOptions.SelectMake.rawValue:
                selectMake(sender: cell.textField)
                
                break
                
            default: break
            }
        }
    }

    
    @objc func addDocumentButtonClicked(sender:UIButton){
        
        self.view.endEditing(true)
        
        weak var weakSelf = self
        
        // limit user for 5 documents pics
        if editProfileObjects.count >= ( indexForInsertImage + 5 ){
            Utility.showAlertwithOkButton(message: ApplicationConstants.ExceedDocsLimit, controller:weakSelf! )
        }
        else{
            self.isAddingDoc = true
            showCameraOptions()
        }
    }
    
    @objc func selectCarModelYear(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getCarModelYearsArray()
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectEffectiveDate(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectExpiryDate(sender: UITextField){
        
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            
            if (Utility.isDateValid(date: selectedData)){
                sender.text = selectedData
                self.syncWithPlist(index: sender.tag, value: selectedData)
                let castTextField = sender as! ValidaterTextField
                castTextField.validate()
            }
            else{
                Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
            }
        }
    }
    
    
    
    override func updateDocImages(){
        
        let entity = SignUpEntity.getModel()
        entity.cellidentifier = AddDocumentCell.nameOfClass()
        entity.text = ""
        entity.docImage = docImage
        editProfileObjects.append(entity)
        tableView.reloadData()
        docImage = nil
    }

    
    @objc func deleteButtonClicked(sender:UIButton){
        let tag = sender.tag
        
        let model : SignUpEntity = editProfileObjects[tag]
        
        if (model.docImage != nil) {
            
        }
        else{
            
        }
        
        self.editProfileObjects.remove(at: tag)
        tableView.deleteRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
        tableView.reloadData()
    }
    
    
    @objc func selectVehicle(sender: UITextField){
        
        view.endEditing(true)
        let controller = CustomPickerViewController.createPickerController(storyboardId: CustomPickerViewController.nameOfClass())
        controller.contentArray = Utility.getVehicles()
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            sender.text=selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
 }
    @objc func selectMake(sender: UITextField){
        
        view.endEditing(true)
        
        let schoolArray = Utility.getVehicleMakeName()
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: schoolArray as [[String : AnyObject]], typeStr: "Vehicle Make")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            self.selectedMakeObject = selectedData
            sender.text=selectedData["name"] as? String
            self.syncWithPlist(index: sender.tag, value: sender.text!)
            self.syncWithPlist(index: sender.tag+1, value: "")
            self.tableView.reloadData()
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectModel(sender: UITextField){
        
        view.endEditing(true)
        
        if self.selectedMakeObject["models"] == nil{
            return
        }
        let modelArray = Utility.getModelNameArray(modelNames: self.selectedMakeObject["models"] as! [String])
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: modelArray as [[String : AnyObject]], typeStr: "Vehicle Model")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            sender.text=selectedData["name"] as? String
            self.syncWithPlist(index: sender.tag, value: sender.text!)
            
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }


    func syncWithPlist(index:Int , value:String){
        
        let signUpObject: SignUpEntity = editProfileObjects[index]
        signUpObject.text=value
    }
    
    
    @objc override func alertOkButtonHandler(){
        if serviceStatus{
            navigationController?.popViewController(animated: true)
        }
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
