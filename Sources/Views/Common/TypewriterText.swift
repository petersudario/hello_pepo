//
//  TypewriterText.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

struct TypewriterText: View {
    let fullText: String
    let isActive: Bool

    @State private var displayedText = ""
    @State private var animationTask: Task<Void, Never>?
    private let interval: TimeInterval = 0.05

    var body: some View {
        Text(displayedText)
            .font(.system(size: 32, weight: .regular))
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .multilineTextAlignment(.leading)
            .onAppear {
                if isActive { startAnimation() }
            }
            .onChange(of: isActive) { active in
                if active { startAnimation() }
                else     { animationTask?.cancel() }
            }
    }

    private func startAnimation() {
        animationTask?.cancel()
        displayedText = ""
        animationTask = Task {
            for char in fullText {
                if Task.isCancelled { return }
                await MainActor.run { displayedText.append(char) }
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }
}
