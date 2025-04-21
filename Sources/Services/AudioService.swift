//
//  AudioService.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import AVFoundation

actor AudioService {
    static let shared = AudioService()
    private init() {
        Task {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default)
                try session.setActive(true)
            } catch {
                print("AudioService initialization error: \(error)")
            }
        }
    }
    
    func preload(_ file: String) async {
        _ = Bundle.main.url(forResource: file, withExtension: nil)
    }
}

