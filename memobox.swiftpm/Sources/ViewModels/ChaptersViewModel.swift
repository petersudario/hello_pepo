//
//  ChaptersViewModel.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import Combine
import Foundation

final class ChaptersViewModel: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var selectedChapterIndex = 0
    @Published var selectedSectionIndex = 0

    @Published var titleUnlockedIndex: Int
    @Published var memoryUnlockedIndex: Int

    private let defaults = UserDefaults.standard
    private let kTitleKey = "titleUnlockedIndex"
    private let kMemoryKey = "memoryUnlockedIndex"

    init() {
        chapters = [
            Chapter(title: "Blue", reference: "- Is that the right color?", modelName: "all_star", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "I was about two years old.", audioFileName: "audio0_1.m4a"),
                .text(text: "Whenever I walked through the mall with my dad, I'd look at every shop window.", audioFileName: "audio0_2.m4a"),
                .text(text: "But there was one window I'd always spend way too long at.", audioFileName: "audio0_3.m4a"),
                .text(text: "One day he let me go inside that store, and I walked out with my first shoes (until then I only wore sandals).", audioFileName: "audio0_4.m4a"),
                .text(text: "My feet were extremely small, so they looked more like a miniature version of the blue shoes.", audioFileName: "audio0_5.m4a"),
                .modelPreview
            ]),
            Chapter(
                title: "Black box",
                reference: "- Where everything started",
                modelName: "ps2",
                soundFileName: "ps2.mp3",
                contents: [
                    .text(text: "I was very young when this story began — around 2007 or 2008.",
                          audioFileName: "audio1_1.m4a"),
                    .text(text: "I remember driving home with my dad; I was really tired.",
                          audioFileName: "audio1_2.m4a"),
                    .text(text: "It was around 4 or 5 p.m. on some weekday, like a Wednesday.",
                          audioFileName: "audio1_3.m4a"),
                    .text(text: "I came inside… there was absolutely nothing to do.",
                          audioFileName: "audio1_3_1.m4a"),
                    .text(text: "I went into another room, and when I came back to the living room, I saw my dad watching a Ferrari on TV.",
                          audioFileName: "audio1_4.m4a"),
                    .text(text: "I didn't even know it was a Ferrari, but I knew it was a car.",
                          audioFileName: "audio1_5.m4a"),
                    .text(text: "But that car looked different — almost like clay and a little polygonal.",
                          audioFileName: "audio1_6.m4a"),
                    .text(text: "I looked at the shelf and saw what looked like a black box with an LED on.",
                          audioFileName: "audio1_7.m4a"),
                    .text(text: "Eventually my dad explained, after seeing how confused I was, that it was a video game console.",
                          audioFileName: "audio1_8.m4a"),
                    .text(text: "He bought my first console. The PlayStation 2.",
                          audioFileName: "audio1_9.m4a"),
                    .text(text: "From that moment on, I never really put games down.",
                          audioFileName: "audio1_10.m4a"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Jill Sandwich", reference: "- Fearless", modelName: "resident_evil", soundFileName: "re4_spinel.mp3", contents: [
                .text(text: "Still in 2009, with the same PlayStation. My sister had just bought a new game for the console.", audioFileName: "audio2_1.m4a"),
                .text(text: "The franchise is called Resident Evil.", audioFileName: "audio2_2.m4a"),
                .text(text: "I was pretty scared of horror movies and games. But this game she bought felt different.", audioFileName: "audio2_3.m4a"),
                .text(text: "I was afraid, but I really wanted to play.", audioFileName: "audio2_4.m4a"),
                .text(text: "Instead I watched my sister play for a while, until she let me take the controller.", audioFileName: "audio2_5.m4a"),
                .text(text: "I played for hours on end, and it became the most memorable game of my life.", audioFileName: "audio2_6.m4a"),
                .text(text: "And I realized I wasn't scared of games like that.", audioFileName: "audio2_7.m4a"),
                .text(text: "It's a short story, but it means a lot to me.", audioFileName: "audio2_8.m4a"),
                .text(text: "Because I've replayed it every year for 17 years, at least once.", audioFileName: "audio2_9.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Jackpot!", reference: "- Where the son cries and the mom doens't see", modelName: "dante", soundFileName: "jackpot!.mp3", contents: [
                .text(text: "It was 2009. I was already used to horror games and hack 'n' slash.", audioFileName: "audio3_1.m4a"),
                .text(text: "I found the game on the shelf — apparently my sister's.", audioFileName: "audio3_2.m4a"),
                .text(text: "It looked like horror; I didn't hesitate to boot it up on the PS2.", audioFileName: "audio3_3.m4a"),
                .text(text: "The graphics weren't clay-like or chunky anymore — they looked incredible!", audioFileName: "audio3_4.m4a"),
                .text(text: "I remember spending days stuck on the same boss.", audioFileName: "audio3_5.m4a"),
                .text(text: "Picture a spoiled kid who gets frustrated easily playing Devil May Cry.", audioFileName: "audio3_6.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Polygons", reference: "- Going back in time", modelName: "spyro", soundFileName: "spyro.mp3", contents: [
                .text(text: "This part is really curious.", audioFileName: "audio4_1.m4a"),
                .text(text: "At some point in my life, for some reason, I stopped having a PS2.", audioFileName: "audio4_2.m4a"),
                .text(text: "Nobody knows exactly why. Maybe because I lost a lot moving in with my mom.", audioFileName: "audio4_3.m4a"),
                .text(text: "Around 2010. I lived in a town where time felt frozen.", audioFileName: "audio4_4.m4a"),
                .text(text: "A town where a sliding-keyboard Samsung felt new while the iPhone 4 was already out.", audioFileName: "audio4_5.m4a"),
                .text(text: "But even going \"back in time,\" I had an amazing experience with the PlayStation 1.", audioFileName: "audio4_6.m4a"),
                .text(text: "It was the first older console I owned, with extremely polygonal graphics.", audioFileName: "audio4_7.m4a"),
                .text(text: "And I had it with one of the most memorable polygonal games of that generation.", audioFileName: "audio4_8.m4a"),
                .text(text: "Spyro.", audioFileName: "audio4_9.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Bombs", reference: "- and a lot of walls", modelName: "Bomberman", soundFileName: "bomberman.mp3", contents: [
                .text(text: "I really, really wanted to talk about Bomberman.", audioFileName: "audio11_1.m4a"),
                .text(text: "It was the first Nintendo-first-party-style game I ever played.", audioFileName: "audio11_2.m4a"),
                .text(text: "But on a chipped PS1!", audioFileName: "audio11_3.m4a"),
                .text(text: "I'd spend entire mid-year vacations playing Bomberman on SNES.", audioFileName: "audio11_4.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Professional Screamer", reference: "- The champion", modelName: "forza_ferrari", soundFileName: "r25.mp3", contents: [
                .text(text: "That's where my love for cars started — especially Formula 1. 2009 through 2012.", audioFileName: "audio5_1.m4a"),
                .text(text: "I had an uncle I didn't really like at first when I was a kid.", audioFileName: "audio5_2.m4a"),
                .text(text: "He only talked about the news, soccer, and trucks.", audioFileName: "audio5_3.m4a"),
                .text(text: "I never liked listening to his topics, and he could be kind of grumpy.", audioFileName: "audio5_4.m4a"),
                .text(text: "But one day in particular was different.", audioFileName: "audio5_5.m4a"),
                .text(text: "One day I saw him really happy, laughing at the TV, watching a Formula 1 car.", audioFileName: "audio5_6.m4a"),
                .text(text: "He was laughing at Galvão Bueno's commentary about Sebastian Vettel, four-time Formula 1 champion.", audioFileName: "audio5_7.m4a"),
                .text(text: "A few weeks later I decided to watch with him and figure out what Formula 1 even was.", audioFileName: "audio5_8.m4a"),
                .text(text: "Since then I haven't stopped watching or rooting for Red Bull and McLaren.", audioFileName: "audio5_9.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Shadows", reference: "- Even the biggest can fall", modelName: "lightsword_sotc", soundFileName: "agro!.mp3", contents: [

                .text(text: "This game is a special memory for me. I had a PS2 again.", audioFileName: "audio6_1.m4a"),
                .text(text: "Every game I'd played as a kid, I could replay as an adult.", audioFileName: "audio6_2.mp4"),
                .text(text: "Except this one.", audioFileName: "audio6_3.m4a"),
                .text(text: "Shadow of the Colossus felt like a game that spoke to me.", audioFileName: "audio6_4.m4a"),
                .text(text: "It was the first time I stood for hours in front of a CRT…", audioFileName: "audio6_5.m4a"),
                .text(text: "Listening to the music and sound effects…", audioFileName: "audio6_6.m4a"),
                .text(text: "Exploring an open world — empty but immensely beautiful.", audioFileName: "audio6_7.m4a"),
                .text(text: "It was also the first open-world game I ever played, around 2012.", audioFileName: "audio6_8.m4a"),
                .text(text: "I played it through once, and never owned the console or the game again.", audioFileName: "audio6_9.m4a"),
                .text(text: "It was a once-in-a-lifetime experience.", audioFileName: "audio6_10.m4a"),
                .modelPreview
            ]),
            Chapter(title: "The neighborhood friend", reference: "- The best hero", modelName: "spiderman", soundFileName: "you_are_a_mistake.mp3", contents: [

                .text(text: "All through childhood I was obsessed with Spider-Man.", audioFileName: "audio7_3.m4a"),
                .text(text: "I had every game and every movie CD burned at home.", audioFileName: "audio7_4.m4a"),
                .text(text: "I loved the cartoons, the comics — everything about him.", audioFileName: "audio7_5.m4a"),
                .text(text: "The PS2 was plastered with Spider-Man on the sunset filter.", audioFileName: "audio7_6.m4a"),
                .text(text: "These days I still watch the new Tom Holland films and Sony's animations.", audioFileName: "audio7_7.m4a"),
                .text(text: "For me, being Spider-Man isn't about being a hero…", audioFileName: "audio7_8.m4a"),
                .text(text: "It's about being there for people and being honest. I try to live like that.", audioFileName: "audio7_9.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Look for the eye", reference: "- A programmer in ascension", modelName: "enderman", soundFileName: "enderman.mp3", contents: [
                .text(text: "In 2013 I discovered a game whose legacy lasts to this day.", audioFileName: "audio8_1.m4a"),
                .text(text: "Time passed. 2015. I retired the PlayStation 2 and got tired of the Xbox 360.", audioFileName: "audio8_2.m4a"),
                .text(text: "I finally started stepping into the digital world.", audioFileName: "audio8_3.m4a"),
                .text(text: "I joined a Minecraft server for the first time.", audioFileName: "audio8_4.m4a"),
                .text(text: "The server was called MzCraft.", audioFileName: "audio8_5.m4a"),
                .text(text: "Until then I'd only known vanilla Minecraft worlds.", audioFileName: "audio8_6.m4a"),
                .text(text: "When I made that discovery in 2015, I got really into running servers.", audioFileName: "audio8_7.m4a"),
                .text(text: "I'd spend night after night on Skype with friends during breaks, building servers.", audioFileName: "audio8_8.m4a"),
                .text(text: "Java here, Spigot there, Craftbukkit somewhere…", audioFileName: "audio8_9.m4a"),
                .text(text: "I'd started tinkering with programming without knowing it was programming! Thanks, Notch!", audioFileName: "audio8_10.m4a"),
                .modelPreview

            ]),
            Chapter(title: "I'm still alive!", reference: "- Being a pirate", modelName: "wheatley", soundFileName: "spaaaace.mp3", contents: [
                .text(text: "It was 2016. My mom and I didn't have money.", audioFileName: "audio9_1.m4a"),
                .text(text: "I really wanted the games everyone else was playing that generation.", audioFileName: "audio9_2.m4a"),
                .text(text: "That's when I wandered into a messy corner of tech: piracy.", audioFileName: "audio9_3.m4a"),
                .text(text: "Alongside finding ways to have fun on the PC…", audioFileName: "audio9_4.m4a"),
                .text(text: "I learned that security and privacy online are the greatest privilege we can have.", audioFileName: "audio9_5.m4a"),
                .text(text: "I managed to pirate my first game in a fairly safe and reasonably ethical way.", audioFileName: "audio9_6.m4a"),
                .text(text: "Portal 2 was one of the peaks of puzzle design.", audioFileName: "audio9_7.m4a"),
                .text(text: "…Oh, and I hate that evil metal ball!", audioFileName: "audio9_8.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Masquerade Fun", reference: "- Going back in time (again)", modelName: "link", soundFileName: "link.mp3", contents: [
                .text(text: "Still in 2016. I caught a new obsession with my middle-school friends: Nintendo.", audioFileName: "audio10_1.m4a"),
                .text(text: "I hadn't had much exposure to Nintendo consoles growing up.", audioFileName: "audio10_2.m4a"),
                .text(text: "Game Boys, 3DS, and GameCube were still novelties to me.", audioFileName: "audio10_3.m4a    "),
                .text(text: "Back then I only knew Mario and Donkey Kong — I had no idea what Nintendo really was.", audioFileName: "audio10_5.m4a"),
                .text(text: "My friends showed me phone emulators where I could play some games.", audioFileName: "audio10_4.m4a"),
                .text(text: "I played the Zelda franchise for the first time — Majora's Mask!", audioFileName: "audio10_5.m4a"),
                .text(text: "I felt wrapped up in the game's atmosphere — calm and natural.", audioFileName: "audio10_6.m4a"),
                .text(text: "I felt like a kid again.", audioFileName: "audio10_7.m4a"),

                .modelPreview

            ]),
            Chapter(title: "Blasters and Swords", reference: "- Learn the force you should", modelName: "lightsaber", soundFileName: "lightsaber.mp3", contents: [
                .text(text: "I always. ALWAYS. Wanted to be a Jedi!", audioFileName: "audio12_1.m4a"),
                .text(text: "Too bad I can't lift rocks with my mind or wield a laser sword…", audioFileName: "audio12_2.m4a"),

                .modelPreview

            ]),
            Chapter(title: "God and void", reference: "- The dark is not always bad.", modelName: "hollow_knight", soundFileName: "hollow_knight_scream.mp3", contents: [
                .text(text: "2020. I was nearing adulthood; I wasn't obsessed with games anymore — more with film, stories, books, and lore.", audioFileName: "audio13_1.m4a"),
                .text(text: "From here on, the stories and events I lived through shaped who I am.", audioFileName: "audio13_2.m4a"),
                .text(text: "A middle-school friend recommended a game — simple platforming and combat.", audioFileName: "audio13_4.m4a"),
                .text(text: "He told me to just play and not ask for spoilers.", audioFileName: "audio13_5.m4a"),
                .text(text: "I was extremely picky — I'd only try things if I knew upfront they'd be good.", audioFileName: "audio13_6.m4a"),
                .text(text: "And that attitude became my biggest regret.", audioFileName: "audio13_6.m4a"),
                .text(text: "Hollow Knight was one of those games that kept me staring at the monitor for hours — real hours.", audioFileName: "audio13_7.m4a"),
                .text(text: "Without realizing I'd played one of the greatest Kickstarter-backed games of the era.", audioFileName: "audio13_8.m4a"),
                .text(text: "The story taught me darkness isn't always bad…", audioFileName: "audio13_9.m4a"),
                .text(text: "…light isn't always good…", audioFileName: "audio13_10.m4a"),
                .text(text: "…and stories don't always have clear rights and wrongs.", audioFileName: "audio13_11.m4a"),
                .text(text: "But there are consequences for what you do — and what others do.", audioFileName: "audio13_12.m4a"),
                .text(text: "It's the only game that made me tear up when I finished it.", audioFileName: "audio13_13.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Dodging life", reference: "- Beating up the stress", modelName: "boxing_gloves", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "The pandemic.", audioFileName: "audio14_1.m4a"),
                .text(text: "Stress at home, insecurity, worries about the future.", audioFileName: "audio14_2.m4a"),
                .text(text: "I needed an outlet that wasn't just things to do inside the house.", audioFileName: "audio14_3.m4a"),
                .text(text: "I was really interested in martial arts…", audioFileName: "audio14_4.m4a"),
                .text(text: "I loved watching Muhammad Ali's speeches in old clips…", audioFileName: "audio14_5.m4a"),
                .text(text: "and I obviously loved Street Fighter.", audioFileName: "audio14_6.m4a"),
                .text(text: "I bought gloves and started training Muay Thai and boxing.", audioFileName: "audio14_7.m4a"),
                .text(text: "I still plan to get back to training.", audioFileName: "audio_14_8.m4a"),
                .modelPreview
            ]),

            Chapter(title: "Boredom, sparks & monsters", reference: "- What to do on a quarantine?", modelName: "meowmere", soundFileName: "meowmere.mp3", contents: [
                .text(text: "When it was time to unwind, I wanted something different to do during the pandemic.", audioFileName: "audio15_1.m4a"),
                .text(text: "How much could I beat boredom stuck at home?", audioFileName: "audio15_2.m4a"),
                .text(text: "I found an amazing game I still play — Terraria.", audioFileName: "audio15_3.m4a"),
                .text(text: "I was drawn to all its quirks, like a sword shaped like a cat.", audioFileName: "audio15_4.m4a"),
                .text(text: "It was glittery horror — bright things with sparkle and monsters.", audioFileName: "audio15_5.m4a"),
                .text(text: "Those were the perfect 587 hours of 2021.", audioFileName: "audio15_6.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Fire and resentment", reference: "- What if feels like to grow up" , modelName: "bonfire", soundFileName: "bonfire_lit.mp3", contents: [
                .text(text: "End of the pandemic in 2022. I hadn't seen many different faces since 2020.", audioFileName: "audio16_1.m4a"),
                .text(text: "I was almost 18.", audioFileName: "audio16_2.m4a"),
                .text(text: "Early in 2022 I went through rough experiences and didn't know how to cope.", audioFileName: "audio16_3.m4a"),
                .text(text: "It wasn't so simple to fix things with people anymore — let alone talk.", audioFileName: "audio16_4.m4a"),
                .text(text: "I was someone who gave up easily when life got complicated.", audioFileName: "audio16_6.m4a"),
                .text(text: "Around then I found a franchise I'd heard people mention a thousand times.", audioFileName: "audio16_5.m4a"),
                .text(text: "Dark Souls this, Dark Souls whatever…", audioFileName: "audio16_6.m4a"),
                .text(text: "I don't know why I decided to play that series — it had nothing to do with what I was going through.", audioFileName: "audio16_7.m4a"),
                .text(text: "Until I understood that it did.", audioFileName: "audio16_8.m4a."),
                .text(text: "Dark Souls was a game about a decaying world — hot and freezing at once.",
                    audioFileName: "audio16_9.m4a"),
                .text(text: "With cold people, cold creatures — hostile and cruel through and through.", audioFileName: "audio16_10.m4a"),
                .text(text: "And I was mature enough by then to understand that…", audioFileName: "audio16_11.m4a"),
                .text(text: "the world is cruel, and you have to keep going.", audioFileName: "audio16_12.m4a"),
                .text(text: "But the world can also be comforting — and you still have to keep going.", audioFileName: "audio16_13.m4a"),
                .text(text: "Keep moving, try again, rest at a bonfire…", audioFileName: "audio16_13.m4a"),
                .text(text: "Dark Souls wasn't just some tiny hard game for me…", audioFileName: "audio16_14.m4a"),
                .text(text: "It was a life lesson.", audioFileName: "audio16_15.m4a"),

                .modelPreview
            ]),
            Chapter(
                title: "Fire and scars",
                reference: "- A tough time",
                modelName: "Berserk_Armor",
                soundFileName: "berserk_clang.mp3",
                contents: [
                    .text(text: "Fire and resentment, part 2.", audioFileName: ".m4a"),
                    .text(text: "Around then I learned what inspired the Dark Souls franchise.", audioFileName: "audio17_1.m4a"),
                    .text(text: "It was an extremely weird manga for adults 18+.", audioFileName: "audio17_2.m4a"),
                    .text(text: "I won't go into detail, but it was as cruel as the games.", audioFileName: "audio17_3.m4a"),
                    .text(text: "The hero was a swordsman with a sword over 100 kg, covered in scars…", audioFileName: "audio17_4.m4a"),
                    .text(text: "…that burned like fire.", audioFileName: "audio17_4_1.m4a"),
                    .text(text: "He wore cursed armor with a red visor.", audioFileName: "audio17_5.m4a"),
                    .text(text: "I dove deeper — read the manga, the franchise details…", audioFileName: "audio17_6.m4a"),
                    .text(text: "and a lot of it clicked for me (except the weird parts of the story).", audioFileName: "audio17_7.m4a"),
                    .text(text: "The hero had an unshakable mind — but he wasn't always like that.", audioFileName: "audio17_8.m4a"),
                    .text(text: "He lost people, peace, good moments…", audioFileName: "audio17_9.m4a"),
                    .text(text: "Yet he kept fighting for his own life…", audioFileName: "audio17_10.m4a"),
                    .text(text: "and for others who were grateful to him.", audioFileName: "audio17_11.m4a"),
                    .text(text: "The biggest lesson I've ever learned — and this manga and game really helped…", audioFileName: "audio17_11.m4a"),
                    .text(text: "was that persistence, focus, obsession with becoming your best self…", audioFileName: "audio17_12.m4a"),
                    .text(text: "turns you into something extraordinary.", audioFileName: "audio17_13.m4a"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Warmth", reference: "- When you feel like you again", modelName: "malenia", soundFileName: "malenia.mp3", contents: [
                .text(text: "Coming from Dark Souls and Berserk too: Elden Ring.", audioFileName: "audio18_1.m4a"),
                .text(text: "I really wanted to honor the greatest work of art I've ever played.", audioFileName: "audio18_2.m4a"),
                .text(text: "For me it was the peak of Hidetaka Miyazaki's storytelling and the clearest example of the philosophy I follow!", audioFileName: "audio18_3.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Sour & Energy", reference: "- A W-O-N-D-E-R-F-U-L drink.", modelName: "monster", soundFileName: "bloxcola_sound.mp3", contents: [
                .text(text: "THE PERFECT UNHEALTHY DRINK!", audioFileName: "audio19_1.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Out of the world", reference: "- You should hear more music", modelName: "virtuoso", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "My hyperfocus method: music.", audioFileName: "audio20_1.m4a"),
                .text(text: "I simply forget I exist in the world and can build unimaginable things while listening.", audioFileName: "audio20_2.m4a"),
                .text(text: "I bought these headphones with my first paycheck as an intern.", audioFileName: "audio20_3.m4a"),
                .text(text: "They saved me years of stress and daydreaming.", audioFileName: "audio20_4.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Friends", reference: "- The best gift ever", modelName: "akira", soundFileName: "akira.mp3", contents: [
                .text(text: "On my 20th birthday in 2024, I got a manga collection.", audioFileName: "audio21_1.m4a"),
                .text(text: "All my friends organized and gave it to me together.", audioFileName: "audio21_2.m4a"),
                .text(text: "It was the best gift I've ever received.", audioFileName: "audio21_3.m4a"),
                .text(text: "No, no — I'm not talking about the manga; I'm talking about my friends!", audioFileName: "audio21_4.m4a"),
                .text(text: "They're the real gift!", audioFileName: "audio21_5.m4a"),

                .modelPreview
            ]),
            Chapter(title: "Colors and Logic", reference: "- 1 billion problems, 1 pattern.", modelName: "rubiks_cube", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "In 2024 I joined a company — my first developer role at 21.", audioFileName: "audio22_1.m4a"),
                .text(text: "As soon as I walked in, I noticed everyone had a Rubik's Cube.", audioFileName: "audio22_2.m4a"),
                .text(text: "There were cube posters and cube stands!", audioFileName: "audio22_3.m4a"),
                .text(text: "Then I realized the cube wasn't just a toy.", audioFileName: "audio22_4.m4a"),
                .text(text: "Think about it: a block with over a million configurations…", audioFileName: "audio22_5.m4a"),
                .text(text: "that you can solve in seconds if you know what you're doing.", audioFileName: "audio22_6.m4a"),
                .text(text: "It's developer energy in physical form!", audioFileName: "audio22_7.m4a")
            ]),
            Chapter(title: "Never give up", reference: "- Keep reaching the horizon", modelName: "macbook", soundFileName: "macbook.mp3", contents: [
                .text(text: "Like I said before — I learned a lot.", audioFileName: "audio23_1.m4a"),
                .text(text: "The best thing I learned is never give up.", audioFileName: "audio23_2.m4a"),
                .text(text: "I thought I'd never touch a MacBook or an iPhone.", audioFileName: "audio23_3.m4a"),
                .text(text: "In 2025 that changed — because I didn't give up.", audioFileName: "audio23_4.m4a"),
                .modelPreview
            ]),

            Chapter(title: "Back to the start", reference: "", modelName: "gamecube", soundFileName: "gamecube.mp3", contents: [
                .text(text: "Just like at the beginning, the story starts again with a console.", audioFileName: "audio24_1.m4a"),
                .text(text: "Seventeen years ago, a console shaped who I am today.", audioFileName: "audio24_2.m4a"),
                .text(text: "I just bought a GameCube — original, Japanese, no games, not modded.", audioFileName: "audio24_3.m4a"),
                .text(text: "Will the story keep getting better?", audioFileName: "audio24_4.m4a"),
                .modelPreview
            ]),

        ]

        defaults.register(defaults: [kTitleKey: 0])
        titleUnlockedIndex = defaults.integer(forKey: kTitleKey)

        if defaults.object(forKey: kMemoryKey) != nil {
            memoryUnlockedIndex = defaults.integer(forKey: kMemoryKey)
        } else {
            memoryUnlockedIndex = -1
        }
    }

    func nextSection() {
        let total = chapters[selectedChapterIndex].contents.count
        if selectedSectionIndex + 1 < total {
            selectedSectionIndex += 1
        }
    }

    func nextChapter() {
        if selectedChapterIndex + 1 < chapters.count {
            selectedChapterIndex += 1
            selectedSectionIndex = 0
        }
    }

    func collectMemory() {
        memoryUnlockedIndex = max(memoryUnlockedIndex, selectedChapterIndex)
        defaults.set(memoryUnlockedIndex, forKey: kMemoryKey)

        let next = selectedChapterIndex + 1
        if next < chapters.count {
            titleUnlockedIndex = max(titleUnlockedIndex, next)
            defaults.set(titleUnlockedIndex, forKey: kTitleKey)
        }

    }
}
