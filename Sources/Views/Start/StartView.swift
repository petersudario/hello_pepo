//
//  StartView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI
import SpriteKit

struct StartView: View {
    @State private var showSplash = true
    @State private var scene = PhysicsScene(size: UIScreen.main.bounds.size)
    @State private var started = false
    @State private var vm = ChaptersViewModel()

    var body: some View {
        Vaporwave {
            ZStack {
                Rectangle().fill(Color.black)
                
                
                ChaptersCarouselView(vm: vm)
                
                if showSplash {
                    Rectangle().fill(Color.black)
                }
                
                SpriteView(
                    scene: scene,
                    options: [.allowsTransparency]
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
                
                if showSplash {
                    SplashOverlay(startAction: {
                        guard !started else { return }
                        started = true
                        scene.startFalling()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation { showSplash = false }
                        }
                    })
                    .ignoresSafeArea()
                }
            }
            .onChange(of: showSplash) { newValue in
                if !newValue {
                    scene.backgroundColor = .clear
                    scene.popAllSprites()
                }
            }
        }

    }
}

