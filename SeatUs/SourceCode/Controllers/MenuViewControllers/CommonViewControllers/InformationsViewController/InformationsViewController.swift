//
//  InformationsViewController.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 30/01/2018.
//  Copyright © 2018 Qazi Naveed. All rights reserved.
//

import UIKit
import WebKit

class InformationsViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    var fileType = FileTypes.Html
    var fileName = FileNames.InfoHtml
    var pageLink : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        var type = ""
        switch (Utility.getUserType()) {
            
        case UserType.UserNormal:
            type = "passenger"
            break
            
        default :
            type = Utility.getUserType()
            break
            
        }
        let webViewUrlString = WebServicesConstant.HelpWebViewBaseURL + type + "#" + pageLink
        print("URL :", webViewUrlString)
        let url = URL(string: webViewUrlString)
        let request = URLRequest(url: url!)
            webView.load(request);
    }
    
    @IBAction func crossButtonTapped(_ sender : UIButton){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension InformationsViewController: WKNavigationDelegate {
    
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

