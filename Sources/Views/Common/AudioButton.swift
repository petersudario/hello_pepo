//
//  AudioButton.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

struct AudioButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.largeTitle)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}
