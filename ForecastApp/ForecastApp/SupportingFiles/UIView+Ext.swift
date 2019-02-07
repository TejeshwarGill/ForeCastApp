//
//  UIView+Ext.swift
//  ForecastApp
//
//  Created by  Developer on 07/02/2019.
//  Copyright © 2019 Developer Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
