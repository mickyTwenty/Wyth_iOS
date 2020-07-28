//
//  ContactUsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 30/11/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import WebKit

class ContactUsViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        let url = URL(string: WebServicesConstant.ContactUsUrl)
        let request = URLRequest(url: url!)
        webView.load(request);
        
    }
    

    @IBAction func crossButtonTapped(_ sender : UIButton){
    }
    

}

extension ContactUsViewController: WKNavigationDelegate {
    
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
