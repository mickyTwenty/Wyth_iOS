//
//  AgrementViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 6/8/18.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import WebKit


class AgrementViewController: ModalAlertBaseViewController {
//    http://34.213.248.253/help/driver#menu
//    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var webView: WKWebView!

    var userType:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData(){
        
        var fileName = ""
        switch userType {
        case UserType.UserDriver:
//            fileName = FileNames.AgreementDriverHTML
            fileName = WebServicesConstant.Driver
            break

        case UserType.UserNormal:
//            fileName = FileNames.AgreementPassengerHTML
            fileName = WebServicesConstant.Passenger
            break

        default:
            break
            
        }

        let webViewUrlString = WebServicesConstant.AgreementUrl + fileName
        print("URL :", webViewUrlString)
        let url = URL(string: webViewUrlString)
        let request = URLRequest(url: url!)
        webView.load(request);
        /*
        let url = Bundle.main.url(forResource: fileName, withExtension: FileTypes.Html)
        let request = NSURLRequest(url: url!)
        webView.loadRequest(request as URLRequest)
         */
    }
    
    @IBAction func acceptButtonClicked(_ sender:UIButton){
        self.close()
        doneButtonTapped?(selectedData)

    }

    @IBAction func rejectButtonClicked(_ sender:UIButton){
        self.close()   
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

extension AgrementViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        WebServices.sharedInstance.hideHud()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        WebServices.sharedInstance.hideHud()
        
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation){
        WebServices.sharedInstance.showHud(message: "")
    }
}
