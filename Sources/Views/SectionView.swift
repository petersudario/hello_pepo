//
//  SectionView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import SwiftUI

struct SectionView: View {
    let section: Section
    @StateObject private var audio = AudioPlayerViewModel()

    var body: some View {
        ScrollView {
            Text(section.text)
                .padding()
                .onAppear { audio.play(section.audioFileName) }
            AudioButton { audio.play(section.audioFileName) }
        }
    }
}