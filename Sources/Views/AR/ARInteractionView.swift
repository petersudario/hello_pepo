//
//  ARInteractionView.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//


import SwiftUI
import ARKit
import SceneKit

struct ARInteractionView: UIViewControllerRepresentable {
    let modelName: String
    let soundFileName: String

    func makeUIViewController(context: Context) -> ARImageTrackingViewController {
        ARImageTrackingViewController(modelName: modelName,
                                       modelSound: soundFileName)
    }

    func updateUIViewController(_ ui: ARImageTrackingViewController, context: Context) {}
}
