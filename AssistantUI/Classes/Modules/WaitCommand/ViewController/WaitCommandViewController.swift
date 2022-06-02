//
//  WaitCommandViewController.swift
//  Pods
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa

final class WaitCommandViewController: BaseViewController<WaitCommandViewModel> {
    static func createViewController() -> WaitCommandViewController {
        let viewModel = WaitCommandViewModel()
        let viewController = WaitCommandViewController.newInstance(with: viewModel)
        return viewController
    }
    
    override func configUI() {
    }

    override func bind() {
        let input = WaitCommandViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.error.drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    private var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            
        })
    }
}
