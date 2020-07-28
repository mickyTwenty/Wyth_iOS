//
//  CameraViewController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/31/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    let imagePicker = UIImagePickerController()
    var selectedImage : UIImage? = nil
    var docImage : UIImage? = nil

    var isAddingDoc : Bool = false
    var isComingFromChangeDP : Bool = false

    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ActionSheet Methods

    func showCameraOptions(){
        
        let actionSheet = UIAlertController.init(title: "Select Photo via", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Gallery", style: UIAlertAction.Style.default, handler: { (action) in
            self.showCameraRoll()
        }))
        
        if isComingFromChangeDP{
            
            selectedImage = nil
            isComingFromChangeDP = false
            actionSheet.addAction(UIAlertAction.init(title: "Remove Picture", style: UIAlertAction.Style.default, handler: { (action) in
                
                let dic :[String:Any] = [ApplicationConstants.Token:User.getUserAccessToken() as Any as Any,"profile_picture":""]
                User.removePicture(param: dic as [String : AnyObject], completionHandler: { (object, message, active, status) in
                    NotificationCenter.default.post(name: Notification.Name(ApplicationConstants.UserImageChangNotification), object: nil)
                })
            }))
        }
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    
    }
    
    func askPermission(){
        let cameraMediaType = AVMediaType.video
        AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
            if granted {
                self.showCameraOptions()
            }
            else {
                DispatchQueue.main.async {
                        self.showCameraSettingsAlert(controller: self)
                }
            }
        }
    }
    
     func showCameraSettingsAlert(controller:BaseViewController){
        
        let alert = UIAlertController(title: "", message: WarningMessages.CameraWarning, preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
        })
        
        let okAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action -> Void in
            //Just dismiss the action sheet
            Utility.goToApplicationSettings()
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        controller.present(alert, animated: false, completion: nil)
    }

    
    func isAccessCamera() -> Bool {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            return false
        case .authorized:
            return true
        case .restricted:
            return false
        case .notDetermined:
            return false
        }
    }


    
    private func showCamera(){
        
        if isAccessCamera() {
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            askPermission()
        }
    }
    
    private func showCameraRoll(){
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            let croppedImage = resizeImage(image: pickedImage, targetSize: DefaultSizes.imageSize)

            if isAddingDoc{
                docImage = croppedImage
                self.updateDocImages()
            }
            else{
                selectedImage = croppedImage
                self.updateImageToView()
            }
        }
            dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
            dismiss(animated: true, completion: nil)
    }
    
    func updateImageToView(){
    }

    func updateDocImages(){
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
