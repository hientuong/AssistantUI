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
    
    func showToast(icon: String, message: String) {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = UIColor(hexString: "#121212") ?? .black
        style.messageFont = StyleKit.appFont(with: .medium, and: .medium)
        style.messageAlignment = .center
        style.imageSize = CGSize(width: 20, height: 20)
        style.activitySize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 100)
        style.displayShadow = true
        style.shadowOpacity = 0.4
        UIApplication.shared.keyWindow?.view.makeToast(message, duration: 2, position: .bottom, image: UIImage(named: icon), style: style, completion: nil)
    }
}
