//
//  SplashOverlay.swift
//  hello_pepo
//
//  Created by Pedro Henrique Sudario da Silva on 19/04/25.
//

import SwiftUI
import SpriteKit

public struct SplashOverlay: View {
    let startAction: () -> Void

    public var body: some View {
        ZStack {
            Color.black.opacity(0.6)

            VStack {
                Spacer()

                Text("MEET")
                    .font(.system(size: 60, weight: .ultraLight))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.8)

                Text("PEPO")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.8)

                Spacer().frame(height: 20)

                Button(action: startAction) {
                    Text("start")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .cornerRadius(8)
                }

                Spacer()
            }
        }
    }
}

