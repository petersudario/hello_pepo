# Implementation Tasks

1. Audit `ChapterDetailView` story layer: document size-class branches (regular vs compact), `TabView` frames, rotation/offset block, and nested `GeometryReader` in `storySectionPage`.
2. Reproduce clipping/off-screen issues on **iPad simulator** (portrait and landscape) and **iPhone** (reference) for at least one long-text chapter.
3. Replace or constrain layouts that use **fixed `.position`** / **manual rotation offsets** where they conflict with safe area or intrinsic content size on large screens.
4. Ensure each story section page uses a **bounded scroll region** (`ScrollView` + max width) that stays inside **safeAreaInsets** on iPad and iPhone.
5. Introduce **clamped** font metrics (min/max) for label, body, and line spacing derived from readable dimensions—not unbounded `shortSide * ratio` alone.
6. Align **VerticalProgressSlider** and **back** button using safe-area padding or `safeAreaInset` so they do not push or obscure story text on iPad.
7. Verify **compact** rotation path (if retained): inner content counter-rotates within a container whose size matches the visible story area after rotation.
8. Manual QA: all orientations for **iPad (11" and 13")** and **iPhone**; confirm no regression on smallest supported phone size.
9. If applicable, add a **snapshot or UI test** (optional) that loads `ChapterDetailView` preview fixture sizes—only if the project already supports XCTest/hosted tests without new infra.
