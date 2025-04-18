import SwiftUI
import ARKit

struct ContentView: View {
    @State private var idx = 0
    let models = ["Berserk_Armor", "akira", "bonfire", "forza_ferrari", "gamecube", "malenia", "spiderman", "macbook", "virtuoso"]

    var body: some View {
        ZStack {
            ModelPreviewRepresentable(modelName: models[idx])
                .edgesIgnoringSafeArea(.all)

            HStack {
                Button(action: { idx = (idx-1+models.count)%models.count }) {
                    Image(systemName: "chevron.left.circle.fill").font(.largeTitle)
                }
                Spacer()
                Button(action: { idx = (idx+1)%models.count }) {
                    Image(systemName: "chevron.right.circle.fill").font(.largeTitle)
                }
            }
            .padding(.horizontal, 30)
            .foregroundColor(.white)
        }
    }
}


