//
//  RatingCommentsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 31/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class RatingCommentsViewController: ModalAlertBaseViewController {

    @IBOutlet weak var ratingField: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var commentsTextField: ValidaterTextField!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var nameField: UILabel!
        
    var hideRatingField = true
    var name: String!
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.setButtonsTarget()
        ratingField.isHidden = hideRatingField
        
        if let contentDict = contentDict {
            if let name = contentDict["driver_name"] as? String {
                self.name = name
            }
            if let date = contentDict["date"] as? String {
                self.date = date
            }
        }
        
        if name != nil {
            nameField.text = "Name: " + name
        }
        if date != nil {
            dateField.text = "Date: " + date
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.close()
        doneButtonTapped?(selectedData)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {

        let rate = RateModel()
        rate.rating = String(Int(ratingView.rating))
        rate.feedback = commentsTextField.text
        
        self.contentArray = [rate]
        
        self.dismissView()


    }
    
    func dismissView(){
        self.close()
        self.selectButtonTapped?(self.contentArray[0] as AnyObject)
    }
    
}
