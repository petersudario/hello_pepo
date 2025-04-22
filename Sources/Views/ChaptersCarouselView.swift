//
//  ChaptersCarouselView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI
struct ChaptersCarouselView: View {
    @ObservedObject var vm: ChaptersViewModel
    @State private var showDetail = false
    @State private var showAR = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $vm.selectedChapterIndex) {
                ForEach(vm.chapters.indices, id: \.self) { idx in
                    let chapter = vm.chapters[idx]
                    VStack {
                        Spacer()
                        Text(chapter.title.uppercased())
                            .font(.system(size: 48, weight: .regular))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .padding(.bottom, 8)
                        
                        Text("\(chapter.reference)")
                            .font(.title3)
                            .italic()
                            .foregroundColor(.purple)
                            .padding(.bottom, 20)
                        ModelPreviewRepresentable(
                            modelName: chapter.modelName,
                            soundFileName: chapter.soundFileName
                        )
                        .frame(width: 300, height: 300)
                        .padding(.bottom, 20)
                        
                        Spacer()

                        Button {
                            showDetail = true
                        } label: {
                            HStack(spacing: 0) {
                                Text("Hear a ")
                                Text("story").foregroundColor(.purple)
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
                        .padding(.bottom, 10)

                        Button {
                            showAR = true
                        } label: {
                            HStack(spacing: 0) {
                                Text("View ")
                                Text("memory").foregroundColor(.purple)
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
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

            .fullScreenCover(isPresented: $showDetail) {
                ChapterDetailView(vm: vm).environmentObject(AudioManager.shared)
            }
        }
        .sheet(isPresented: $showAR) {
            let chapter = vm.chapters[vm.selectedChapterIndex]
            ARImageTrackingViewRepresentable(
                modelName: chapter.modelName,
                modelSound: chapter.soundFileName
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}
