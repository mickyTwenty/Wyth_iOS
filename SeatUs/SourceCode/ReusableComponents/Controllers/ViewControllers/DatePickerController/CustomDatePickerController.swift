//
//  CustomDatePickerController.swift
//  GlobalDents
//
//  Created by Qazi Naveed on 9/8/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func datePickerViewController (_ datePicker :UIDatePicker, date:Date, sourceView:UIView)
}
class CustomDatePickerController: UIViewController {

    var selectedData:String! = ""
    var doneButtonTapped: ((String)->())?

    var sourceTxtFeild: UITextField!
    var format : String = ApplicationConstants.YearFormat
    weak var delegate: DatePickerDelegate?
    @IBOutlet weak var datePickerObj: UIDatePicker!
    var isShowingByPresenting : Bool! = false
    var mode:Int = 1
    var interval:Int = 5
    
    static func createDatePickerController(storyboardId:String)->CustomDatePickerController {
        
        let datePicker = UIStoryboard(name: FileNames.ReusableComponentsStoryBoard, bundle: nil).instantiateViewController(withIdentifier: storyboardId) as! CustomDatePickerController
        return datePicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        datePickerObj.datePickerMode = UIDatePicker.Mode(rawValue: mode)!
        datePickerObj.minuteInterval = interval
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if isShowingByPresenting {
            dismiss(animated: true, completion: nil)
        }
        else{
            close()
        }

    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if isShowingByPresenting {
            sourceTxtFeild.text=Utility.getDateInString(datePickerObj.date, format: format)
            delegate?.datePickerViewController(datePickerObj, date: datePickerObj.date, sourceView: sourceTxtFeild)
            dismiss(animated: true, completion: nil)
        }
        else{
            
            switch (mode){
                
            case 0:
                selectedData = Utility.getTimeInString(datePickerObj.date, format: "HH:mm")
                break
                
            case 1:
            
                selectedData = Utility.getDateInString(datePickerObj.date, format: format)
                break
                
            default:
                break
            }
            doneButtonTapped?(selectedData)
            close()
        }
    }
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        
        if isShowingByPresenting {
            sourceTxtFeild.text=Utility.getDateInString(datePickerObj.date, format: format)
            delegate?.datePickerViewController(datePickerObj, date: datePickerObj.date, sourceView: sourceTxtFeild)
        }
        else{
            selectedData = Utility.getDateInString(datePickerObj.date, format: format)
        }
    }
    
    
    func show(controller:UIViewController) {
        
        controller.addChild(self)
        controller.view.addSubview(self.view)
    }
    
    func close() {
        
        self.view.removeFromSuperview()
        self.removeFromParent()

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
