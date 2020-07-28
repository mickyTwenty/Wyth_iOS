//
//  PendingRatingViewControllers.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 09/02/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit

class PendingRatingViewControllers: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var childSelectionView: ChildSelectionView!
    var pendingRatingModel: PendingRatingModel!
    var childControllerNames: [String] = []
    var screenNames: [String] = []
    var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pending Ratings"
        getPendings()
//        childSelectionView.initialize(ButtonsTitle: screenNames)
//        childSelectionView.delegate = self
//        childSelectionView.defaultIndex = 0
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
        case is DriversPendingRatingViewController:
            let viewController = viewController as! DriversPendingRatingViewController
            viewController.contentArray = pendingRatingModel.driver
            break
        case is PassengersPendingRatingViewController:
            let viewController = viewController as! PassengersPendingRatingViewController
            viewController.contentArray = pendingRatingModel.passenger
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
                case is DriversPendingRatingViewController:
                    let viewController = viewController as! DriversPendingRatingViewController
                    
                    //             paymentData = viewController.contentArray
                    break
                case is PassengerRatingViewController:
                    let viewController = viewController as! PassengerRatingViewController
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
    
    func getPendings(){
        PendingRatingModel.getPendingRatingsFromSever()
        { (object, message, active, status) in
            
            self.pendingRatingModel = object as? PendingRatingModel
            self.initializeScreens()
            
        }
    }
    
    func initializeScreens(){
        
        if pendingRatingModel != nil {
            
            if pendingRatingModel.driver.count > 0 {
                
            childControllerNames.append(DriversPendingRatingViewController.nameOfClass())
                screenNames.append("Drivers")

                
            }
            
            if pendingRatingModel.passenger.count > 0 {
                
            childControllerNames.append(PassengersPendingRatingViewController.nameOfClass())
                screenNames.append("Passengers")
                
            }

            
        }

        childSelectionView.initialize(ButtonsTitle: screenNames)
        childSelectionView.delegate = self
        childSelectionView.defaultIndex = 0
    }
    
}

extension PendingRatingViewControllers: ChildSelectionViewDelegate {
    func onClickButton(ChildSelectionView index: Int) {
        removeViewController()
        let controllerName = childControllerNames[index]
        addViewController(controllerName: controllerName)
    }
}
