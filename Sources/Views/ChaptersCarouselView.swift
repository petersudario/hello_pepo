//
//  ChaptersCarouselView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import SwiftUI

struct ChaptersCarouselView: View {
    @ObservedObject var vm: ChaptersViewModel

    var body: some View {
        TabView(selection: $vm.selectedChapterIndex) {
            ForEach(vm.chapters.indices, id: \.self) { idx in
                VStack {
                    Text(vm.chapters[idx].title)
                        .font(.largeTitle)
                    ModelPreviewRepresentable(
                        modelName: ModelInfo(fileName: "", displayName: "", reference: "", description: "", soundFileName: "").fileName,
                        soundFileName: ""
                    )
                }
                .tag(idx)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .toolbar { ToolbarItem(placement: .bottomBar) {
            NavigationLink("Open") { ChapterDetailView(vm: vm) }
        }}
    }
}

struct ChapterDetailView: View {
    @ObservedObject var vm: ChaptersViewModel

    var body: some View {
        TabView(selection: $vm.selectedSectionIndex) {
            ForEach(vm.chapters[vm.selectedChapterIndex].sections.indices, id: \.self) { idx in
                SectionView(section: vm.chapters[vm.selectedChapterIndex].sections[idx])
                    .tag(idx)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .rotationEffect(.degrees(-90))
        .frame(width: UIScreen.main.bounds.height,
               height: UIScreen.main.bounds.width)
        .rotationEffect(.degrees(90), anchor: .topLeading)
        .ignoresSafeArea()
    }
}
