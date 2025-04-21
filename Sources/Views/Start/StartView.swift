//
//  StartView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import SwiftUI

struct StartView: View {
    @StateObject var vm = ChaptersViewModel()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashOverlay(startAction: { showSplash = false })
            } else {
                NavigationStack {
                    VStack(spacing: 20) {
                        NavigationLink("Start") {
                            ChaptersCarouselView(vm: vm)
                        }
                        NavigationLink("Free Mode") {
                            ARInteractionView(modelName: vm.chapters[vm.selectedChapterIndex].title,
                                              soundFileName: "")
                        }
                    }
                    .navigationTitle("Meet Pepo")
                }
            }
        }
    }
}