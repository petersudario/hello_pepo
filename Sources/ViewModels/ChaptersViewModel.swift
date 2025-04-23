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
            Chapter(title: "Blue", reference: "- Is that the right color?", modelName: "all_star", soundFileName: "", contents: [
                .text(text: "", audioFileName: "")
            ]),
            Chapter(
                title: "Black box",
                reference: "- Where everything started",
                modelName: "ps2",
                soundFileName: "ps2.mp3",
                contents: [
                    .text(text: "Eu era muito pequeno quando essa história começou. Mais ou menos em 2007 ou 2008.",
                          audioFileName: "audio1_1.m4a"),
                    .text(text: "Lembro de voltar de carro para casa junto do meu pai, eu tava bem cansado.",
                          audioFileName: "audio1_2.m4a"),
                    .text(text: "Era por volta das 16h ou 17h em algum dia no meio da semana, tipo uma quarta‑feira.",
                          audioFileName: "audio1_3.m4a"),
                    .text(text: "Entrei em casa....não tinha absolutamente nada para fazer",
                          audioFileName: "audio1_3_1.m4a"),
                    .text(text: "Eu fui para um cômodo diferente e quando voltei para a sala, vi meu pai olhando para uma Ferrari na televisão.",
                          audioFileName: "audio1_4.m4a"),
                    .text(text: "Nem sabia que era uma Ferrari, mas sabia que era um carro.",
                          audioFileName: "audio1_5.m4a"),
                    .text(text: "Mas o carro parecia diferente, parecia de massinha e um pouco poligonal.",
                          audioFileName: "audio1_6.m4a"),
                    .text(text: "Olhei para a estante, e vi o que parecia ser uma caixa preta com um LED aceso.",
                          audioFileName: "audio1_7.m4a"),
                    .text(text: "Até que meu pai finalmente explicou, depois de me ver muito confuso, que aquilo era um videogame.",
                          audioFileName: "audio1_8.m4a"),
                    .text(text: "Ele comprou o meu primeiro videogame. O PlayStation 2.",
                          audioFileName: "audio1_9.m4a"),
                    .text(text: "A partir desse momento, eu nunca mais larguei um videogame.",
                          audioFileName: "audio1_10.m4a"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Jill Sandwich", reference: "- Fearless", modelName: "resident_evil", soundFileName: "re4_spinel.mp3", contents: [
                .text(text: "Ainda em 2009, com o mesmo PlayStation. Minha irmã tinha acabado de comprar um jogo novo pro videogame.", audioFileName: "audio2_1.m4a"),
                .text(text: "O nome da franquia é Resident Evil", audioFileName: "audio2_2.m4a"),
                .text(text: "Eu era bem medroso com filmes e jogos de terror. Mas tinha uma sensação diferente sobre o jogo que ela tinha comprado.", audioFileName: "audio2_3.m4a"),
                .text(text: "Eu tinha medo, mas queria muito jogar.", audioFileName: "audio2_4.m4a"),
                .text(text: "Em vez disso eu fiquei vendo minha irmã jogar por um tempo, até ela me deixar jogar.", audioFileName: "audio2_5.m4a"),
                .text(text: "Passei horas e horas jogando, e se tornou o jogo mais memorável da minha vida.", audioFileName: "audio2_6.m4a"),
                .text(text: "É uma história curta, mas tem um valor especial pra mim.", audioFileName: "audio2_7.m4a"),
                .text(text: "Porque eu jogo a mesma coisa, durante 17 anos, pelo menos uma vez por ano.", audioFileName: "audio2_8.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Jackpot!", reference: "- Where the son cries and the mom doens't see", modelName: "dante", soundFileName: "jackpot!.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Polygons", reference: "- Going back in time", modelName: "spyro", soundFileName: "spyro.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Professional Screamer", reference: "- The champion", modelName: "forza_ferrari", soundFileName: "r25.mp3", contents: []),
            Chapter(title: "Shadows", reference: "- Even the biggest can fall", modelName: "lightsword_sotc", soundFileName: "agro!.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "The neighborhood friend", reference: "- The best hero", modelName: "spiderman", soundFileName: "you_are_a_mistake.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Look for the eye", reference: "- A programmer in ascension", modelName: "enderman", soundFileName: "enderman.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "I'm still alive!", reference: "- Being a pirate", modelName: "wheatley", soundFileName: "spaaaace.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Masquerade Fun", reference: "- Going back in time (again)", modelName: "link", soundFileName: "link.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Blasters and Swords", reference: "- Learn the force you should", modelName: "lightsaber", soundFileName: "lightsaber.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "God and void", reference: "- The dark is not always bad.", modelName: "hollow_knight", soundFileName: "hollow_knight_scream.mp3", contents: [
                .modelPreview

            ]),
            Chapter(title: "Dodging life", reference: "- Beating up the stress", modelName: "boxing_gloves", soundFileName: "", contents: [
                .modelPreview
            ]),

            Chapter(title: "Boredom, sparks & monsters", reference: "- What to do on a quarantine?", modelName: "meowmere", soundFileName: "meowmere.mp3", contents: [
                .modelPreview
            ]),
            Chapter(title: "Fire and resentment", reference: "- What if feels like to grow up" , modelName: "bonfire", soundFileName: "bonfire_lit.mp3", contents: [
                .modelPreview
            ]),
            Chapter(
                title: "Scars",
                reference: "- A tough time",
                modelName: "Berserk_Armor",
                soundFileName: "berserk_clang.mp3",
                contents: [
                    .text(text: "Texto da seção 2.1", audioFileName: "audio2_1.mp3"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Warmth", reference: "- When you feel like you again", modelName: "malenia", soundFileName: "malenia.mp3", contents: [
                .modelPreview
            ]),
            Chapter(title: "Sour & Energy", reference: "- A W-O-N-D-E-R-F-U-L drink.", modelName: "monster", soundFileName: "bloxcola_sound.mp3", contents: [
                .modelPreview
            ]),
            Chapter(title: "Out of the world", reference: "- You should hear more music", modelName: "virtuoso", soundFileName: "", contents: [
                .modelPreview
            ]),
            Chapter(title: "Friends", reference: "- The best gift ever", modelName: "akira", soundFileName: "akira.mp3", contents: [
                .modelPreview
            ]),
            Chapter(title: "Never give up", reference: "- Keep reaching the horizon", modelName: "macbook", soundFileName: "macbook.mp3", contents: [
                .modelPreview
            ]),

            Chapter(title: "Back to the start", reference: "- Being a child forever", modelName: "gamecube", soundFileName: "gamecube.mp3", contents: [
                .modelPreview
            ]),
            
        ]

        // Registrar default para título
        defaults.register(defaults: [kTitleKey: 0])
        titleUnlockedIndex = defaults.integer(forKey: kTitleKey)

        // Restaurar progresso de memória ou definir como -1
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

        nextChapter()
    }
}
