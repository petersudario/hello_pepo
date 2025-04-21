//
//  SplashOverlay.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

public struct SplashOverlay: View {
    let startAction: () -> Void

    public var body: some View {
        ZStack {
            Color.black.opacity(0)

            VStack {

                Text("MEET")
                    .font(.system(size: 60, weight: .ultraLight))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(0.8)
                    .rotationEffect(.degrees(-10))


                Text("PEPO")
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


                Spacer().frame(height: 20)

                Button(action: startAction) {
                    Text("start")
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
                        .rotationEffect(.degrees(-10))

                }

            }
        }
    }
}
