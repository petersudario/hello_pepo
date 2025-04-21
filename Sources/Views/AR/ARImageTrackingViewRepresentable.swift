//
//  ARImageTrackingViewRepresentable.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 19/04/25.
//

import SwiftUI
import ARKit
import SceneKit
import AVFoundation


struct ARImageTrackingViewRepresentable: UIViewControllerRepresentable {
    let modelName: String
    let modelSound: String

    func makeUIViewController(context: Context) -> ARImageTrackingViewController {
        return ARImageTrackingViewController(modelName: modelName, modelSound: modelSound)
    }

    func updateUIViewController(_ uiViewController: ARImageTrackingViewController, context: Context) {}
}

class ARImageTrackingViewController: UIViewController, ARSCNViewDelegate {
    let sceneView = ARSCNView()
    let modelName: String
    let modelSound: String
    var audioPlayer: AVAudioPlayer?

    init(modelName: String, modelSound: String) {
        self.modelName = modelName
        self.modelSound = modelSound
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(sceneView)
        sceneView.frame = view.bounds
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true

        addOverlayButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard
            let img = UIImage(named: "marker"),
            let cgImage = img.cgImage
        else { fatalError("Marker not found") }

        let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2)
        referenceImage.name = "marker"

        let config = ARImageTrackingConfiguration()
        config.trackingImages = [referenceImage]
        config.maximumNumberOfTrackedImages = 1
        sceneView.session.run(config, options: [.removeExistingAnchors, .resetTracking])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    nonisolated func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }

        Task { @MainActor in
            await handleImageAnchor(modelName: self.modelName, node: node)
        }
    }

    @MainActor
    func handleImageAnchor(modelName: String, node: SCNNode) {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            return
        }

        guard let modelScene = try? SCNScene(url: url),
              let modelNode = modelScene.rootNode.childNodes.first else {
            return
        }

        let (minVec, maxVec) = modelNode.boundingBox
        let center = SCNVector3(
            (maxVec.x + minVec.x) / 2,
            (maxVec.y + minVec.y) / 2,
            (maxVec.z + minVec.z) / 2
        )
        modelNode.pivot = SCNMatrix4MakeTranslation(center.x, center.y, center.z)

        let size = maxVec - minVec
        let largest = max(size.x, size.y, size.z)
        let targetSize: Float = 0.1
        let scaleFactor = targetSize / largest
        modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)

        modelNode.position.y = 0

        node.addChildNode(modelNode)
    }

    private func addOverlayButtons() {
        let soundButton = UIButton(type: .system)
        soundButton.setTitle("🔊", for: .normal)
        soundButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        soundButton.tintColor = .white
        soundButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        soundButton.layer.cornerRadius = 30
        soundButton.frame = CGRect(x: view.bounds.width - 80, y: view.safeAreaInsets.top + 20, width: 60, height: 60)
        soundButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        soundButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        view.addSubview(soundButton)

    }

    @objc private func playSound() {
        guard let url = Bundle.main.url(forResource: modelSound, withExtension: nil) else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {}
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

fileprivate func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}
