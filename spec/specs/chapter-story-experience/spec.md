# Capability: Chapter story experience

Living specification merged from archived changes:

- `fix-chapter-detail-responsive-layout` (2026-05-09)
- `fix-story-layout-iphone-compact` (2026-05-09)

---

### Requirement: Story content stays within safe layout bounds

WHEN the user opens a chapter story from the carousel (“Hear a story”) on **any supported device** (iPhone or iPad),

THEN all visible story text, typewriter content, and section chrome (back affordance, vertical progress indicator) SHALL remain **fully interactable and readable** without being clipped or displaced outside the screen edges in **portrait and landscape**, except where the user intentionally scrolls within a designated scroll region.

WHEN the device uses **compact horizontal size class** (typical iPhone layout, including iPhone 16-class sizes),

THEN story text SHALL respect the **effective visible layout rectangle** after any transforms applied for paging (including rotation and offset),

AND SHALL NOT be truncated horizontally or vertically at rest solely due to incorrect container sizing, transform composition, or missing safe-area compensation.

#### Scenario: iPad landscape reading

GIVEN the app is running on an iPad in landscape

WHEN the story layer is visible after the introductory cutscene

THEN the active section’s text SHALL stay within the root view’s **safe area** (accounting for status bar, home indicator, and optional notch margins)

AND the user SHALL be able to scroll to read the full section if content exceeds the visible height.

#### Scenario: iPad portrait reading

GIVEN the app is running on an iPad in portrait

WHEN the user advances between story sections

THEN section text SHALL not be offset entirely off-screen due to container rotation, incorrect `GeometryReader` sizing, or manual `offset` correction.

#### Scenario: iPhone compact — portrait without clipping

GIVEN the app is running on an iPhone with compact horizontal size class in **portrait** (e.g. iPhone 16)

WHEN the story layer is visible and the first line of a text section is shown without user scrolling

THEN no portion of that line SHALL be clipped by the leading or trailing edge of the display

AND no portion SHALL be clipped by the top safe area (status bar / Dynamic Island) beyond acceptable margins inside the scroll region.

#### Scenario: iPhone compact — landscape without clipping

GIVEN the same device in **landscape**

WHEN a multi-line section is displayed

THEN text SHALL remain within horizontally usable bounds reserved for reading (including space for the vertical progress slider when shown)

AND vertical overflow SHALL be reachable only via the section `ScrollView`, not by lines disappearing under the top or bottom safe regions at rest.

---

### Requirement: Proportional typography with readability bounds

WHEN story sections render body and attribution text,

THEN font sizes and line spacing MAY scale with the available reading area

AND the system SHALL enforce **minimum and maximum** font sizes (and related spacing) so that text does not become illegibly small on large canvases or overflow vertically more than necessary on small canvases.

#### Scenario: Long paragraph section

GIVEN a section whose text spans multiple lines on iPad

WHEN the section is displayed

THEN the rendered column width SHALL not exceed a comfortable maximum width for reading on large screens

AND the user SHALL scroll within the section’s scroll view to read overflow content rather than losing lines off-screen.

---

### Requirement: Progress and navigation controls respect safe areas

WHEN the story layer is visible,

THEN the vertical progress slider and the back navigation control SHALL be positioned using **safe-area-aware** layout

AND they SHALL not overlap story text in typical configurations on iPad **and iPhone**.

#### Scenario: Slider clears text column

GIVEN an iPad in landscape with the vertical slider on the leading edge

WHEN the longest line of the story text is displayed

THEN the text column SHALL remain clear of the slider hit area (including generous padding)

AND the slider SHALL remain visible and draggable without sitting under the status bar region.

#### Scenario: iPhone compact slider and text separation

GIVEN an iPhone in compact horizontal size class with the vertical slider visible

WHEN the user reads the widest line of a section

THEN the story text column SHALL not extend under the slider track

AND the slider SHALL remain usable without overlapping body text in portrait and landscape.

---

### Requirement: Non-goals preserved

WHEN implementing layout adjustments,

THEN implementations SHALL NOT alter **Vaporwave** styling composition as used by `ChapterDetailView`

AND SHALL NOT modify **progression mechanics** (chapter unlock indices, `collectMemory`, audio progression rules, or cutscene timing) except where strictly required to reposition existing UI—**behavioral logic MUST remain unchanged**.

#### Scenario: Collect memory control unchanged in behavior

GIVEN the user reaches the model preview section

WHEN they tap **Collect memory›**

THEN memory collection and subsequent presentation SHALL behave as today; only layout metrics MAY change.

---

### Requirement: Compact layout SHALL NOT rely on unstated geometry assumptions

WHEN implementing compact-width story layout,

THEN implementations SHALL validate inner `GeometryReader` sizes against the root container after safe-area and transform application,

AND SHALL NOT assume inner pages inherit meaningful `safeAreaInsets` unless explicitly propagated.

#### Scenario: Scroll view fills visible reading frame only

GIVEN a compact iPhone story section with vertical scrolling

WHEN the section appears

THEN the `ScrollView` SHALL occupy at most the **visible** reading area between reserved chrome (slider, back affordance) and screen safe areas,

AND expanding content SHALL scroll inside that frame without clipping at the scroll view’s bounds.
