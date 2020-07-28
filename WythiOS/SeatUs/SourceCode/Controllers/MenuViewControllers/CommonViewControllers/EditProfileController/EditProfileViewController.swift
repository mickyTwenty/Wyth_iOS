//
//  EditProfileViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/23/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class EditProfileViewController: CameraViewController,UITableViewDataSource,UITableViewDelegate {

    // MARK: - Outlets
    var editProfileObjects: [SignUpEntity]!
    @IBOutlet weak var editProfileTableView: UITableView!
    var applyValidation: Bool! = false
    var isAllFieldsValidatedSucessfully: Bool! = true
    var selectedStateID:String!
    var serviceStaus : Bool = false
    var totalRowsCount = 14
    var indexForInsertImage = 14
    var selectedMakeObject:[String:AnyObject]! = [:]

    // MARK: - ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadTableViewData()
        parseValues()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataOnTableView), name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)


    }
    
    @objc func reloadDataOnTableView(){
        editProfileTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - TableView methods
    
    func loadTableViewData(){
        
        // Register Nib
        let cellNib = UINib(nibName: EditProfileLabelCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellNib, forCellReuseIdentifier: EditProfileLabelCell.nameOfClass())
        
        let cellEditProfileCell = UINib(nibName: EditProfileCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellEditProfileCell, forCellReuseIdentifier: EditProfileCell.nameOfClass())
        
        let cellSaveChangesCell = UINib(nibName: SaveChangesCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellSaveChangesCell, forCellReuseIdentifier: SaveChangesCell.nameOfClass())

        
        let cellDocCell = UINib(nibName: DocumentsCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellDocCell, forCellReuseIdentifier: DocumentsCell.nameOfClass())
        
        
        let cellAddDoc = UINib(nibName: AddDocumentCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellAddDoc, forCellReuseIdentifier: AddDocumentCell.nameOfClass())


        let cellHeading = UINib(nibName: ProfileHeadingCell.nameOfClass(), bundle: nil)
        editProfileTableView.register(cellHeading, forCellReuseIdentifier: ProfileHeadingCell.nameOfClass())

        editProfileTableView.tableFooterView = UIView()
        
        switch User.getUserType() {
        case UserType.UserNormal?:
            editProfileObjects = User.sharedInstance.getPassengerEditProfileData()

            break
        case UserType.UserDriver?:
            editProfileObjects = User.sharedInstance.getDriverEditProfileData()
            break
            
        default:
            break
        }

        
        editProfileTableView.dataSource = self
        editProfileTableView.delegate = self
    }
    
    func parseValues(){

        let dateString = Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateFormatClient, dateString: User.sharedInstance.birth_date!)

        let modeldob : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.DobPlaceHolder, array: editProfileObjects!)
        modeldob.text = dateString

        let modelGender : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.genderPlaceHolder, array: editProfileObjects!)
        modelGender.text = User.sharedInstance.gender
        
        let modelPhone : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.PhoneNumberPlaceHolder, array: editProfileObjects!)
        modelPhone.text = Utility.getFormatedNumber(phoneNumber: User.sharedInstance.phone!)

        let modelZip : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.ZipPlaceHolder, array: editProfileObjects!)
        modelZip.text = User.sharedInstance.postal_code
        
        let modelSchool : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.SchoolNamePlaceHolder, array: editProfileObjects!)
        modelSchool.text = User.sharedInstance.school_name

        let modelEmail : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.EmailPlaceHolder, array: editProfileObjects!)
        modelEmail.text = User.sharedInstance.email
        
        let modelOrg : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.SchoolOrganizationPlaceHolder, array: editProfileObjects!)
        modelOrg.text = User.sharedInstance.student_organization

        let modelGradYear : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.GraduationPlaceHolder, array: editProfileObjects!)
        modelGradYear.text = User.sharedInstance.graduation_year
        
        let modelState : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.StatePlaceHolder, array: editProfileObjects!)
        modelState.text = User.sharedInstance.state_text
        
        let modelCity : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.CityPlaceHolder, array: editProfileObjects!)
        modelCity.text = User.sharedInstance.city_text

        let modelVehicle : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.VehiclePlaceHolder, array: editProfileObjects!)
        modelVehicle.text = User.sharedInstance.vehicle_type
        
        let modelLicense : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.LicencePlaceHolder, array: editProfileObjects!)
        modelLicense.text = User.sharedInstance.driving_license_no
        
        let vehicleIDNumber : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.VehicleIDPlaceHolder, array: editProfileObjects!)
        vehicleIDNumber.text = User.sharedInstance.vehicle_id_number
        
        let vehicleMake : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.MakePlaceHolder, array: editProfileObjects!)
        vehicleMake.text = User.sharedInstance.vehicle_make
        
        if !(User.sharedInstance.vehicle_make?.isEmpty)! {
            self.selectedMakeObject = Utility.getSelectedVehicleMakeObject(makeName: vehicleMake.text)

        }
        let vehicleModel : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.ModelPlaceHolder, array: editProfileObjects!)
        vehicleModel.text = User.sharedInstance.vehicle_model
        
        
        let vehicleYear : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.YearPlaceHolder, array: editProfileObjects!)
        vehicleYear.text = User.sharedInstance.vehicle_year
        
        let ssn : SignUpEntity  = Utility.getModel(key: PlistPlaceHolderConstant.SSNPlaceHolder, array: editProfileObjects!)
        ssn.text = User.sharedInstance.ssn
        

        self.selectedStateID = User.sharedInstance.state?.stringValue

        totalRowsCount = editProfileObjects.count
        
        indexForInsertImage = totalRowsCount - 1
        
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
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // use as? or as! to cast UITableViewCell to your desired type
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            if applyValidation {
                applyValidationOnTableView()
                applyValidation = false
            }
        }
    }
 */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = editProfileObjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
        
        switch cell {
            
        case is EditProfileLabelCell:
            
            let signupCell = cell as! EditProfileLabelCell
            signupCell.actionButton.tag=indexPath.row
            signupCell.textField.tag=indexPath.row
            signupCell.updateCellForEditProfile(model: object)
            
            signupCell.actionButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)

            if applyValidation{
                if signupCell.textField.isMandatory && signupCell.textField.tag == indexPath.row{
                    if !(signupCell.textField.validate()) {
                        //print("validate false")
                        print(object.placeholdertext)
                        isAllFieldsValidatedSucessfully = false
                    }
                }
            }
            break
            
        case is SaveChangesCell:
            
            let saveChangesCell = cell as! SaveChangesCell
            saveChangesCell.saveButton.addTarget(self, action: #selector(saveButtonClicked(sender:)), for: .touchUpInside)
            saveChangesCell.cancelButton.addTarget(self, action: #selector(cancelButtonClicked(sender:)), for: .touchUpInside)

            break
            
        case is EditProfileCell:
            
            let editProfileCell = cell as! EditProfileCell
            editProfileCell.nameLable.text = User.getUserName()
            let url = URL(string: User.getProfilePictureUrl()!)
            if (selectedImage != nil) {
                editProfileCell.userImageView.image = selectedImage
            }
            else{
                editProfileCell.userImageView.af_setImage(withURL: url!)
            }
            editProfileCell.userImageView.setRounded()
            editProfileCell.changePicButton.addTarget(self, action: #selector(showImagePicker(sender:)), for: .touchUpInside)
            
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

    
    
    // MARK: - Custom button actions
    
    @objc func addDocumentButtonClicked(sender:UIButton){
        
        self.view.endEditing(true)
        
        weak var weakSelf = self

        if editProfileObjects.count >= (totalRowsCount + 5) {
            Utility.showAlertwithOkButton(message: ApplicationConstants.ExceedDocsLimit, controller:weakSelf! )
        }
        else{
            self.isAddingDoc = true
            showCameraOptions()
        }
    }
    
    override func updateDocImages(){
        
        let entity = SignUpEntity.getModel()
        entity.cellidentifier = AddDocumentCell.nameOfClass()
        entity.text = ""
        entity.docImage = docImage
        editProfileObjects.insert(entity, at: indexForInsertImage)
        editProfileTableView.reloadData()
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
        editProfileTableView.deleteRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
        editProfileTableView.reloadData()
    }

    @objc func saveButtonClicked(sender:UIButton){
        applyValidation = true
        editProfileTableView.reloadData()
        self.perform(#selector(applyValidationOnTableView), with: nil, afterDelay: 0.2)
    }
    
    @objc func removePicture(){
        

    }


    @objc func applyValidationOnTableView(){
        
        weak var weakSelf = self

        if self.isAllFieldsValidatedSucessfully {
            User.sharedInstance.signUpDetailsObjectArray = editProfileObjects
            
            var array : [[String: AnyObject]?]? = []
            // getting profile image
            if (selectedImage != nil){
                
                let imageInfo = ["image" : selectedImage!,
                                 "image_key" : ApplicationConstants.UserProfileImageKey,
                                 "image_type" : ImageType.jpeg.rawValue as AnyObject ,
                                 "image_compression" : ApplicationConstants.ProfileImageCompression as AnyObject ]
                array  = [imageInfo] as [[String: AnyObject]?]?
            }
            
            
            // getting new images which are not posted on server
            for (_,value) in editProfileObjects.enumerated(){
                
                let signUpObject = value
                if (signUpObject.docImage != nil){
                    
//                    let docImageInfo = ["image" : signUpObject.docImage!,
//                                     "image_key" : ApplicationConstants.UserDocsImageKey,
//                                     "image_type" : ImageType.jpeg.rawValue as AnyObject ,
//                                     "image_compression" : ApplicationConstants.DocImageCompression as AnyObject ]
//                    array?.append(docImageInfo)
                }
            }
            
            User.postDataWithPicture(userType: User.getUserType()!, imageParam: (array as? [[String : AnyObject]]), completionHandler: { (object, message, action, status) in
                
                self.serviceStaus = status!
                let stringMessage = message!["message"] as! String
                
                switch action{
                case .ShowMesasgeAtRunTime?:
                    break
                case .DoNotShowMesasgeAtRunTime?:
                    break
                    
                case .ShowMesasgeOnAlert?:
                    NotificationCenter.default.post(name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)
                    Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                    break
                    
                default:
                    break
                }
                
            })
        }
        isAllFieldsValidatedSucessfully=true
    }

    
    @objc func cancelButtonClicked(sender:UIButton){
        navigationController?.popViewController(animated: true)
    }

    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        let signUpObject: SignUpEntity = editProfileObjects[index]
        
        let shouldCallCustomFunction = Bool(truncating: signUpObject.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = editProfileTableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath) as! EditProfileLabelCell
            
            switch signUpObject.customactionname{
                
            case DropDownOptions.SelectDOB.rawValue:
                selectDOB(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectGender.rawValue:
                selectGender(sender: cell.textField)
                break
                
            case DropDownOptions.SelectCity.rawValue:
                selectCity(sender: cell.textField)
                break;

            case DropDownOptions.SelectState.rawValue:
                selectState(sender: cell.textField)
                break;
                
            case DropDownOptions.SelectGraduationYear.rawValue:
                selectGraduationYear(sender: cell.textField)
                break
                
            case DropDownOptions.SelectVehicleType.rawValue:
                selectVehicle(sender: cell.textField)
                break

            case DropDownOptions.SelectSchool.rawValue:
                selectSchool(sender: cell.textField)
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


    @objc func selectState(sender: UITextField){
        
        let stateList = WorldLocation.getStatesList(countryID : ApplicationConstants.CountryIdUS)
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: stateList as! [[String : AnyObject]], typeStr: "State")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            let selectedState = selectedData["name"] as? String
            self.selectedStateID = (selectedData["id"] as? NSNumber)?.stringValue
            sender.text=selectedState
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
            self.syncWithPlist(index: sender.tag, value: selectedState!)
            self.syncWithPlist(index: sender.tag+1, value: "")
            self.editProfileTableView.reloadData()
        }
    }
    
    
    @objc func selectCity(sender: UITextField){
        
        if (!(selectedStateID != nil)){
            return
        }
        let citiesList = WorldLocation.getCitiesList(stateId: selectedStateID)
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: citiesList as! [[String : AnyObject]], typeStr: "City")
        searchPicker.show(vc: self)
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
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            sender.text = selectedData
            self.syncWithPlist(index: sender.tag, value: selectedData)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
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
    
    @objc func selectSchool(sender: UITextField){
        
        view.endEditing(true)
        
        let schoolArray = Utility.getSchoolName()

        let searchPicker = SearchAndFindPicker.createPicker(dataArray: schoolArray as [[String : AnyObject]], typeStr: "College Name")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            sender.text=selectedData["school"] as? String
            self.syncWithPlist(index: sender.tag, value: sender.text!)
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectMake(sender: UITextField){
        
        view.endEditing(true)
        
        let makeArray = Utility.getVehicleMakeName()
        
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: makeArray as [[String : AnyObject]], typeStr: "Vehicle Make")
        searchPicker.show(vc: self)
        searchPicker.doneButtonTapped =  { selectedData in
            
            self.selectedMakeObject = selectedData
            sender.text=selectedData["name"] as? String
            self.syncWithPlist(index: sender.tag, value: sender.text!)
            self.syncWithPlist(index: sender.tag+1, value: "")
            self.editProfileTableView.reloadData()
            let castTextField = sender as! ValidaterTextField
            castTextField.validate()
        }
    }
    
    @objc func selectModel(sender: UITextField){
        
        view.endEditing(true)
        
        if self.selectedMakeObject["models"] != nil {
            
            print(self.selectedMakeObject["models"])

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
        
    }

    @objc func showImagePicker(sender: UIButton){
        self.isAddingDoc = false
        
        if !((User.getProfilePictureUrl())!.contains(AssetsName.defaultProfileName)) || selectedImage != nil {
            self.isComingFromChangeDP = true
        }
        showCameraOptions()
    }
    
    override func updateImageToView(){
        let cell =  editProfileTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! EditProfileCell
        cell.userImageView.image = selectedImage
    }

    
    func syncWithPlist(index:Int , value:String){

        let signUpObject: SignUpEntity = editProfileObjects[index]
        signUpObject.text=value
    }

    @objc override func alertOkButtonHandler(){
        if serviceStaus{
            navigationController?.popViewController(animated: true)
        }
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
