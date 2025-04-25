import SwiftUI

struct CollectMemoryView: View {
    @ObservedObject var vm: ChaptersViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Vaporwave {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    Text("Memory")
                        .font(.system(size: 40, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(0.8)
                        .rotationEffect(.degrees(-10))

                    Text("Collected!")
                        .font(.system(size: 40, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, .white]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(0.8)
                        .rotationEffect(.degrees(-10))

                    Spacer()
                }
                .padding(.top, 120)

                ModelPreviewRepresentable(
                    modelName: vm.chapters[vm.selectedChapterIndex].modelName,
                    soundFileName: vm.chapters[vm.selectedChapterIndex].soundFileName
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
            }
        }
    }
}
