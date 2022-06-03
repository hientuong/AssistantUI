//
//  AssistantViewModel.swift
//  Pods
//
//  Created by user on 03/06/2022.
// 
//

import Foundation
import RxSwift
import RxCocoa

final class AssistantViewModel: BaseViewModel {
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
