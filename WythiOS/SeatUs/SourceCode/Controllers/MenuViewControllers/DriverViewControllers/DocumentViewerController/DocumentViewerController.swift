//
//  DocumentViewerController.swift
//  SeatUs
//
//  Created by Qazi Naveed on 11/1/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class DocumentViewerController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    @IBOutlet weak var docCollectionView:UICollectionView!
    var contentArray : [[String:AnyObject]]!
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        docCollectionView.delegate = self
        docCollectionView.dataSource = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentViewerCollectionViewCell.nameOfClass(), for: indexPath as IndexPath) as! DocumentViewerCollectionViewCell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = UIScreen.main.bounds.size.height
        return CGSize(width: cellWidth, height: cellHeight)
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
