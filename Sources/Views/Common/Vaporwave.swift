//
//  Vaporwave.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//
import SwiftUI

struct GridView: View {
    var spacing: CGFloat = 40
    var lineWidth: CGFloat = 1
    var color: Color = Color.pink.opacity(0.2)
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let w = geo.size.width
                let h = geo.size.height
                for x in stride(from: 0, to: w, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: h))
                }
                for y in stride(from: 0, to: h, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: w, y: y))
                }
            }
            .stroke(color, lineWidth: lineWidth)
            .blur(radius: 0.5)
            .offset(x: offsetX, y: offsetY)
        }
        .allowsHitTesting(false)
    }
}

struct PastelGradientOverlay: View {
    var startPoint: UnitPoint
    var endPoint: UnitPoint

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.pink.opacity(0.3),
                Color.purple.opacity(0.3),
                Color.blue.opacity(0.3)
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .blendMode(.overlay)
        .allowsHitTesting(false)
    }
}

struct ScanlineView: View {
    var lineSpacing: CGFloat = 3
    var opacity: Double = 0.1

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let h = geo.size.height, w = geo.size.width
                for y in stride(from: 0, to: h, by: lineSpacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: w, y: y))
                }
            }
            .stroke(Color.white.opacity(opacity), lineWidth: 1)
        }
        .allowsHitTesting(false)
    }
}

struct NoiseView: View {
    @State private var tick = false

    var body: some View {
        Canvas { context, size in
            for _ in 0..<Int(size.width * size.height / 4000) {
                let x = CGFloat.random(in: 0..<size.width)
                let y = CGFloat.random(in: 0..<size.height)
                let alpha = Double.random(in: 0.0...0.08)
                context.fill(Path(CGRect(x: x, y: y, width: 1, height: 1)),
                             with: .color(.white.opacity(alpha)))
            }
        }
        .blendMode(.screen)
        .drawingGroup()
        .onAppear {
            withAnimation(.linear(duration: 0.1).repeatForever(autoreverses: false)) {
                tick.toggle()
            }
        }
        .allowsHitTesting(false)
    }
}

struct ChromaticShiftView: View {
    var amount: CGFloat = 1.5
    var opacity: Double = 0.04

    var body: some View {
        ZStack {
            Color.red
                .blendMode(.screen)
                .opacity(opacity)
                .offset(x: amount)
            Color.green
                .blendMode(.screen)
                .opacity(opacity)
            Color.blue
                .blendMode(.screen)
                .opacity(opacity)
                .offset(x: -amount)
        }
        .allowsHitTesting(false)
    }
}

struct VaporwaveOverlay: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ScanlineView()
            ChromaticShiftView(amount: animate ? 3 : 1)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
            NoiseView()
            PastelGradientOverlay(
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate)
            GridView(offsetX: animate ? -40 : 40,
                     offsetY: animate ? 40 : -40)
            .animation(.linear(duration: 4).repeatForever(autoreverses: true), value: animate)
        }
        .compositingGroup()
        .onAppear {
            animate.toggle()
        }
    }
}

struct Vaporwave<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        ZStack {
            content
            VaporwaveOverlay()
        }
    }
}
