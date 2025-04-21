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
    @State private var started = false

    var body: some View {
        ZStack {
            Rectangle().fill(Color.black)

            ContentView()

            
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
                    if started == false {
                        scene.startFalling()
                        started = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation { showSplash = false }
                        }
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


