 //
//  BaseViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/21/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,LeftMenuTransitionDelegate {
    
    
    // MARK: - BaseViewController helper methods
    var leftMenuViewController: LeftMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setLeftBarButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPendingAlert), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLeftBarButtons()
        
//        let notAllowedControllers = [ PassengerRatingViewController.nameOfClass(), PendingRatingViewControllers.nameOfClass(), PassengersPendingRatingViewController.nameOfClass(), DriversPendingRatingViewController.nameOfClass() ]
//
//        if ( notAllowedControllers.contains(String(describing: type(of: self))) ){
//
//            return
//
//        }
        
        //showPendingAlert()
        
    }

    func setObserver(){
        if self is CreateTripModifiedController {
            if !Utility.isDriver() {
                NotificationCenter.default.addObserver(self, selector: #selector(driverUpdatedAlert), name: Notification.Name(ApplicationConstants.DriverUpdatedNotification), object: nil)
            
                _ = FireBaseManager.sharedInstance.addListenerToChatCount { (count) in
                
                }
            
            
            }
        }
    }
    
    @objc func driverUpdatedAlert(notification: NSNotification) {
        DispatchQueue.main.async {
            if let notif = notification.userInfo![FireBaseConstant.driverNode]{
                self.driverUpdated(driver: notif as? [String : Any])
        //        self.addDriverToList(driver: notif as! [String : Any])
            }
            else{
                self.driverUpdated(driver: nil)
       //         self.deleteDriverFromList()
            }
        }
    }
    
    func driverUpdated(driver: [String : Any]?){

    }
    
    func setLeftBarButtons(){
        
        if self.navigationController != nil{
            let leftBarButton: UIButton!
            if self.navigationController!.viewControllers.count > 1 {
                leftBarButton = getBackButton()
            }
            else{
                leftBarButton = getMenuButton()
            }
            let barButton = UIBarButtonItem.init(customView: leftBarButton)
            self.navigationItem.leftBarButtonItem = barButton
            
            if Utility.isDriver() {
                showDriverButton()
                self.navigationController?.navigationBar.barTintColor = ApplicationConstants.DriverThemeColor
            }
            else {
                self.navigationController?.navigationBar.barTintColor = ApplicationConstants.PassengerThemeColor
            }
        }
    }
    
    func getBackButton()->UIButton{
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage.init(named: AssetsName.SideMenuBackButton), for: UIControl.State.normal)
        backButton.addTarget(self, action:#selector(backButtonClicked(sender:)), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        return backButton
    }
    
    func getMenuButton()->UIButton{
        
        let menuButton = UIButton.init(type: .custom)
        menuButton.setImage(UIImage.init(named: AssetsName.MenuButtonImage), for: UIControl.State.normal)
        menuButton.addTarget(self, action:#selector(menuButtonclicked), for: UIControl.Event.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        return menuButton
    }
    
    func showDriverButton(){
        
        if self.navigationItem.rightBarButtonItems == nil {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem]()
        }
        
        let accessibilityIdentifier = "driverbutton"
        
        for rightBarButtonItem in self.navigationItem.rightBarButtonItems! {
            
            if rightBarButtonItem.accessibilityIdentifier != nil && rightBarButtonItem.accessibilityIdentifier == accessibilityIdentifier {
                
                return
                
            }
            
        }
        
        let driverButton = UIButton.init(type: .custom)
        driverButton.setImage(UIImage.init(named: AssetsName.DriverIconImage), for: UIControl.State.normal)
        driverButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let driverBarButton = UIBarButtonItem.init(customView: driverButton)
        driverBarButton.accessibilityIdentifier = accessibilityIdentifier
        self.navigationItem.rightBarButtonItems?.append(driverBarButton)
        
    }
    
    
    @objc func menuButtonclicked(){
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        if leftMenuViewController == nil{
            leftMenuViewController = (self.storyboard?.instantiateViewController(withIdentifier: LeftMenuViewController.nameOfClass()))! as! LeftMenuViewController
            leftMenuViewController.menuTransitionDelegate = self
        }
        
        leftMenuViewController?.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        navigationController?.addChild(leftMenuViewController!)
        navigationController?.view.addSubview((leftMenuViewController?.view)!)
        
        UIView.animate(withDuration: ApplicationConstants.AnimationDuration, animations: {
            self.leftMenuViewController?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (isCompleted) in
            print("isCompleted")
        }
    }
  
    
    @objc func enableWithDelay(){
        print("enableWithDelay")
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func backButtonClicked(sender: UIButton){
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - LeftMenuTransitionDelegate Delegate
    func didSelectHeader(objSubMenuDetail: SideMenuOption ) {
        
        self.performActionOnSideMenuHeader(obj: objSubMenuDetail)
        closeLeftMenu()
    }
    
    func didSelectRow(objSubMenuDetail: SideMenuOption, index:Int) {
        
        self.performActionOnSideMenuHeader(obj: objSubMenuDetail, index:index)
        closeLeftMenu()
        
    }
    
    func didSelectRow(objSubMenuDetail: SubMenuDetail) {
        closeLeftMenu()
    }
    
    
    func closeLeftMenu(){
        
        UIView.animate(withDuration: ApplicationConstants.AnimationDuration, animations: {
            self.leftMenuViewController?.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (isCompleted) in
            self.leftMenuViewController?.view.removeFromSuperview()
            self.leftMenuViewController?.removeFromParent()
            self.enableWithDelay()
        }

    }
    func performActionOnSideMenuHeader(obj:SideMenuOption){
        
        switch obj.controllerid {
        case LogOutViewController.nameOfClass() :
            showLogoutPopup()
            break
            
        case BookNowViewController.nameOfClass() :
            break
            
        case MakeOfferViewController.nameOfClass() :
            break
            
            
        case NotificationsViewController.nameOfClass():
            if Int(obj.notifCount)! > 0 {
                Utility.resetBadgeCount()
                FireBaseManager.sharedInstance.resetNotifCount()
            }
            pushController(controllerIdentifier: obj.controllerid,navigationTitle: obj.navigationtitle ?? "")

            break
            
            
        case MessagingViewController.nameOfClass():
            if Int(obj.chatCount)! > 0 {
                FireBaseManager.sharedInstance.resetChatCount()
            }
            pushController(controllerIdentifier: obj.controllerid,navigationTitle: obj.navigationtitle ?? "")
            break
            
        case UpgradeToDriverViewController.nameOfClass() :
            
            let optionEditPtofile = SideMenuOption()
            optionEditPtofile.controllerid = ProfileViewController.nameOfClass()
            optionEditPtofile.navigationtitle = "Manage Profile"
            pushMultiControler(firstControllerModel: optionEditPtofile, secondControllerModel: obj)
            break
            
        case ApplicationConstants.InvitePeoplePopup :
            
            let message = "Check out this cool new app called Wyth - it's a city-to-city carpooling app designed exclusively for college students.\nDownload it now at Apple store: " + ApplicationConstants.iTunesUrl
            Utility.send(Message: message, ToNumber: "")

            break
            
        default:
            if !obj.controllerid.isEmpty{
                pushController(controllerIdentifier: obj.controllerid,navigationTitle: obj.navigationtitle ?? "")
            }
            break
        }
    }
    
    func performActionOnSideMenuHeader(obj:SideMenuOption, index:Int){
        
        if !obj.controllerid.isEmpty{
            pushController(controllerIdentifier: obj.controllerid, navigationTitle: obj.navigationtitle ?? "", conditons: index)
        }
    }
    
    func pushController(controllerIdentifier:String, navigationTitle: String, conditons: Any = ""){
        
        var controller = self.storyboard?.instantiateViewController(withIdentifier: controllerIdentifier)
        controller?.navigationItem.title = navigationTitle
        
        switch controller {
            
        case is MyTripsViewController:
            
            let viewController = controller as! MyTripsViewController
            viewController.selectedTab = conditons as! Int
            break
            
        case is ChatViewController:
            
            let viewController = controller as! ChatViewController
            viewController.trip = conditons as! Trip
            break
            
        case is PassengerCreateTripViewController:            
            break
            
        
        
            
        default:
            break
        }

        navigationController?.viewControllers = [controller!]

    }
    

    
    func pushViewController(controllerIdentifier:String, navigationTitle: String, conditons: Any = ""){

        let  controller = self.storyboard?.instantiateViewController(withIdentifier: controllerIdentifier)
        controller?.navigationItem.title = navigationTitle
        
        switch controller {
        case is AddFriendsViewController:
            
            let addFriendsViewController = controller as! AddFriendsViewController
            addFriendsViewController.cellName = conditons as! String
            break
           
        case is FriendsSearchViewController:
            
            let viewController = controller as! FriendsSearchViewController
            let conditons = conditons as! [String:Any]
            viewController.delegate = conditons["delegate"] as! FriendsSearchViewControllerDelegate
            viewController.isManuallyAdded = conditons["isManuallyAdded"] as! Bool
            break
            
        case is OffersDetailViewController:
            
            let viewController = controller as! OffersDetailViewController
            viewController.trip = conditons as! Trip
            break
            
            
        case is ChatViewController:
            
            let totalPassengers = (conditons as! Trip).passengers?.count ?? 0
            if totalPassengers <= 0 {
                Utility.showAlertwithOkButton(message: "There is currently no one to chat in this trip.", controller: self)
                return
            }
            
            let viewController = controller as! ChatViewController
            viewController.trip = conditons as! Trip
            break
            
        case is PassengerRatingViewController:
            
            let viewController = controller as! PassengerRatingViewController
            viewController.tripInfo = conditons as! Trip
            break
            
        case is ItineraryDetailsViewController:
            
            let viewController = controller as! ItineraryDetailsViewController
            viewController.trip = conditons as! Trip
            break
            
        case is CreateTripModifiedController:
            
            let viewController = controller as! CreateTripModifiedController
            viewController.selectedRoute = conditons as! Route
            break
         
        case is SharedItineraryListViewController:
            
            let viewController = controller as! SharedItineraryListViewController
            viewController.sharedItinerary = conditons as! [[String : Any]]
            break
            
        case is SearchRidesViewController:
            
            let viewController = controller as! SearchRidesViewController
            viewController.selectedRoute = conditons as! Route
            break
            
        case is AddBankDetailViewController:
            
            let viewController = controller as! AddBankDetailViewController
            viewController.isComeFromRouteSelectionScreen = (conditons as? Bool) ?? false
            break
            
        case is MyPaymentsViewController:
            
            let viewController = controller as! MyPaymentsViewController
            viewController.isComeFromRideDetailsScreen = (conditons as? Bool) ?? false
            break
            
        default:
            break
        }
        
        navigationController?.pushViewController(controller!, animated: true)
        
    }
    
    func pushMultiControler(firstControllerModel:SideMenuOption, secondControllerModel:SideMenuOption){
        
        let firstController = self.storyboard?.instantiateViewController(withIdentifier: firstControllerModel.controllerid)
        let secondController = self.storyboard?.instantiateViewController(withIdentifier: secondControllerModel.controllerid)

        firstController?.navigationItem.title = firstControllerModel.navigationtitle
        secondController?.navigationItem.title = secondControllerModel.navigationtitle

        navigationController?.viewControllers = [firstController!,secondController!]

    }
    
    // MARK: - Contacts Syncing callback
    
    
    func syncContacts(){
        
        weak var weakSelf = self
        
        if  !User.hasSyncedFreinds(){
            Utility.showContactSyncAlert(controller: weakSelf!)
        }
    }

    @objc func proceedWithCancelSyncing(){
        
        let dic :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any as Any,"numbers":"","facebook_ids":""]
        User.syncUserFreinds(param: dic as [String : AnyObject], completionHandler: { (object, message, action, status) in
        })
    }
    
    
    @objc func proceedWithSyncing(){
        weak var weakSelf = self

        // getting contact permission
        ContactsUtility.applyForContactsPermission { (numbers, contactNumberStatus) in
        
                            if (contactNumberStatus!){
            
            
                                // dispatch on background queue
                                DispatchQueue.global(qos: .background).async {
            
                                    // retrive local contacts  if permission is given
                                    if contactNumberStatus!{
                                        ContactsUtility.retrieveContactsWithStore(completionHandler: { (numbers, status) in
                                            self.syncConatactsWithServer(fbSyncAllow: false, userContactsAllow: contactNumberStatus!)
                                        })
                                    }
                                    else{
                                        self.syncConatactsWithServer(fbSyncAllow: false, userContactsAllow: contactNumberStatus!)
                                    }
                                }
                            }
            
            // getting fb friends list
//            FacebookUtility.gettingFriends(controller: weakSelf!, compilationHandler: { (fbFriendStatus) in
//
//                if (contactNumberStatus! || fbFriendStatus!){
//
//
//                    // dispatch on background queue
//                    DispatchQueue.global(qos: .background).async {
//
//                        // retrive local contacts  if permission is given
//                        if contactNumberStatus!{
//                            ContactsUtility.retrieveContactsWithStore(completionHandler: { (numbers, status) in
//                                self.syncConatactsWithServer(fbSyncAllow: fbFriendStatus!, userContactsAllow: contactNumberStatus!)
//                            })
//                        }
//                        else{
//                            self.syncConatactsWithServer(fbSyncAllow: fbFriendStatus!, userContactsAllow: contactNumberStatus!)
//                        }
//                    }
//                }
//            })
        }
    }
    
    
    func syncConatactsWithServer(fbSyncAllow:Bool, userContactsAllow:Bool){
        
        let token = User.getUserAccessToken() as AnyObject
        let dic :[String:Any] = [ApplicationConstants.Token:token,"numbers":User.sharedInstance.contactNumbersToSubmit,"facebook_ids":User.sharedInstance.fbFriendIsToSubmit]
        
        if fbSyncAllow{
            
//            let fbToken = FacebookUtility.getFaceebookToken() as AnyObject
//            
//            User.bindWithFacebook(param: [ApplicationConstants.Token:token,"facebook_token":fbToken], completionHandler: { (object, message, action, status) in
 //           })
        }
        User.syncUserFreinds(param: dic as [String : AnyObject], completionHandler: { (object, message, action, status) in
            NotificationCenter.default.post(name: Notification.Name(ApplicationConstants.SyncedFriendNotification), object: nil)

        })

    }
    
    // MARK: - Logout callback
    func showLogoutPopup(){
    
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: LogOutViewController.nameOfClass())
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            self.disimissDashBorad()
        }
    }
    
    @objc func disimissDashBorad(){
        
        DataPersister.sharedInstance.deleteAllFriends()
        modalTransitionStyle = .flipHorizontal
        dismiss(animated: true, completion: nil)
    }

    

    // MARK: - Ok Button PopUp handler
    @objc func alertOkButtonHandler(){
        User.setPendingRatings(hasPending: false)
        print("calling alertOkButtonHandler from BaseViewController")
    }
    
    func getPendingRatings(){
        PendingRatingModel.getPendingRatingsFromSever()
            { (object, message, active, status) in
                
                let pendingRatingModel = object as? PendingRatingModel
                
                if ((pendingRatingModel?.driver.count)! > 0 ) || ((pendingRatingModel?.passenger.count)! > 0) {
                    
                    let alert = UIAlertController(title: ApplicationConstants.RateAlertTitle , message: ApplicationConstants.RateAlertMessage , preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "No", style: .default, handler: { action -> Void in
                    })
                    
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action -> Void in
                        self.pushViewController(controllerIdentifier: PendingRatingViewControllers.nameOfClass(), navigationTitle: "")
                    })
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                    
                }
                
                
        }
    }
    @objc func showPendingAlert(){
        
        let notAllowedControllers = [ PassengerRatingViewController.nameOfClass(), PendingRatingViewControllers.nameOfClass(), PassengersPendingRatingViewController.nameOfClass(), DriversPendingRatingViewController.nameOfClass() ]
        
        if ( User.hasPendingRatings() && !( notAllowedControllers.contains(String(describing: type(of: self))) ) ){
            getPendingRatings()
        }
        
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
