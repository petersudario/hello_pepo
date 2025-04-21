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
    @State private var showAR = false
    @State private var selection = 0

    private var sheetHeight: CGFloat { UIScreen.main.bounds.height * 0.4 }
    
    private let models: [ModelInfo] = [
        .init(fileName: "Berserk_Armor", displayName: "Guts", reference: "Berserk", description: "A legendary armor worn by the Skull Knight, and then passed to Guts through the series. Berserk is my favorite story, has my favorite characters and is my favorite manga on my bookshelf. Many people ask me why and thinks i'm a weirdo since it's a 18+ book. But the meaning of this book for me it's deeper than people think. The manga is not just about death, about crimes or blood. It's about betrayal, punishment, innocence and how life can beat you up and you still stand up. I read it when I was going through a rough time in life and it helped me alot and since then I always see life as a constant challenge that I can keep sharpening myself through. Guts (the protagonist) suffers a lot due to the plot of the story but still stands up to the challenges that comes infront of him. I have 20 volumes in my bookshelf (18 normal volumes, 2 special editions) and I intend to have every single volume in my bookshelf.", soundFileName: "berserk_clang.mp3"),
        .init(fileName: "hollow_knight", displayName: "Hollow Knight", reference:"the game Hollow Knight", description: "The protagonist and also yourself in the game Hollow Knight. This game has a special place in my heart. The soundtrack, the art style, the storytelling, the game mechanics it's just perfect. The story basically tells us that darkness is not always the bad guy, and the light is not always the good guy. But also, none of them are the bad or the good guy, but messed with each other. It's a masterpiece at it's pure meaning.", soundFileName: "hollow_knight_scream.mp3"),
        .init(fileName: "bonfire", displayName: "Bonfire", reference:"DARK SOULS III", description:"A place for those in need of resting. The bonfire (or campfire) is a symbol of peace, since it's a checkpoint in the Dark Souls series. This game it's what defines me as a person nowadays, just like Berserk. It's also about challenge and persistence, like Berserk. The game is also a direct reference to Berserk, since it has so many references and tributes to Kentaro Miura (the mangaka, or creator of Berserk). This game teached me alot about persistence, improvement and about selfishness. The trilogy (1, 2 and 3) is a true masterpiece, and I recommended it to everyone.  ", soundFileName: "bonfire_lit.mp3"),
        .init(fileName: "link", displayName: "Link", reference: "Zelda - Ocarina of Time", description: "Zelda is one of the games that I never had the chance to play, but this dream is reaching further results today! It's curious that this game is very important to me but I never played it. Maybe it brings me memories of when I was a kid and also because it's ambiance it's sooooo calm. Hope I can find it's original games for the Gamecube..", soundFileName: "link_sounds.mp3"),
        .init(fileName: "spiderman", displayName: "Spider-Man 2099", reference: "Marvel Comics", description: "Spider‑Man it's my favorite hero in any comic book. He does his things for the people, and only for the people. He's not rich, he's strong but limits himself agains't his enemies, he's intelligent and uses it for humanity. He's a true hero and a true friend, and I try to be like him whenever I can.", soundFileName: "you_are_a_mistake.mp3"),
        .init(fileName: "dante", displayName: "Dante", reference: "Devil May Cry", description: "Jackpot! \nI don't know how to explain this, lol. But I really like Devil May Cry due to the stylish moves this game has, and also because I loved Heck 'n' Slash when I was a kid. It's a living memory for me.", soundFileName: "jackpot!.mp3"),
        .init(fileName: "malenia", displayName: "Winged Helmet", reference: "ELDEN RING", description: "Oh my god. I don't have the words to describe this game. Think of it as masterpiece WAY GREATER than Dark Souls. A god's hand writing basically. It follows the same philosophy that Dark Souls teached me, but this time, it's just WOOOOOOW. It's my favorite game ever.", soundFileName: "malenia.mp3"),
        .init(fileName: "resident_evil", displayName: "Keys", reference: "Resident Evil 2", description: "Keys to open specific doors in Resident Evil 2 RPD. \nThe Biohazard/Resident Evil franchise it's stored in my heart forever. If I have a taste for horror stories and games, it's because of Capcom and it's masterpiece Resident Evil. Hope I can play the old games on the Gamecube also.", soundFileName: "re4_spinel.mp3"),
        .init(fileName: "akira", displayName: "Akira Vol.1", reference: "Manga book", description: "One of my favorites from the 80's. I started to read it recently and I also watched the movie. Unbelievable manual art work. Bought the volume one, and won other two volumes on my birthday (I simply love the people who gave me this as birthday gift).", soundFileName: "akira.mp3"),
        .init(fileName: "macbook", displayName: "Macbook", reference: "Apple Inc.", description: "I don't have words to describe how happy I am today. I never had the chance to touch a Macbook or even an iPhone. I used to watch Steve Jobs presentations a looooooot when I was a kid, and every new device was something from another world in my sight. Glady, the Apple Developer Academy made my dream come true. Thank you all again, and I hope we do amazing things on these 2 years and forward!", soundFileName: "macbook.mp3"),
        .init(fileName: "virtuoso", displayName: "Corsair Virtuoso", reference: "Headset", description: "This headset was the first eletronic I ever bought, with my first salary. I was going through a tough time and it helped me with concentration. It's a lovely headset and I have nothing to complain about.", soundFileName: "none"),
        .init(fileName: "monster", displayName: "Mango Loco", reference: "Monster Energy Drink", description: "My favorite unhealthy drink and I'm glad that more peole enjoy it :D", soundFileName: "bloxcola_sound.mp3"),
        .init(fileName: "forza_ferrari", displayName: "Formula 1", reference: "Ferrari", description: "My favorite cars forever. I watch Formula 1 since I was kid, and since Sebastian Vettel was a driver in Red Bull Racing (retired World Champion). I miss the V10 engines. I also completed my dream of hearing a real engine and seeing the real car during the Red Bull Showrun in Curitiba during 2025, and also wearing official clothes. Simply lovely! I'm not a Ferrari fan but I think they deserved to be in this 3D presentation.", soundFileName: "r25.mp3"),
        .init(fileName: "lightsaber", displayName: "Blue Lightsaber", reference: "Star Wars", description: "Use the force, Luke!\nMy favorite series since I was a kid. Loved playing Lego Star Wars and also watching the movies.", soundFileName: "lightsaber.mp3"),
        .init(fileName: "gamecube", displayName: "Gamecube 2001", reference: "Nintendo", description: "Just the most lovely videogame console ever. Had the chance to buy one for 120U$D, japanese language. Totally original. I'm never getting rid of it.", soundFileName: "gamecube.mp3"),
        .init(fileName: "ps2", displayName: "PlayStation 2", reference: "Sony", description: "My first videogame and the first time I saw a game ever. 2007, I was 3 years old. Thanks dad!", soundFileName: "ps2.mp3"),
        .init(fileName: "lightsword_sotc", displayName: "Ancient Sword", reference: "Shadow of the Colossus", description: "It's one of the very first last generation games I ever had a chance to play during PlayStation 2 era. I know ELDEN RING and Dark Souls are my favorites, but no story telling and game mechanics can beat this one.", soundFileName: "agro!.mp3"),
        .init(fileName: "meowmere", displayName: "Meowmere", reference: "Terraria", description: "The legendary cat sword from Terraria. I used to play this game alot during the pandemic, helped me with boredom. The only sandbox game I ever dare to say that it's better than Minecraft.", soundFileName: "meowmere.mp3"),
        .init(fileName: "enderman", displayName: "Enderman", reference: "Minecraft", description: "Since I mentioned Minecraft, would be be unfair if I didn't put something here.\nThe Enderman was just terrifying when I first played Minecraft. His sounds still gives me goosebumps. Minecraft is very important to me, because it 's where I started having contact with coding and the online world. Thank you Notch!", soundFileName: "enderman.mp3"),
        .init(fileName: "wheatley", displayName: "Wheatley", reference: "Portal 2", description: "I hate this little guy but he marked my childhood. Portal and Portal 2 were the very first games I ever played from Valve, and also the very first pirated games I had on a PC (I'm not proud of it, but I didn't have money back then). Golden age of my childhood.", soundFileName: "spaaaace.mp3"),
        .init(fileName: "spyro", displayName: "Spyro", reference: "Spyro The Dragon", description: "I HAD TO PLACE HIM HERE!\nSometime on my life, for some unknown reason, I had a PS1 and I didn't have my PS2 anymore. This is the first game I ever played on PS1, and maybe the most memorable for me. I'm still in shock that they made a Remake nowadays. Simply lovely...", soundFileName: "spyro.mp3"),
        .init(fileName: "boxing_gloves", displayName: "Boxing Gloves", reference: "Pepo", description: "I used to train boxing and Muay Thai before the pandemic and during the pandemic. I'm still trying to go back to the training habits, but life is demanding a lot from me. Still finding ways to put it in my routine.", soundFileName: ""),
        .init(fileName: "rubiks_cube", displayName: "Rubik's Cube", reference: "Ernő Rubik", description: "Yeah i'm a nerd, cry about it. But the Rubik's cube has a deeper meaning for me.\nImagine being capable of solving any problem from any starting point. That's literally what defines the essence of a developer in my point of view. I don't know to solve one YET, but they are very special for me nowadays." , soundFileName: ""),
        .init(fileName: "all_star", displayName: "All Star", reference: "Converse", description: "I wear these since childhood. Just can't give up on them. It's too stylish.", soundFileName: ""),
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack() {
                TabView(selection: $selection) {
                    ForEach(models.indices, id: \.self) { idx in
                        ZStack{
                            VStack {
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
                                
                                Button {
                                    showAR = true
                                } label: {
                                    HStack(spacing: 0) {
                                        Text("see in ")
                                        Text("AR").foregroundColor(.purple)
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
                                .sheet(isPresented: $showAR) {
                                    ARImageTrackingViewRepresentable(modelName: models[idx].fileName, modelSound: models[idx].soundFileName)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                Spacer()
                            }
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
                                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

        }
    }
}
