import SceneKit
import SwiftUI

class ModelPreviewView: SCNView {
    private(set) var modelNode: SCNNode?
    var rotationSpeed: Float = 0.5
    private(set) var currentModelName: String?

    init(frame: CGRect = .zero,
         modelName: String,
         fileExtension: String = "usdz",
         rotationSpeed: Float = 0.5) {
        super.init(frame: frame, options: nil)
        self.rotationSpeed = rotationSpeed
        configureView()
        loadModel(named: modelName, fileExtension: fileExtension)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func loadModel(named name: String, fileExtension: String = "usdz") {
        guard currentModelName != name,
              let url = Bundle.main.url(forResource: name, withExtension: fileExtension),
              let scene = try? SCNScene(url: url, options: nil) else {
            return
        }

        if scene.rootNode.childNodes.first != nil && self.scene == nil {
            scene.rootNode.addChildNode(Self.makeLightNode())
            scene.rootNode.addChildNode(Self.makeCameraNode())
        }

        if let node = scene.rootNode.childNodes.first {
            modelNode = node
        }

        self.scene = scene
        currentModelName = name
    }

    private func configureView() {
        autoenablesDefaultLighting = true
        allowsCameraControl = false
        backgroundColor = .black

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        addGestureRecognizer(pinch)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let node = modelNode else { return }
        let t = gesture.translation(in: self)
        let dx = Float(t.x)
        let dy = Float(t.y)
        node.eulerAngles.y += dx * (Float.pi / 180) * rotationSpeed
        node.eulerAngles.x += dy * (Float.pi / 180) * rotationSpeed
        gesture.setTranslation(.zero, in: self)
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let node = modelNode else { return }
        let scale = Float(gesture.scale)
        let newScale = node.scale * scale
        node.scale = SCNVector3(
            x: min(max(newScale.x, 0.1), 5),
            y: min(max(newScale.y, 0.1), 5),
            z: min(max(newScale.z, 0.1), 5)
        )
        gesture.scale = 1
    }

    private static func makeLightNode() -> SCNNode {
        let light = SCNLight()
        light.type = .directional
        light.intensity = 1000
        let node = SCNNode()
        node.light = light
        node.eulerAngles = SCNVector3(-Float.pi/4, Float.pi/4, 0)
        return node
    }

    private static func makeCameraNode() -> SCNNode {
        let camera = SCNCamera()
        camera.fieldOfView = 75
        let node = SCNNode()
        node.camera = camera
        node.position = SCNVector3(0, 20, 60)
        return node
    }
}

private func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

struct ModelPreviewRepresentable: UIViewRepresentable {
    let modelName: String
    var fileExtension: String = "usdz"
    var rotationSpeed: Float = 0.5

    func makeUIView(context: Context) -> ModelPreviewView {
        ModelPreviewView(modelName: modelName, fileExtension: fileExtension, rotationSpeed: rotationSpeed)
    }

    func updateUIView(_ uiView: ModelPreviewView, context: Context) {
        if uiView.currentModelName != modelName {
            uiView.loadModel(named: modelName, fileExtension: fileExtension)
        }
        uiView.rotationSpeed = rotationSpeed
    }
}
