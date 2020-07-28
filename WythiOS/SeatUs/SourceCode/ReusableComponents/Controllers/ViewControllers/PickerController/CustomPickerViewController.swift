//
//  CustomPickerViewController.swift
//  GlobalDents
//
//  Created by Qazi Naveed on 9/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class CustomPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var contentArray : [String]! = []
    var selectedData:String! = ""
    var doneButtonTapped: ((String)->())?
    @IBOutlet weak var picker: UIPickerView!
    
    static func createPickerController(storyboardId:String)->CustomPickerViewController {
        
        let picker = UIStoryboard(name: FileNames.ReusableComponentsStoryBoard, bundle: nil).instantiateViewController(withIdentifier: storyboardId) as! CustomPickerViewController
        return picker
    }

    func show(controller:UIViewController) {
        
        controller.addChild(self)
        controller.view.addSubview(self.view)
    }
    
    func close() {
        
        self.view.removeFromSuperview()
        self.removeFromParent()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate=self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return contentArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        let option = contentArray[row]
        return option
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let option = contentArray[row]
        selectedData = option
    }
    

    @IBAction func cancelButtonClicked(_ sender: Any) {
        close()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        let option = contentArray[picker.selectedRow(inComponent: 0)]
        selectedData = option

        doneButtonTapped?(selectedData)
        close()

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
