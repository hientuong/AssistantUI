//
//  UIVIewController+Extensions.swift
//  demo
//
//  Created by Gà Nguy Hiểm on 22/12/2020.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            let bundle = Bundle(for: self)
            return T(nibName: String(describing: self), bundle: bundle)
        }
        return instanceFromNib()
    }
}
