# Spec delta: ar-memory-experience

## ADDED Requirements

### Requirement: In-session access to the AR marker image

WHEN the user is viewing the **AR image-tracking** experience (full-screen session launched from the chapter carousel after unlock),

THEN the system SHALL provide at least one **visible control** on the AR overlay that lets the user **access the same marker image** the app uses for `ARReferenceImage` tracking (asset resolved as the bundled marker image, e.g. `marker` / `marker.png`),

AND that control SHALL remain reachable within **safe layout bounds** on notched and non-notched iPhones (respecting safe area insets alongside existing overlay controls).

#### Scenario: Marker control is available during AR

GIVEN the AR session is active and the camera feed is visible

WHEN the user looks at the overlay chrome (without dismissing AR)

THEN a marker-related affordance SHALL be visible and tappable

AND the user SHALL NOT need to leave the AR screen to start saving or printing the marker image.

---

### Requirement: Save marker to Photos

WHEN the user chooses the action to **save the marker to the photo library**,

THEN the system SHALL request **photo library add** authorization when required by the platform,

AND IF authorization is granted,

THEN the system SHALL write the marker **UIImage** to the photo library

AND SHALL provide non-destructive feedback on success (e.g. brief confirmation) or a clear message if saving fails.

#### Scenario: First-time save prompts permission

GIVEN the user has not previously granted photo library add access

WHEN they initiate save to gallery

THEN the system SHALL show the system permission dialog with the **`NSPhotoLibraryAddUsageDescription`** string

AND after the user allows adding photos, the marker image SHALL be saved.

#### Scenario: Permission denied

GIVEN the user denies photo library add access

WHEN they attempt to save the marker

THEN the system SHALL not crash

AND SHALL communicate that saving is unavailable or direct the user to Settings per platform conventions.

---

### Requirement: Print the marker

WHEN the user chooses the action to **print** the marker,

THEN the system SHALL present the **standard iOS print interaction** for that image,

AND the user SHALL be able to cancel the print UI without ending the AR session.

#### Scenario: Print sheet opens from AR

GIVEN the AR session is active

WHEN the user selects print for the marker

THEN the system SHALL present the standard print interaction preconfigured with the marker image

AND dismissing the sheet SHALL return the user to the same AR session state.

---

### Requirement: Privacy declarations for gallery save

WHEN the app supports saving the marker to the photo library,

THEN the app bundle SHALL include **`NSPhotoLibraryAddUsageDescription`** explaining that the app saves the **AR marker image** so the user can print or use it for tracking.

#### Scenario: App Store privacy string present

GIVEN the built app is inspected for Info.plist keys

WHEN photo library add usage is required for save

THEN `NSPhotoLibraryAddUsageDescription` SHALL be present and non-empty.

---

### Requirement: Tracking behavior preserved

WHEN implementing marker export,

THEN implementations SHALL NOT change **ARImageTrackingConfiguration** reference images, **physical width**, maximum tracked images, or model placement logic except where strictly required for UI overlay layout.

#### Scenario: Tracking unchanged after export actions

GIVEN the user saves or prints the marker during an active session

WHEN they point the camera at a printed marker matching the reference image

THEN image tracking and model attachment SHALL behave as before this change.
