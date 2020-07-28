//
//  UIView+Customization.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 12/12/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
}
