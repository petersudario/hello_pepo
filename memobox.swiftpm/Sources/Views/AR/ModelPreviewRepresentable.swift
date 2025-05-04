//
//  ModelPreviewRepresentable.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import SwiftUI

public struct ModelPreviewRepresentable: UIViewRepresentable {
    public let modelName: String
    public let soundFileName: String
    public var fileExtension: String = "usdz"
    public var rotationSpeed: Float = 0.5

    public func makeUIView(context: Context) -> ModelPreviewView {
        ModelPreviewView(
            modelName: modelName,
            fileExtension: fileExtension,
            rotationSpeed: rotationSpeed,
            soundFileName: soundFileName
        )
    }

    public func updateUIView(_ uiView: ModelPreviewView, context: Context) {
        if uiView.currentModelName != modelName {
            uiView.soundFileName = soundFileName
            uiView.loadModel(named: modelName,
                             fileExtension: fileExtension)
        }
        uiView.rotationSpeed = rotationSpeed
    }
}


