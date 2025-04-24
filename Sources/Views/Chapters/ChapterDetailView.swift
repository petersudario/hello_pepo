//
//  ChapterDetailView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI
import AVFoundation

struct ChapterDetailView: View {
    @ObservedObject var vm: ChaptersViewModel
    @State private var selectedSectionIndex = 0
    @State private var showCutscene = true
    @State private var audioPlayer: AVAudioPlayer?
    @EnvironmentObject private var audioManager: AudioManager

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Vaporwave {
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    if showCutscene {
                        Color.black.ignoresSafeArea()
                        Text(vm.chapters[vm.selectedChapterIndex].title)
                            .font(.custom("SF Pro", size: geo.size.width * 0.07))
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        let contents = vm.chapters[vm.selectedChapterIndex].contents
                        ZStack(alignment: .center) {
                            Rectangle().fill(Color.black)

                            TabView(selection: $selectedSectionIndex) {
                                ForEach(contents.indices, id: \.self) { idx in
                                    GeometryReader { pageGeo in
                                        let hPad = pageGeo.size.width * 0.05
                                        let textW = pageGeo.size.height - hPad * 2
                                        ZStack {
                                            Color.black.ignoresSafeArea()
                                            VStack(alignment: .leading, spacing: 8) {
                                                if case let .text(text, _) = contents[idx] {
                                                    Text("- Pepo")
                                                        .font(.custom("SF Pro", size: pageGeo.size.width * 0.06))
                                                        .fontWeight(.ultraLight)
                                                        .foregroundStyle(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [Color.white, Color.purple]),
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                    TypewriterText(fullText: text,
                                                                   isActive: selectedSectionIndex == idx)
                                                    .font(.custom("SF Pro", size: pageGeo.size.width * 0.045))
                                                    .multilineTextAlignment(.leading)
                                                    .lineSpacing(pageGeo.size.width * 0.012)
                                                    .frame(
                                                        maxWidth: textW,
                                                        maxHeight: .infinity,
                                                        alignment: .topLeading
                                                    )
                                                    .fixedSize(horizontal: false, vertical: true)
                                                }
                                                if case .modelPreview = contents[idx] {
                                                    ModelPreviewRepresentable(
                                                        modelName: vm.chapters[vm.selectedChapterIndex].modelName,
                                                        soundFileName: vm.chapters[vm.selectedChapterIndex].soundFileName
                                                    )
                                                    .frame(
                                                        width: pageGeo.size.height * 0.7,
                                                        height: pageGeo.size.height * 0.7
                                                    )
                                                    .cornerRadius(12)
                                                    HStack(spacing: 40) {
                                                        Button("Collect memory›") {
                                                            vm.collectMemory()
                                                            dismiss()
                                                        }
                                                    }
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.white, lineWidth: 2)
                                                    )
                                                }
                                                Spacer()
                                            }
                                            .padding(.horizontal, hPad)
                                            .offset(y: -pageGeo.size.height * 0.50)
                                        }
                                        .rotationEffect(.degrees(-90))
                                    }
                                    .tag(idx)
                                }
                            }
                            .frame(width: geo.size.height, height: geo.size.width)
                            .rotationEffect(.degrees(90), anchor: .topLeading)
                            .offset(x: geo.size.width)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .ignoresSafeArea()
                            VerticalProgressSlider(
                                total: contents.count,
                                current: selectedSectionIndex
                            )
                            .frame(width: 24, height: geo.size.height * 0.4)
                            .position(x: geo.size.width * 0.08, y: geo.size.height / 2)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeInOut) { showCutscene = false }
                        playCurrentSectionAudio()
                    }
                }
                .onChange(of: selectedSectionIndex) { _ in
                    playCurrentSectionAudio()
                }
                .overlay(alignment: .topLeading) {
                    if !showCutscene {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: geo.size.width * 0.06, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white, Color.purple]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .padding(.leading, geo.size.width * 0.125)
                        .padding(.top, geo.size.width * 0.3)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }

    private func playCurrentSectionAudio() {
        let contents = vm.chapters[vm.selectedChapterIndex].contents
        guard selectedSectionIndex < contents.count,
              case let .text(_, audioFileWithExt) = contents[selectedSectionIndex] else {
            return
        }
        let parts = audioFileWithExt.split(separator: ".", maxSplits: 1).map(String.init)
        let name = parts.first ?? audioFileWithExt
        let ext = parts.count > 1 ? parts[1] : "mp3"
        audioManager.playSFX(named: name, ofType: ext)
    }
}
