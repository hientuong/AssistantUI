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
import AssistantAPI

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

extension AssistantViewModel {
    private func pushMessage() {
        AssistantClient.pushMessage(message: "Tại sao gọi Ocean Park là thành phố 15 phút?",
                                    vaAgenId: "1653292868813182109",
                                    nlpFeature: ["DIALOG"])
            .delay(.microseconds(100), scheduler: MainScheduler.instance)
            .flatMap({ messageId -> Single<VAResponse> in
                return AssistantClient.getVAResponse(by: messageId)
            }).flatMap({ response -> Single<VAResponse> in
                print("DEBUG: getVAResponse by message id ")
                print(response)
                return AssistantClient.getVAResponse()
            })
        .subscribe { response in
            print("DEBUG: getVAResponse by session id ")
            print(response)
        } onFailure: { error in
            print(error)
        }.disposed(by: disposeBag)
    }
}

extension AssistantViewModel {
    private func getResponse() {
        AssistantClient.getVAResponse(by: "test")
            .delay(.microseconds(100), scheduler: MainScheduler.instance)
        .subscribe { response in
            print("DEBUG: getVAResponse by session id ")
            print(response)
        } onFailure: { error in
            print(error)
        }.disposed(by: disposeBag)
    }
}
