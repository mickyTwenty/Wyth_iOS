//
//  ProfileViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/27/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class FreindProfileViewController: BaseViewController {

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
    @IBOutlet weak var ratingView: RatingView!
    
    var friendsID : String! = ""
    var hideDriverFields: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateViewWithRefrenceOfUser()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let token = User.getUserAccessToken() as AnyObject
        let dict : [String: AnyObject] = [ApplicationConstants.Token:token,"user_id":friendsID as AnyObject]
        
        User.friendProfile(param: dict) { (message, object, active, status) in
            self.updateValues(freindObject: message as! FriendProfile)
        }
    }

    
    func updateValues(freindObject:FriendProfile){
        
        if hideDriverFields == nil {
            hideDriverFields(shouldHide: Utility.isDriver())
        }
        else {
            hideDriverFields(shouldHide: hideDriverFields!)
        }
        
        ratingView.rating = User.getUserRating()!
        if let rating = freindObject.rating{
            ratingView.rating = Float(rating)!
        }

        let servereDate = freindObject.birth_date ?? ""
        let dateString = Utility.dateFormater(clientFormat: ApplicationConstants.DateFormatClient, serverFormat: ApplicationConstants.DateFormatClient, dateString: servereDate)
        
        let number = Utility.getFormatedNumber(phoneNumber: User.sharedInstance.phone!) 

        userNameLable.text = freindObject.first_name! + " "  + freindObject.last_name!
        dobLable.text = dateString
        genderLable.text = freindObject.gender ?? ""
        phoneLable.text = number 
        stateLable.text = freindObject.state_text ?? ""
        cityLable.text = freindObject.city_text ?? ""
        zipLable.text = freindObject.postal_code ?? ""
        schoolNameLable.text = freindObject.school_name
        schoolEmailLable.text = freindObject.email ?? ""
        graduationYearLable.text = freindObject.graduation_year ?? ""
        studentOrganizationLable.text = freindObject.student_organization ?? ""
        licenceLable.text = freindObject.driving_license_no ?? ""
        vehicleTypeLable.text = freindObject.vehicle_type ?? ""
        vehicleIDLable.text = freindObject.vehicle_id_number ?? ""
        vehicleMakeLable.text = freindObject.vehicle_make ?? ""
        vehicleModelLable.text = freindObject.vehicle_model ?? ""
        vehicleYearLable.text = freindObject.vehicle_year ?? ""
        friendsCountLable.text =  freindObject.follower_count?.stringValue ?? ""
        
        let url = URL(string: freindObject.profile_picture!)
        userImageView.profileImageView.af_setImage(withURL: url!)

    }
    
    @IBAction func editProfileButtonClicked(sender : UIButton){
        print("editProfileButtonClicked")
        let  controller = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.nameOfClass())
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    @IBAction func documentViewerButtonClicked(sender : UIButton){}
    
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
        
        hideDriverFields(shouldHide: true)
        
        /*
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
 */
    }
    
    func hideDriverFields(shouldHide:Bool){
    
        driverFiledsView.isHidden = shouldHide
        studentOrgSeperater.isHidden = shouldHide
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
