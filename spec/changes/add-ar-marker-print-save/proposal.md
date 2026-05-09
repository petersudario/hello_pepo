# Proposal: AR marker image — print and save to gallery

## Why

Users open the AR memory experience from the chapter carousel and must **physically place the printed marker** (`marker.png`) so image tracking works. Today there is **no in-session path** to obtain that image: users would need to extract it from the repository or receive it elsewhere. Offering **print** and **save to Photos** **during** the AR session reduces friction and failed tracking due to missing or wrong markers.

**Current state**: `ARImageTrackingViewController` loads `UIImage(named: "marker")` for `ARReferenceImage` only; the overlay exposes sound playback, not marker export.

**Desired state**: While AR is active, the user can **open the same marker asset** the app uses for tracking and **save it to the photo library** and/or **print it** via standard iOS flows, with correct privacy strings and permission handling.

## What Changes

- Add **user-visible controls** on the AR overlay (alongside existing controls) to **share/export the marker image** used for tracking (`Sources/Materials/Images/marker.png` / asset catalog name `marker`).
- Implement **save to Photos** using the system photo library APIs, including **authorization** handling when add-only access is not granted.
- Implement **print** using the system print UI (`UIPrintInteractionController` or equivalent) so the user can send the marker to a printer or PDF.
- Add **`NSPhotoLibraryAddUsageDescription`** (and any other required Info.plist keys) with a clear explanation for saving the marker.
- Keep **tracking behavior unchanged**: the exported image is the **same** bitmap used as `ARReferenceImage`.

## Impact

| Area | Impact |
|------|--------|
| Specs | **ADDED** requirements under new capability `ar-memory-experience`; merge into `spec/specs/ar-memory-experience/spec.md` after approval. |
| Code | `ARImageTrackingViewRepresentable.swift` / `ARImageTrackingViewController`, app Info.plist or SwiftPM manifest privacy strings as applicable. |
| Users | Faster setup for AR: print or save the official marker without leaving the session. |

## Out of scope

- Changing marker artwork, physical width (`0.2` m), or tracking configuration.
- Hosting markers on a server or QR deep links.
- Localization of new strings beyond what implementation requires (can follow existing app i18n patterns if present).

## Risks

- **Photos permission denial**: Mitigate with clear copy and graceful fallback (e.g. offer print only, or open share sheet).
- **Small overlay on notch devices**: Mitigate with safe-area-aware button placement consistent with the existing sound control.
