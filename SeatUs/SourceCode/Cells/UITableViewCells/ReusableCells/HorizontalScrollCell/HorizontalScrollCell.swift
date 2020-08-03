//
//  HorizontalScrollCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 10/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

protocol HorizontalScrollCellDelegate: class {
    func clickEvent(_ tag: Int, itemTag: Int, selectedStates: [Int:Bool])
}

class HorizontalScrollCell: UITableViewCell {

    weak var delegate: HorizontalScrollCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: PreferencesCell.nameOfClass(), bundle: nil), forCellWithReuseIdentifier: PreferencesCell.nameOfClass())
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeCell(_ model: PostTrip){
        titleLabel.text = model.title
        collectionView.reloadData()
    }
    
}

extension HorizontalScrollCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (Utility.getPreference()?.count) != nil{
            return (Utility.getPreference()?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let preferenceObject = Utility.getPreference()?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferencesCell.nameOfClass(),for:indexPath) as! PreferencesCell
        
        cell.setDetails(OfPreference: preferenceObject!)
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
}

extension HorizontalScrollCell: PreferencesCellDelegate {
    func clickEvent(_ tag: Int, selectedStates: [Int : Bool]) {
        if delegate != nil {
            delegate?.clickEvent(self.tag, itemTag: tag, selectedStates: selectedStates)
        }
    }
}


