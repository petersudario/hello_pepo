# Implementation Tasks

1. Reproduce clipping on **iPhone 16** (or same-size Simulator) in **portrait** and **landscape** with a long-text chapter; capture which edges clip (leading/trailing/top/bottom).
2. Trace compact-branch layout: padding on `storyTabView`, swapped `.frame(width:height:)`, `.rotationEffect`, `.offset`, and overlay slider—document effective coordinate mapping vs screen safe area.
3. Measure inner `storySectionPage` `GeometryReader` sizes with SwiftUI instruments or temporary debug overlays; confirm whether **safeAreaInsets** are zero inside `TabView` pages.
4. Adjust compact layout so the **scrollable text region** uses dimensions derived from **visible width/height after transforms**, not pre-transform sizes alone.
5. Apply **explicit safe-area padding** (or `safeAreaInset`) for story content on compact devices so text never sits under notch/Dynamic Island/home indicator except inside intentional scroll margins.
6. Validate **slider overlay** + reserved leading padding: ensure combined inset does not exceed usable width; reduce spacing or switch to `safeAreaInset(edge: .leading)` if needed.
7. Regression test **iPad regular** path from previous change: confirm no loss of iPad layout quality.
8. Manual QA matrix: **iPhone SE (small)**, **iPhone 16**, **iPhone 16 Pro Max** (or simulators), portrait + landscape; confirm no clipping at chapter start and after changing sections.
