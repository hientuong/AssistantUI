//
//  Assistant.swift
//  AssistantUI
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import AssistantAPI

struct AppEnvironment: NetworkEnv {
    var baseUrl: String {
        return "https://vinbase.ai/"
    }

    static var shared = AppEnvironment()
}

public class Assistant {
    public static let shared = Assistant()
    
    private var disposeBag = DisposeBag()
    private var speechRecognizer: SpeechRecognizer!
    private var hasNewCommand = true
    private var navigationVC: UINavigationController?
    
    var commandObser = PublishSubject<String>()
    
    init() {
        config()
        registerDevice()
    }
    
    public func start() {
        speechRecognizer.transcribe()
    }
    
    func dismiss() {
        self.navigationVC?.dismiss(animated: true, completion: nil)
        self.navigationVC = nil
        self.speechRecognizer.resetTranscript()
    }
    
    func autoDismiss() {
        if self.hasNewCommand == false {
            dismiss()
        }
    }
    
    private func config() {
        NetworkAdapter.shared.setupAdapter(environment: AppEnvironment())
        
        speechRecognizer = SpeechRecognizer()
        speechRecognizer.didGotTranscript = { [weak self] message in
            self?.checkCommand(message)
        }
    }
    
    private func checkCommand(_ command: String) {
        print("test command \(command)")
        if shouldStart(command: command), navigationVC == nil {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
                self?.autoDismiss()
            }
        } else {
            if navigationVC != nil {
                hasNewCommand = true
                commandObser.onNext(command)
            }
        }
        
    }
    
    private func shouldStart(command: String) -> Bool {
        var shouldStart = false
        let checkCommand = command.lowercased().replacingOccurrences(of: " ", with: "")
        if checkCommand.contains("hey") ||
            checkCommand.contains("vin") ||
            checkCommand.contains("home") {
            shouldStart = true
        }
        return shouldStart
    }
}

extension Assistant {
    func registerDevice() {
        let regData =  """
{\"device_code\":\"VINHOMES_OPC_00002\",\"va_release_version_id\":1653911899461852567,\"asr_release_version_id\":1653921035257562939,\"tts_release_version_id\":1653921191625342767,\"va_agent_id\":1653292868813182109,\"device_model\":\"DEFAULT MODEL\",\"device_info\":{\"model\":\"DEFAULT MODEL\",\"manufacture\":\"\",\"vin\":\"VINHOMES_OPC_00001\",\"model_year\":0,\"fuel_capacity\":0,\"variant\":\"\",\"market\":\"\",\"car_type\":\"\",\"sw_version\":\"DEFAULT VERSION\",\"hw_version\":\"\"},\"device_type\":\"VINFAST\",\"device_public_key\":\"1\"}
"""
        AssistantClient.registerDevice(isDevMode: true,
                                       registrationData: regData,
                                       deviceCert: "",
                                       signature: "",
                                       isFromDevice: false).subscribe { appToken in
            print("DEBUG: \(appToken)")
        } onFailure: { error in
            print("DEBUG: \(error)")
        }.disposed(by: disposeBag)
    }
}
