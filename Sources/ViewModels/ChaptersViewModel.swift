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

    init() {
        chapters = [
            Chapter(title: "Capítulo 1", sections: [
                Section(text: "Texto 1.1", audioFileName: "audio1_1.mp3"),
                Section(text: "Texto 1.2", audioFileName: "audio1_2.mp3")
            ]),
            Chapter(title: "Capítulo 2", sections: [
                Section(text: "Texto 2.1", audioFileName: "audio2_1.mp3")
            ])
        ]
    }

    func nextSection() {
        let sec = chapters[selectedChapterIndex].sections
        if selectedSectionIndex + 1 < sec.count {
            selectedSectionIndex += 1
        }
    }

    func nextChapter() {
        if selectedChapterIndex + 1 < chapters.count {
            selectedChapterIndex += 1
            selectedSectionIndex = 0
        }
    }
}
