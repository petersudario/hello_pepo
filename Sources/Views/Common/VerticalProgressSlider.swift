//
//  VerticalProgressSlider.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

struct VerticalProgressSlider: View {
    let total: Int
    let current: Int
    let lineLength: CGFloat = 20
    let lineHeight: CGFloat = 2

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let step = total > 1
                ? (h - lineLength) / CGFloat(total - 1)
                : 0

            ZStack {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 4, height: h)

                Capsule()
                    .fill(Color.purple)
                    .frame(
                        width: 4,
                        height: CGFloat(current + 1) / CGFloat(total) * h
                    )
                    .frame(maxHeight: h, alignment: .top)

                ForEach(0..<total, id: \.self) { idx in
                    Rectangle()
                        .fill(idx == current ? Color.purple : Color.gray.opacity(0.6))
                        .frame(width: lineLength, height: lineHeight)
                        .position(
                            x: lineLength/2 + 2, 
                            y: step * CGFloat(idx) + lineLength/2
                        )
                }
            }
        }
    }
}
