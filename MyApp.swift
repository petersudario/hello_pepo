import SwiftUI
import SpriteKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .ignoresSafeArea()
        }
    }
}

struct RootView: View {
    @State private var showSplash = true
    @State private var scene = PhysicsScene(size: UIScreen.main.bounds.size)

    var body: some View {
        ZStack {
            ContentView()

            SpriteView(scene: scene, options: .allowsTransparency)
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .ignoresSafeArea()

            if showSplash {
                SplashOverlay(startAction: {
                    scene.startFalling()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                })
                .ignoresSafeArea()
            }
        }
        .onChange(of: showSplash) { newValue in
            if !newValue {
                scene.popAllSprites()
            }
        }
    }
}

