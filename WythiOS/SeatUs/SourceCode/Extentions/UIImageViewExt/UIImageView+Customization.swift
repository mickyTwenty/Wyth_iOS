//
//  UIImageView+Customization.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/31/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded(_ cornerRadius: CGFloat = 0.49) {
        self.layer.cornerRadius = (self.frame.height * cornerRadius)
        self.layer.masksToBounds = true
    }
    
}
