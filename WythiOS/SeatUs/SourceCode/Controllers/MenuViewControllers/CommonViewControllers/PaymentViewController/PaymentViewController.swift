//
//  PaymentViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 23/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var childSelectionView: ChildSelectionView!

    var selectedTab = 0
    var childControllerNames: [String] = [MyPaymentsViewController.nameOfClass(), PaymentHistoryViewController.nameOfClass()]
    var screenNames: [String] = [   PaymentConstant.PaymentInfoHeading, PaymentConstant.PaymentHistoryHeading ]
    var paymentData: [Payment]!
    var paymentHistoryData: [Payment]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isDriver() {
            childControllerNames.insert(AddBankDetailViewController.nameOfClass(), at:1)
            screenNames.insert(PaymentConstant.BankInfoHeading, at: 1)
        }
        childSelectionView.initialize(ButtonsTitle: screenNames)
        childSelectionView.delegate = self
        childSelectionView.defaultIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.MyPaymentHelp
        
        present(controller, animated: true, completion: nil)
    }
    
    func updateViewByNotification(){
        if isDriver() {
            childControllerNames.insert(AddBankDetailViewController.nameOfClass(), at:1)
            screenNames.insert(PaymentConstant.BankInfoHeading, at: 1)
        }
        childSelectionView.initialize(ButtonsTitle: screenNames)
        childSelectionView.delegate = self
        childSelectionView.defaultIndex = 0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getViewController(_ controllerName: String) -> BaseViewController {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: controllerName) as! BaseViewController
        return viewController
    }
    
    private func addViewController(controllerName: String) {
        let viewController = getViewController(controllerName)
        switch viewController {
        case is MyPaymentsViewController:
            let viewController = viewController as! MyPaymentsViewController
            viewController.contentArray = paymentData
            break
        case is PaymentHistoryViewController:
            let viewController = viewController as! PaymentHistoryViewController
        //    viewController.contentArray = paymentHistoryData
            break
        default: break
        }
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func removeViewController() {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewController in viewControllers{
                switch viewController {
                case is MyPaymentsViewController:
                    let viewController = viewController as! MyPaymentsViewController
                    paymentData = viewController.contentArray
                    break
                case is PaymentHistoryViewController:
                    let viewController = viewController as! PaymentHistoryViewController
       //             paymentHistoryData = viewController.contentArray
                    break
                default: break
                }
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
    }
    
    func isDriver() -> Bool{
        let userType = User.getUserType() ?? ""
        return userType == UserType.UserDriver
    }
    
}

extension PaymentViewController: ChildSelectionViewDelegate {
    func onClickButton(ChildSelectionView index: Int) {
        removeViewController()
        let controllerName = childControllerNames[index]
        addViewController(controllerName: controllerName)
    }
}
