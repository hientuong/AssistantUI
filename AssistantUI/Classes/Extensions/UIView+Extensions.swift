//
//  UIView+Extensions.swift
//  Apollo11
//
//  Created by cong nguyen on 3/30/20.
//  Copyright © 2020 smartosc. All rights reserved.
//

import UIKit

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return loadFromNib(named: String(describing: self)) as! T
    }
}
