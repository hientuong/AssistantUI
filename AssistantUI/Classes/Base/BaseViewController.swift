//
//  BaseViewController.swift
//  demo
//
//  Created by Gà Nguy Hiểm on 22/12/2020.
//

import UIKit
import RxSwift

protocol BaseAlert {
    func alert(title: String?,
               message: String,
               buttonTittle: String?,
               handler: (() -> Void)?)
}

class BaseViewController<T: ViewModelProtocol>: UIViewController, UseViewModel, BaseAlert {
    
    public typealias Model = T
    var disposeBag = DisposeBag()
    var viewModel: Model!
    var bottomConstraint: NSLayoutConstraint?
    
    var isLoading: Bool = false
    
    open func bind(to model: Model) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configUI()
        bind()
        extendedLayoutIncludesOpaqueBars = true
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func bind() {}
    
    func configUI() {}
    
    @objc func viewDidBecomeActive() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }

    func alert(title: String?,
               message: String,
               buttonTittle: String? = "OK",
               handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title ?? "",
                                                message: message,
                                                defaultActionButtonTitle: buttonTittle ?? "OK")
        let action = UIAlertAction(title: buttonTittle, style: .default) { action in
            handler?()
        }
        alertController.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.bottomConstraint?.constant = 10.0
        } else {
            if #available(iOS 11.0, *) {
                self.bottomConstraint?.constant = (endFrame?.size.height ?? 0.0) - self.view.safeAreaInsets.bottom + 10
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
}

extension BaseViewController {
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
