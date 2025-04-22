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
            Chapter(
                title: "Armor",
                reference: "Berserk",
                modelName: "Berserk_Armor",
                soundFileName: "berserk_clang.mp3",
                contents: [
                    .text(text: "Texto da seção 2.1", audioFileName: "audio2_1.mp3"),
                    .modelPreview
                ]
            )
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
