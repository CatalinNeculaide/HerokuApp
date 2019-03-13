//
//  UIColor.swift
//  HerokuApp
//
//  Created by Catalin Neculaide on 12/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var defaultBlue = UIColor(red: 36, green: 145, blue: 255, alpha: 1)
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}
