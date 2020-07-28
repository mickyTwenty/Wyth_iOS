//
//  MarkTripSelectionController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 06/02/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class MarkTripSelectionController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate : TripTrackingViewController!
    var contentArray: [Passenger]! = []

    var trip_id: String!
    let cellName = MarkPassengerTripCell.nameOfClass()
    var tripService: MarkTripsConstant!
    var coordinates:String = ""
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    var isDropOffSelection: Bool {
        return ( tripService == MarkTripsConstant.DropOff)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
//        view.isOpaque = false

        if !isDropOffSelection {
            headingLabel.text = "Mark Pickup"

        } else {
            headingLabel.text = "Mark Dropoff"
        }

        if let passengers = contentArray {
            contentArray = passengers
            heightTableView.constant = CGFloat(75 * passengers.count + 20)
            registerCustomCell()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCustomCell(){
        
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func onDoneButtonClicked(_ sender: Any) {
        if isDropOffSelection {
            contentArray = contentArray.filter( { ($0.is_dropped?.boolValue)! == true } )
        } else {
            contentArray = contentArray.filter( { ($0.is_picked?.boolValue)! == true } )
        }
        
        if contentArray.count > 0 {
            
            let passenger_ids = contentArray.compactMap { $0.user_id?.stringValue }
            
            Trip.markTrip(passenger_ids: passenger_ids, tripId: trip_id, tripService: tripService,coordinates:coordinates)
            { (object, message, active, status) in
                let markObject = Trip.getTrip(object!)
                self.presentingViewController?.dismiss(animated: true, completion: {
                    self.delegate.tripInfo = markObject
                    self.delegate.updateView()
                })
            }
        }
        else{
            self.presentingViewController?.dismiss(animated: true, completion: {
            })

        }
    }
    
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        
        for (_, value ) in contentArray.enumerated(){
            if isDropOffSelection {
                value.is_dropped = NSNumber(booleanLiteral: false)
            } else {
                value.is_picked = NSNumber(booleanLiteral: false)
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: {
        })

    }
    
}

extension MarkTripSelectionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let passenger = contentArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName , for: indexPath) as! MarkPassengerTripCell
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.initializeCell(passenger)
        cell.delegate = self
        if isDropOffSelection {
            cell.checkboxView.setCheckBoxState((passenger.is_dropped?.boolValue)!)
        } else {
            cell.checkboxView.setCheckBoxState((passenger.is_picked?.boolValue)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension MarkTripSelectionController: MarkPassengerTripCellDelegate {
    func clickEvent(LabelCheckBoxIndex tag: Int, isSelected: Bool) {
        let passenger = contentArray[tag]
        if isDropOffSelection {
            passenger.is_dropped = isSelected as NSNumber
        } else {
            passenger.is_picked = isSelected as NSNumber
        }
    }
}
