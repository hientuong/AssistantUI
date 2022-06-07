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
        let voiceCommand: Driver<String>
    }
    struct Output {
        let messages: Driver<[BotMessage]>
        let error: Driver<Error>
    }
    
    private let dataMessages = BehaviorSubject<[BotMessage]>(value: [])

    func transform(input: Input) -> Output {
        
        input.voiceCommand
            .drive(onNext: sendMessage(_:))
            .disposed(by: disposeBag)
        
        return Output(messages: dataMessages.asDriverOnErrorJustComplete(),
                      error: errorTracker.asDriver())
    }
}

extension AssistantViewModel {
    private func prepareUserMessage(_ text: String) {
        let message =  BotMessage(type: nil,
                                  value: text,
                                  modelName: nil,
                                  pitch: nil,
                                  speed: nil)
        guard var messages = try? dataMessages.value() else { return }
        messages.append(message)
        dataMessages.onNext(messages)
    }
    
    private func sendMessage(_ text: String) {
        prepareUserMessage(text)
        pushMessage(text)
    }
    
    private func pushMessage(_ text: String) {
        AssistantClient.pushMessage(message: text,
                                    vaAgenId: "1653292868813182109",
                                    nlpFeature: ["DIALOG"])
            .delay(.microseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] messageId in
                self?.getVAResponse(messageId)
            }, onFailure: handleError)
            .disposed(by: disposeBag)
    }
    
    private func getVAResponse(_ messageId: String) {
        AssistantClient.getVAResponse(by: messageId)
            .subscribe(onSuccess: { [weak self] response in
                print("DEBUG: getVAResponse by session id ")
                print(response)
                if response.vaData?.isAllDone == false {
                    self?.getVAResponse(messageId)
                } else {
                    guard let datas = response.vaData?.dmResponse?.botMessage else { return }
                    guard var messages = try? self?.dataMessages.value() else { return }
                    messages.append(contentsOf: datas)
                    messages = messages.filter({$0.type != .voice})
                    self?.dataMessages.onNext(messages)
                }
            }, onFailure: handleError)
            .disposed(by: disposeBag)
    }
}
