//
//  BaseViewModel.swift
//  demo
//
//  Created by Gà Nguy Hiểm on 22/12/2020.
//

import Foundation
import RxSwift
import RxCocoa
import SwifterSwift

protocol ViewModelProtocol {
    var disposeBag: DisposeBag { get set }
    init()
    func back()
}

class BaseViewModel: NSObject, ViewModelProtocol {
    public typealias RouteType = AppRoute
    public var router: WeakRouter<AppRoute>
    public var disposeBag: DisposeBag = DisposeBag()
    public let errorTracker = ErrorTracker()
    public let validateTracker = PublishSubject<[Error]>()
    public var currentPage: Int = 0
    public var pageSize: Int = 16
    public var total: Int = 0
    public var isLoading: Bool = false
    public var shouldLoadMore = BehaviorSubject<Bool>(value: true)
    
    required public init(with router: WeakRouter<AppRoute>) {
        self.router = router
    }
    
    func back() {
        router.trigger(.pop(nil))
    }
    
    func handleError(_ error: Error) {
        errorTracker.trackError(error)
    }
}

extension UseViewModel where Self: UIViewController {
    static func newInstance(with viewModel: Model) -> Self {
        let viewController = self.initFromNib()
        viewController.bind(to: viewModel)
        return viewController
    }
    
    static func newInstance() -> Self {
        return self.initFromNib()
    }
}

protocol UseViewModel {
    associatedtype Model
    var viewModel: Model! { get set }
    func bind(to model: Model)
}
