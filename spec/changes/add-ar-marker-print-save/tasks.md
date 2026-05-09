# Implementation Tasks

1. Confirm the marker asset resolution path (`UIImage(named: "marker")` / bundle resource) matches `Sources/Materials/Images/marker.png` in the Swift package so export uses the **identical** image bytes as tracking.
2. Add Info.plist (or package manifest) **`NSPhotoLibraryAddUsageDescription`** with user-facing text explaining that the app saves the **AR marker** image for printing or reference.
3. Extend `ARImageTrackingViewController` overlay with at least one affordance (e.g. button or menu) labeled for **marker / imprimir / galeria** per product copy, placed with **safe-area** constraints and visible above the camera feed.
4. Implement **save to Photos**: request add-only authorization if needed; write `UIImage` for the marker; present success or permission-denied feedback without crashing.
5. Implement **print**: present system print UI with the marker image; handle cancellation and missing printers without errors surfaced as crashes.
6. Optional consolidation: use **`UIActivityViewController`** for share/print/save if it simplifies UX while still meeting save and print scenarios (verify Photos save still satisfies requirement).
7. Manual QA on device: first launch (permission prompt), denied permission, successful save (verify image in Photos), print sheet opens and completes or cancels; regression: AR session still tracks marker and sound button works.
