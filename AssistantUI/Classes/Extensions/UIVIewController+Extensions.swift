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
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
