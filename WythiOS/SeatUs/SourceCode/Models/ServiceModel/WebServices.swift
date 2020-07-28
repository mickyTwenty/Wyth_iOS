//
//  WebServices.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/19/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AlamofireImage
import MBProgressHUD

class WebServices : NSObject{
    
    let webHeader:HTTPHeaders = ["Accept":"application/json"]
//    var hudView : MBProgressHUD!
    var alertWindow : UIWindow!

    static let sharedInstance = WebServices()
    
    private override init() {
//        self.hudView = MBProgressHUD()
    }
    
    func sendRequestToServer(urlString: String,
                               methodType : HTTPMethods,
                               param:[String : AnyObject]? = nil,
                               shouldShowHud : Bool = true,
                               completionHandler: @escaping (AnyObject?, NSDictionary?, Bool?, Error?) -> ())
    {
        
        let serviceUrl = WebServicesConstant.DomainUrl + urlString
        if shouldShowHud{
            showHud(message: "")

        }
        let typeMethod: HTTPMethod = HTTPMethod(rawValue: methodType.rawValue)!
        Alamofire.request(serviceUrl, method:typeMethod , parameters: param, headers:webHeader)
            .responseJSON { response in
                print("Request URL : " + serviceUrl)
                print("Param : ",param ?? "")
                print(response)
                self.hideHud()
                switch response.result {
                case .success(let JSON):
                    let object = JSON as? NSDictionary
                    let status = object!["status"] as! Bool
                    completionHandler(object?["body"] as AnyObject , object, status,nil)
                case .failure(let error):
                    print(error)
                    self.showAlertController(message: error.localizedDescription)
//                    completionHandler(nil, nil, false,error)
                }
        }
    }

    func sendRequestToThirdPartyServer(urlString: String,
                             methodType : HTTPMethods,
                             param:[String : AnyObject]? = nil,
                             shouldShowHud : Bool = true,
                             completionHandler: @escaping (AnyObject?, NSDictionary?, Bool?, Error?) -> ())
    {
        
        if shouldShowHud{
            showHud(message: "")
        }
        let typeMethod: HTTPMethod = HTTPMethod(rawValue: methodType.rawValue)!
        Alamofire.request(urlString, method:typeMethod , parameters: param, headers:webHeader)
            .responseJSON { response in
                print("Request URL : " + urlString)
                //print("Param : ",param ?? "")
                //print(response)
                self.hideHud()
                switch response.result {
                case .success(let JSON):
                    let object = JSON as? AnyObject
                    completionHandler(object , nil, true,nil)
                case .failure(let error):
                    print(error)
                    self.showAlertController(message: error.localizedDescription)
                    //                    completionHandler(nil, nil, false,error)
                }
        }
    }

    
    
    
    
    func postRequestWithImage(urlString: String,
                              controllerView: UIView?=nil,
                              paramDict:[String : AnyObject]? = nil,
                              imageParams:[[String : AnyObject]]? = nil,
                              completionHandler: @escaping (AnyObject?, NSDictionary?, Bool?) -> ()) {
        
        let serviceUrl = WebServicesConstant.DomainUrl + urlString

        showHud(message: "")

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
               
                
                if let imageInfoArray = imageParams {
                    
                    
                    
                    for imageInfo in imageInfoArray {
                        
                        if  let image = imageInfo["image"] as? UIImage,
                            let imageKey = imageInfo["image_key"] as? String,
                            let imageCompression = imageInfo["image_compression"] as? CGFloat,
                            let imageTypeName = imageInfo["image_type"] as? String,
                            let imageData =  image.jpegData(compressionQuality: imageCompression) {
                            multipartFormData.append(imageData, withName:imageKey, fileName: "imageKey"+"."+imageTypeName, mimeType: "image/"+imageTypeName)
                        }
                    }
                }
                
                if let paramDictionary = paramDict {
                    
                    for (key, value) in paramDictionary {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
               
        },
            to: serviceUrl,
            headers:webHeader,
            encodingCompletion:
            { encodingResult in
                
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON
                        { response in
                            
                            self.hideHud()

                            print("Request URL : " + serviceUrl)
                            print("Param : ",paramDict ?? "")
                            print(response)

                            switch response.result
                            {
                            case .success(let JSON):
                                let object = JSON as? NSDictionary
                                let status = object!["status"] as! Bool
                                completionHandler(object?["body"] as AnyObject , object, status)

                            case .failure(let error):
//                                completionHandler(nil , error.localizedDescription, false)
                                self.showAlertController(message: error.localizedDescription)

                            }
                    }
                case .failure(let encodingError):
                    self.hideHud()
//                    completionHandler(nil , encodingError.localizedDescription, false)
                    self.showAlertController(message: encodingError.localizedDescription)
                }
        }
        )
    }
    
    func showHud(message:String){
        print("adding hud on Services")

        let window: UIView =  UIApplication.shared.keyWindow!
        
        MBProgressHUD.showAdded(to: window, animated: true)
//        hudView = MBProgressHUD.showAdded(to: window, animated: true)
    }
    
    func hideHud(){
        
        let window: UIView =  UIApplication.shared.keyWindow!
        
        DispatchQueue.global(qos: .background).async {
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                print("removing hud on webservices")
                //MBProgressHUD.hide(for: window, animated: true)
                MBProgressHUD.hideAllHUDs(for: window, animated: true)
            }
        }
    }
    
    func showAlertController(message:String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            alert.dismiss(animated: true, completion: nil)
            self.alertWindow=nil
        })
        alert.addAction(okAction)
        
        self.alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        self.alertWindow.rootViewController = UIViewController()
        self.alertWindow.windowLevel = UIWindow.Level.alert + 1
        self.alertWindow.makeKeyAndVisible()
        self.alertWindow.rootViewController?.present(alert, animated: false, completion: nil)
    }
}
