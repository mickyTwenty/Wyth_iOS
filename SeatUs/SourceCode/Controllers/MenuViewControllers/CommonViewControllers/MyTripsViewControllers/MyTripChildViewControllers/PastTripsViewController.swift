//
//  PastTripsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 21/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class PastTripsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    let upcomingTripCellDriver = UpcomingTripDriverCell.nameOfClass()
    let upcomingTripCellPassenger = UpComingTripsCell.nameOfClass()
    var currentStateCell : String! = ""

    
    var contentArray: [Trip]!
    
    var placesClient: GMSPlacesClient!
    
    private let refreshControl = UIRefreshControl()
    
    var isServiceCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCell()
        setDefaultText()
        setUpPullToReferesh()
        if contentArray != nil {
            updateTableView()
        }
        else {
            self.getPastTrips()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPastTrips()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCustomCell(){

        let cellNib = UINib(nibName: upcomingTripCellPassenger, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: upcomingTripCellPassenger)
        
        let cellNibDriver = UINib(nibName: upcomingTripCellDriver, bundle: nil)
        tableView.register(cellNibDriver, forCellReuseIdentifier: upcomingTripCellDriver)
        
        tableView.tableFooterView = UIView()

        if !(Utility.isDriver()){
            currentStateCell = upcomingTripCellDriver
        }
        else{
            currentStateCell = upcomingTripCellPassenger
        }

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
    
    func setDefaultText(){
        dateLabel.text = "Date"
        destinationLabel.text = "Destination"
    }
    
    @IBAction func onClickDestination(_ sender: Any) {
        setDefaultText()
        showPlacePicker()
    }
    
    @IBAction func onClickDate(_ sender: Any) {
        setDefaultText()
        view.endEditing(true)
        
        let controller = CustomDatePickerController.createDatePickerController(storyboardId: CustomDatePickerController.nameOfClass())
        controller.format = ApplicationConstants.DateFormatClient
        controller.show(controller: self.parent!)
        controller.doneButtonTapped = { selectedData in
            self.dateLabel.text = selectedData
            self.getPastTrips(date: self.dateLabel.text!)
        }
        
    }
    
    func getPastTrips(date: String = "",latitude: String = "",longitude: String = ""){
        if isServiceCalled {
            return
        }
        isServiceCalled = true
        let filterObject: [String: Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any,
                                           "date":date, "latitude":latitude, "longitude":longitude ]
        
        Trip.getTripsFromSever(filterObject: filterObject, rideService: MyTripsConstant.Past)
        { (object, message, active, status) in
            self.isServiceCalled = false
            self.contentArray = Trip.getTrips(object!)
            self.updateTableView()
        }
    }
    
    func showPlacePicker(){
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        setDefaultText()
        self.getPastTrips()
    }
    
    func showRideDetailsScreen(trip:Trip){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: RideDetailsViewController.nameOfClass()) as! RideDetailsViewController
        controller.tripID = String(describing: trip.trip_id!)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PastTripsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: currentStateCell , for: indexPath)
        cell.tag = indexPath.row
        
        
        switch (cell){
            
        case is UpComingTripsCell:
            let passengerCell = cell as! UpComingTripsCell
            passengerCell.delegate = self
            passengerCell.setDetails(trip: contentArray[indexPath.row])
            
            break
            
        case is UpcomingTripDriverCell:
            let driverCell = cell as! UpcomingTripDriverCell
            driverCell.delegate = self
            driverCell.setDetails(trip: contentArray[indexPath.row])
            break
            
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
        let trip = contentArray[indexPath.row]
        showRideDetailsScreen(trip: trip)
    }
}

extension PastTripsViewController: PastTripsCellDelegate {
    func onClickViewDetail(PastTripsCell index: Int, _ sender: Any) {
        
        let trip = contentArray[index]
        showRideDetailsScreen(trip: trip)
//        pushViewController(controllerIdentifier: PastTripsDetailViewController.nameOfClass(), navigationTitle: PastTripsDetailViewController.nameOfClass())
    }
}

extension PastTripsViewController: UpComingTripsCellDelegate {
    func onClickViewDetail(UpComingTripsCell index: Int, _ sender: Any) {
        let trip = contentArray[index]
        showRideDetailsScreen(trip: trip)
    }
}


extension PastTripsViewController : GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        var latitude = ""
        var longitude = ""
        var formattedAddress = ""
        
        if (place.formattedAddress != nil){
            latitude = String(place.coordinate.latitude)
            longitude = String(place.coordinate.longitude)
            formattedAddress = place.formattedAddress!
        }
            
        else{
            placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID(place.placeID ?? "", callback: { (objGMSPlace, error) in
                if (objGMSPlace != nil){
                    latitude = String(place.coordinate.latitude)
                    longitude = String(place.coordinate.longitude)
                    formattedAddress = place.formattedAddress!
                }
            })
        }
        
        self.destinationLabel.text = formattedAddress
        self.getPastTrips(latitude: latitude, longitude: longitude)
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}
