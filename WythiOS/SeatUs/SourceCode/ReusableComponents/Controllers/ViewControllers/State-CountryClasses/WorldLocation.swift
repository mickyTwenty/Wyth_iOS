//
//  WorldLocation.swift
//  SUITA
//
//  Created by Malik Wahaj Ahmed on 3/1/17.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import Foundation
import UIKit


class WorldLocation : NSObject {

    
    class func getCountriesList() -> [NSDictionary]{
    
        var countriesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    countriesInfo = jsonResult as! [NSDictionary]
                } catch {}
            } catch {}
        }
        return countriesInfo
    }
    
    class func getStatesList(countryID:String) -> [NSDictionary] {
        
        var statesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    statesInfo = (jsonResult as! [NSDictionary]).filter{ ($0.value(forKey: "country_id") as! NSNumber).stringValue == countryID}
                } catch {}
            } catch {}
        }
        return statesInfo
    }

    class func getCitiesList(stateId:String)-> [NSDictionary] {
        
        var citiesInfo = [NSDictionary]()
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    citiesInfo = (jsonResult as! [NSDictionary]).filter{ ($0.value(forKey: "state_id") as! NSNumber).stringValue == stateId}
                } catch {}
            } catch {}
        }
        return citiesInfo
    }
    
    class func getStateBy(stateId:String, countryID:String) -> NSDictionary? {
        let statesInfo = getStatesList(countryID: countryID)
        return statesInfo.filter({ ($0.value(forKey: "id") as? Int) == Int(stateId) }).first
    }
    
    class func getCityBy(cityId:String, stateId:String) -> NSDictionary? {
        let citiesInfo = getCitiesList(stateId: stateId)
        return citiesInfo.filter({ ($0.value(forKey: "id") as? Int) == Int(cityId) }).first
    }
    
}
