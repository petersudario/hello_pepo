# Proposal: Fix chapter story layout on compact iPhones (e.g. iPhone 16)

## Why

After the responsive-layout pass (`fix-chapter-detail-responsive-layout`), **iPad-oriented fixes** improved regular size-class behavior, but on **compact-width iPhones** (reported on **iPhone 16**) story text is **clipped** or **does not respect visible screen bounds**. Likely contributors include the **rotated `TabView` + offset** stack, **ordering of padding vs frame**, nested `GeometryReader` / `ScrollView` sizing with **zero safe-area insets inside pages**, and interaction with **`.ignoresSafeArea()`** on the root.

This change focuses **only** on **compact horizontal size class** story presentation: geometry, safe areas, scroll bounds, and typography constraints—**without** changing Vaporwave, progression, audio, or cutscene timing.

## What Changes

- **Audit** `ChapterDetailView` compact branch: rotation, offsets, and leading padding reserved for the vertical slider vs usable text width/height.
- **Guarantee** the story `ScrollView` fills a rectangle that matches **post-transform visible bounds** on phone portrait and landscape (including Dynamic Island / home indicator).
- **Reconcile** `safeAreaInsets` from the root `GeometryReader` with inner pages (propagate or apply consistent padding so `GeometryReader` inside `TabView` does not assume full bleed incorrectly).
- **Optional strategy** (decision during implementation): simplify compact layout by **removing rotation** if vertical paging can be preserved another way, or fix rotation math while keeping current swipe semantics—whichever restores bounds without regressing iPad.

## Impact

| Area | Impact |
|------|--------|
| Specs | **MODIFIED** / **ADDED** deltas under `chapter-story-experience` for compact iPhone scenarios. |
| Code | Primarily `ChapterDetailView.swift`; possible small touch to `VerticalProgressSlider` or `TypewriterText` only if layout measurement requires it. |
| Users | Readable, fully scrollable story sections on iPhone 16-class devices without horizontal or vertical clipping at rest. |

## Out of scope

- **Vaporwave** visuals and **progression** / **Collect memory** behavior.
- Re-design of **PageTabViewStyle** interaction beyond what is needed to fix clipping.
