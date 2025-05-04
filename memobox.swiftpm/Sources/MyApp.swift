import SwiftUI
import AVFoundation

@main
struct MyApp: App {
    @StateObject private var audioManager = AudioManager.shared

    
    var body: some Scene {
        WindowGroup {
            StartView()
                .ignoresSafeArea()
                .environmentObject(audioManager)
        }
    }
}



@MainActor
final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    @Published var musicVolume: Float = 0.5 {
        didSet { musicPlayer?.volume = musicVolume }
    }
    @Published var sfxVolume: Float = 1.0 {
        didSet { sfxPlayer?.volume = sfxVolume }
    }
    
    private init() {
        if let url = Bundle.main.url(forResource: "home_resonance", withExtension: "mp3") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.volume = musicVolume
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
            } catch { print("Erro BGM:", error) }
        }
    }
    
    func playSFX(named name: String, ofType ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("SFX não encontrado:", name)
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = sfxVolume
            player.prepareToPlay()
            player.play()
            sfxPlayer = player
        } catch {
            print("Erro SFX:", error)
        }
    }
}




