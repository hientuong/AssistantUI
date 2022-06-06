//
//  SpeechRecognizer.swift
//  AssistantUI
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
//

import UIKit
import Foundation
import AVFoundation
import Speech
import RxSwift

class SpeechRecognizer {
   enum RecognizerError: Error {
       case nilRecognizer
       case notAuthorizedToRecognize
       case notPermittedToRecord
       case recognizerIsUnavailable
       
       var message: String {
           switch self {
           case .nilRecognizer: return "Can't initialize speech recognizer"
           case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
           case .notPermittedToRecord: return "Not permitted to record audio"
           case .recognizerIsUnavailable: return "Recognizer is unavailable"
           }
       }
    }
       
    var didGotTranscript: ((String) -> ())? = nil
    
    private var transcript: String = ""
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
        
    init() {
        recognizer = SFSpeechRecognizer()
        requestPermissions { [weak self] error in
            guard let error = error else { return }
            self?.speakError(error)
        }
    }
    
    deinit {
        reset()
    }
    
    func transcribe() {
        prepareEngine()
    }
    
    func stopTranscribing() {
        reset()
    }
    
    func resetTranscript() {
        transcript = ""
    }
    
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func prepareEngine() {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            speakError(error)
            return
        }
        let inputNode = audioEngine.inputNode
        
        guard let recognizer = self.recognizer,
              recognizer.isAvailable else {
            speakError(RecognizerError.recognizerIsUnavailable)
            return
        }
        self.audioEngine = audioEngine
        self.request = request
        task = recognizer.recognitionTask(with: request, resultHandler: recognitionHandler(result:error:))
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            speakError(error)
        }
    }
    
    private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
//        if receivedFinalResult || receivedError {
//            audioEngine?.stop()
//            audioEngine?.inputNode.removeTap(onBus: 0)
//        }
        
        if let result = result {
            speak(result.bestTranscription.formattedString)
        }
    }
    
    private func speak(_ message: String) {
        guard transcript != message else { return }
        transcript = message
        self.didGotTranscript?(message)
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
        print("Permission Error: \(transcript)")
    }
}

extension SpeechRecognizer {
    private func requestPermissions(completion: @escaping((Error?) -> ())) {
        let group = DispatchGroup()
        var hasSpeechPermission = false
        var hasAvAudioPermission = false
        
        group.enter()
        requestSpeechPermission { success in
            hasSpeechPermission = success
            group.leave()
        }

        group.enter()
        requestAVAudioPermission { success in
            hasAvAudioPermission = success
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            if self?.recognizer == nil {
                completion(RecognizerError.nilRecognizer)
            } else if !hasSpeechPermission {
                completion(RecognizerError.notAuthorizedToRecognize)
            } else if !hasAvAudioPermission {
                completion(RecognizerError.notPermittedToRecord)
            } else {
                completion(nil)
            }
        }
    }
    
    private func requestSpeechPermission(status: @escaping (Bool)->()){
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
                 status(true)
                    return
                }
                SFSpeechRecognizer.requestAuthorization { (sta) in
                    switch sta {
                    case .authorized:
                        status(true)
                    case .denied:
                        status(false)
                    case .notDetermined:
                        SFSpeechRecognizer.requestAuthorization({ (st) in
                            if st  == .authorized {
                                status(true)
                            } else {
                                status(false)
                            }
                        })
                    case .restricted:
                        status(false)
                    default:
                        status(false)
                    }
                }
        
    }
    
    private func requestAVAudioPermission(status: @escaping (Bool)->()){
        AVAudioSession.sharedInstance().requestRecordPermission { stt in
            status(stt)
        }
    }
}
