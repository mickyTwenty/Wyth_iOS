//
//  SearchRidesViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 30/03/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import FZAccordionTableView

class SearchRidesViewController: BaseViewController {

    @IBOutlet weak var tableView: FZAccordionTableView!
    var contentArray : [PostTrip]! = []
    var constantArray : [PostTrip]! = []
    var tripArray : [GroupSearchTrip]! = []
    var filterArray : [GroupSearchTrip]! = []
    var filters: [String:Int]! = [:]
    var viewHeader : FindRidesHeaderCell?
    var selectedRoute : Route! = Route()
    
    @IBOutlet weak var postRideButton: UIButton!
    @IBOutlet weak var postRideButtonWithTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomWithParent: NSLayoutConstraint!
    @IBOutlet weak var noSubscriberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNoSubscriberMessage(nil)
        self.syncContacts()
        registerCustomCell()
        loadTableViewData()
        
        searchTripRequest(shouldFtechMembers:false)
        
        if Utility.isDriver() {
            self.title = "FIND RIDERS"
        }
        else {
            self.title = "FIND RIDE"
        }
        
        if Utility.isDriver() {
            postRideButtonWithTableViewTop.isActive = true
            tableViewBottomWithParent.isActive = false
        }
        else {
            postRideButton.isHidden = true
            postRideButtonWithTableViewTop.isActive = false
            tableViewBottomWithParent.isActive = true
        }
        
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.FindRideHelp
        
        present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CreateTripDetails.shared.clear()
    }
    
    @IBAction func noRideButtonClicked(){
        
//        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: NoRidePopUPController.nameOfClass())
//        cont.show(controller: self)
//        cont.doneButtonTapped = { selectedData in
//
//            let action = selectedData["action"] as! String
//            if action == "1"{
//                self.performSegue(withIdentifier: "goBackToDashboardController", sender: self)
//            }
//            else{
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//        return
        
        if Utility.isDriver() {
            setNoSubscriberMessage(nil)
            return
        }
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: NoMatchPopUPController.nameOfClass())
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            
            let action = selectedData["action"] as! String
            if action == "1"{
                
                PostTrip.subscribeRideForPassenger(route: self.selectedRoute) { (object, message, active, status) in
                    
                    self.navigationController?.popViewController(animated: true)
//                    self.serviceStatus = status ?? false
//                    if status! {
//                        FireBaseManager.sharedInstance.deleteFreindInvites()
//                    }
//                    if (message!["message"] as? String ?? "") == ApplicationConstants.InviteNotAcceptedMessage {
//                        self.serviceStatus = false
//                    }
//                    Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                }
                
//                self.performSegue(withIdentifier: "goBackToDashboardController", sender: self)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
            
         //   self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func registerCustomCell(){
        tableView.register(UINib(nibName: FindRidesHeaderCell.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: FindRidesHeaderCell.nameOfClass())
        
        for cell in [RideEstimateWithBookNow.nameOfClass(),ActionButtonCell.nameOfClass(),InvitedDriverCell.nameOfClass(),SingleActionButtonCell.nameOfClass(),GenderCell.nameOfClass(),PreferenceCell.nameOfClass(),RoundTripTimeZoneCell.nameOfClass(), TimeZoneCell.nameOfClass(), FindRidesCell.nameOfClass() ]
        {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
    }
    
    func loadTableViewData(){
        
        tableView.initialOpenSections = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        tableView.separatorColor = UIColor.clear
        tableView.allowMultipleSectionsOpen = true
        
        // timezone cell
        let tripTimeZone = PostTrip()
        tripTimeZone.cellidentifier = TimeZoneCell.nameOfClass()
        tripTimeZone.text = "7"
        
        
        // timezone return
        let tripTimeZoneReturn  = PostTrip()
        tripTimeZoneReturn.cellidentifier = RoundTripTimeZoneCell.nameOfClass()
        tripTimeZoneReturn.text = "7"
        tripTimeZoneReturn.title = "7"
        
        if isRoundTrip() {
            contentArray.append(tripTimeZoneReturn)
            filters["TripTime"] = contentArray.index(of: tripTimeZoneReturn)
        }
        else {
            contentArray.append(tripTimeZone)
            filters["TripTime"] = contentArray.index(of: tripTimeZone)
        }
        
        let contentGender = PostTrip()
        contentGender.cellidentifier = GenderCell.nameOfClass()
        contentGender.title = "Gender"
        contentGender.placeholdertext = "Both"
        contentGender.cellidentifier = GenderCell.nameOfClass()
        contentArray.append(contentGender)
        filters["Gender"] = contentArray.index(of: contentGender)
        
        let preferences = Utility.getValueFromUserDefaults(key: BootMeUpKeys.PreferenceKey.value)
            as? [[String:Any]] ?? []
        
        for preference in preferences {
            
            let musicRow = PostTrip()
            musicRow.placeholdertext = preference["title"] as? String
            musicRow.text = preference["option"] as? String
            musicRow.customactionname = preference["identifier"] as? String
            musicRow.cellidentifier = PreferenceCell.nameOfClass()
            contentArray.append(musicRow)
            filters[musicRow.placeholdertext] = contentArray.index(of: musicRow)
            
        }


        let freindCell = PostTrip()
        freindCell.cellidentifier = ActionButtonCell.nameOfClass()
        if !Utility.isDriver() {
         //   contentArray.append(freindCell)
        }
        
        let createTripCell = PostTrip()
        createTripCell.cellidentifier = SingleActionButtonCell.nameOfClass()
        createTripCell.imagename = "apply_filter_btn"
        contentArray.append(createTripCell)
        
        if Utility.isDriver() {
            
            contentArray = []
            
            let postTripCell = PostTrip()
            postTripCell.cellidentifier = SingleActionButtonCell.nameOfClass()
            postTripCell.imagename = "post_ride_btn"
     //       constantArray.append(postTripCell)
        
        }
        
//        if Utility.isDriver() {
//            contentArray = PostTrip.getPostTripData(name: FileNames.SearchRidePlist)
//        }
//        else {
//            contentArray = PostTrip.getPostTripData(name: FileNames.FindRidePlist)
//        }
        
//        contentArray = contentArray.filter( { $0.cellidentifier == MultipleCheckboxCell.nameOfClass() } )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func isRoundTrip() -> Bool {
        let trip = DataPersister.sharedInstance.getTripInfo()
        if (trip != nil) {
            return (trip?.roundTrip) ?? false
        }
        return false
    }
    
    func showRideDetailsScreen(trip:SearchTrip){
        CreateTripDetails.shared.searchArray = contentArray
        let controller = storyboard?.instantiateViewController(withIdentifier: RideDetailsViewController.nameOfClass()) as! RideDetailsViewController
        controller.tripID = String(describing: trip.trip_id!)
        controller.isFromSearchScreen = true
        controller.isRoundTrip = isRoundTrip()
        if trip.group_id != nil && isRoundTrip() {
            controller.isRoundTripButSingle = true
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    func setCollapseImageState(isOpened: Bool){
        if let header = viewHeader {
            header.collapseImageView.isHighlighted = isOpened
        }
    }
    
    var searchFilterModel = SearchFilterModel()
    
    func initSearchFilters(){
        searchFilterModel.tripArray = tripArray
        
        searchFilterModel.createFilters()
        
//        searchFilterModel.createSearchIds()
//        searchFilterModel.createPreferences()
//        searchFilterModel.createGenderFilters()
//        searchFilterModel.createTimeRangeFilters()
    }
    
    func searchTrip(index: Int){
        
        searchFilterModel.search(byFilter: getCurrentSearchObject())

        filterArray = searchFilterModel.filterArray
        
        tableView.reloadData()
        
        if filterArray.count > 0 {
            self.tableView.toggleSection(0)
            self.setCollapseImageState(isOpened: false)
        }
        
    }
    
    func getCurrentSearchObject() -> [String:Any] {
        
        var searchFilter = [String:Any]()
        var preferences = [String:Any]()
        
        for object in contentArray {
            
            switch object.cellidentifier {
                
            case TimeZoneCell.nameOfClass():
                
                searchFilter["timeRange"] = object.text
                
                break
                
            case RoundTripTimeZoneCell.nameOfClass():
                
                searchFilter["timeRange"] = object.text
                searchFilter["timeRangeReturning"] = object.title
                
                break
                
            case PreferenceCell.nameOfClass():
                
                preferences[object.placeholdertext] = object.isselected
                
                break
                
            case GenderCell.nameOfClass():
                
                searchFilter["Gender"] = object.placeholdertext
                
                break
                
                
            default: break
                
            }
            
        }
        
        searchFilter["preferences"] = preferences
        
        
        
        
        
        
//        for (key,value) in filters {
//
//            let object = contentArray[value]
//
//            switch key {
//
//            case "TripTime":
//
//                searchFilter["timeRange"] = object.text
//
//                if isRoundTrip() {
//
//                    searchFilter["timeRangeReturning"] = object.text
//
//                }
//
//
//                break
//
//
//
//
//            default:
//
//                // Which have no multiple values
//
//                searchFilter[key] = object.placeholdertext
//
//                break
//
//
//
//            }
//
//
//        }
    
        return searchFilter
        
    }
    
    
    func searchTripRequest(shouldFtechMembers:Bool){
        
        PostTrip.searchTrip(route: Route(), shouldFetchMembers: shouldFtechMembers) { (response, message, active, status) in
            
            if let array = response as? [GroupSearchTrip] {
                
                if array.count > 0 {
                    
                    self.tripArray = response as! [GroupSearchTrip]
                    self.filterArray = self.tripArray.filter( { $0.group_id == nil } ) +
                        self.tripArray.filter( { $0.group_id != nil } )
                 //   self.filterArray = self.tripArray
         
                    if self.contentArray.count > 0 {
                        self.initSearchFilters()
                    }
                    self.tableView.reloadData()
                    self.tableView.toggleSection(0)
                    
                }
                else {
                    if Utility.isDriver() {
                        self.setNoSubscriberMessage(message?.value(forKey: "message"))
                    }
                    else {
                        self.noRideButtonClicked()
                    }
                }
                self.setCollapseImageState(isOpened: false)
                
            }
            else {
                self.noRideButtonClicked()
            //    Utility.showAlertwithOkButton(message: message?.value(forKey: "message") as! String, controller: self)
            }
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
    
    func getLastInvitedTime(trip: SearchTrip){
        FireBaseManager.sharedInstance.getLastUpdatedTime { (objInvitedFriendTimeStatus) in
            
            switch objInvitedFriendTimeStatus{
                
            case InvitedFriendTimeStatus.InviteNotExist?:
                self.showRideDetailsScreen(trip: trip)
                break
                
            case InvitedFriendTimeStatus.InvitExpires?:
                self.showRideDetailsScreen(trip: trip)
                break
                
            case InvitedFriendTimeStatus.InviteNotExpire?:
                PostTrip.fetchInvitedMembers()
                { (ids) in
                    
                    if ids == ApplicationConstants.InviteNotAcceptedMessage {
                        Utility.showAlertwithOkButton(message: ids, controller: self)
                    }
                    else {
                        let _ids = ids.components(separatedBy: "-,-")
                        
                        var seats = [Int]()
                        
                        if let rides = trip.rides {
                            
                            for ride in rides {
                                
                                if let seat = ride["seats_available"] as? Int {
                                    
                                    seats.append(seat)
                                
                                }
                                
                                
                            }
                            
                        }
                        
                        let minSeats = seats.reduce(Int.max, { min($0, $1) })

                        if _ids.count <= minSeats {
                            self.showRideDetailsScreen(trip: trip)
                        }
                        else {
                            Utility.showAlertwithOkButton(message: "This Ride does'nt have enough Seats for all of your invited friends", controller: self)
                        }
                    }
                }
                break
                
            case InvitedFriendTimeStatus.InviteExistForDifferentType?:
                self.showRideDetailsScreen(trip: trip)
                break
                
            default:
                break
            }
        }
    
    }
    
    
    @IBAction func postRideButtonClicked(_ sender: Any) {
        var screenTitle = ""
        switch(Utility.getUserType()){
            
        case UserType.UserDriver:
            screenTitle = ApplicationConstants.CreateTripPostRideTitle
            break
            
        case UserType.UserNormal:
            screenTitle = ApplicationConstants.CreateTripTitle
            
            break
            
        default:
            break
        }
        pushViewController(controllerIdentifier: CreateTripModifiedController.nameOfClass(), navigationTitle: screenTitle, conditons: selectedRoute )
    }
    
    func setNoSubscriberMessage(_ message: Any?){
        if let message = message as? String {
            noSubscriberLabel.text = message
            noSubscriberLabel.isHidden = false
        }
        else {
            noSubscriberLabel.isHidden = true
        }
    }
    
}

extension SearchRidesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return contentArray.count
        }else if(section == 1){
            
            if filterArray.count <= 0 {
                return 0
            }
            
            print("Sections",section)
            print("Rows", filterArray[section-1].trips.count)
            
            return filterArray[section-1].trips.count
        }
        else {
            return constantArray.count
        }
 
       // return contentArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
      //  return 1

        print("Total Sections", filterArray.count)
        return filterArray.count + 2
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if contentArray.count > 0{
                let object = contentArray[indexPath.row]
                if indexPath.section == 0 && object.cellidentifier == HorizontalScrollCell.nameOfClass(){
                    return CGFloat(130)
                }
                else{
                    return UITableView.automaticDimension
                }
                
            }
            else{
                return UITableView.automaticDimension
            }
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if section == 0 {
            if Utility.isDriver() {
                return 0
            }
            return FindRidesHeaderCell.kDefaultAccordionHeaderViewHeight
        }
        else if section == 2 {
            return 0
        }
//        else if filterArray[section-1].group_id != nil {
//            return FindRidesHeaderCell.kDefaultAccordionHeaderViewHeight
//        }
        else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            
            let object = contentArray[indexPath.row]
            cell  = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
            
            cell.backgroundColor = UIColor.white
            cell.tag = indexPath.row
            
            switch cell {
                
            case is MultipleCheckboxCell:
                
                let multipleCheckboxCell = cell as! MultipleCheckboxCell
                multipleCheckboxCell.initializeCell(contentArray[indexPath.row])
                multipleCheckboxCell.tag = indexPath.row
                multipleCheckboxCell.delegate = self
                break

            case is PreferenceCell:
                let genderCell = cell as! PreferenceCell
                genderCell.initialize(object)
                break
                
            case is GenderCell:
                let genderCell = cell as! GenderCell
                genderCell.initialize(object, vc: self)
                break
                
            case is TimeZoneCell:
                let timeZoneCell = cell as! TimeZoneCell
                timeZoneCell.initialize(object)
                timeZoneCell.noSeatBackground()
                timeZoneCell.hideSeats()
                timeZoneCell.delegate = self
                break
                
            case is ActionButtonCell:
                let cell = cell as! ActionButtonCell
                cell.delegate = self
                cell.hideLeftButton()
                break
                
            case is SingleActionButtonCell:
                let cell = cell as! SingleActionButtonCell
                cell.setButtonImage(object)
                cell.delegate = self
                break
                
            default: break
                
            }
        }
            
        else if (indexPath.section == 2) {
            
            let object = constantArray[indexPath.row]
            cell  = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier, for: indexPath)
            
            cell.backgroundColor = UIColor.white
            cell.tag = indexPath.row
            
            switch cell {
                
            case is SingleActionButtonCell:
                let cell = cell as! SingleActionButtonCell
                cell.setButtonImage(object)
                cell.delegate = self
                cell.tag = indexPath.row + 100
                break
                
            default: break
                
            }
            
        }
            
        else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: FindRidesCell.nameOfClass(), for: indexPath)
            let findRidesCell = cell  as! FindRidesCell
            
            if filterArray[indexPath.section-1].group_id != nil {
                cell.backgroundColor = UIColor.groupTableViewBackground
            }
            else {
                cell.backgroundColor = UIColor.white
            }
            
            findRidesCell.initializeCell(
                filterArray[indexPath.section-1].trips[indexPath.row] )
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FindRidesHeaderCell.nameOfClass()) as! FindRidesHeaderCell
            view.filterLabel.text = "Filter"
            view.leadingConstraint.constant = 0
            view.trailingConstraint.constant = 0
            view.headerBgView.backgroundColor = .black
            view.filterLabel.textColor = .white
            if viewHeader == nil {
                viewHeader = view
                self.setCollapseImageState(isOpened: true)
            }
            
            return view
        }
        else{
            let label = UILabel()
            label.text = " Suggested Rides For Round Trip"
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.black
            return label
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 && indexPath.section != 2 {
            if Utility.isDriver() {
               // showRideDetailsScreen(trip: filterArray[indexPath.section-1].trips[indexPath.row])
            }
            else {
                getLastInvitedTime(trip: filterArray[indexPath.section-1].trips[indexPath.row])
            }
//            getLastInvitedTime(trip: filterArray[indexPath.section-1].trips[indexPath.row])
//            showRideDetailsScreen(trip: filterArray[indexPath.section-1].trips[indexPath.row])
        }
    }
    
}

extension SearchRidesViewController : FZAccordionTableViewDelegate {
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        self.setCollapseImageState(isOpened: true)
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        if header != nil {
            self.setCollapseImageState(isOpened: false)
        }
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}

extension SearchRidesViewController: MultipleCheckboxCellDelegate {
    
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
//        removeTripSearchData()
    }
}

extension SearchRidesViewController: TimeZoneCellDelegate {
    func thresholdDayClicked(_ tag: Int) {
    }
    func seatsClicked(_ tag: Int) {}
}

extension SearchRidesViewController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        
        if tag < 100 {
            searchTrip(index: 0)
        }
        else {
           // postRide()
//            var screenTitle = ""
//            switch(Utility.getUserType()){
//
//            case UserType.UserDriver:
//                screenTitle = ApplicationConstants.CreateTripPostRideTitle
//                break
//
//            case UserType.UserNormal:
//                screenTitle = ApplicationConstants.CreateTripTitle
//
//                break
//
//            default:
//                break
//            }
//            pushViewController(controllerIdentifier: CreateTripModifiedController.nameOfClass(), navigationTitle: screenTitle, conditons: selectedRoute )
        }
        
    }
}

extension SearchRidesViewController: ActionButtonCellDelegate {
    func leftButtonClicked(_ sender: Any) {

    }
    
    func rightButtonClicked(_ sender: Any) {
        setInviteType()
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: AddFriendsViewController.nameOfClass()) as! AddFriendsViewController
        navigationController?.pushViewController(controller, animated: true)
    }
}
