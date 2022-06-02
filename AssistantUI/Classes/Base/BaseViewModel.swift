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
}

class BaseViewModel: NSObject, ViewModelProtocol {
    public var disposeBag: DisposeBag = DisposeBag()
    public let errorTracker = ErrorTracker()
    public let validateTracker = PublishSubject<[Error]>()
    public var currentPage: Int = 0
    public var pageSize: Int = 16
    public var total: Int = 0
    public var isLoading: Bool = false
    public var shouldLoadMore = BehaviorSubject<Bool>(value: true)

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
