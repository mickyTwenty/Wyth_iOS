//
//  NSLog.swift
//  EatNow
//
//  Created by Shahrukh Jamil on 11/2/17.
//  Copyright © 2017 Appmaisters. All rights reserved.
//

import Foundation
import UIKit

public func NSLog(_ format: String, _ args: CVarArg...) {
    let message = String(format: format, arguments:args)
    print(message);
    NSLogv(message, getVaList([]))
}


