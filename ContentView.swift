import SwiftUI
import ARKit

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct ContentView: View {
    @State private var idx = 0
    @State private var showDetail = false
    private var sheetHeight: CGFloat { UIScreen.main.bounds.height * 0.4 }
    
    private let models: [ModelInfo] = [
        .init(fileName: "Berserk_Armor", displayName: "Guts", reference: "Berserk", description: "A legendary armor worn by the Skull Knight.", soundFileName: "berserk_clang.mp3"),
        .init(fileName: "hollow_knight", displayName: "Hollow Knight", reference:"Game", description: "The protagonist and yourself from the game", soundFileName: "hollow_knight_scream.mp3"),
        .init(fileName: "bonfire", displayName: "Bonfire", reference:"DARK SOULS IIII", description: "Where everyone rests and tells stories.", soundFileName: "bonfire_lit.mp3"),
        .init(fileName: "link", displayName: "Link", reference: "Zelda - Ocarina of Time", description: "", soundFileName: "link_sounds.mp3"),
        .init(fileName: "spiderman", displayName: "Spider-Man 2099", reference: "Comic", description: "Spider‑man from alternate reality and from future", soundFileName: "you_are_a_mistake.mp3"),
        .init(fileName: "dante", displayName: "Dante", reference: "Devil May Cry", description: "Jackpot!", soundFileName: "jackpot!.mp3"),
        .init(fileName: "malenia", displayName: "Winged Helmet", reference: "ELDEN RING", description: "I am Malenia, Blade of Miquella.", soundFileName: "malenia.mp3"),
        .init(fileName: "resident_evil", displayName: "Keys", reference: "Resident Evil 2", description: "Keys to open specific doors in Resident Evil 2 RPD", soundFileName: "re4_spinel.mp3"),
        .init(fileName: "akira", displayName: "Akira Vol.1", reference: "Manga book", description: "My favorite from the bookshelf", soundFileName: "akira.mp3"),
        .init(fileName: "macbook", displayName: "Macbook", reference: "Apple Inc.", description: "My nowadays comfort zone", soundFileName: "macbook.mp3"),
        .init(fileName: "virtuoso", displayName: "Corsair Virtuoso", reference: "Headset", description: "Where I forget about the world", soundFileName: "none"),
        .init(fileName: "monster", displayName: "Mango Loco", reference: "Monster Energy Drink", description: "My favorite unhealthy drink", soundFileName: "bloxcola_sound.mp3"),
        .init(fileName: "forza_ferrari", displayName: "Formula 1", reference: "Ferrari", description: "My favorite cars forever", soundFileName: "r25.mp3"),
        .init(fileName: "lightsaber", displayName: "Blue Lightsaber", reference: "Star Wars", description: "Use the force, Luke.", soundFileName: "lightsaber.mp3"),
        .init(fileName: "gamecube", displayName: "Gamecube 2001", reference: "Nintendo", description: "Just the most lovely videogame console ever", soundFileName: "gamecube.mp3"),
        .init(fileName: "lightsword_sotc", displayName: "Ancient Sword", reference: "Shadow of the Colossus", description: "The one who wields the guiding light", soundFileName: "agro!.mp3"),
        .init(fileName: "meowmere", displayName: "Meowmere", reference: "Terraria", description: "The legendary cat sword – Meow", soundFileName: "meowmere.mp3"),
        .init(fileName: "boxing_gloves", displayName: "Boxing Gloves", reference: "Pepo", description: "I love boxing", soundFileName: "")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Spacer()
                
                Text(models[idx].displayName.uppercased())
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("from \(models[idx].reference)")
                    .font(.title3).italic()
                    .foregroundColor(.purple)
                
                ModelPreviewRepresentable(
                    modelName: models[idx].fileName,
                    soundFileName: models[idx].soundFileName
                )
                .frame(width: 300, height: 300)
                .overlay(
                    HStack {
                        Button { idx = (idx - 1 + models.count) % models.count }
                        label: {
                            Image(systemName: "chevron.left")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button { idx = (idx + 1) % models.count }
                        label: {
                            Image(systemName: "chevron.right")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 40),
                    alignment: .center
                )
                
                Button {
                    withAnimation { showDetail = true }
                } label: {
                    HStack(spacing: 0) {
                        Text("see ")
                        Text("more").foregroundColor(.purple)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                
                Spacer()
                
                HStack {
                    Button { idx = (idx - 1 + models.count) % models.count }
                    label: { Image(systemName: "chevron.left").font(.largeTitle) }
                    
                    Spacer()
                    
                    Button { idx = (idx + 1) % models.count }
                    label: { Image(systemName: "chevron.right").font(.largeTitle) }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .hidden()
            }
            .padding(.horizontal, 20)
            
            if showDetail {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showDetail = false } }
                
                GeometryReader { geo in
                    let topGap = geo.size.height / 2
                    let sheetHeight = geo.size.height - topGap
                    
                    VStack {
                        Spacer()
                        VStack(spacing: 0) {
                            Capsule()
                                .frame(width: 40, height: 5)
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.top, 8)
                            
                            Text("\(models[idx].displayName) – \(models[idx].reference)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                            
                            ScrollView {
                                Text(models[idx].description)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: sheetHeight)
                        .background(Color(white: 0.1))
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: showDetail)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}
