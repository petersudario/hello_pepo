//
//  AudioPlayerViewModel.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import AVFoundation
import Combine

final class AudioPlayerViewModel: ObservableObject {
    private var player: AVAudioPlayer?

    func play(_ file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Erro áudio: \(error)")
        }
    }

    func stop() { player?.stop() }
}