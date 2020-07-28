//
//  SearchAndFindPicker.swift
//  WorldLocationPicker
//
//  Created by Malik Wahaj Ahmed on 21/03/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import Foundation
import UIKit


class SearchAndFindPicker : UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var previousSelectedRow: IndexPath!

    var contentKey :String! = "name"
    
    var searchActive : Bool = false
    var filteredArray:[[String:AnyObject]] = []
    var dataArray = [[String:AnyObject]]()
    
    var dataTypeStr = ""
    
    var selectedData:[String:AnyObject]!
    var doneButtonTapped: (([String:AnyObject])->())?
    
    static func createPicker(dataArray: [[String:AnyObject]], typeStr : String) -> SearchAndFindPicker {
        let newViewController = UIStoryboard(name: "SearchAndFindPicker", bundle: nil).instantiateViewController(withIdentifier: "SearchAndFindPicker") as! SearchAndFindPicker
        newViewController.dataArray = dataArray
        newViewController.dataTypeStr = typeStr
        return newViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.placeholder = "Search \(dataTypeStr)"
        
        self.searchBar.setTextColor(color: .black)
        self.searchBar.setPlaceholderTextColor(color: .black)
        self.searchBar.setTextFieldColor(color: .clear)
        self.searchBar.setSearchImageColor(color: .black)
        self.searchBar.setTextFieldClearButtonColor(color: .black)
        
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(tapGestureRecognizer:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        if ApplicationConstants.CollegeNameConstant.compare(dataTypeStr) == .orderedSame {
            contentKey = "school"
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120 //Set this to any value that works for you.
        

        clearSelection()
    }
    
    @objc func backgroundTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard (selectedData) != nil else {
            print("Select \(dataTypeStr)")
            return
        }
        doneButtonTapped?(selectedData)
        self.close()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.close()
    }
    
    func show(vc:UIViewController) {
        vc.addChild(self)
        vc.view.addSubview(self.view)
    }
    
    func close() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func clearSelection() {
    
        var tempDataArray = [[String:AnyObject]]()
        for i in 0..<dataArray.count {
            var data = dataArray[i]
            data.updateValue(0 as AnyObject, forKey: "unselected")
            tempDataArray.append(data)
        }
        dataArray = tempDataArray
        //tableView.reloadData()
    }
    
    func smartSearch(searchText: String){
        
// FilterResults results = new FilterResults();
        filteredArray = []
        
//        ArrayList<SchoolItem> FilteredArrayNames = new ArrayList<SchoolItem>();
//        ArrayList<SchoolItem> FilteredArraySchoolStarts = new ArrayList<SchoolItem>();
//        ArrayList<SchoolItem> FilteredArraySchools = new ArrayList<SchoolItem>();
//        ArrayList<SchoolItem> FilteredArrayLocations = new ArrayList<SchoolItem>();u
        var filteredArraySchoolStarts = [[String:AnyObject]]()
        var filteredArraySchools = [[String:AnyObject]]()
        var filteredArrayLocations = [[String:AnyObject]]()
    
        let firstSpace = searchText.isEmpty ? "" : String(searchText[searchText.startIndex])
        
        //  constraint = constraint.toString().toLowerCase();
        var constraint = searchText.lowercased()
        
        // CharSequence shortcut = "university of ";
        let shortcut = "university of "
        
        // String[] shortcutted = constraint.toString().toLowerCase().split(" ");
        var shortcutted = constraint.split(separator: " ")
        
        if firstSpace == " " {
            shortcutted.insert("", at: 0)
        }
        
        // if((shortcut.toString().startsWith(shortcutted[0])) && (constraint.toString().contains(" "))) {
            
        if shortcutted.count > 0 && (shortcut.starts(with: shortcutted[0])) && (constraint.contains(" ")) {
            
            var index: Int!
            
        //    if(constraint.toString().contains(" o ") || constraint.toString().contains(" of "))
            
            if ( constraint.contains(" o ") || constraint.contains(" of ")) {
                
              //  constraint = shortcut.toString() + constraint.subSequence(shortcutted[0].length() + shortcutted[1].length() + 2, constraint.length()).toString();

                index = shortcutted[0].count + shortcutted[1].count + 2
                
            }
            // else if(constraint.toString().contains(" o") || constraint.toString().contains(" of"))
            else if ( constraint.contains(" o") || constraint.contains(" of")) {
            
                // constraint = shortcut.toString() + constraint.subSequence(shortcutted[0].length() + shortcutted[1].length() + 1, constraint.length()).toString();
                
                index = shortcutted[0].count + shortcutted[1].count + 1
                
            }
            else {
                
                // constraint = shortcut.toString() + constraint.subSequence(shortcutted[0].length() + 1, constraint.length()).toString();

                index = shortcutted[0].count + 1
                
            }
            
            let startIndex = constraint.index(constraint.startIndex, offsetBy: index)
            
            constraint = shortcut + constraint[startIndex...]
            
        }
        
        print("new value ",constraint)
        //String firstLetters = "";
        var firstLetters = ""
        
//        for (int i = 0; i < defaultData.size(); i++) {
        for data in dataArray {
            
    //  data = ["city": Kirksville, "state": Missouri, "unselected": 0, "school": A.T. Still University of Health Sciences]

            let school = (data["school"] as? String ?? "").lowercased()
            let state = (data["state"] as? String ?? "").lowercased()
            let city = (data["city"] as? String ?? "").lowercased().replacingOccurrences(of: " ", with: "")
            
//            if (
//                defaultData.get(i).school.toLowerCase().startsWith(constraint.toString() ) ||
//
//                ( defaultData.get(i).school.toLowerCase().startsWith(shortcut.toString() ) &&
//                  defaultData.get(i).school.toLowerCase().startsWith( constraint.toString(), shortcut.length() )
//                )
//
//                ) {
            
                
            if ( school.starts(with: constraint) ||
                ( school.starts(with: shortcut) && school.dropFirst(shortcut.count).starts(with: constraint) ) ) {
                
            //    FilteredArraySchoolStarts.add(defaultData.get(i));
                
                filteredArraySchoolStarts.append(data)
                
            }
            
//            else if (defaultData.get(i).school.toLowerCase().contains(constraint.toString())) {
//                FilteredArraySchools.add(defaultData.get(i));
//            }
            
            else if school.contains(constraint) {
                
                filteredArraySchools.append(data)
                
            }
            
//            else if (
//                defaultData.get(i).school.toLowerCase().contains(constraint.toString()) ||
//                defaultData.get(i).state.toLowerCase().contains(constraint.toString()) ||
//                defaultData.get(i).city.toLowerCase().replaceAll(" ", "").contains(constraint.toString())
//                )
//            {
//                FilteredArrayLocations.add(defaultData.get(i));
//            }
//
            else if ( school.contains(constraint) || state.contains(constraint) || city.contains(constraint) ) {
            
                filteredArrayLocations.append(data)
                
            }
            
            else {
                
//                StringBuffer sb = new StringBuffer();
//                String[] splitNames = defaultData.get(i).school.toLowerCase().split(" ");
                
                let splitNames = school.split(separator: " ")
                
//                for (int j = 0; j < splitNames.length; j++) {
//                    if(splitNames[j].length() > 1)
//                    sb.append(splitNames[j].charAt(0));
//                }
//                firstLetters = sb.toString();
                
                for name in splitNames {
                    
                    if name.count > 1 {
                        
                        firstLetters += String(name[name.startIndex])
                        
                    }
                    
                }
                
//                if(firstLetters.contains(constraint.toString())){
//                    FilteredArraySchools.add(defaultData.get(i));
//                }
                
                if firstLetters.contains(constraint) {
                    
                    filteredArraySchools.append(data)
                    
                }
                
            }
            
            
        }
        
//        FilteredArrayNames.addAll(FilteredArraySchoolStarts);
//        FilteredArrayNames.addAll(FilteredArraySchools);
//        FilteredArrayNames.addAll(FilteredArrayLocations);
        print("filteredArray \(constraint) SchoolStarts: ", filteredArraySchoolStarts.compactMap({$0["school"]}))
        print("filteredArray \(constraint) Schools: ", filteredArraySchools.compactMap({$0["school"]}))
        print("filteredArray \(constraint) SchoLocations: ", filteredArrayLocations.compactMap({$0["school"]}))
        
        filteredArray.append(contentsOf: filteredArraySchoolStarts)
        filteredArray.append(contentsOf: filteredArraySchools)
        filteredArray.append(contentsOf: filteredArrayLocations)
        
    }
    
}

extension SearchAndFindPicker : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false;
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        print("here is text : ", searchText)
        var status = false
        
        
        
        if ApplicationConstants.CollegeNameConstant.compare(dataTypeStr) == .orderedSame {
            
            smartSearch(searchText: searchText)
            
//            filteredArray = dataArray.filter ({ (data) -> Bool in
//
//                let school = data[contentKey] as? NSString
//                let city = data["city"] as? NSString
//                let state = data["state"] as? NSString
//
//
//                if let tmpSchool = school {
//                    let range = tmpSchool.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                    status = range.location != NSNotFound
//                    if status {
//                        return true
//                    }
//                }
//
//                if let tmpCity = city {
//                    let range = tmpCity.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                    status = range.location != NSNotFound
//                    if status {
//                        return true
//                    }
//                }
//
//                if let tmpState = state {
//                    let range = tmpState.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//                    status = range.location != NSNotFound
//                    if status {
//                        return true
//                    }
//                }
//                return status
//            })
        }
        
        else {
            filteredArray = dataArray.filter ({ (data) -> Bool in
                if let tmp = data[contentKey] as? NSString {
                    let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                }
                return false
            })
            
        }
        
        
        if(filteredArray.count == 0){
            //searchActive = false;
        } else {
            searchActive = true;
        }
        
        if searchText.count == 0 {
            searchActive = false;
        }
        self.tableView.reloadData()
    }
    
}

extension SearchAndFindPicker : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredArray.count
        }
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAndFindCell", for: indexPath) as? SearchAndFindCell {
            if(searchActive && filteredArray.count > 0){
                cell.labelName.text = filteredArray[indexPath.row][contentKey] as? String
            } else {
                cell.labelName.text = dataArray[indexPath.row][contentKey] as? String
            }
            cell.selectionStyle = .none
            cell.actionButton.isHidden = true
//            if let unselected = dataArray[indexPath.row]["unselected"] as? Int {
//                cell.actionButton.isHidden = unselected == 0 ? true : false
//            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if (previousSelectedRow != nil) {
            
            let previousRowCell = tableView.cellForRow(at: previousSelectedRow!) as? SearchAndFindCell
            previousRowCell?.actionButton.isHidden = true
        }
        previousSelectedRow = indexPath

        let indexPathSelectedRow = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRow(at: indexPathSelectedRow!) as? SearchAndFindCell
        
        //clearSelection()
    
        if let cell = currentCell {
            cell.actionButton.isHidden = false
            if (searchActive && filteredArray.count > 0) {
                selectedData = filteredArray[indexPath.row]
            }
            else {
                selectedData = dataArray[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return   UITableView.automaticDimension
}
}

extension SearchAndFindPicker {
    
    @objc func keyBoardWillShow() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    @objc func keyBoardWillHide() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool){
        
        let kOffset:CGFloat = 0.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= kOffset;
            rect.size.height += kOffset;
        }
        else
        {
            rect.origin.y += kOffset;
            rect.size.height -= kOffset;
        }
        self.view.frame = rect;
        UIView.commitAnimations()
    }
    
}
