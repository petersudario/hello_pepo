import SceneKit
import UIKit

public class ModelPreviewView: SCNView {
    private(set) var modelNode: SCNNode?
    public private(set) var currentModelName: String?
    public var rotationSpeed: Float = 0.5
    public var soundFileName: String
    private let targetRadius: Float = 20

    public init(frame: CGRect = .zero,
                modelName: String,
                fileExtension: String = "usdz",
                rotationSpeed: Float = 0.5,
                soundFileName: String) {
        self.soundFileName = soundFileName
        super.init(frame: frame, options: nil)
        self.rotationSpeed = rotationSpeed
        configureView()
        loadModel(named: modelName, fileExtension: fileExtension)
    }

    required init?(coder: NSCoder) {
        self.soundFileName = ""
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        autoenablesDefaultLighting = true
        allowsCameraControl      = false
        backgroundColor          = .black

        let pan   = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let tap   = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        addGestureRecognizer(pan)
        addGestureRecognizer(pinch)
        addGestureRecognizer(tap)
    }

    public func loadModel(named name: String, fileExtension: String = "usdz") {
        guard currentModelName != name,
              let url = Bundle.main.url(forResource: name, withExtension: fileExtension),
              let scene = try? SCNScene(url: url, options: nil) else {
            return
        }

        if let node = scene.rootNode.childNodes.first {
            modelNode = node
            let (center, radius) = node.boundingSphere
            node.pivot = SCNMatrix4MakeTranslation(center.x, center.y, center.z)
            let factor = targetRadius / radius
            node.scale = SCNVector3(factor, factor, factor)
        }

        let lightNode  = Self.makeLightNode()
        let cameraNode = makeCameraNode()
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)

        self.scene       = scene
        self.pointOfView = cameraNode
        currentModelName = name
    }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        guard let node = modelNode else { return }
        let t = g.translation(in: self)
        node.eulerAngles.y += Float(t.x) * (Float.pi / 180) * rotationSpeed
        node.eulerAngles.x += Float(t.y) * (Float.pi / 180) * rotationSpeed
        g.setTranslation(.zero, in: self)
    }

    @objc private func handlePinch(_ g: UIPinchGestureRecognizer) {
        guard let node = modelNode else { return }
        let s = node.scale * Float(g.scale)
        node.scale = SCNVector3(
            x: min(max(s.x, 0.1), 5),
            y: min(max(s.y, 0.1), 5),
            z: min(max(s.z, 0.1), 5)
        )
        g.scale = 1
    }

    @objc private func handleTap(_ g: UITapGestureRecognizer) {
        let loc = g.location(in: self)
        if hitTest(loc, options: nil).first != nil {
            playSound()
        }
    }

    private func playSound() {
        guard let source = SCNAudioSource(fileNamed: soundFileName) else { return }
        source.load()
        let player = SCNAudioPlayer(source: source)
        modelNode?.addAudioPlayer(player)
    }

    private static func makeLightNode() -> SCNNode {
        let light = SCNLight()
        light.type      = .directional
        light.intensity = 1000
        let node = SCNNode()
        node.light       = light
        node.eulerAngles = SCNVector3(-Float.pi / 4, Float.pi / 4, 0)
        return node
    }

    private func makeCameraNode() -> SCNNode {
        let camera = SCNCamera()
        camera.fieldOfView = 120
        let node = SCNNode()
        node.camera   = camera
        node.position = SCNVector3(0, 0, targetRadius * 3)
        return node
    }
}

private func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}
