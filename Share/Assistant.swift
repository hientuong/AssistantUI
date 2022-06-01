//
//  Assistant.swift
//  AssistantUI
//
//  Created by Gà Nguy Hiểm on 01/06/2022.
//

import Foundation

public class Assistant {
    public static var shared = Assistant()
    private var speechRecognizer: SpeechRecognizer!
    
    init() {
        speechRecognizer = SpeechRecognizer()
    }
    
    public func startListen() {
        speechRecognizer.reset()
        speechRecognizer.transcribe()
        speechRecognizer.isRecording = true
    }
    
    public func stopListen() {
        speechRecognizer.stopTranscribing()
        speechRecognizer.isRecording = false
    }
}
