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

                if !showSplash {
                    GeometryReader { geo in
                        let topInset = geo.safeAreaInsets.top + 36
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: handleBackToMenu) {
                                    Image(systemName: "house.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background(Color.black.opacity(0.45))
                                        .clipShape(Circle())
                                }
                                .accessibilityLabel("Voltar ao menu inicial")
                                .padding(.top, topInset)
                                .padding(.trailing, max(16, geo.safeAreaInsets.trailing))
                            }
                            Spacer()
                        }
                    }
                    .allowsHitTesting(true)
                }
            }
            .onChange(of: showSplash) { _, newValue in
                if !newValue {
                    scene.backgroundColor = .clear
                    scene.popAllSprites()
                }
            }
        }

    }

    private func handleBackToMenu() {
        vm.selectedChapterIndex = 0
        vm.selectedSectionIndex = 0
        scene.resetForMenu()
        started = false
        withAnimation {
            showSplash = true
        }
    }
}

