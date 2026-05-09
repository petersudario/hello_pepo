//
//  ARImageTrackingViewRepresentable.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 19/04/25.
//

import SwiftUI
import ARKit
import Photos

@MainActor
struct ARImageTrackingViewRepresentable: UIViewControllerRepresentable {
    let modelName: String
    let modelSound: String

    func makeUIViewController(context: Context) -> ARImageTrackingViewController {
        ARImageTrackingViewController(modelName: modelName, modelSound: modelSound)
    }

    func updateUIViewController(_ uiViewController: ARImageTrackingViewController, context: Context) {}
}

@MainActor
class ARImageTrackingViewController: UIViewController, ARSCNViewDelegate {
    private let sceneView = ARSCNView()
    private let markerOptionsButton = UIButton(type: .system)
    /// Read from SceneKit delegate callbacks; immutable after `init`, safe across isolation boundaries.
    private nonisolated(unsafe) let modelName: String
    private nonisolated(unsafe) let modelSound: String

    init(modelName: String, modelSound: String) {
        self.modelName = modelName
        self.modelSound = modelSound
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        sceneView.frame = view.bounds
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        addOverlayButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let img = UIImage(named: "marker"), let cgImage = img.cgImage else {
            fatalError("Marker not found")
        }
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
        handleImageAnchor(modelName: modelName, node: node)
    }

    nonisolated private func handleImageAnchor(modelName: String, node: SCNNode) {
        guard
            let url = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
            let scene = try? SCNScene(url: url),
            let modelNode = scene.rootNode.childNodes.first
        else { return }

        let (minVec, maxVec) = modelNode.boundingBox
        let center = SCNVector3((maxVec.x + minVec.x)/2,
                                 (maxVec.y + minVec.y)/2,
                                 (maxVec.z + minVec.z)/2)
        modelNode.pivot = SCNMatrix4MakeTranslation(center.x, center.y, center.z)
        let size = maxVec - minVec
        let largest = max(size.x, size.y, size.z)
        let scaleFactor = 0.1 / largest
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
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.accessibilityLabel = "Play sound"
        soundButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)

        markerOptionsButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        markerOptionsButton.tintColor = .white
        markerOptionsButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        markerOptionsButton.layer.cornerRadius = 30
        markerOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        markerOptionsButton.accessibilityLabel = "View AR marker image"
        markerOptionsButton.addTarget(self, action: #selector(showMarkerPreview), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [markerOptionsButton, soundButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            markerOptionsButton.widthAnchor.constraint(equalToConstant: 60),
            markerOptionsButton.heightAnchor.constraint(equalToConstant: 60),
            soundButton.widthAnchor.constraint(equalToConstant: 60),
            soundButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func loadMarkerImageForExport() -> UIImage? {
        UIImage(named: "marker")
    }

    @objc private func showMarkerPreview() {
        guard let image = loadMarkerImageForExport() else {
            presentSimpleAlert(title: "Marker unavailable", message: "Could not load the marker image from the app bundle.")
            return
        }
        let preview = MarkerPreviewSheetController(markerImage: image, host: self)
        preview.modalPresentationStyle = .pageSheet
        if let sheet = preview.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(preview, animated: true)
    }

    private func saveMarkerToPhotos() {
        guard let image = loadMarkerImageForExport() else {
            presentSimpleAlert(title: "Marker unavailable", message: "Could not load the marker image.")
            return
        }

        let current = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if current == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                DispatchQueue.main.async {
                    self?.applyPhotoAuthorizationStatus(status, image: image)
                }
            }
        } else {
            applyPhotoAuthorizationStatus(current, image: image)
        }
    }

    private func applyPhotoAuthorizationStatus(_ status: PHAuthorizationStatus, image: UIImage) {
        switch status {
        case .authorized, .limited:
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if success {
                        self.presentSimpleAlert(title: "Saved", message: "The marker was saved to Photos.")
                    } else {
                        let msg = error?.localizedDescription ?? "Unknown error"
                        self.presentSimpleAlert(title: "Could not save", message: msg)
                    }
                }
            }
        case .denied, .restricted:
            presentSimpleAlert(
                title: "Photos access needed",
                message: "Allow Pepo's MemoBox to add photos in Settings so you can save the AR marker."
            )
        case .notDetermined:
            presentSimpleAlert(title: "Photos", message: "Photo library access was not determined.")
        @unknown default:
            presentSimpleAlert(title: "Photos", message: "Could not access the photo library.")
        }
    }

    private func printMarker() {
        guard let image = loadMarkerImageForExport() else {
            presentSimpleAlert(title: "Marker unavailable", message: "Could not load the marker image.")
            return
        }
        let printInfo = UIPrintInfo.printInfo()
        printInfo.jobName = "AR Marker"
        printInfo.outputType = .photo

        let controller = UIPrintInteractionController.shared
        controller.printInfo = printInfo
        controller.printingItem = image
        controller.present(animated: true) { [weak self] _, _, error in
            guard let error else { return }
            DispatchQueue.main.async { [weak self] in
                self?.presentSimpleAlert(title: "Print failed", message: error.localizedDescription)
            }
        }
    }

    private func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @MainActor
    @objc private func playSound() {
        let parts = modelSound.split(separator: ".")
        let name = String(parts.first ?? "")
        let ext = parts.count > 1 ? String(parts.last!) : "wav"
        AudioManager.shared.playSFX(named: name, ofType: ext)
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    private final class MarkerPreviewSheetController: UIViewController {
        private let markerImage: UIImage
        private weak var host: ARImageTrackingViewController?

        init(markerImage: UIImage, host: ARImageTrackingViewController) {
            self.markerImage = markerImage
            self.host = host
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemGroupedBackground

            let scroll = UIScrollView()
            scroll.translatesAutoresizingMaskIntoConstraints = false
            scroll.alwaysBounceVertical = true

            let rootStack = UIStackView()
            rootStack.axis = .vertical
            rootStack.spacing = 16
            rootStack.translatesAutoresizingMaskIntoConstraints = false
            rootStack.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 28, right: 20)
            rootStack.isLayoutMarginsRelativeArrangement = true

            let titleLabel = UILabel()
            titleLabel.text = "This image powers AR tracking"
            titleLabel.font = .preferredFont(forTextStyle: .title1)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.adjustsFontForContentSizeCategory = true

            let subtitleLabel = UILabel()
            subtitleLabel.text = "The camera looks for this exact picture in the real world. Print or save it, then point your phone at the printout."
            subtitleLabel.font = .preferredFont(forTextStyle: .body)
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.adjustsFontForContentSizeCategory = true

            let badgeStack = UIStackView()
            badgeStack.axis = .horizontal
            badgeStack.spacing = 8
            badgeStack.alignment = .center
            badgeStack.distribution = .fill

            let check = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
            check.tintColor = .systemGreen
            check.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            check.setContentHuggingPriority(.required, for: .horizontal)

            let badgeLabel = UILabel()
            badgeLabel.text = "Same file the app loads for ARKit"
            badgeLabel.font = .preferredFont(forTextStyle: .subheadline)
            badgeLabel.numberOfLines = 0
            badgeLabel.adjustsFontForContentSizeCategory = true

            badgeStack.addArrangedSubview(check)
            badgeStack.addArrangedSubview(badgeLabel)

            let imageContainer = UIView()
            imageContainer.translatesAutoresizingMaskIntoConstraints = false
            imageContainer.backgroundColor = .secondarySystemGroupedBackground
            imageContainer.layer.cornerRadius = 16
            imageContainer.layer.borderWidth = 2
            imageContainer.layer.borderColor = UIColor.separator.cgColor

            let imageView = UIImageView(image: markerImage)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.accessibilityLabel = "AR marker reference image"

            imageContainer.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageContainer.heightAnchor.constraint(equalToConstant: 280),
                imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 12),
                imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 12),
                imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -12),
                imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -12),
            ])

            let saveButton = UIButton(configuration: .filled())
            saveButton.configuration?.title = "Save to Photos"
            saveButton.configuration?.image = UIImage(systemName: "square.and.arrow.down")
            saveButton.configuration?.imagePadding = 8
            saveButton.addAction(UIAction { [weak self] _ in
                guard let self, let host = self.host else { return }
                dismiss(animated: true) { host.saveMarkerToPhotos() }
            }, for: .touchUpInside)

            let printButton = UIButton(configuration: .bordered())
            printButton.configuration?.title = "Print"
            printButton.configuration?.image = UIImage(systemName: "printer.fill")
            printButton.configuration?.imagePadding = 8
            printButton.addAction(UIAction { [weak self] _ in
                guard let self, let host = self.host else { return }
                dismiss(animated: true) { host.printMarker() }
            }, for: .touchUpInside)

            rootStack.addArrangedSubview(titleLabel)
            rootStack.addArrangedSubview(subtitleLabel)
            rootStack.addArrangedSubview(badgeStack)
            rootStack.addArrangedSubview(imageContainer)
            rootStack.addArrangedSubview(saveButton)
            rootStack.addArrangedSubview(printButton)

            scroll.addSubview(rootStack)
            view.addSubview(scroll)

            NSLayoutConstraint.activate([
                scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                rootStack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
                rootStack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor),
                rootStack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor),
                rootStack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
                rootStack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor),

                imageContainer.leadingAnchor.constraint(equalTo: rootStack.layoutMarginsGuide.leadingAnchor),
                imageContainer.trailingAnchor.constraint(equalTo: rootStack.layoutMarginsGuide.trailingAnchor),
            ])
        }

    }
}

fileprivate func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}
