//
//  BaseViewController.swift
//  demo
//
//  Created by Gà Nguy Hiểm on 22/12/2020.
//

import UIKit
import RxSwift

struct NavigationSetting {
    var title: String? = nil
    var isHiddenTabbar: Bool = false
    var isHiddenNavigation: Bool = false
    var isHasBackButton: Bool = true
    var backImage: String = "ic_back_left_white"
    var navigationColor: UIColor = StyleKit.MainColorNavigationBar
    var navigationShadow: UIImage? = nil
    var rightButtons: [UIBarButtonItem]? = nil
}

protocol BaseAlert {
    func alert(title: String?,
               message: String,
               buttonTittle: String?,
               highlight: PopupViewController.HighlightSetting?,
               handler: ((String?) -> Void)?)
    func confirmAlert(title: String, message: String,
               noTitle: String,
               noColor: UIColor?,
               yesTitle: String,
               highlight: PopupViewController.HighlightSetting?,
               input: PopupViewController.InputSetting?,
               yesHandler: ((String?) -> Void)?,
               noHandler: (() -> Void)?)
}

class BaseViewController<T: ViewModelProtocol>: UIViewController, UseViewModel, BaseAlert {
    
    public typealias Model = T
    typealias SettingPopup = PopupViewController.SettingPopup
    var disposeBag = DisposeBag()
    var viewModel: Model!
    var bottomConstraint: NSLayoutConstraint?
    
    var isLoading: Bool = false
    
    public var setting: NavigationSetting {
        return NavigationSetting()
    }
    
    open func bind(to model: Model) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex1D1D27
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
        UIApplication.shared.statusBarStyle = .lightContent
        title = setting.title
        tabBarController?.tabBar.isHidden = setting.isHiddenTabbar
        navigationController?.navigationBar.isHidden = setting.isHiddenNavigation
        styleNavigation()
    }
    
    private func styleNavigation() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = setting.navigationShadow
        let backgroundColor = UIImage(color: setting.navigationColor, size: CGSize(width: 1, height: 1))
        navigationController?.navigationBar.setBackgroundImage(backgroundColor, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white,
                                                                   .font: UIFont(name: StyleKit.fontNameBold, size: 16) ??
                                                                            UIFont.systemFont(ofSize: 16)]
        navigationController?.navigationBar.isTranslucent = false
        if setting.isHasBackButton {
            let backItem = UIBarButtonItem(
                image: UIImage(named: setting.backImage),
                style: .plain,
                target: self,
                action: #selector(backAction))
            navigationItem.leftBarButtonItem = backItem
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: nil,
                style: .plain,
                target: self,
                action: nil)
        }
        if let rightButtons = setting.rightButtons {
            navigationItem.rightBarButtonItems = rightButtons
        } else {
            navigationItem.rightBarButtonItems = nil
        }
        view.layoutIfNeeded()
    }

    func alert(title: String?,
               message: String,
               buttonTittle: String? = "OK",
               highlight: PopupViewController.HighlightSetting? = nil,
               handler: ((String?) -> Void)? = nil) {
        let alertController = PopupViewController.initFromNib()
        alertController.setting = SettingPopup(title: title,
                                               highlight: highlight,
                                               message: message,
                                               rightTitle: buttonTittle,
                                               rightAction: handler)
        alertController.modalTransitionStyle = .crossDissolve
        alertController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func confirmAlert(title: String, message: String,
               noTitle: String = "Cancel",
               noColor: UIColor? = nil,
               yesTitle: String = "Confirm",
               highlight: PopupViewController.HighlightSetting? = nil,
               input: PopupViewController.InputSetting? = nil,
               yesHandler: ((String?) -> Void)? = nil,
               noHandler: (() -> Void)? = nil) {
        let alertController = PopupViewController.initFromNib()
        alertController.setting = SettingPopup(title: title,
                                               highlight: highlight,
                                               message: message,
                                               input: input,
                                               leftTitle: noTitle,
                                               leftColor: noColor,
                                               leftAction: noHandler,
                                               rightTitle: yesTitle,
                                               rightAction: yesHandler)
        alertController.modalTransitionStyle = .crossDissolve
        alertController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    
    @objc func backAction() {
        viewModel.back()
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
