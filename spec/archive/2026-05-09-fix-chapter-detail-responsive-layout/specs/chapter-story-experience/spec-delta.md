# Spec Delta: Chapter story experience (responsive layout)

## ADDED Requirements

### Requirement: Story content stays within safe layout bounds

WHEN the user opens a chapter story from the carousel (“Hear a story”) on **any supported device** (iPhone or iPad),

THEN all visible story text, typewriter content, and section chrome (back affordance, vertical progress indicator) SHALL remain **fully interactable and readable** without being clipped or displaced outside the screen edges in **portrait and landscape**, except where the user intentionally scrolls within a designated scroll region.

#### Scenario: iPad landscape reading

GIVEN the app is running on an iPad in landscape

WHEN the story layer is visible after the introductory cutscene

THEN the active section’s text SHALL stay within the root view’s **safe area** (accounting for status bar, home indicator, and optional notch margins)

AND the user SHALL be able to scroll to read the full section if content exceeds the visible height.

#### Scenario: iPad portrait reading

GIVEN the app is running on an iPad in portrait

WHEN the user advances between story sections

THEN section text SHALL not be offset entirely off-screen due to container rotation, incorrect `GeometryReader` sizing, or manual `offset` correction.

#### Scenario: iPhone reference layout

GIVEN the app is running on an iPhone

WHEN the story layer uses compact horizontal size class behaviors (including any rotation workaround)

THEN story text and controls SHALL remain usable and SHALL match the same logical reading column width behavior as before this change, modulo intentional clamping for readability.

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

AND they SHALL not overlap story text in typical configurations on iPad and iPhone.

#### Scenario: Slider clears text column

GIVEN an iPad in landscape with the vertical slider on the leading edge

WHEN the longest line of the story text is displayed

THEN the text column SHALL remain clear of the slider hit area (including generous padding)

AND the slider SHALL remain visible and draggable without sitting under the status bar region.

---

### Requirement: Non-goals preserved

WHEN implementing layout adjustments,

THEN implementations SHALL NOT alter **Vaporwave** styling composition as used by `ChapterDetailView`

AND SHALL NOT modify **progression mechanics** (chapter unlock indices, `collectMemory`, audio progression rules, or cutscene timing) except where strictly required to reposition existing UI—**behavioral logic MUST remain unchanged**.

#### Scenario: Collect memory control unchanged in behavior

GIVEN the user reaches the model preview section

WHEN they tap **Collect memory›**

THEN memory collection and subsequent presentation SHALL behave as today; only layout metrics MAY change.
