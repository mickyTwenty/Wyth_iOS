//
//  CreateTripModifiedController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 3/22/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import FZAccordionTableView


class CreateTripModifiedController: BaseViewController {

    var serviceStatus = false
    var selectedRoute : Route! = Route()
    var sectionsArray : [CreateTripEntity]! = []
    @IBOutlet weak var tableView: FZAccordionTableView!
    
    var currentDriver : Driver? = nil
    
//    var cellsArray : [PostTrip]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCustomCell()
        addObjects()
        
        refreshDriverList()
    }
    
    func setButtonDependentOnUserSelectedType(button:UIButton){
        switch (Utility.getUserType()){
            
        case UserType.UserDriver:
            button.setImage(UIImage(named: AssetsName.PostRideButtonImageName), for: .normal)
            break
            
        case UserType.UserNormal:
            break
            
        default :
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CreateTripDetails.shared.clear()
    }
    
    override func driverUpdated(driver: [String : Any]?) {
        if let driver = driver {
            self.addDriverToList(driver: driver)
        }
        else{
            self.deleteDriverFromList()
        }
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.CreateRideHelp
        
        present(controller, animated: true, completion: nil)
    }
    
    func isVerified() -> Bool {
        for section in sectionsArray {
            
            let objectIdentifier = section.objectIdentifier ?? ""
            
            switch objectIdentifier {
                
            case CreateTripEntityConstant.sectionOneEntity:
                
                var isVerified = true
                
                let object = section.rowsArray[0]
                
                let thresholdDayStates = ["1","2","3","4","5","6","7"]
                let seatsStates = ["1","2","3","4","5","6","7","8"]
                
                
                if !thresholdDayStates.contains(object.text ?? "") {
                    isVerified = false
                }
                
                if !isVerified {
                    
                    Utility.showAlertwithOkButton(message: "Please Select Time Of Day before proceeding", controller: self)
                    return isVerified
                }
                
                let trip_date_str = DataPersister.getTripInfo(forKey: CoreDataConstants.TripInfoDate) as! String
                let trip_date = Utility.getDateFromString(date: trip_date_str, format: ApplicationConstants.DateFormatClient)
                
                let current_day = Calendar.current.component(.day, from: Date())
                
                let trip_day = Calendar.current.component(.day, from: trip_date)
                
                if current_day == trip_day {
                    
                    let hour = Calendar.current.component(.hour, from: Date())
                    
                    let isTimePassed =  PostTrip.isTimeSlotPassed(hour: hour, thresholdTime: Int(object.text)!)
                    
                    if isTimePassed {
                        Utility.showAlertwithOkButton(message: "The selected time of the day has passed. Please select an another time of the day.", controller: self)
                        return false
                    }
                }

                
                if !isPassenger() {
                    
                    if !seatsStates.contains(object.placeholdertext ?? "") {
                        isVerified = false
                    }
                    
                    if !isVerified {
                        
                        Utility.showAlertwithOkButton(message: "Please Select Seats before proceeding", controller: self)
                        return isVerified
                    }
                }
                
                if isRoundTrip() {
                    
                    if !thresholdDayStates.contains(object.title ?? "") {
                        isVerified = false
                    }
                    
                    if !isVerified {
                        
                        Utility.showAlertwithOkButton(message: "Please Select Return Time Of Day before proceeding", controller: self)
                        
                        return isVerified
                        
                    }
                    
                    if !isPassenger() {
                        
                        if !seatsStates.contains(object.expected_start_time ?? "") {
                            isVerified = false
                        }
                        
                        if !isVerified {
                            
                            Utility.showAlertwithOkButton(message: "Please Select Return Seats before proceeding", controller: self)
                            
                            return isVerified
                            
                        }
                        
                    }
                    
                }
                
                return isVerified
                
                break
                
            default:
                break
                
            }
            
            
        }
        
        return false
    }
    
    // Passenger Methods
    
    func showDriverScreen(){
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: FriendsSearchViewController.nameOfClass()) as! FriendsSearchViewController
        controller.addingFreinds = AddingFreinds.isComingForDriverOnly
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func refreshDriverList() {
        if isPassenger() && Manager.sharedInstance.driver  != nil{
            addDriverToList(driver: Manager.sharedInstance.driver!)
        }
    }
    
    func deleteDriverFromList(){
        
        if (currentDriver != nil) {
            Manager.sharedInstance.driver = nil
            refreshDriverList()
            currentDriver = nil
        }
        
    }
    
    func addDriverToList(driver:[String:Any]){
        
        let sections = sectionsArray.filter( { ($0.objectIdentifier ?? "") == CreateTripEntityConstant.sectionThreeEntity } ).first
        
        var rows = sections?.rowsArray.filter( { $0.cellidentifier != InvitedDriverCell.nameOfClass() } )
        
//        if (rows?.count ?? 0) > 2  {
//            rows = [(rows?.first!)!,(rows?.last!)!]
//        }
//
        let freinds = PostTrip()
        freinds.cellidentifier = InvitedDriverCell.nameOfClass()
        freinds.title = InvitedDriverCell.nameOfClass()
        
        _ = DynamicParser.setValuesOnClass(object: driver, classObj: freinds.driver)
        
        if freinds.driver.first_name != nil {
            if currentDriver == nil{
                currentDriver = freinds.driver
                rows?.insert(freinds, at: 1)
            }
            else{
                
                if (currentDriver?.user_id)! == freinds.driver.user_id{
                    rows?.insert(freinds, at: 1)
                }
            }
            
            Manager.sharedInstance.driver = driver
            sections?.rowsArray = rows
            tableView.reloadData()
            
            
        }
    }
    
//    @objc func driverUpdated(notification: NSNotification){
//
//        DispatchQueue.main.async {
//            if let notif = notification.userInfo![FireBaseConstant.driverNode]{
//                self.addDriverToList(driver: notif as! [String : Any])
//            }
//            else{
//                self.deleteDriverFromList()
//            }
//        }
//    }
    
    func isPassenger()-> Bool {
        return !Utility.isDriver()
    }

    func getLastInvitedTimeForDriver(){
        
        FireBaseManager.sharedInstance.getLastUpdatedTimeForBothDriverPaseenger { (status, message, seat, returnSeats)  in
            
            switch (status){
                
            case InvitedFriendTimeStatus.InviteNotExpireButDriverPending?:
        //        self.serviceStatus = true
                Utility.showAlertwithOkButton(message: message!, controller: self)
                break
                
            case InvitedFriendTimeStatus.InviteNotExpireAndDriverAccepted?:
                self.creatTripRequestForPassenger(shouldFtechMembers: true,driverID:message,seat:seat!,returnSeats: returnSeats)
                break
                
            case InvitedFriendTimeStatus.InvitExpires?:
                self.showAlertForEventExpire()
                break
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                self.creatTripRequestForPassenger(shouldFtechMembers: false,driverID:nil,seat: 0,returnSeats: returnSeats)
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                self.creatTripRequestForPassenger(shouldFtechMembers: true,driverID:nil,seat: 0,returnSeats: returnSeats)
                break
                
            default:
                break
            }
        }
    }
    
    func creatTripRequestForPassenger(shouldFtechMembers:Bool,driverID:String?,seat:Int, returnSeats:Int? = nil ){
        
        PostTrip.createTripByPassenger(route: self.selectedRoute, shouldFetchMembers: shouldFtechMembers, driverID: driverID,seat:seat, returnSeats: returnSeats) { (object, message, active, status) in
            self.serviceStatus = status ?? false
            if status! {
                FireBaseManager.sharedInstance.deleteFreindInvites()
            }
            if (message!["message"] as? String ?? "") == ApplicationConstants.InviteNotAcceptedMessage {
                self.serviceStatus = false
            }
            Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
        }
    }
    
    func showAlertForEventExpire(){
        
        let alert = UIAlertController(title: ApplicationConstants.InviteExpireMessageTitleOnCreateTripeScreen, message: ApplicationConstants.InviteExpireMessageOnCreateTripeScreen, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            
            self.deleteDriverWithFreindsAndCreateTrip()
            
        })
        
        
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    func deleteDriverWithFreindsAndCreateTrip(){
        
        self.creatTripRequestForPassenger(shouldFtechMembers: false,driverID:nil, seat: 0)
        FireBaseManager.sharedInstance.deleteDriverPassengerData { (status) in
        }
    }
    
    override func alertOkButtonHandler() {
        if isPassenger() && serviceStatus {
            serviceStatus = false
            //self.navigationController?.popViewController(animated: true)
            pushController(controllerIdentifier: MyTripsViewController.nameOfClass(), navigationTitle: "MY TRIPS", conditons: 1)
        }
    }
    
    // Passenger Methods End
    
    func isRoundTrip() -> Bool {
        let trip = DataPersister.sharedInstance.getTripInfo()
        if (trip != nil) {
            return (trip?.roundTrip) ?? false
        }
        return false
    }
    
    func addObjects(){
        
        // trip critreria cell
        let tripHearder = PostTrip()
        tripHearder.cellidentifier = CreateTripHeaderCell.nameOfClass()
        //cellsArray.append(tripHearder)
        
        // timezone cell
        let tripTimeZone = PostTrip()
        tripTimeZone.cellidentifier = TimeZoneCell.nameOfClass()
        tripTimeZone.placeholdertext = "1"
        //cellsArray.append(tripTimeZone)
        
        // timezone return
        let tripTimeZoneReturn  = PostTrip()
        tripTimeZoneReturn.cellidentifier = RoundTripTimeZoneCell.nameOfClass()
        tripTimeZoneReturn.placeholdertext = "1"
        tripTimeZoneReturn.expected_start_time = "1"
    //    tripTimeZoneReturn.placeholdertext = "When would you like to return?"
        //cellsArray.append(tripTimeZoneReturn)
        
        // seat cell
        let seatCell = PostTrip()
        seatCell.cellidentifier = SelectSeatsCell.nameOfClass()
        seatCell.placeholdertext = "Select Seat:"
        //cellsArray.append(seatCell)
        
        // seat cell return
        let seatCellReturn = PostTrip()
        seatCellReturn.cellidentifier = SelectSeatsCell.nameOfClass()
        seatCellReturn.placeholdertext = "Select Return Seat:"
        //cellsArray.append(seatCellReturn)
        
        // ride estimate cell
        let estimateCell  = PostTrip()
        estimateCell.cellidentifier = RideEstimateWithBookNow.nameOfClass()
        //cellsArray.append(estimateCell)
        
        // preference header cell
        let preferenceHeaderCell = PostTrip()
        preferenceHeaderCell.cellidentifier = PrepferenceHeaderCell.nameOfClass()
        //cellsArray.append(preferenceHeaderCell)

        // preference content cell
        let contentGender = PostTrip()
        contentGender.cellidentifier = GenderCell.nameOfClass()
        contentGender.title = "Gender"
        contentGender.placeholdertext = "Both"
        contentGender.cellidentifier = GenderCell.nameOfClass()
        //cellsArray.append(contentGender)
        
      
        // smoking
//        let smokingRow = PostTrip()
//        smokingRow.cellidentifier = PreferenceCell.nameOfClass()
//        smokingRow.placeholdertext = "Smoking"
//        //cellsArray.append(smokingRow)
//
//        // pets allowed
//        let petsRow = PostTrip()
//        petsRow.cellidentifier = PreferenceCell.nameOfClass()
//        petsRow.placeholdertext = "Pets Allowed"
//        //cellsArray.append(petsRow)
//
//        // music
//        let musicRow = PostTrip()
//        musicRow.placeholdertext = "Music"
//        musicRow.cellidentifier = PreferenceCell.nameOfClass()
        //cellsArray.append(musicRow)
        
        
        // add freind cell
        let freindCell = PostTrip()
        freindCell.cellidentifier = ActionButtonCell.nameOfClass()
        //cellsArray.append(freindCell)
        
        // invited driver cell
        let invitedDriverCell = PostTrip()
        invitedDriverCell.cellidentifier = InvitedDriverCell.nameOfClass()
        //cellsArray.append(invitedDriverCell)
        
        // create trip
        let createTripCell = PostTrip()
        createTripCell.cellidentifier = SingleActionButtonCell.nameOfClass()
        //cellsArray.append(createTripCell)
        
        
        var rowsArraySectionOne : [PostTrip]! = []
        if isRoundTrip() {
            rowsArraySectionOne.append(tripTimeZoneReturn)
        }
        else {
            rowsArraySectionOne.append(tripTimeZone)
        }
//        rowsArraySectionOne.append(tripTimeZone)
//        rowsArraySectionOne.append(tripTimeZoneReturn)
//        rowsArraySectionOne.append(estimateCell)

        
        let sectionOneEntity = CreateTripEntity()
        sectionOneEntity.rowsArray = rowsArraySectionOne
        sectionOneEntity.objectIdentifier = CreateTripEntityConstant.sectionOneEntity
        sectionsArray.append(sectionOneEntity)
        
        
        var rowsArraySectionTwo : [PostTrip]! = []
        rowsArraySectionTwo.append(contentGender)
        
        
        let preferences = Utility.getValueFromUserDefaults(key: BootMeUpKeys.PreferenceKey.value)
            as? [[String:Any]] ?? []
        
        for preference in preferences {
            
            let musicRow = PostTrip()
            musicRow.placeholdertext = ((preference["title"] as? String) ?? "") + ":"
            musicRow.text = preference["option"] as? String
            musicRow.customactionname = preference["identifier"] as? String
            musicRow.cellidentifier = PreferenceCell.nameOfClass()
            rowsArraySectionTwo.append(musicRow)
            
        }
//
//        rowsArraySectionTwo.append(smokingRow)
//        rowsArraySectionTwo.append(petsRow)
//        rowsArraySectionTwo.append(musicRow)

        
        let sectionTwoEntity = CreateTripEntity()
        sectionTwoEntity.sectionTitle = "Advanced Preferences :"
        sectionTwoEntity.rowsArray = rowsArraySectionTwo
        sectionTwoEntity.objectIdentifier = CreateTripEntityConstant.sectionTwoEntity
        sectionsArray.append(sectionTwoEntity)
        
        var rowsArraySectionThree : [PostTrip]! = []
   //     rowsArraySectionThree.append(freindCell)
        rowsArraySectionThree.append(createTripCell)
        
        let sectionThreeEntity = CreateTripEntity()
        sectionThreeEntity.rowsArray = rowsArraySectionThree
        sectionThreeEntity.objectIdentifier = CreateTripEntityConstant.sectionThreeEntity
        sectionsArray.append(sectionThreeEntity)
    }
    
    func registerCustomCell(){
        
        tableView.register(UINib(nibName: FindRidesHeaderCell.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: FindRidesHeaderCell.nameOfClass())

       let cells = [RideEstimateWithBookNow.nameOfClass(),ActionButtonCell.nameOfClass(),InvitedDriverCell.nameOfClass(),SingleActionButtonCell.nameOfClass(),GenderCell.nameOfClass(),PreferenceCell.nameOfClass(),RoundTripTimeZoneCell.nameOfClass(), TimeZoneCell.nameOfClass()]

        for cell in cells {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.separatorColor = UIColor.clear
        tableView.allowMultipleSectionsOpen = true
        tableView.sectionsAlwaysOpen = [0,1,2]
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
extension CreateTripModifiedController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = sectionsArray[section]
        return object.rowsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let object = sectionsArray[section]
        if let _ = object.sectionTitle{
            return FindRidesHeaderCell.kDefaultAccordionHeaderViewHeight
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objectSection = sectionsArray[indexPath.section]
        let object = objectSection.rowsArray[indexPath.row]
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
        switch cell {
            
        case is CreateTripHeaderCell:
            break
            
        case is TimeZoneCell:
            let timeZoneCell = cell as! TimeZoneCell
            timeZoneCell.initialize(object)
            if isPassenger() {
                timeZoneCell.noSeatBackground()
                timeZoneCell.hideSeats()
            }
          //  timeZoneCell.contentLable.text = object.placeholdertext
            break
            
        case is RideEstimateWithBookNow:
            break
            
            
        case is SelectSeatsCell:
            let seatCell = cell as! SelectSeatsCell
            seatCell.seatTitleLabel.text = object.placeholdertext
            break
            
            
        case is ActionButtonCell:
            let cell = cell as! ActionButtonCell
            cell.delegate = self
            if !isPassenger() {
                cell.hideLeftButton()
            }
            break
            
            
        case is InvitedDriverCell:
            let driverCell = cell as! InvitedDriverCell
            driverCell.initializeCell(object.driver!)
            break
            
            
        case is SingleActionButtonCell:
            let cell = cell as! SingleActionButtonCell
            setButtonDependentOnUserSelectedType(button: cell.button)
            cell.delegate = self
            break
            
            
        case is PreferenceCell:
            let genderCell = cell as! PreferenceCell
            genderCell.initialize(object)
//            genderCell.leftLable.text = object.placeholdertext
            
//        case is MultipleCheckboxCell:
//
//            let multipleCheckboxCell = cell as! MultipleCheckboxCell
//            multipleCheckboxCell.initializeCell(contentArray[indexPath.row])
//            multipleCheckboxCell.tag = indexPath.row
//            multipleCheckboxCell.delegate = self
//            break
            
        case is GenderCell:
            let genderCell = cell as! GenderCell
            genderCell.initialize(object, vc: self)
            
        default :
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let object = sectionsArray[section]
        if let _ = object.sectionTitle{
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FindRidesHeaderCell.nameOfClass()) as! FindRidesHeaderCell
            view.filterLabel.textAlignment = .center
            view.filterLabel.text = "Advanced Preferences"
            view.filterLabel.font = UIFont.boldSystemFont(ofSize: view.filterLabel.font.pointSize)
            view.collapseImageView.isHidden = true
            return view
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            FireBaseManager.sharedInstance.deleteDriverData(completionHandler: { (status) in
                if status! {
                    self.deleteDriverFromList()
                    
                    let objectSection = self.sectionsArray[indexPath.section]
                    objectSection.rowsArray = objectSection.rowsArray.filter( { $0.cellidentifier != InvitedDriverCell.nameOfClass() } )
                    
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let objectSection = sectionsArray[indexPath.section]
        let object = objectSection.rowsArray[indexPath.row]
        if object.driver.user_id != nil{
            return true
        }
        return false
    }
    
}

extension CreateTripModifiedController : FZAccordionTableViewDelegate {

    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("willOpenSection")

    }

    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
//        self.tableView.toggleSection(0)

        print("didOpenSection")
    }

    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("willCloseSection")

    }

    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("didCloseSection")

    }

    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}

extension CreateTripModifiedController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        print("Button clicked")
        
        if isVerified() {
            
            CreateTripDetails.shared.postArray = sectionsArray
            
            setInviteType()
            
            if isPassenger() {
            
                getLastInvitedTimeForDriver()
                
            }
            else {
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: RouteSelectionViewController.nameOfClass())
                navigationController?.pushViewController(controller!, animated: true)
            }
        }
    }
}


extension CreateTripModifiedController: ActionButtonCellDelegate {
    func leftButtonClicked(_ sender: Any) {
        if isVerified() {
            
            
            FireBaseManager.sharedInstance.getLastUpdatedTime(isForDriver:true, completionHandler: { (objInvitedFriendTimeStatus) in
                
                switch objInvitedFriendTimeStatus{
                    
                case InvitedFriendTimeStatus.InviteNotExist?:
                    self.showDriverScreen()
                    break
                    
                case InvitedFriendTimeStatus.InvitExpires?:
                    FireBaseManager.sharedInstance.deleteDriverData(completionHandler: { (status) in
                        
                        if status! {
                            self.showDriverScreen()
                            self.deleteDriverFromList()
                        }
                    })
                    break
                    
                case InvitedFriendTimeStatus.InviteNotExpire?:
                    
                    Utility.showAlertwithOkButton(message: "Driver exist, Kinldy delete driver before select another.", controller: self)
                    break
                    
                case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                    self.showDriverScreen()
                    
                    break
                    
                default:
                    break
                }
            })
            
            
        }
    }
    
    func rightButtonClicked(_ sender: Any) {
        //
     //   let alertMessage = isVerifiedFields()
        let alertMessage = ""
        if isVerified() {
            
            setInviteType()
            let  controller = self.storyboard?.instantiateViewController(withIdentifier: AddFriendsViewController.nameOfClass()) as! AddFriendsViewController
            navigationController?.pushViewController(controller, animated: true)
            
            
        }
    }
}
