# Proposal: Responsive layout for chapter story dialogs

## Why

After opening a chapter via **“Hear a story”**, the story screens (`ChapterDetailView` story layer) use geometry-driven frames, `TabView` paging, optional 90° rotation for compact width, and a fixed-position vertical slider. On **larger canvases (especially iPad)** in portrait or landscape, content can be **clipped, offset off-screen, or misaligned** relative to safe areas—hurting readability without changing game rules.

This change targets **layout and typography scaling only**, preserving **Vaporwave** styling hooks and **progression mechanics** (`collectMemory`, chapter unlock flow, audio sequencing).

## What Changes

- **Story container**: Constrain story pages within the **safe area** and visible bounds on iPhone and iPad (all orientations supported by the app).
- **TabView / paging**: Ensure horizontal paging for story sections does not translate content outside the visible region when size classes or dimensions change (including nested `GeometryReader` behavior).
- **Rotation path** (compact layouts that use counter-rotation): Reconcile inner page geometry with outer container so text and controls are not “kicked” off-screen after rotation/offset math.
- **Typography**: Keep proportional scaling but **clamp** min/max font sizes and column width so long paragraphs remain on-screen and legible on iPad.
- **Chrome**: Adjust **back control** and **vertical progress slider** positions using safe-area-aware layout so they do not overlap story text or sit under system bars on iPad.

## Impact

| Area | Impact |
|------|--------|
| Specs | New capability requirements under `chapter-story-experience` (no existing spec file in repo today). |
| Code | Primarily `ChapterDetailView.swift` (and shared helpers only if needed for layout constants); **no** edits to `Vaporwave.swift`, progression logic in `ChaptersViewModel`, or splash/carousel mechanics unless required for frame fixes. |
| Users | Consistent story reading on iPhone and iPad without clipping or off-screen dialogs. |

## Out of scope

- Changing **Vaporwave** background/visual system.
- Changing **progression**, unlock rules, or **Collect memory** flow behavior (only layout of existing controls).
