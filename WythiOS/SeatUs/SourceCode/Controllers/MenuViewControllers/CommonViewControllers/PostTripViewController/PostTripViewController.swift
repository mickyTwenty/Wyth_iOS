//
//  PostTripViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker


class PostTripViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var placesClient: GMSPlacesClient!

    var slectedIndex : Int = -1
    var contentArray : [PostTrip]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.syncContacts()
        registerCustomCell()
        loadTableViewData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTripName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func showRoutSelectionScreen(){
        
        saveTripName()
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: RouteSelectionViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)
    }
    func registerCustomCell(){
        
        for cell in [TextFieldCell.nameOfClass(), LabelCell.nameOfClass(), DateButtonCell.nameOfClass(), MultipleCheckboxCell.nameOfClass(), SelectSeatsCell.nameOfClass(), ButtonCell.nameOfClass(), HorizontalScrollCell.nameOfClass(), CheckboxCell.nameOfClass(), ActionButtonCell.nameOfClass(), MultiLabelCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.clear
        
    }
    
    func calculateDistance(){
        
        let tripOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: contentArray)
        let destinationOriginObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: contentArray)

        if (!(tripOriginObject.address.isEmpty) && !(destinationOriginObject.address.isEmpty))
        {
        
            PostTrip.calculateRoutePriceEstimation(fromOrigin: tripOriginObject.address, toDestination: destinationOriginObject.address, completionHandler: { (object, message, active, status, error) in
                if status!{
                    
                    let estimateObject = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripEstimates, array: self.contentArray)
                    estimateObject.placeholdertext = object
                    _ = DataPersister.sharedInstance.saveTrip(trip: estimateObject)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func loadTableViewData(){
        
        contentArray = PostTrip.getPostTripData(name: FileNames.PostTripPlist)
        
        let trip = DataPersister.sharedInstance.getTripInfo()
        
        if (trip != nil) {
            
//            let objectTripName = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripName, array: contentArray)
//            if trip?.trip_name != nil{
//                objectTripName.placeholdertext = (trip?.trip_name)
//            }

            let objectGender = Utility.getPostTripModel(key: PlistPlaceHolderConstant.genderPlaceHolder, array: contentArray)
            if trip?.gender != nil{
                objectGender.placeholdertext = (trip?.gender)
            }
            
            let object = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripOrigin, array: contentArray)
            
            if trip?.origin != nil{
                object.placeholdertext = (trip?.origin)
                object.address = trip?.originCoordinates
            }

            
            let objectDest = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDestination, array: contentArray)
            
            if trip?.destination != nil{
                objectDest.placeholdertext = trip?.destination
                objectDest.address = trip?.destinationCoordinates
            }

            
            let objectEstimates = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripEstimates, array: contentArray)
            
            if trip?.estimate != nil{
                objectEstimates.placeholdertext = trip?.estimate
            }
            
            let objectDate = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripDate, array: contentArray)
            
            if trip?.date != nil{
                objectDate.placeholdertext = trip?.date
            }
            
            let objectBooknow = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripBookNow, array: contentArray)
            objectBooknow.isselected = NSNumber(booleanLiteral: (trip?.bookNow)!)
            
            var objectTimeOfDay = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripTimeOfDay, array: contentArray)
            
            var refrenceValueString = ""
            if trip?.timeOfDay != nil{
                refrenceValueString = (trip?.timeOfDay)!
            }
            
            let objectSeats = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripSeats, array: contentArray)
            if trip?.seats != nil{
                objectSeats.placeholdertext = (trip?.seats)!
            }
            
            let objectRoundTrip = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripRoundTrip, array: contentArray)
            objectRoundTrip.isselected = NSNumber(booleanLiteral: (trip?.roundTrip)!)

            objectTimeOfDay =  Utility.setTimeOfDay(trip: objectTimeOfDay, thresholdDay: refrenceValueString) 
            
        }
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @objc func dropDownButtonPressed(sender:UIButton!) {
        
        let index = sender.tag
        slectedIndex = sender.tag
        let postTrip: PostTrip = contentArray[index]
        
        let shouldCallCustomFunction = Bool(truncating: postTrip.hascustomaction as NSNumber)
        if shouldCallCustomFunction{
            
            let cell = tableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath)
            
            switch postTrip.customactionname{
            
            case DropDownOptions.WriteTripName.rawValue:
                let labelCell = cell as! LabelCell
                witeTripNamePopup(label: labelCell.contentLabel)
                break;

            case DropDownOptions.SelectOrigin.rawValue:
                let labelCell = cell as! LabelCell
                showPlacePicker(locationAddressLable: labelCell.contentLabel)
                break;
                
            case DropDownOptions.SelectDestination.rawValue:
                let labelCell = cell as! LabelCell
                showPlacePicker(locationAddressLable: labelCell.contentLabel)

                break;
                
            case DropDownOptions.SelectDate.rawValue:
                let dateCell = cell as! DateButtonCell
                selectDOB(label: dateCell.dateLabel, index: index)
                break;
                
            case DropDownOptions.SelectGender.rawValue:
                let labelCell = cell as! LabelCell
                selectGender(sender: labelCell.contentLabel)
                break

                
            default: break
            }
        }
    }
    
    
    func showPlacePicker(locationAddressLable:UILabel ){
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    @objc func selectGender(sender: UILabel){
        
        view.endEditing(true)
        let array = Utility.getGenderArrayForRidePrephences()
        let actionSheet = UIAlertController.init(title: "Gender", message: nil, preferredStyle: .actionSheet)
        
        for (_, value) in array.enumerated() {
            actionSheet.addAction(UIAlertAction.init(title: value, style: UIAlertAction.Style.default, handler: { (action) in
                sender.text = value
                self.syncWithPlist(index: sender.tag, value: value)
            }))
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }

    
    func witeTripNamePopup(label:UILabel){
        print("witeTripNamePopup")
    }

    
    func setDataOnTableView(){
        self.tableView.reloadData()
        self.calculateDistance()
    }
    
    @objc func selectDOB(label: UILabel, index: Int){
        
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self)
        controller.doneButtonTapped = { selectedData in
            
            if (Utility.isDateValid(date: selectedData)){
                label.text = selectedData
                self.syncWithPlist(index: index, value: selectedData)
            }
            else{
                Utility.showAlertwithOkButton(message: ApplicationConstants.PastDateMessage, controller: self)
            }
        }
    }
    
    func syncWithPlist(index:Int , value:String){
        
        let postTrip: PostTrip = contentArray[index]
        postTrip.placeholdertext = value
        _ = (DataPersister.sharedInstance.saveTrip(trip: postTrip))
    }

    func isEmpty(titleKey: String, placeHolderText: String) -> Bool{
        let object = Utility.getPostTripModel(key: titleKey, array: contentArray)
        if object.placeholdertext != nil {
            return (object.placeholdertext == placeHolderText)
        }else{
            return true
        }
    }
    
    func isVerifiedFields() -> String {
        var emptyFields = [String]()
        
        if isEmpty(titleKey: PlistPlaceHolderConstant.PostTripOrigin, placeHolderText: PlistPlaceHolderConstant.PlaceHolderForMap) {
            emptyFields.append(PlistPlaceHolderConstant.PostTripOrigin)
        }
        
        if isEmpty(titleKey: PlistPlaceHolderConstant.PostTripDestination, placeHolderText: PlistPlaceHolderConstant.PlaceHolderForMap) {
            emptyFields.append(PlistPlaceHolderConstant.PostTripDestination)
        }
        
        if isEmpty(titleKey: PlistPlaceHolderConstant.PostTripDate, placeHolderText: PlistPlaceHolderConstant.PlaceHolderDate) {
            emptyFields.append(PlistPlaceHolderConstant.PostTripDate)
        }
        
        let checkboxStates = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripTimeOfDay, array: contentArray)
        
        let selectedCheckboxes = CheckboxState.getCheckboxState(checkboxStates.checkboxes).filter { ($0.isselected == 1) }.count
        
        if selectedCheckboxes <= 0 {
            emptyFields.append(checkboxStates.title)
        }
        
        var message = ""
        
        if emptyFields.count > 0 {
            message = WarningMessage.PleaseSelectText
            message += emptyFields.joined(separator: ", ")
            message += WarningMessage.BeforeProceedingText
        }
        
        return message
    }
    
    func clearTripName(){
        PostTrip.unSetTripName()
    }
    
    func saveTripName(){
        let objectTripName = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripName, array: contentArray)
        _ = DataPersister.sharedInstance.saveTrip(trip: objectTripName)
        objectTripName.placeholdertext = ""
    }
    
}

extension PostTripViewController : GMSPlacePickerViewControllerDelegate {

    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.

        let model = contentArray[slectedIndex]
        if (place.formattedAddress != nil){
            model.address = Utility.getCoordinateString(byCLLocationCoordinate2D: place.coordinate)
            syncWithPlist(index: slectedIndex, value: place.formattedAddress!)
        }
            
        else{
            placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(place.placeID ?? "", callback: { (objGMSPlace, error) in
                if (objGMSPlace != nil){
                    model.address = Utility.getCoordinateString(byCLLocationCoordinate2D: place.coordinate)

                    self.syncWithPlist(index: self.slectedIndex, value: (objGMSPlace?.formattedAddress)!)
                    self.setDataOnTableView()
                }
            })
        }
        setDataOnTableView()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}


extension PostTripViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = contentArray[indexPath.row]
        let cell   = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
        cell.tag = indexPath.row

        switch cell {
        
        case is LabelCell:

            let labelCell = cell as! LabelCell
            labelCell.initializeCell(contentArray[indexPath.row])
            labelCell.selectButton.tag = indexPath.row
            labelCell.contentLabel.tag = indexPath.row
            labelCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
        
        case is DateButtonCell:
            
            let dateCell = cell as! DateButtonCell
            dateCell.initializeCell(contentArray[indexPath.row])
            dateCell.selectButton.tag = indexPath.row
            dateCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
            
        case is MultipleCheckboxCell:

            let multipleCheckboxCell = cell as! MultipleCheckboxCell
            multipleCheckboxCell.initializeCell(contentArray[indexPath.row])
            multipleCheckboxCell.tag = indexPath.row
            multipleCheckboxCell.delegate = self
            break

        case is ButtonCell:

            let buttonCell = cell as! ButtonCell
            buttonCell.initializeCell(contentArray[indexPath.row])
            buttonCell.tag = indexPath.row
            buttonCell.delegate = self
            break

        case is CheckboxCell:

            let checkboxCell = cell as! CheckboxCell
            checkboxCell.initializeCell(contentArray[indexPath.row])
            checkboxCell.tag = indexPath.row
            checkboxCell.delegate = self
            break

        case is SelectSeatsCell:

            let seatsTableViewCell = cell as! SelectSeatsCell
            seatsTableViewCell.initializeCell(contentArray[indexPath.row])
            seatsTableViewCell.tag = indexPath.row
            seatsTableViewCell.delegate = self
            break
            
        case is HorizontalScrollCell:
            
            let horizontalScrollCell = cell as! HorizontalScrollCell
            horizontalScrollCell.initializeCell(contentArray[indexPath.row])
            horizontalScrollCell.delegate = self
            horizontalScrollCell.tag = indexPath.row
            break
            
        case is ActionButtonCell:
            
            let actionButtonCell = cell as! ActionButtonCell
            actionButtonCell.initializeCell(contentArray[indexPath.row])
            actionButtonCell.delegate = self
            break

        case is TextFieldCell:
            
            let textFieldCell = cell as! TextFieldCell
            textFieldCell.initializeCell(contentArray[indexPath.row])
            textFieldCell.delegate = self
            break
            
        default: break
            
       }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = contentArray[indexPath.row]
        
        if object.cellidentifier == HorizontalScrollCell.nameOfClass(){
            return CGFloat(130)
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
}

extension PostTripViewController: MultipleCheckboxCellDelegate {
   
    func rideTimeButtonClicked(){
    }

    func clickEvent(_ tag: Int, CheckboxStates checkboxStates: [CheckboxState]) {
        let index = tag
        let postTrip: PostTrip = contentArray[index]
        postTrip.checkboxes.removeAll()
        for checkboxState in checkboxStates{
            let keys = Mirror(reflecting: checkboxState).children
            var dict = [String:Any]()
            for key in keys{
                dict[key.label!] = key.value
            }
            postTrip.checkboxes.append(dict)
        }
        _ = DataPersister.sharedInstance.saveTrip(trip: postTrip)

    }
}

extension PostTripViewController: ActionButtonCellDelegate {
    func leftButtonClicked(_ sender: Any) {
        let alertMessage = isVerifiedFields()
        if alertMessage.isEmpty {
            
            let trip_origin = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoOrigin) as! String
            let trip_destination = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDestination) as! String
            
            if trip_origin.compare(trip_destination) == .orderedSame {
                Utility.showAlertwithOkButton(message: ApplicationConstants.SameAddressMessage, controller: self)
                return
            }
            setInviteType()

            showRoutSelectionScreen()
            
        }else{
            Utility.showAlertwithOkButton(message: alertMessage, controller: self)
        }
    }
    
    func rightButtonClicked(_ sender: Any) {
        
        
        let alertMessage = isVerifiedFields()
        if alertMessage.isEmpty {
            
            setInviteType()
            let  controller = self.storyboard?.instantiateViewController(withIdentifier: AddFriendsViewController.nameOfClass()) as! AddFriendsViewController
            navigationController?.pushViewController(controller, animated: true)

            
        }else{
            Utility.showAlertwithOkButton(message: alertMessage, controller: self)
        }
    }
    
    func setInviteType(){
        
        switch Utility.getUserType(){
            
        case UserType.UserNormal:
            Manager.sharedInstance.inviteType = InviteCategory.UserCreate
            break
            
        case UserType.UserDriver:
            Manager.sharedInstance.inviteType = InviteCategory.DriverCreate
            break
            
        default:
            break
            
        }

    }
}

extension PostTripViewController: ButtonCellDelegate {
    func clickEvent(ButtonIndex tag: Int, isSelected: Bool) {
        let index = tag
        let postTrip: PostTrip = contentArray[index]
        postTrip.isselected = isSelected as NSNumber
        _ = DataPersister.sharedInstance.saveTrip(trip: postTrip)
        
    }
}


extension PostTripViewController: CheckboxCellDelegate {
    func clickEvent(CheckboxIndex tag: Int, isSelected: Bool) {
        let index = tag
        let postTrip: PostTrip = contentArray[index]
        postTrip.isselected = isSelected as NSNumber
        _ = DataPersister.sharedInstance.saveTrip(trip: postTrip)
    }
}

extension PostTripViewController: HorizontalScrollCellDelegate {
    func clickEvent(_ tag: Int, itemTag: Int, selectedStates: [Int : Bool]) {
        Utility.updatePreference(itemTag: itemTag, selectedStates: selectedStates)
    }
}

extension PostTripViewController: SelectSeatsCellDelegate{
    func seatsLimit(_ message: String) {
        Utility.showAlertwithOkButton(message: message, controller: self)
    }
    func clickEvent(tag: Int, seatsCount: Int){
        
        let index = tag
        let postTrip: PostTrip = contentArray[index]
        postTrip.placeholdertext = "\(seatsCount)"
        _ = DataPersister.sharedInstance.saveTrip(trip: postTrip)
    }

}

extension PostTripViewController: TextFieldCellDelegate {
    func textChanged(TextFieldCell tag: Int, _ text: String) {
        let postTrip: PostTrip = contentArray[tag]
        postTrip.placeholdertext = text
    }
}


