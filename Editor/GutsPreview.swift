//
//  GutsPreview.swift
//  hello_pepo
//
//  Created by Pedro Henrique Sudario da Silva on 15/04/25.
//

import SceneKit
import SwiftUI

class GutsPreview: SCNView {
    var modelNode: SCNNode?

    static func createGutsPreview() -> GutsPreview {
        let preview = GutsPreview()
        
        let panGesture = UIPanGestureRecognizer(target: preview, action: #selector(handlePan(_:)))
        preview.addGestureRecognizer(panGesture)
        
        guard let sceneURL = Bundle.main.url(forResource: "Berserk_Armor", withExtension: "usdz") else {
            print("Unable to find file")
            return preview
        }
        
        let sceneSource = SCNSceneSource(url: sceneURL)
        
        guard let scene = sceneSource?.scene(options: nil) else {
            print("Unable to load file")
            return preview
        }
        
        let lightNode = createLightNode()
        let cameraNode = createCameraNode()
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)

        if let firstNode = scene.rootNode.childNodes.first {
            preview.modelNode = firstNode
        }
        
        preview.scene = scene
        
        return preview
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        let rotationAngle = Float(translation.x) * (Float.pi / 180) * 0.5
        
        modelNode?.eulerAngles.y += rotationAngle
        
        gesture.setTranslation(.zero, in: self)
    }
    
    private static func createLightNode() -> SCNNode {
        let light = SCNLight()
        light.type = .directional
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.rotation = SCNQuaternion(x: -0.5, y: 1, z: 0, w: 1)
        
        return lightNode
    }
    
    private static func createCameraNode() -> SCNNode {
        let camera = SCNCamera()
        camera.fieldOfView = 120
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 35, z: 80)
        
        return cameraNode
    }
}

struct GutsPreviewView: UIViewRepresentable {
    typealias UIViewType = GutsPreview
    
    func makeUIView(context: Context) -> UIViewType {
        return GutsPreview.createGutsPreview()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
