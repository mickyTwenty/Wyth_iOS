//
//  ProfileViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/27/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var dobLable : UILabel!
    @IBOutlet weak var genderLable : UILabel!
    @IBOutlet weak var phoneLable : UILabel!
    @IBOutlet weak var stateLable : UILabel!
    @IBOutlet weak var cityLable : UILabel!
    @IBOutlet weak var zipLable : UILabel!
    @IBOutlet weak var schoolNameLable : UILabel!
    @IBOutlet weak var schoolEmailLable : UILabel!
    @IBOutlet weak var graduationYearLable : UILabel!
    @IBOutlet weak var studentOrganizationLable : UILabel!
    @IBOutlet weak var licenceLable : UILabel!
    @IBOutlet weak var documentsLable : UILabel!
    @IBOutlet weak var vehicleTypeLable : UILabel!
    @IBOutlet weak var vehicleIDLable : UILabel!
    @IBOutlet weak var vehicleMakeLable : UILabel!
    @IBOutlet weak var vehicleModelLable : UILabel!
    @IBOutlet weak var vehicleYearLable : UILabel!
    @IBOutlet weak var companyNameLable : UILabel!
    @IBOutlet weak var friendsCountLable : UILabel!
    @IBOutlet weak var userNameLable : UILabel!
    @IBOutlet weak var driverFiledsView : UIStackView!
    @IBOutlet weak var studentOrgSeperater : UIView!
    @IBOutlet weak var documentCounterLable : UILabel!
    @IBOutlet weak var userImageView : ProfileImageView!

    @IBOutlet weak var cancelledTripLabel: UILabel!
    @IBOutlet weak var driverCancelledTripLabel: UILabel!
    @IBOutlet weak var driverCancelledView: UIView!
    @IBOutlet weak var ratingView : RatingView!
    
    @IBOutlet weak var ssnoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ratingView.rating = User.getUserRating()!

        self.updateValues()

        let url = URL(string: User.getProfilePictureUrl()!)
        userImageView.profileImageView.af_setImage(withURL: url!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserImage), name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)
    }
    
    @objc func updateUserImage(){
        
        let url = URL(string: User.getProfilePictureUrl()!)
        userImageView.profileImageView.af_setImage(withURL: url!)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let token = User.getUserAccessToken() as AnyObject
        let dict : [String: AnyObject] = [ApplicationConstants.Token:token]
        User.aboutMe(param: dict) { (object, message, action, status) in
            self.updateValues()
            self.updateViewWithRefrenceOfUser()
        }
    }

    
    func updateValues(){
        
        let servereDate = User.sharedInstance.birth_date ?? ""
        let dateString = Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateFormatClient, dateString: servereDate)
        
        let number = Utility.getFormatedNumber(phoneNumber: User.sharedInstance.phone!) 

        userNameLable.text = User.getUserName()
        dobLable.text = dateString
        genderLable.text = User.sharedInstance.gender ?? ""
        phoneLable.text = number 
        stateLable.text = User.sharedInstance.state_text ?? ""
        cityLable.text = User.sharedInstance.city_text ?? ""
        zipLable.text = User.sharedInstance.postal_code ?? ""
        schoolNameLable.text = User.sharedInstance.school_name
        schoolEmailLable.text = User.sharedInstance.email ?? ""
        graduationYearLable.text = User.sharedInstance.graduation_year ?? ""
        studentOrganizationLable.text = User.sharedInstance.student_organization ?? ""
        licenceLable.text = User.sharedInstance.driving_license_no ?? ""
        vehicleTypeLable.text = User.sharedInstance.vehicle_type ?? ""
        vehicleIDLable.text = User.sharedInstance.vehicle_id_number ?? ""
        vehicleMakeLable.text = User.sharedInstance.vehicle_make ?? ""
        vehicleModelLable.text = User.sharedInstance.vehicle_model ?? ""
        vehicleYearLable.text = User.sharedInstance.vehicle_year ?? ""
        friendsCountLable.text =  User.sharedInstance.follower_count?.stringValue ?? ""
        updateUserImage()
        cancelledTripLabel.text = User.sharedInstance.trips_canceled?.stringValue ?? "0"
        driverCancelledTripLabel.text = User.sharedInstance.trips_canceled_driver?.stringValue ?? "0"
        ssnoLabel.text = User.sharedInstance.ssn
        
        ssnoLabel.superview?.isHidden = true
//        if Utility.isDriver() {
//            driverCancelledTripLabel.text = User.sharedInstance.trips_canceled_driver?.stringValue ?? "0"
//        }
//        else {
//            driverCancelledView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//            for view in driverCancelledView.subviews {
//                view.isHidden = true
//            }
//        }
    }
    
    @IBAction func editProfileButtonClicked(sender : UIButton){
        print("editProfileButtonClicked")
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func documentViewerButtonClicked(sender : UIButton){
    }
    
    @IBAction func friendsButtonClicked(sender : UIButton){
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: FriendsViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func changePasswordButtonClicked(sender:UIButton){
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: ChangePasswordViewController.nameOfClass())
        cont.show(controller: self)
    }

    @IBAction func deleteAccountButtonClicked(sender:UIButton){
        showAccountDeleteAlert(controller: self)
    }
    
    func showAccountDeleteAlert(controller:BaseViewController){
        
        let alert = UIAlertController(title: ApplicationConstants.AccountDeleteTitle, message: ApplicationConstants.AccountDeleteMessage, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            
        })
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            
            let dict: [String:AnyObject] = [ApplicationConstants.Token:User.getUserAccessToken() as AnyObject]

            User.deleteAccount(param: dict) { (object, message, active, status) in
                if status!{
                    self.disimissDashBorad()
                }
            }
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }


    func updateViewWithRefrenceOfUser(){
        
        let userType = User.getUserType()
        switch userType {
            
        case UserType.UserNormal?:
            hideDriverFields(shouldHide: true)
            break
            
        case UserType.UserDriver? :
            hideDriverFields(shouldHide: false)
            break
            
        default:
            break
            
        }
    }
    
    func hideDriverFields(shouldHide:Bool){
    
        driverFiledsView.isHidden = shouldHide
        studentOrgSeperater.isHidden = shouldHide
        ssnoLabel.isHidden = shouldHide
        
        if shouldHide {
            driverCancelledView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            for view in driverCancelledView.subviews {
                view.isHidden = true
            }
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
