//
//  ChapterDetailView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

struct ChapterDetailView: View {
    @ObservedObject var vm: ChaptersViewModel
    @State private var selectedSectionIndex = 0
    @State private var showCutscene = true
    @State private var showCollectMemory = false

    @EnvironmentObject private var audioManager: AudioManager
    @Environment(\.dismiss) private var dismiss

    private static let sliderTrackWidth: CGFloat = 24
    private static let sliderStorySpacing: CGFloat = 16
    private static let cutsceneTitleFontRange: ClosedRange<CGFloat> = 28 ... 64

    var body: some View {
        Vaporwave {
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    if showCutscene {
                        cutsceneLayer(geo: geo)
                    } else {
                        storyLayer(geo: geo)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeInOut) {
                            showCutscene = false
                        }
                        playCurrentSectionAudio()
                    }
                }
                .onChange(of: selectedSectionIndex) { _, _ in
                    playCurrentSectionAudio()
                }
                .overlay(alignment: .topLeading) {
                    if !showCutscene {
                        backButton(geo: geo)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(
            isPresented: $showCollectMemory,
            onDismiss: { dismiss() }
        ) {
            CollectMemoryView(vm: vm)
        }
    }

    private func cutsceneLayer(geo: GeometryProxy) -> some View {
        let titleScale = min(geo.size.width, geo.size.height)
        let rawTitleSize = titleScale * 0.07
        let titleFontSize = min(
            max(rawTitleSize, Self.cutsceneTitleFontRange.lowerBound),
            Self.cutsceneTitleFontRange.upperBound
        )
        return ZStack {
            Color.black.ignoresSafeArea()
            Text(vm.chapters[vm.selectedChapterIndex].title)
                .font(.custom("SF Pro", size: titleFontSize))
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
                .padding(.horizontal, 24)
        }
    }

    /// Single layout for iPhone and iPad: slider + `TabView` in reading coordinates (no rotation).
    /// The previous compact-only rotate/offset stack caused clipping on modern iPhones.
    private func storyLayer(geo: GeometryProxy) -> some View {
        let contents = vm.chapters[vm.selectedChapterIndex].contents
        let safe = geo.safeAreaInsets
        let topBarReserve: CGFloat = 52
        let availableHeight = max(
            geo.size.height - safe.top - safe.bottom - topBarReserve,
            120
        )
        let sliderHeight = min(availableHeight * 0.52, 520)

        return ZStack(alignment: .center) {
            Rectangle().fill(Color.black)

            HStack(alignment: .center, spacing: Self.sliderStorySpacing) {
                VerticalProgressSlider(
                    total: contents.count,
                    current: selectedSectionIndex
                )
                .frame(width: Self.sliderTrackWidth, height: sliderHeight)
                .padding(.leading, max(safe.leading, 8))

                storyTabView(contents: contents)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.trailing, safe.trailing + 12)
            .padding(.top, safe.top + topBarReserve)
            .padding(.bottom, max(safe.bottom, 12) + 8)
        }
    }

    private func storyTabView(contents: [ChapterContent]) -> some View {
        TabView(selection: $selectedSectionIndex) {
            ForEach(contents.indices, id: \.self) { idx in
                storySectionPage(index: idx, contents: contents)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func storySectionPage(
        index idx: Int,
        contents: [ChapterContent]
    ) -> some View {
        GeometryReader { pageGeo in
            let safePage = pageGeo.safeAreaInsets
            let shortSide = min(pageGeo.size.width, pageGeo.size.height)
            let contentWidth = pageGeo.size.width - safePage.leading - safePage.trailing
            let metrics = Self.storyTypographyMetrics(
                shortSide: shortSide,
                contentWidth: max(contentWidth, 1)
            )

            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        VStack(alignment: .leading, spacing: 8) {
                            if case .text(let text, _) = contents[idx] {
                                Text("- Pepo")
                                    .font(.custom("SF Pro", size: metrics.labelSize))
                                    .fontWeight(.ultraLight)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white, Color.purple]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )

                                TypewriterText(
                                    fullText: text,
                                    isActive: selectedSectionIndex == idx
                                )
                                .font(.custom("SF Pro", size: metrics.bodySize))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(metrics.lineSpacing)
                                .frame(maxWidth: metrics.textColumn, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                            }

                            if case .modelPreview = contents[idx] {
                                let previewSide = min(shortSide * 0.72, metrics.textColumn)
                                ModelPreviewRepresentable(
                                    modelName: vm.chapters[vm.selectedChapterIndex].modelName,
                                    soundFileName: vm.chapters[vm.selectedChapterIndex].soundFileName
                                )
                                .frame(width: previewSide, height: previewSide)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity)

                                Button("Collect memory›") {
                                    vm.collectMemory()
                                    showCollectMemory = true
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            }
                        }
                        .frame(maxWidth: metrics.textColumn)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, metrics.horizontalPadding)
                        .padding(.vertical, 24)
                        Spacer(minLength: 0)
                    }
                    .frame(minHeight: pageGeo.size.height)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    /// Keeps story text readable on small phones and large iPads without unbounded scaling.
    private static func storyTypographyMetrics(shortSide: CGFloat, contentWidth: CGFloat) -> (
        labelSize: CGFloat,
        bodySize: CGFloat,
        lineSpacing: CGFloat,
        textColumn: CGFloat,
        horizontalPadding: CGFloat
    ) {
        let horizontalPadding = min(max(shortSide * 0.05, 12), 28)
        let labelSize = min(max(shortSide * 0.06, 14), 26)
        let bodySize = min(max(shortSide * 0.045, 12), 22)
        let lineSpacing = min(max(shortSide * 0.012, 4), 11)
        let maxReadableColumn: CGFloat = 560
        let innerMax = max(contentWidth - horizontalPadding * 2, 120)
        let textColumn = min(innerMax, maxReadableColumn)
        return (labelSize, bodySize, lineSpacing, textColumn, horizontalPadding)
    }

    private func backButton(geo: GeometryProxy) -> some View {
        let iconSize = min(
            max(min(geo.size.width, geo.size.height) * 0.055, 18),
            30
        )
        return Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: iconSize, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.purple]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .padding(.leading, geo.safeAreaInsets.leading + 20)
        .padding(.top, geo.safeAreaInsets.top + 28)
        .accessibilityLabel("Back")
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
