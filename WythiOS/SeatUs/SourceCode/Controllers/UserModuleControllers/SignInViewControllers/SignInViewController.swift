//
//  SignInViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/10/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import AETextFieldValidator
//import FacebookCore
//import FacebookLogin

class SignInViewController: UIViewController,LoginTransitionDelegate {
    
    
    @IBOutlet var textFeildCollectionArr: [ValidaterTextField]!
    @IBOutlet weak var leadingConstraintOnRegController: NSLayoutConstraint!
    @IBOutlet var trailingConstraintOnLogo: NSLayoutConstraint!
    @IBOutlet weak var userNameTxtField: ValidaterTextField!
    @IBOutlet weak var passwordTxtField: ValidaterTextField!
    @IBOutlet weak var rememberMebutton: UIButton!

    var objRegisterViewController: RegisterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setInitailStateForLogin()
        setupValidationOnTextField()
        Manager.sharedInstance.transitionState=TransitionState.IsOnLoginScreen
        Utility.resignKeyboardWhenTouchOutside()
        
        #if DEBUG
//            userNameTxtField.text = ApplicationConstants.UserEmail
//            passwordTxtField.text = ApplicationConstants.UserPassword
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRememberState()
    }
    
    func setRememberState(){
        
        let isRememberMe = Utility.isUserRemembered()
        rememberMebutton.isSelected = isRememberMe
        if isRememberMe {
            let (email,password) = Utility.getUserCredentails()
            userNameTxtField.text = email
            passwordTxtField.text = password
        }
        else{
            userNameTxtField.text = ""
            passwordTxtField.text = ""
        }
    }
    
    func setupValidationOnTextField(){
        
        Utility.changePlaceHolderColor(textField: userNameTxtField, color: .white)
        Utility.changePlaceHolderColor(textField: passwordTxtField, color: .white)

        userNameTxtField.validateOnCharacterChanged = true
        passwordTxtField.validateOnCharacterChanged = true

        userNameTxtField.restorationIdentifier = ValidationExpressions.EmailValidator + "|" + ValidationMessages.EmailValidationMessage
        passwordTxtField.restorationIdentifier = ValidationExpressions.PasswordLengthValidator + "|" + ValidationMessages.MinimumPasswordLengthMessage

        passwordTxtField.addRegx(ValidationExpressions.LengthValidator, withMsg: ValidationMessages.MinimumLengthMessage)
        userNameTxtField.addRegx(ValidationExpressions.EmailValidator, withMsg: ValidationMessages.EmailValidationMessage)
    }
    func setInitailStateForLogin(){
        self.leadingConstraintOnRegController.constant=getScreenDimensionsToSetupLoginState()
        self.trailingConstraintOnLogo.constant=getCenterCordinatesForLogo()
    }
    
    @IBAction func rememberMeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Utility.setRememberState(isRemember: sender.isSelected)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        weak var weakSelf = self
        // valifate textFields
        var isValidated:Bool = true
        for (_,element) in textFeildCollectionArr.enumerated(){
            let txtField : AETextFieldValidator = element
            
            if !(txtField.validate()) {
                //print("validate false")
                isValidated = false
            }

        }
        
    
        if isValidated{
            let email  = userNameTxtField.text as AnyObject
            let pass = passwordTxtField.text as AnyObject
            
            let dic:[String:AnyObject] = ["email":email,"password":pass, "device_token":FireBaseManager.getFCMToken() as AnyObject, "device_type":ApplicationConstants.DeviceType]
            
            Utility.printIt(optionalText: "loginText", logText: Utility.convertArrayToJson(array: [dic as NSDictionary]))
            
            User.loginUser(param: dic, completionHandler: { (userObject, message, action, status, error) in
                
                    switch action{
                    case .ShowMesasgeAtRunTime?:
                        break
                    case .DoNotShowMesasgeAtRunTime?:
                        self.goToApplicationDashboard()
                        break
                    case .ShowMesasgeOnAlert?:
                        
                        let errorInfo = message!["error_code"] as! String
                        let stringMessage = message!["message"] as! String
                        
                        switch errorInfo{
                        case ErrorTypes.InvalidCredErrorCode:
                            Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                            break
                            
                        case ErrorTypes.VerifyEmailErrorCode:
                            self.addNumberVerificationScreen()
                            break
                            
                        case ErrorTypes.InvalidCredEmailErrorCode:
                            Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                            break
                            
                        case ErrorTypes.ExceptionErrorCode:
                            Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                            break
                            
                        case ErrorTypes.InactiveAccountErrorCode:
                            Utility.showAlertwithOkButton(message: stringMessage, controller: weakSelf!)
                            break
                            
                        default:
                            break
                        }
                        break
                        
                    default:
                        break
                    }
            })
        }
    }
    
    @IBAction func facebookLoginButtonClicked(_ sender: Any) {
        
        weak var weakeSelf = self
//        FacebookUtility.loginToFB(controller: weakeSelf!) { (results) in
//            
//            switch results{
//                
//            case .cancelled?:
//                print("cancelled")
//                break
//                
//            case .failed( _)?:
////                Utility.showAlertwithOkButton(message: FacebookConstant.FBLoginFailed, controller: weakeSelf!)
//                print("failed")
//                break
//                
//            case .success(grantedPermissions: _, declinedPermissions: _, token: let token)?:
//                let authToken: String = token.authenticationToken
//                FacebookUtility.getProfileMeInfo(completionHandler: { (objcet, message) in
//                    var fbUserInfo: [String:Any] = objcet!
//                    fbUserInfo["token"] = authToken
//                    weakeSelf?.loginToFb(fbUser: fbUserInfo)
//                })
//
//                break
//
//            default:
//                break
//            }
//        }
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        
        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: ForgotPasswordController.nameOfClass())
        cont.setStructForForgotPassword(options: PopScreen.ForgotPassword)
        cont.show(controller: self)
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RegisterViewController.nameOfClass()) as! RegisterViewController
        controller.delegateLogin = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func loginToFb(fbUser:[String:Any])->(){
        
        let token = fbUser["token"] as Any
        User.sharedInstance.fbUserInfo = fbUser
        let dic = ["facebook_token":token ,"device_token":FireBaseManager.getFCMToken() as Any, "device_type":ApplicationConstants.DeviceType] as [String : Any]
        User.loginToFacebook(param: dic as [String : AnyObject]) { (response, message, action, status) in
            if (status!) {
                self.goToApplicationDashboard()
            }
            else{
                self.gettingSignUpFromFacebook()
            }
        }
    }
    
    
    func gettingSignUpFromFacebook(){
        print("gettingSignUpFromFacebook")
        Manager.sharedInstance.transitionState=TransitionState.ComingFromFBSignUp
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RegisterViewController.nameOfClass()) as! RegisterViewController
        controller.delegateLogin = self
        self.present(controller, animated: true, completion: {
            controller.actionOnTransitionState()
        })
//        objRegisterViewController.registerButtonClicked(objRegisterViewController.signUpButton)
        
    }
    func goToApplicationDashboard(){
        
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: ApplicationConstants.NavigationControllerID) as! UINavigationController
        
        switch Utility.getUserType(){
            
        case UserType.UserNormal:
            navigationController.viewControllers = [Utility.getPassengerController()]
            break
            
        case UserType.UserDriver:
            navigationController.viewControllers = [Utility.getDriverController()]
            break
            
        default:
            break
            
        }
        
        navigationController.modalTransitionStyle = .flipHorizontal
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func addNumberVerificationScreen(){

        let cont = ModalAlertBaseViewController.createAlertController(storyboardId: ForgotPasswordController.nameOfClass())
        cont.setStructForForgotPassword(options: PopScreen.NumberValidation)
        cont.show(controller: self)
        cont.doneButtonTapped = { selectedData in
            self.goToApplicationDashboard()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLoginView(sender: UIButton) {

        self.view.endEditing(true)

        if leadingConstraintOnRegController.constant > 0{
            
            self.leadingConstraintOnRegController.constant=0.0
            
            
            // animate view to RegistrationController
            UIView.animate(withDuration: TimeInterval(ApplicationConstants.AnimationDuration), delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.manageState(sender: sender)
            }
        }
        else{
            // animate view back to SignInController
            self.leadingConstraintOnRegController.constant=getScreenDimensionsToSetupLoginState()
            
            UIView.animate(withDuration: TimeInterval(ApplicationConstants.AnimationDuration), delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.manageState(sender: sender)
            }
        }
    }
    
    func getScreenDimensionsToSetupLoginState()->CGFloat{
        let screenSize: CGRect = UIScreen.main.bounds
        let btnImageWidth : CGFloat = (UIImage(named: AssetsName.SinUpScreenSignUpButtonImageName)?.size.width)!
        return screenSize.width-btnImageWidth
    }
    
    
    func manageState(sender:UIButton){
        
        switch Manager.sharedInstance.transitionState! {
            
        case .GoingBackToLoginScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenLoginButtonImageName), for: .normal)
            break
            
        case .IsOnLoginScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenSignUpButtonImageName), for: .normal)
            break
            
        case .GoingToSignUpDetailScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenBackButtonImageName), for: .normal)
            break
            
        case .ShowNumberVerifivationScreen:
            sender.setImage(UIImage(named: AssetsName.SinUpScreenSignUpButtonImageName), for: .normal)
            addNumberVerificationScreen()
            break

            
        default: break
        }
    }
    func getCenterCordinatesForLogo()->CGFloat{
        
        let screenSize: CGRect = UIScreen.main.bounds
        let btnImageWidth : CGFloat = (UIImage(named: AssetsName.SinUpScreenLoginButtonImageName)?.size.width)!
        let remainingBounds : CGFloat = screenSize.width - btnImageWidth
        let remainingBoundsCenter : CGFloat = remainingBounds/2
        let logoImageWidth : CGFloat = (UIImage(named: "login_logo")?.size.width)!/2
        let centerLogoPosition : CGFloat = remainingBoundsCenter - logoImageWidth
        return centerLogoPosition
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue .destination.isKind(of: RegisterViewController.self){
            objRegisterViewController = segue .destination as! RegisterViewController
            objRegisterViewController.delegateLogin = self
        }
    }
    
    func accountCreated() {
        addNumberVerificationScreen()
    }
    
}
