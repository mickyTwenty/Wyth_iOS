//
//  SignUpModel.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/16/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class SignUpEntity: NSObject {

    @objc  var placeholdertext:String!
    @objc  var hascustomaction:NSNumber!
    @objc  var issecured:NSNumber!
    @objc  var customactionname:String!
    @objc  var keyboardtype:NSNumber!
    @objc  var imagename:String!
    @objc  var text:String!
    @objc  var cellidentifier:String!
    @objc  var validationtype:NSNumber!
    @objc  var isselected:NSNumber!
    @objc  var docImage:UIImage!

    
    class func getModel()->(SignUpEntity){
        
        let model = SignUpEntity()
        model.placeholdertext = ""
        model.cellidentifier = ""
        return model
    }

}
