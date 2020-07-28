//
//  FindRidesHeaderCell.swift
//  SeatUs
//
//  Created by Syed Muhammad Muzzammil on 15/11/2017.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit
import FZAccordionTableView

class FindRidesHeaderCell: FZAccordionTableViewHeaderView {
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 40.0;
    @IBOutlet weak var collapseImageView: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerBgView: UIView!
}
