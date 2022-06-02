//
//  SpeechRecognizer.swift
//  AssistantUI
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
//

import Foundation
import AVFoundation
import Speech

class SpeechRecognizer: ObservableObject {
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
    private let recognizer: SFSpeechRecognizer?
        
    init() {
        recognizer = SFSpeechRecognizer()
        prepareEngine()
        
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
    }
    
    deinit {
        reset()
    }
    
    private func transcribe() {
        guard let recognizer = self.recognizer, recognizer.isAvailable else {
            speakError(RecognizerError.recognizerIsUnavailable)
            return
        }
        guard let request = self.request else { return }
        task = recognizer.recognitionTask(with: request, resultHandler: recognitionHandler(result:error:))
    }
    
    func stopTranscribing() {
        reset()
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
        transcript = message
        self.didGotTranscript?(transcript)
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
}

fileprivate extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

fileprivate extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
