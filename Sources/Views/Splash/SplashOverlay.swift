//
//  SplashOverlay.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import SwiftUI

public struct SplashOverlay: View {
    let startAction: () -> Void
    @State private var float = false
    @State private var showAudioControls = false
    @EnvironmentObject private var audioManager: AudioManager

    public var body: some View {
        ZStack {

            VStack(spacing: 30) {
                Spacer(minLength: 30)
                Group {
                    Text("Pepo's")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(0.8)
                        .rotationEffect(.degrees(-10))

                    Text("MemoBox")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(0.8)
                        .rotationEffect(.degrees(-10))
                }
                .offset(y: float ? -10 : 10)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: float
                )
                .onAppear { float.toggle() }

                Button(action: startAction) {
                    Text("Begin")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .cornerRadius(8)
                }

                Button(action: { showAudioControls = true }) {
                    Text("Settings")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()

            if showAudioControls {
                VStack {
                    Spacer()
                    AudioControlsView(isPresented: $showAudioControls)

                    Spacer()
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut, value: showAudioControls)
                .environmentObject(audioManager)
            }
        }
    }
}
