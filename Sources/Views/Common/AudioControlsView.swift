//
//  AudioControlsView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import AVFoundation
import SwiftUI

public struct AudioControlsView: View {
    @EnvironmentObject var audio: AudioManager
    @Binding var isPresented: Bool

    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                }
            }

            Text("🎵 Background Music")
            Slider(value: $audio.musicVolume, in: 0...1, step: 0.01)

            Text("Volume: \(Int(audio.musicVolume * 100))%")

            Divider().padding(.vertical)

            Text("🔊 Sound Effects")
            Slider(value: $audio.sfxVolume, in: 0...1, step: 0.01)
                .onChange(of: audio.sfxVolume) { _ in
                    audio.playSFX(named: "pop_sound")
                }
            Text("Volume: \(Int(audio.sfxVolume * 100))%")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
