//
//  WaitCommandViewModel.swift
//  Pods
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
// 
//

import Foundation
import RxSwift
import RxCocoa

final class WaitCommandViewModel: BaseViewModel {
    struct Input {
        
    }
    struct Output {
        let error: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        return Output(error: errorTracker.asDriver())
    }
    
    private func next() {
        
    }
}
