//
//  SplashViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/29/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        User.bootMeUp { (object, message, active, status) in

        }
        
        //if Utility.shouldCallService() {
            
            User.getSchoolData { (object, message, action, status) in
            }
        //}
        
        if User.getArchiveObject() {
            let token = User.getUserAccessToken() as AnyObject
            let dict : [String: AnyObject] = [ApplicationConstants.Token:token]
            User.aboutMe(param: dict) { (object, message, action, status) in}
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
        performTransition()

    }
    func performTransition(){
        
        if isUserLoggedIn() {
            goToDashboard()
        }
        else{
            goToLogInScreen()
        }
    }
    
    func isUserLoggedIn()->Bool{
        return User.getArchiveObject()
    }
    
    func goToDashboard(){
        let controller = getController(controllerId: ApplicationConstants.NavigationControllerID) as! UINavigationController
        
        switch Utility.getUserType(){
            
        case UserType.UserNormal:
            controller.viewControllers = [switchToUser()]
            break
            
        case UserType.UserDriver:
            controller.viewControllers = [switchToDriver()]
            break
            
        default:
            break
            
        }
        
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
    
    func switchToDriver()->(UIViewController){
        return Utility.getDriverController()
    }
    
    
    func switchToUser()->(UIViewController){
        return Utility.getPassengerController()
    }
    
    func goToLogInScreen(){
        let controller = getController(controllerId: SignInViewController.nameOfClass())
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
    
    func getController(controllerId:String)->(UIViewController){
        return (self.storyboard?.instantiateViewController(withIdentifier:controllerId))!
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
