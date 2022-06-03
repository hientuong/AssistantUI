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
    
    private var disposeBag = DisposeBag()
    private var speechRecognizer: SpeechRecognizer!
    private var hasNewCommand = true
    private var navigationVC: UINavigationController?
    
    var commandObser = PublishSubject<String>()
    
    init() {
        config()
    }
    
    public func start() {
        speechRecognizer.transcribe()
    }
    
    private func config() {
        speechRecognizer = SpeechRecognizer()
        speechRecognizer.didGotTranscript = { [weak self] message in
            self?.checkCommand(message)
        }
    }
    
    private func checkCommand(_ command: String) {
        if command == "Hello", navigationVC == nil {
            hasNewCommand = false
            let vc = AssistantViewController.createViewController()
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalTransitionStyle = .crossDissolve
            navigation.modalPresentationStyle = .overFullScreen
            if let rootVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
                rootVC.pushViewController(navigation, completion: nil)
            } else if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(navigation, animated: true)
            }
            self.navigationVC = navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                if self?.hasNewCommand == false {
                    self?.navigationVC?.dismiss(animated: true, completion: nil)
                    self?.navigationVC = nil
                    self?.speechRecognizer.resetTranscript()
                }
            }
        } else {
            hasNewCommand = true
            commandObser.onNext(command)
        }
        
    }
}
