//
//  String+ClassName.swift
//  GlobalDents
//
//  Created by Qazi Naveed on 8/24/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//
import Swift
import UIKit

extension NSObject {
    static func nameOfClass() -> String {
        return NSStringFromClass(self as AnyClass).components(separatedBy: ".").last!
    }
}
