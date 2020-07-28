//
//  OffersDetailViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 22/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import FZAccordionTableView
import FirebaseCore
import FirebaseFirestore


class OffersDetailViewController: BaseViewController {

    @IBOutlet weak var selectionView: SelectNumbersView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: FZAccordionTableView!
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    var serviceResponse:[String:Any]! = [:]
    var listener : ListenerRegistration? = nil
    var numberOfBags : String = "0"
    var contentArray : [PostTrip]!
    var trip: Trip!
    var chatArray: [OffersModel]! = []
    var serviceStatus: Bool! = false
    var isMinimumOfferAlertShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTripDetails()
        Utility.resignKeyboardWhenTouchOutside()
        textField.keyboardDistanceFromTextField = -10
        textField.inputAccessoryView = UIView()
            
        registerCustomCell()
        tableView.reloadData()
        selectionView.delegate = self
        selectionView.hideBulletView()
        
        if Utility.isDriver() {
            selectionView.isHidden = true
            selectionView.heightAnchor.constraint(equalToConstant: 0)
            selectionView.widthAnchor.constraint(equalToConstant: 0)
            textFieldLeadingConstraint.isActive = true
            textFieldLeadingConstraint.constant = 5.0
        }
        else {
            textFieldLeadingConstraint.isActive = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerCustomCell(){
        
        tableView.register(UINib(nibName: ShowMoreLessHeaderCell.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: ShowMoreLessHeaderCell.nameOfClass())
        
        for cell in [OffersDetailCell.nameOfClass(),LabelCell.nameOfClass(),MultipleCheckboxCell.nameOfClass(),SelectBagsCell.nameOfClass(),SenderCell.nameOfClass(), AcceptOfferRecieverCell.nameOfClass(),MultiLabelCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.initialOpenSections = [0,2]
//        tableView.initialOpenSections = [0,1]

        tableView.separatorColor = UIColor.clear
        tableView.allowMultipleSectionsOpen = true
        
        
    }
    
    func updatePlaceHolder(key: String, value: String){
        let object = Utility.getPostTripModel(key: key, array: contentArray)
        object.placeholdertext = value
    }
    
    func loadTableViewData(){
        
        contentArray = PostTrip.getPostTripData(name: FileNames.OfferDetailsPlist)
        
        updatePlaceHolder(key: PlistPlaceHolderConstant.PostTripName, value: trip.getTripIdOrTripName() ?? "")
        
        updatePlaceHolder(key: PlistPlaceHolderConstant.PostTripOrigin, value: trip.origin_title ?? "")
        
        updatePlaceHolder(key: PlistPlaceHolderConstant.PostTripDestination, value: trip.destination_title ?? "")
        
        updatePlaceHolder(key: PlistPlaceHolderConstant.PostTripDate, value: trip.date ?? "")
        
        var objectTimeOfDay = Utility.getPostTripModel(key: PlistPlaceHolderConstant.PostTripTimeOfDay, array: contentArray)
        var refrenceValueString = ""
        if trip?.time_range?.stringValue != nil{
            refrenceValueString = (trip?.time_range?.stringValue)!
        }
        
        objectTimeOfDay =  Utility.setTimeOfDay(trip: objectTimeOfDay, thresholdDay: refrenceValueString)
        
        updatePlaceHolder(key: PlistPlaceHolderConstant.PostTripEstimates, value: trip.estimates ?? "")
    }
    
    func getTripDetails(){
        var serviceId = Utility.isDriver() ? (WebServicesConstant.Passenger) : (WebServicesConstant.Driver)
        serviceId += "_id"
        serviceId = String(serviceId.dropFirst(1))
        let userId = Utility.isDriver() ? (trip.passenger?.user_id) : (trip.driver?.user_id)
        
        let filterObject: [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any, serviceId:userId as Any ]
        Trip.getTripDetailsFromSever(filterObject: filterObject, rideService: WebServicesConstant.OfferDetail, tripId: String(describing: trip.trip_id!)) { (object, message, active, status) in
            if status! {
                self.trip = object as! Trip
                self.addObserverOnOffers()
                self.loadTableViewData()
                self.tableView.reloadData()
            }
            else{
                Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
            }
        }
    }
    
    func addObserverOnOffers(){
        
        let collectionName = Trip.getOffersCollectionName(trip: self.trip)
        print(collectionName)
        listener = FireBaseManager.sharedInstance.addListenerOffersCollection(trip: trip) { (array) in
            
            self.chatArray = array
            self.updateBags()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onClick(_ sender: Any) {
        
        if !(textField.text?.isEmpty)! {
            if makeOfferToTrip() {
                textField.text = ""
                textField.resignFirstResponder()
                scrollToLastIndex()
            }
        }
        else{
            Utility.showAlertwithOkButton(message: "Amount field can not be empty", controller: self)
        }
        
    }
    
    func makeOfferToTrip()-> Bool{
        
        let price = (textField.text)! as Any
        
        if !Trip.isOfferAcceptable(price: price, vc: self) {
            isMinimumOfferAlertShow = true
            return false
        }
        
        var tripDetails :[String:Any] = [:]
        if Utility.isDriver(){
            let driverObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":(trip.trip_id?.stringValue)!,"passenger_id":(trip.passenger?.user_id?.stringValue)!,"price":(textField.text)!]
            tripDetails = driverObject
        }
        else{
            let passengerObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":(trip.trip_id?.stringValue)!,"driver_id":(trip.driver?.user_id?.stringValue)!,"bags":numberOfBags,"price":(textField.text)!]
            tripDetails = passengerObject
        }
        
        print(tripDetails)
        Trip.postMakeOfferOnTrip(tripObject: tripDetails, showHud: true, freindIds: "") { (object, message, active, status) in
            if !(status!) {
                
                self.serviceResponse = message as! [String : Any]
                
                if let code = self.serviceResponse!["error_code"] as? String{
                    if code == ErrorTypes.InvalidCCErrorCode{
                        Utility.showAlertwithOkButton(message: ApplicationConstants.NoCreditCardMessage , controller: self)
                    }
                    else{
                        Utility.showAlertwithOkButton(message: message!["message"] as! String , controller: self)

                    }
                }
                else{
                    Utility.showAlertwithOkButton(message: message!["message"] as! String, controller: self)
                }
            }
        }
        
        return true
    }
    
    
    func acceptOffer(object:OffersModel){
        
        var tripDetails :[String:Any] = [:]
        if Utility.isDriver(){
            let driverObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":(trip.trip_id?.stringValue)!,"passenger_id":(trip.passenger?.user_id?.stringValue)!,"price":object.price as Any]
            tripDetails = driverObject

        }
//        else{
//            let passengerObject :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,"trip_id":(trip.trip_id?.stringValue)!,"driver_id":(trip.driver?.user_id?.stringValue)!,"bags":numberOfBags,"price":object.price as Any]
//            tripDetails = passengerObject
//        }
        
        Trip.postAcceptOfferOnTrip(tripObject: tripDetails) { (object, message, active, status) in
            
            self.serviceStatus = status
            let stringMessage = message!["message"] as! String
            Utility.showAlertwithOkButton(message: stringMessage, controller: self)
        }
        

    }
    
    func scrollToLastIndex() {
        
        if tableView.numberOfSections > 0 {
            let rows: Int = tableView.numberOfRows(inSection: 2)
            if rows > 0 {
                tableView.scrollToRow(at: IndexPath(row: rows - 1, section: 2), at: .bottom, animated: false)
            }
        }

    }
    
    @objc override func alertOkButtonHandler(){
        
        if isMinimumOfferAlertShow {
            isMinimumOfferAlertShow = false
            return
        }
        
        if let code = serviceResponse!["error_code"] as? String{
            if code == ErrorTypes.InvalidCCErrorCode{
                self.pushViewController(controllerIdentifier: MyPaymentsViewController.nameOfClass(), navigationTitle: "ADD CREDIT CARD", conditons: true)
//                self.pushController(controllerIdentifier: PaymentViewController.nameOfClass(), navigationTitle: ApplicationConstants.MyPaymentScreenTitle)
                return
            }
        }
        if serviceStatus{
                performSegue(withIdentifier: "comingFromOfferDetailsVC", sender: self)
                performSegue(withIdentifier: "comingFromOfferDetailsVC_RD", sender: self)
        }
        
        if !serviceStatus {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateBags(){
        if self.chatArray.count > 0 {
            if let bags = self.chatArray[self.chatArray.count-1].bags {
                if Utility.isDriver() {
                    self.trip.passenger?.bags_quantity = bags
                }
                else {
                    self.selectionView.countLabel.text = String(describing: bags)
                }
            }
        }
    }
    
}

extension OffersDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            var count = 0
            if let contentArrayClone = contentArray {
                
              count = contentArrayClone.count - 1
            }
            return count
        default:
            break
        }
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 || indexPath.section == 1 {
            
            var index = indexPath.row
            if indexPath.section == 1 {
                index += 1
            }
            
            let object = contentArray[index]
            
            cell = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier , for: indexPath)
            
            switch cell {
            
            case is LabelCell:
                
                let labelCell = cell as! LabelCell
                labelCell.initializeCell(contentArray[index])
                break
                
            case is OffersDetailCell:
                
                let offerDetails = cell as! OffersDetailCell
                offerDetails.delegate = self
                offerDetails.state = .isComingFromOffers

                offerDetails.initiliazeCell(object: self.trip)
                break
                
            case is MultipleCheckboxCell:
                
                let multipleCheckboxCell = cell as! MultipleCheckboxCell
                multipleCheckboxCell.initializeCell(contentArray[index])
                multipleCheckboxCell.isEnabled = false
                break
                
            default:
                break
            }
            
        }
        
        else if indexPath.section == 2 {
            let object = chatArray[indexPath.row]
            let cellidentifier = object.cell_identifier
            cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier as! String , for: indexPath)
            
            switch cell {
                
            case is SenderCell:
                
                let senderCell = cell as! SenderCell
                cell.tag = indexPath.row
                senderCell.initializeCell(object)
                break
                
            case is AcceptOfferRecieverCell:
                
                let recieverCell = cell as! AcceptOfferRecieverCell
                cell.tag = indexPath.row
                recieverCell.initializeCell(object)
                recieverCell.delegate = self
                break
                
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1{
            if self.tableView.isSectionOpen(1) {
                return 0
            } else {
                return ShowMoreLessHeaderCell.kDefaultAccordionHeaderViewHeight
            }
        } else if section == 2{
            if self.tableView.isSectionOpen(1) {
                return ShowMoreLessHeaderCell.kDefaultAccordionHeaderViewHeight
            } else {
                return 0
            }
        } else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var countRows = 0
        if let contentArray = contentArray{
            countRows = 4
        }
        return countRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShowMoreLessHeaderCell.nameOfClass()) as! ShowMoreLessHeaderCell
        if section == 1 {
            view.showButton.setTitle("View Details +", for: UIControl.State.normal)
        }
        if section == 2 {
            view.showButton.setTitle("Hide Details -", for: UIControl.State.normal)
        }
        
        view.showButton.addTarget(self, action: #selector(backButtoncked), for: UIControl.Event.touchUpInside)
        return view
    }
    
    @objc func backButtoncked() {
        tableView.toggleSection(1)
        tableView.reloadData()
    }
    
   
}

extension OffersDetailViewController: MultipleCheckboxCellDelegate {
   
    func rideTimeButtonClicked(){
    }

    func clickEvent(_ tag: Int, CheckboxStates checkboxStates: [CheckboxState]) {
        print("called")
    }
}

extension OffersDetailViewController : FZAccordionTableViewDelegate {
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}

extension OffersDetailViewController: AcceptOfferRecieverCellDelegate {
    func acceptOfferButtonClicked(_ index: Int, _ sender: Any) {
        
        numberOfBags = selectionView.countLabel.text!
        if Utility.isDriver() {
            acceptOffer(object: chatArray[index])
        } else {
            let object = chatArray[index]
            let passengerObject :[String:Any] = [
                "trip_id":(trip.trip_id?.stringValue)!,
                "driver_id":(trip.driver?.user_id?.stringValue)!,
                "bags_quantity":numberOfBags,
                "proposed_amount":object.price as Any,
                "accept_offer":true,
                FireBaseConstant.searchDataDestinationText:trip.destination_title ?? "",
                FireBaseConstant.searchDataOriginText:trip.origin_title ?? "",
                ]
            
            let cont = ModalAlertBaseViewController.createAlertController(storyboardId: DriverAcceptedRideViewController.nameOfClass())
            cont.contentDict = passengerObject
            cont.show(controller: self)
            cont.doneButtonTapped = { selectedData in
                
                if let status = selectedData["status"] {
                    self.serviceStatus = status as! Bool
                }
                
                if let stringMessage = selectedData["message"] {
                    Utility.showAlertwithOkButton(message: stringMessage as! String, controller: self)
                }

            }
            

        }
        print("Offer Button Clicked")
    }
    
}

extension OffersDetailViewController: SelectNumbersViewDelegate {
    func clickEvent(_ tag: Int, SeatsCount seats: Int) {
        numberOfBags = String(seats)
    }
    
//    func clickEvent(SeatsCount seats: Int) {
//        numberOfBags = String(seats)
//        //        print(seats)
//    }
//    
    func seatsLimit(WarningMessage message: String) {
        print(message)
    }
}

extension OffersDetailViewController: OffersDetailCellDelegate {
    func onClickProfileButton(_ sender: Any, tag: Int) {
        print("onClickProfileButton")
        
        var friendsID = ""
        
        if Utility.isDriver(){
            if self.trip.passenger?.user_id != nil
            {
                friendsID = (self.trip.passenger?.user_id?.stringValue)!
            }
        }
        else {
            if self.trip.driver?.user_id != nil
            {
                friendsID = (self.trip.driver?.user_id?.stringValue)!
            }
        }
        
        let cont = self.storyboard?.instantiateViewController(withIdentifier: FreindProfileViewController.nameOfClass()) as! FreindProfileViewController
        cont.friendsID = friendsID
        self.navigationController?.pushViewController(cont, animated: true)
       
    }
    
}

