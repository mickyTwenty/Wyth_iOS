//
//  LeftMenuViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/21/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import FZAccordionTableView

protocol LeftMenuTransitionDelegate: class {
    func didSelectHeader(objSubMenuDetail:SideMenuOption)
    func didSelectRow(objSubMenuDetail:SubMenuDetail)
    func didSelectRow(objSubMenuDetail:SideMenuOption, index:Int)
}

class LeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FZAccordionTableViewDelegate {

    @IBOutlet weak var listingOptionLbl: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var userImageButton: UIButton!

    @IBOutlet weak var ratingView: RatingView!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableContentView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: FZAccordionTableView!
    @IBOutlet var bottomConstraintTblView : NSLayoutConstraint!
    weak var menuTransitionDelegate : LeftMenuTransitionDelegate?
    
    var contentArray : [SideMenuOption]!
    var chatCount : String!  = "0"
    var notifCount : String! = "0"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setData()
        loadLastSelectedStateOfUser()
        addSwipeGesture()
        setupUpTableViewOptions()
        updateUserImage()
        
      _ = FireBaseManager.sharedInstance.addListenerToChatCount { (count) in
            
            let counter = count[FireBaseConstant.unreadChatCount]
            let unreadNotificationCount = count[FireBaseConstant.unreadNotificationCount]
        
            if (counter != nil){
               _ = self.calculateChatCount(count: counter as! Int)
            }
            else{
              _ = self.calculateChatCount(count: 0)
            }
        
            if (unreadNotificationCount != nil){
                _  = self.calculateNotoficationCount(count: unreadNotificationCount as! Int)
            }
            else{
                _ = self.calculateNotoficationCount(count: 0)
            }
            self.sideMenuTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserImage), name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)
    }
    
    
    @objc func calculateChatCount(count:Int)->(String){
        
        chatCount = "\(count)"
        return chatCount
    }

    
    @objc func calculateNotoficationCount(count:Int)->(String){
    
        notifCount = "\(count)"
        return notifCount
    }

    @objc func updateUserImage(){
    
        let url = URL(string: User.getProfilePictureUrl()!)
        userImageView?.af_setImage(withURL: url!)
        ratingView.rating = User.getUserRating()!
        userImageView?.setRounded()
    }
    
    
    func setData(){
        switchButton.isSelected = (User.getUserType() == UserType.UserDriver)
        userNameLbl.text = User.getUserName()
        addressLbl.text = User.getUserAddress()
    }
    
    
    func getData(userType:String){
        contentArray = SideMenuOption.getSideMenuData(userType: userType)
        sideMenuTableView.reloadData()
    }
    
    func loadLastSelectedStateOfUser(){
        
        switch User.sharedInstance.user_type {
        case UserType.UserNormal?:
            loadPassengerData()
            break
            
        case UserType.UserDriver?:
            
            switch Utility.getUserType(){
                
                case UserType.UserNormal:
                    loadPassengerData()
                    break
                
                case UserType.UserDriver:
                    loadDriverData()
                    break
                
                default:
                    break
                
            }
            break
            
        default:
            break
        }
        
    }

    
    func loadDriverData(){
        contentArray = SideMenuOption.getSideMenuData(userType: UserType.UserDriver)
        self.listingOptionLbl.text = ApplicationConstants.ListingTypeUserDriver
        switchButton.isSelected = true

    }
    
    func loadPassengerData(){
        contentArray = SideMenuOption.getSideMenuData(userType: UserType.UserNormal)
        self.listingOptionLbl.text = ApplicationConstants.ListingTypeUserPassenger
        switchButton.isSelected = false
    }
    

    @IBAction func userProfileButtonClicked(sender: UIButton){
        
        backgroundButtonClicked(sender: nil)
        let controller = storyboard?.instantiateViewController(withIdentifier: ProfileViewController.nameOfClass())
        navigationController?.viewControllers = [controller!]
    }
    
    
    func setupUpTableViewOptions(){
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.allowMultipleSectionsOpen = true
        sideMenuTableView.estimatedRowHeight = 44
        sideMenuTableView.register(UINib(nibName: SideMenuCell.nameOfClass(), bundle: nil), forCellReuseIdentifier: SideMenuCell.nameOfClass())
        
        // register cell
        sideMenuTableView.register(UINib(nibName: SideMenuHeader.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: SideMenuHeader.nameOfClass())
        
        // register chat header
        sideMenuTableView.register(UINib(nibName: SideMenuChatCell.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: SideMenuChatCell.nameOfClass())
        
        // register notification header
        sideMenuTableView.register(UINib(nibName: SideMenuNotificationHeader.nameOfClass(), bundle: nil), forHeaderFooterViewReuseIdentifier: SideMenuNotificationHeader.nameOfClass())

        sideMenuTableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let objSideMenuOption = contentArray[section]
        if objSideMenuOption.subCatArray != nil{
            return objSideMenuOption.subCatArray.count
        }
        else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let object: SideMenuOption = contentArray[section]
        
        let objFZAccordionTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: object.cellidentifier)
        
        switch objFZAccordionTableViewHeaderView{
            
        case is SideMenuHeader:
            
            let sideMenuHeader = objFZAccordionTableViewHeaderView as! SideMenuHeader
            sideMenuHeader.headerLbl.text = object.title
            sideMenuHeader.downArrowImageView.isHidden = !(object.subCatArray != nil)
            break
            
        case is SideMenuChatCell :
            
            let sideMenuChat = objFZAccordionTableViewHeaderView as! SideMenuChatCell
            sideMenuChat.headerLbl.text = object.title
            object.chatCount = chatCount
            sideMenuChat.chatCounterLbl.text  = chatCount
            if let count = Int(chatCount){
                if count <=  0 {
                    sideMenuChat.chatCounterLbl.text  = ""
                    sideMenuChat.chatCounterImageView.isHidden = true
                }
                else{
                    sideMenuChat.chatCounterImageView.isHidden = false
                }
            }
            
            break
            
        case is SideMenuNotificationHeader:
            let sideMenuNotif = objFZAccordionTableViewHeaderView as! SideMenuNotificationHeader
            sideMenuNotif.headerLbl.text = object.title
            object.notifCount = notifCount
            sideMenuNotif.notificationCounterLbl.text = notifCount
            
            if let count = Int(notifCount){
                if count <=  0 {
                    sideMenuNotif.notificationCounterLbl.text  = ""
                    sideMenuNotif.notificationCounterImageView.isHidden = true
                }
                else{
                    sideMenuNotif.notificationCounterImageView.isHidden = false
                }
            }
            break
            
        default :
            break
        }
        return objFZAccordionTableViewHeaderView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell   = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.nameOfClass(), for: indexPath) as! SideMenuCell
        
        let objectMain = contentArray[indexPath.section]
        let subCat = objectMain.subCatArray[indexPath.row]
        
        cell.titleLabel.text = subCat.title
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objSideMenuOption = contentArray[indexPath.section]
        menuTransitionDelegate?.didSelectRow(objSubMenuDetail: objSideMenuOption, index: indexPath.row)
    }

    
    // MARK: - UserSwitch PopUp

    @IBAction func userSwitchedChanged(_ sender: Any) {
        
        switch User.getUserType(){
            
        case UserType.UserNormal?:
            showUserSwicthPopUp()
            break
            
        case UserType.UserDriver?:
            self.switchButton.isSelected = !self.switchButton.isSelected
            performAnimationForUserTypeChanges(passengerButton: switchButton)
            break
            
        default:
            break
        }
    }
    
    func performAnimationForUserTypeChanges(passengerButton:UIButton){
        animationOnTopMenu(passengerButton: passengerButton)
    }
    
    func showUserSwicthPopUp(){
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: UpgradeUserViewController.nameOfClass())
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            
            self.goToUpgradeUser()
        }

    }
    
    
    func goToUpgradeUser(){
        
        let sideMenuOption = SideMenuOption()
        sideMenuOption.controllerid = UpgradeToDriverViewController.nameOfClass()
        sideMenuOption.navigationtitle = "UPGRADE TO DRIVER"
        menuTransitionDelegate?.didSelectHeader(objSubMenuDetail: sideMenuOption)
    }
    
    
    func animationOnTopMenu(passengerButton: UIButton){
        
        // getting MenuView width
        passengerButton.isUserInteractionEnabled = false
        let widthConstraint:NSLayoutConstraint = menuView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([widthConstraint])
        
        // getting height of TableView
        let height: CGFloat = tableContentView.frame.size.height
        bottomConstraintTblView.constant = height - 10

        
        UIView.animate(withDuration: ApplicationConstants.OptionsLblAnimationType, animations: {
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            widthConstraint.isActive=false
            UIView.animate(withDuration: ApplicationConstants.OptionsLblAnimationType, animations: {
                
                // animation to scroll tableView to bottom
                self.bottomConstraintTblView.constant = 0

                if !passengerButton.isSelected {
//                    self.navigationController?.viewControllers = [Utility.getPassengerController()]

                    self.listingOptionLbl.text = ApplicationConstants.ListingTypeUserPassenger
                    self.getData(userType: UserType.UserNormal)
                    Utility.setUserType(type: UserType.UserNormal)
                }
                else{

                    self.listingOptionLbl.text = ApplicationConstants.ListingTypeUserDriver
                    self.getData(userType: UserType.UserDriver)
                    Utility.setUserType(type: UserType.UserDriver)

                }
                self.view.layoutIfNeeded()
                
            }) { (isCompleted) in
            
                self.setInterface()
                passengerButton.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func setInterface(){
        
        let sideMenuOption = SideMenuOption()
        sideMenuOption.navigationtitle = Utility.loadLastSelectedStateOfUser()

        switch Utility.getUserType(){
            
//        case UserType.UserDriver:
//            //sideMenuOption.controllerid = PostTripViewController.nameOfClass()
//            break
//            
//        case UserType.UserNormal:
//            //sideMenuOption.controllerid = FindRidesViewController.nameOfClass()
//            break
            
        default:
            sideMenuOption.controllerid = PassengerTripController.nameOfClass()
            break
            
        }
        self.menuTransitionDelegate?.didSelectHeader(objSubMenuDetail: sideMenuOption)
    }

    
    func addSwipeGesture(){
        
        let swipGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(gesture:)))
        swipGesture.direction = .left
        view.gestureRecognizers = [swipGesture]
    }
    
    @objc func leftSwipe(gesture : UISwipeGestureRecognizer){
       
        if gesture.state == .ended{
            backgroundButtonClicked(sender: nil)
        }
    }

    @IBAction func backgroundButtonClicked(sender:UIButton?){

        let option = SideMenuOption()
        option.controllerid = ""
        menuTransitionDelegate?.didSelectHeader(objSubMenuDetail: option)
    }

    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        let objSideMenuOption = contentArray[section]
        self.sideMenuTableView.isSectionOpen(section)
        if objSideMenuOption.subCatArray == nil{
            menuTransitionDelegate?.didSelectHeader(objSubMenuDetail: objSideMenuOption)
        }
    }
    
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("willCloseSection")
        let objSideMenuOption = contentArray[section]
        self.sideMenuTableView.isSectionOpen(section)
        if objSideMenuOption.subCatArray == nil{
            menuTransitionDelegate?.didSelectHeader(objSubMenuDetail: objSideMenuOption)
        }
    }

    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?){
        print("didOpenSection")

        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?){
        print("didCloseSection")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        backgroundButtonClicked(sender: nil)
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.MenuHelp
        present(controller, animated: true, completion: nil)
        
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
