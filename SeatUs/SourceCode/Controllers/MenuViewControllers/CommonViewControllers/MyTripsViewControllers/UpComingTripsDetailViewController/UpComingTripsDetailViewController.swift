//
//  UpComingTripsDetailViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class UpComingTripsDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var contentArray : [PostTrip]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = PostTrip.getPostTripData(name: FileNames.UpcomingTripsPlist)
        registerCustomCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerCustomCell(){
        
        for cell in [OffersDetailCell.nameOfClass(),RatingDetailsCell.nameOfClass(),LabelCell.nameOfClass(),MultipleCheckboxCell.nameOfClass(),SeatsCell.nameOfClass(),DateButtonCell.nameOfClass(),ActionDetailsCell.nameOfClass(),ActionButtonCell.nameOfClass(),SingleActionButtonCell.nameOfClass(),SingleActionButtonCell.nameOfClass()] {
            let cellNib = UINib(nibName: cell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension UpComingTripsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = contentArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: object.cellidentifier , for: indexPath)
        
        switch cell {
            
        case is OffersDetailCell:
            
            let offersDetailCell = cell as! OffersDetailCell
            offersDetailCell.state = .isComingFromUpcomingTrips
            offersDetailCell.hideRatingView()
            
        case is LabelCell:
            
            let labelCell = cell as! LabelCell
            labelCell.initializeCell(contentArray[indexPath.row])
            labelCell.selectButton.tag = indexPath.row
            //            labelCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
            
        case is DateButtonCell:
            
            let dateCell = cell as! DateButtonCell
            dateCell.initializeCell(contentArray[indexPath.row])
            dateCell.selectButton.tag = indexPath.row
            //            dateCell.selectButton.addTarget(self, action: #selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
            break
            
        case is MultipleCheckboxCell:
            
            let multipleCheckboxCell = cell as! MultipleCheckboxCell
            multipleCheckboxCell.initializeCell(contentArray[indexPath.row])
            multipleCheckboxCell.tag = indexPath.row
            multipleCheckboxCell.isEnabled = false
            //multipleCheckboxCell.delegate = self
            break
            
        case is SeatsCell:
            
            let seatsCellCell = cell as! SeatsCell
            seatsCellCell.initializeCell(contentArray[indexPath.row])
            seatsCellCell.tag = indexPath.row
            break
            
        case is ActionButtonCell:
            
            let actionButtonCell = cell as! ActionButtonCell
            actionButtonCell.initializeCell(contentArray[indexPath.row])
            actionButtonCell.delegate = self
            break
            
        case is SingleActionButtonCell:
            
            let singleActionButtonCell = cell as! SingleActionButtonCell
            singleActionButtonCell.initializeCell(contentArray[indexPath.row])
            singleActionButtonCell.delegate = self
            break
            
        case is ActionDetailsCell:
            
            let actionDetailsCell = cell as! ActionDetailsCell
            actionDetailsCell.delegate = self
            break
            
        default:
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
    
}

extension UpComingTripsDetailViewController: MultipleCheckboxCellDelegate {
   
    func rideTimeButtonClicked(){
    }

    func clickEvent(_ tag: Int, CheckboxStates checkboxStates: [CheckboxState]) {
        print("called")
    }
}

extension UpComingTripsDetailViewController: ActionButtonCellDelegate {
    func leftButtonClicked(_ sender: Any) {
        print("called")
    }
    
    func rightButtonClicked(_ sender: Any) {
        print("called")
    }
}

extension UpComingTripsDetailViewController: SingleActionButtonCellDelegate {
    func onClickButton(_ sender: Any, tag: Int) {
        pushViewController(controllerIdentifier: RideSeatsDetailViewController.nameOfClass(), navigationTitle: RideSeatsDetailViewController.nameOfClass())
        print("called")
    }
}

extension UpComingTripsDetailViewController: ActionDetailsCellDelegate {
    func onClickViewMap(_ sender: Any) {
        print("called")
    }
    
    func onClickShare(_ sender: Any) {
        pushViewController(controllerIdentifier: ItineraryDetailsViewController.nameOfClass() , navigationTitle: "Itinerary Details")
    }
}
