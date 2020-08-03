//
//  MyTripsViewControllers.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 21/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class MyTripsViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var containerButtons: [UIButton]!
    
    var offersTripData: [GroupTrip]!
    var pastTripData: [Trip]!
    var upcomingTripData: [Trip]!
    
    var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        updateButtonViews(containerButtons[selectedTab])
        switch selectedTab {
        case 0:
            addViewController(controllerName: OffersViewController.nameOfClass())
            break
            
        case 1:
            addViewController(controllerName: UpcomingTripsViewController.nameOfClass())
            break
            
        case 2:
            addViewController(controllerName: PastTripsViewController.nameOfClass())
            break
        
        default:
            break
        }
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton){
        
        let controller = storyboard?.instantiateViewController(withIdentifier: InformationsViewController.nameOfClass()) as! InformationsViewController
        controller.pageLink = WebViewLinks.MyTripHelp
        
        present(controller, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickOffers(_ sender: UIButton) {
        updateButtonViews(sender)
        removeViewController()
        addViewController(controllerName: OffersViewController.nameOfClass())
    }
    
    @IBAction func onClickPastTrips(_ sender: UIButton) {
        updateButtonViews(sender)
        removeViewController()
        addViewController(controllerName: PastTripsViewController.nameOfClass())
    }
    
    @IBAction func onClickUpcomingTrips(_ sender: UIButton) {
        updateButtonViews(sender)
        removeViewController()
        addViewController(controllerName: UpcomingTripsViewController.nameOfClass())
    }
    
    func getViewController(_ controllerName: String) -> BaseViewController {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: controllerName) as! BaseViewController
        return viewController
    }
    
    private func addViewController(controllerName: String) {
        let viewController = getViewController(controllerName)
        switch viewController {
        case is OffersViewController:
            let viewController = viewController as! OffersViewController
            viewController.contentArray = offersTripData
            break
        case is PastTripsViewController:
            let viewController = viewController as! PastTripsViewController
            viewController.contentArray = pastTripData
            break
        case is UpcomingTripsViewController:
            let viewController = viewController as! UpcomingTripsViewController
            viewController.contentArray = upcomingTripData
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
                case is OffersViewController:
                    let viewController = viewController as! OffersViewController
                    offersTripData = viewController.contentArray
                    break
                case is PastTripsViewController:
                    let viewController = viewController as! PastTripsViewController
                    pastTripData = viewController.contentArray
                    break
                case is UpcomingTripsViewController:
                    let viewController = viewController as! UpcomingTripsViewController
                    upcomingTripData = viewController.contentArray
                    break
                default: break
                }
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
    }
    
    func updateButtonViews(_ selectedButton: UIButton){
        for button in containerButtons {
            button.isSelected = false
        }
        selectedButton.isSelected = true
    }
    
    func setUpButtons(){
        for button in containerButtons {
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.setBackgroundImage(UIImage(named: "gray_bg"), for: .normal)
            button.setBackgroundImage(UIImage(named: "black_bg"), for: .selected)
        }
    }

}
