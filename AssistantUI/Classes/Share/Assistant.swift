//
//  Assistant.swift
//  AssistantUI
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

public class Assistant {
    public static let shared = Assistant()
    private var speechRecognizer: SpeechRecognizer!
    internal var voiceCommand = BehaviorSubject<String>(value: "")
    
    public func start() {
        speechRecognizer = SpeechRecognizer()
        config()
    }
    
    private func config() {
        speechRecognizer.didGotTranscript = { [weak self] message in
            self?.checkCommand(message)
            self?.voiceCommand.onNext(message)
        }
    }
    
    private func checkCommand(_ command: String) {
        if command == "Hello" {
            let vc = WaitCommandViewController.createViewController()
            let navigation = UINavigationController(rootViewController: vc)
            guard let rootVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else { return }
            rootVC.pushViewController(navigation, completion: nil)
        }
    }
}
