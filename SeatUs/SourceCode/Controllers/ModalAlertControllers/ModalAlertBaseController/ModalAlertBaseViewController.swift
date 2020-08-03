//
//  ModalAlertBaseViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed Ullah on 10/24/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class ModalAlertBaseViewController: UIViewController {

    @IBOutlet weak var yAxisConstrint: NSLayoutConstraint!
    var popUpScreen : PopScreen!
    var selectedData:[String:AnyObject]! = [:]
    var doneButtonTapped: (([String:AnyObject])->())?
    var contentDict :[String:Any]!
    var contentArray :[AnyObject]!
    var selectButtonTapped: ((AnyObject)->())?
    var alertMessageView: PopUpAlertView! = PopUpAlertView()
    var contentViewClone:UIView?
    var viewControllerObject : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func showAlertMessage(responderView:UIView,onContentView:UIView,message:String, isYesNoButton: Bool? = nil){
        
        alertMessageView.alertLable.text = message
        if isYesNoButton == nil {
            alertMessageView.alertOkButton.addTarget(self, action: #selector(closeByAlertMessage), for: .touchUpInside)
        }
        else {
            alertMessageView.alertOkButton.isHidden = true
            alertMessageView.doubleButtonsView.isHidden = false
            alertMessageView.alertYesButton.addTarget(self, action: #selector(closeByAlertMessage), for: .touchUpInside)
            alertMessageView.alertNoButton.addTarget(self, action: #selector(closeByAlertMessageOnNoButton), for: .touchUpInside)
        }
        alertMessageView.translatesAutoresizingMaskIntoConstraints = false
        responderView.addSubview(alertMessageView)
        createConstraints(responderView: responderView, onContentView: onContentView)
    }
    
    
    func createConstraints(responderView:UIView,onContentView:UIView){
        
        let metrics = Dictionary(dictionaryLiteral: ("viewHeight", onContentView.frame.size.height + onContentView.frame.origin.y + 72 + ((-1)*(ApplicationConstants.ForgotDialogCenterY))),("alertHeight",100),("edges",20),("botomSpace",20))
        
        //Views to add constraints to
        let views = Dictionary(dictionaryLiteral: ("alertMessageView",alertMessageView),("onContentView",responderView))
        
        //Horizontal constraints
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-edges-[alertMessageView]-edges-|", options: .alignAllCenterX, metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraints)
        
        //Vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[alertMessageView(alertHeight)]-botomSpace-|", options: [.alignAllLeading, .alignAllTrailing], metrics: metrics,       views: views)
        
        self.view.addConstraints(verticalConstraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (yAxisConstrint) != nil{
            yAxisConstrint.constant = ApplicationConstants.ForgotDialogOriginY
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (yAxisConstrint) != nil{
            performAnimation(axis: ApplicationConstants.ForgotDialogCenterY)
        }
    }

    
    static func createAlertController(storyboardId:String)->ModalAlertBaseViewController {
        
        let alertController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId) as! ModalAlertBaseViewController
        return alertController
    }

    @objc func performAnimation(axis:CGFloat){
        self.yAxisConstrint.constant=axis
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseInOut, animations: ({
            self.view.layoutIfNeeded()
            
        }), completion: { _ in
        })
    }

    func setStructForForgotPassword(options:PopScreen){
        popUpScreen = options
    }
    func show(controller:UIViewController) {

        viewControllerObject = controller
        controller.addChild(self)
        controller.view.addSubview(self.view)
        controller.didMove(toParent: self)

    }
    
    @objc func close() {
        
        let vc = viewControllerObject.children.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()


//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()
//        doneButtonTapped?(selectedData)


    }
    
    @objc func closeByAlertMessage() {
        
        let vc = viewControllerObject.children.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()
        doneButtonTapped?(selectedData)
    }

    @objc func closeByAlertMessageOnNoButton() {
        
        let vc = viewControllerObject.children.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()
        doneButtonTapped?([:])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func alertOkButtonHandler(){
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
