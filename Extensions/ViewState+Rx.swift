//
//  ViewState+Rx.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 2/2/21..
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController view states.
enum ViewControllerViewState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
    case viewDidLayoutSubviews
    case willMove
    case didMove
}

/// UIViewController view state changes.
/// Emits a Bool value indicating whether the change was animated or not.
extension RxSwift.Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
    }

    var viewDidLayoutSubviews: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in }
    }

    var viewWillAppear: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in }
    }

    var viewDidAppear: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { _ in }
    }

    var viewWillDisappear: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { _ in }
    }

    var viewDidDisappear: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { _ in }
    }

    var willMove: Observable<UIViewController?> {
        methodInvoked(#selector(UIViewController.willMove(toParent:)))
            .map { $0.first as? UIViewController? ?? nil }
    }

    var didMove: Observable<UIViewController?> {
        methodInvoked(#selector(UIViewController.didMove(toParent:)))
            .map { $0.first as? UIViewController? ?? nil }
    }

    /// Observable sequence of the view controller's view state.
    /// This gives you an observable sequence of all possible states.
    /// - returns: Observable sequence of AppStates.
    var viewState: Observable<ViewControllerViewState> {
        Observable.of(
            viewDidLoad.map { _ in ViewControllerViewState.viewDidLoad },
            viewDidLayoutSubviews.map { _ in ViewControllerViewState.viewDidLayoutSubviews },
            viewWillAppear.map { _ in ViewControllerViewState.viewWillAppear },
            viewDidAppear.map { _ in ViewControllerViewState.viewDidAppear },
            viewWillDisappear.map { _ in ViewControllerViewState.viewWillDisappear },
            viewDidDisappear.map { _ in ViewControllerViewState.viewDidDisappear }
        )
        .merge()
    }
}

