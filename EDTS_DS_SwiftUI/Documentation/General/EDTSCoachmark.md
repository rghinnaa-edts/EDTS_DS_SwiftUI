# EDTSCoachmark

The `EDTSCoachmark` component is a multi-step spotlight overlay used for onboarding and feature walkthroughs — it dims the screen, cuts a highlighted "spotlight" hole around a target view, and shows a tooltip card beside it with a title, description, and navigation controls.

## Features

- Multi-step guided tours with a `targetID`-based spotlight, driven entirely by SwiftUI preferences — no view references required
- Automatic tooltip placement above or below the target, with an arrow that tracks the target's center
- `.single` and `.multiple` step presentation types, each with their own layout
- Icon, divider, font, and button styling that adapts automatically to `EDTSColor.theme` (klikIDM / poinku), overridable per call
- Combined spotlight across two targets via `endTargetID`, for highlighting a range
- Per-step spotlight padding for list-row targets via `isTargetAList`

---

## Preview
![Coachmark Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/q_auto/f_auto/v1775039040/Coachmark_ko1uju.gif)

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Coachmark'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

### Basic (multi-step)

```swift
struct ContentView: View {
    @State private var showCoachmark = false
    @State private var coachmarkStep = 1

    var body: some View {
        VStack {
            Circle()
                .fill(.blue)
                .frame(width: 48, height: 48)
                .coachmarkTarget("avatar")

            Button("Add to cart") { }
                .coachmarkTarget("addToCart")
        }
        .edtsCoachmark(
            isPresented: $showCoachmark,
            currentStep: $coachmarkStep,
            steps: [
                EDTSCoachmarkStepConfig(
                    title: "Your profile",
                    description: "Tap your avatar any time to edit your profile.",
                    targetID: "avatar"
                ),
                EDTSCoachmarkStepConfig(
                    title: "Add to cart",
                    description: "Add a product to your cart from here.",
                    targetID: "addToCart"
                )
            ],
            onDismiss: { coachmarkStep = 1 }
        )
        .onAppear { showCoachmark = true }
    }
}
```

Tag every highlightable view with `.coachmarkTarget(_:)`, then attach `.edtsCoachmark(...)` once near the root of the screen — it needs to sit above every tagged view to see their positions.

### Single Step

```swift
EDTSCoachmarkStepConfig(
    title: "Title Goes Here",
    description: "The quick brown fox jumps over the lazy dog",
    targetID: "someTarget",
    btnPrimaryText: "Got it"
)
```

```swift
.edtsCoachmark(
    isPresented: $showCoachmark,
    steps: [singleStepConfig],
    type: .single
)
```

`.single` drops the icon, divider, step counter, and skip button. The action button stretches to the tooltip's full width, and tapping it dismisses the coachmark.

### Highlighting a Range

```swift
EDTSCoachmarkStepConfig(
    title: "Set your budget",
    description: "Drag either handle to set your price range.",
    targetID: "minHandle",
    endTargetID: "maxHandle"
)
```

When `endTargetID` is set, the spotlight expands to cover both targets' union, with 16pt of padding around the combined area.

### List Row Target

```swift
EDTSCoachmarkStepConfig(
    title: "Swipe to delete",
    description: "Swipe left on any row to remove it.",
    targetID: "row_3",
    spotlightPadding: 8,
    isTargetAList: true
)
```

### With Custom Fonts

```swift
EDTSCoachmarkStepConfig(
    title: "Bold title",
    titleFontName: "Helvetica",
    titleFontSize: 18,
    titleFontWeight: "bold",
    description: "Light description",
    descFontName: "Helvetica",
    descFontSize: 13,
    descFontWeight: "light",
    targetID: "addToCart"
)
```

You can also pass a ready-made SwiftUI `Font` with `titleFontStyle` / `descFontStyle`, which takes priority over the name, size, and weight.

### With Custom Buttons

```swift
EDTSCoachmarkStepConfig(
    title: "Custom buttons",
    description: "This step passes its own buttons, so their styles are used.",
    targetID: "addToCart",
    btnSecondary: EDTSButton(btnType: .secondary, btnSize: .small, text: "Skip") { },
    btnPrimary: EDTSButton(btnType: .primary, btnSize: .small, text: "Continue", bgColor: EDTSColor.orange40) { }
)
```

### With Custom Colors

```swift
.edtsCoachmark(
    isPresented: $showCoachmark,
    steps: steps,
    iconTint: EDTSColor.orange40,
    iconBgColor: EDTSColor.orange10,
    bgColor: EDTSColor.grey10
)
```

`bgColor` sets the tooltip card's own background — since the card and its arrow tail are drawn as one shape, this colors both together.

### With a Custom Step Separator

```swift
.edtsCoachmark(
    isPresented: $showCoachmark,
    steps: steps,
    stepConjunction: "of"
)
```

Leave `stepConjunction` unset to use the theme default (`"dari"` for klikIDM, `"/"` for poinku).

---

## Public Interface

### `EDTSCoachmarkStepConfig`

#### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `icon` | `Image?` | `nil` | Falls back to `Image("ic_placeholder")` from your asset catalog. Only rendered when the icon isn't hidden. |
| `title` | `String?` | `nil` | Title text. Ignored if `titleAttributed` is set |
| `titleAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `title` |
| `description` | `String?` | `nil` | Description text, clamped to 3 lines. Ignored if `descAttributed` is set |
| `descAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `description` |
| `targetID` | `String` | — (required) | The id passed to `.coachmarkTarget(_:)` on the view to spotlight |
| `endTargetID` | `String?` | `nil` | When set, the spotlight expands to cover both `targetID` and this view's union, with 16pt padding |

#### Fonts

Title and description each have their own set of four parameters. Color is not affected by these — it always comes from the theme.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleFontStyle` | `Font?` | `nil` | A ready-made SwiftUI `Font`. Takes priority over the name, size, and weight below |
| `titleFontName` | `String?` | `nil` | Custom font name. `nil` or empty uses the system font |
| `titleFontSize` | `Double?` | `nil` | Point size. `nil` or `0` uses `UIFont.systemFontSize` |
| `titleFontWeight` | `String?` | `nil` | Weight name, e.g. `"bold"`, `"semibold"`, `"light"` |
| `descFontStyle` | `Font?` | `nil` | A ready-made SwiftUI `Font`. Takes priority over the name, size, and weight below |
| `descFontName` | `String?` | `nil` | Custom font name. `nil` or empty uses the system font |
| `descFontSize` | `Double?` | `nil` | Point size. `nil` or `0` uses `UIFont.systemFontSize` |
| `descFontWeight` | `String?` | `nil` | Weight name, e.g. `"bold"`, `"semibold"`, `"light"` |

#### Buttons

| Parameter | Type | Default | Description |
|---|---|---|---|
| `btnSecondaryText` | `String?` | `"Tutup"` | Skip/dismiss button label. Not shown for `.single` type |
| `btnPrimaryText` | `String?` | `"Berikutnya"`, or `"Mengerti"` on the last step | Next/finish button label |
| `btnSecondary` | `EDTSButton?` | `nil` | Custom skip button. When set, it replaces the built-in one and `btnSecondaryText` is ignored. Its action runs first, then the coachmark dismisses |
| `btnPrimary` | `EDTSButton?` | `nil` | Custom next/finish button. When set, it replaces the built-in one and `btnPrimaryText` is ignored. Its action runs first, then the coachmark advances (or dismisses on the last step) |
| `isBtnSecondaryHide` | `Bool?` | `nil` | Explicit value always wins. If unset, the skip button auto-hides on the last step |
| `isBtnPrimaryHide` | `Bool?` | `nil` | No auto-hide behavior — only hides when you say so |

#### Spotlight & Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `contentMargin` | `CGFloat?` | `24` | Horizontal margin from the screen edge, used to size and place the tooltip |
| `offsetMargin` | `CGFloat?` | falls back to `contentMargin` | Overrides just the tooltip's horizontal x-origin, independent of its width |
| `spotlightRadius` | `CGFloat?` | `4` | Corner radius of the spotlight cutout, and (for a plain single-view target) how far the cutout is inset outward from the target's frame |
| `spotlightPadding` | `CGFloat?` | `8` | Padding used when `isTargetAList` is `true` |
| `spotlightPaddingLeft` | `CGFloat?` | falls back to `spotlightPadding` | Left-edge override for the list case |
| `spotlightPaddingRight` | `CGFloat?` | falls back to `spotlightPadding` | Right-edge override for the list case |
| `isTargetAList` | `Bool` | `false` | Applies asymmetric list-row padding instead of a uniform outward inset. No SwiftUI equivalent of iterating a list's cells — this only shapes padding around whichever single view you've tagged |
| `isHideSpotlight` | `Bool` | `false` | When `true`, no dimming/cutout is drawn for this step — just the tooltip, still positioned relative to `targetID`'s frame |

---

### `edtsCoachmark(...)` modifier

```swift
func edtsCoachmark(
    isPresented: Binding<Bool>,
    currentStep: Binding<Int> = .constant(1),
    steps: [EDTSCoachmarkStepConfig],
    type: EDTSCoachmarkType = .multiple,
    stepConjunction: String? = nil,
    iconTint: Color? = nil,
    iconBgColor: Color? = nil,
    isIconHide: Bool? = nil,
    isDividerHide: Bool? = nil,
    bgColor: Color? = nil,
    btnSecondaryTint: Color? = nil,
    btnPrimaryTint: Color? = nil,
    onDismiss: (() -> Void)? = nil
) -> some View
```

#### Presentation

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isPresented` | `Binding<Bool>` | — (required) | Shows/hides the whole overlay |
| `currentStep` | `Binding<Int>` | `.constant(1)` | 1-indexed. Advancing it is animated automatically |
| `steps` | `[EDTSCoachmarkStepConfig]` | — (required) | The step list. If empty, the overlay never renders |
| `onDismiss` | `(() -> Void)?` | `nil` | Called once, after the close animation finishes — on finishing the last step, or tapping skip. Good place to reset `currentStep` back to `1` |

#### Type & Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | `EDTSCoachmarkType` | `.multiple` | `.multiple` shows icon/divider/step-counter/skip+next; `.single` shows just a title, description, and a full-width action button |
| `stepConjunction` | `String?` | `nil` | Text between the step numbers, e.g. `"1 dari 3"`. `nil` uses the theme default |

#### Styling Overrides

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTint` | `Color?` | `nil` | Overrides the icon's tint for every step. Falls back to `EDTSColor.blue50` |
| `iconBgColor` | `Color?` | `nil` | Overrides the icon circle's background for every step. Falls back to `EDTSColor.grey20` |
| `isIconHide` | `Bool?` | `nil` | Explicit override; `nil` falls back to the theme default |
| `isDividerHide` | `Bool?` | `nil` | Explicit override; `nil` falls back to the theme default |
| `bgColor` | `Color?` | `nil` | Overrides the tooltip card's background for every step. Falls back to `EDTSColor.white`. Since the card and its arrow tail are drawn as a single merged shape, this one color fills both |
| `btnSecondaryTint` | `Color?` | `nil` | Reserved. Accepted by the modifier but not applied yet. To restyle the skip button, pass `btnSecondary` on the step |
| `btnPrimaryTint` | `Color?` | `nil` | Reserved. Accepted by the modifier but not applied yet. To restyle the next/finish button, pass `btnPrimary` on the step |

---

### `coachmarkTarget(_:)`

```swift
func coachmarkTarget(_ id: String) -> some View
```

Registers this view's bounds under `id`, so a step's `targetID` or `endTargetID` can reference it. Must be applied to any view an `.edtsCoachmark(...)` overlay elsewhere in the hierarchy needs to spotlight.

---

## Theming Defaults

Icon visibility, divider visibility, fonts, and button styling all resolve the same way: an explicit value you pass always wins; if you don't pass one, the current `EDTSColor.theme` decides.

| | klikIDM | poinku |
|---|---|---|
| Icon | shown (40×40 circle, `grey20` bg, drop shadow, `blue50` tint) | hidden by default |
| Divider | shown | hidden by default |
| Title font / color | `EDTSFont.Klik.H1` / `grey70` | `EDTSFont.Poinku.H3.Medium` / `grey80` |
| Description font / color | `EDTSFont.Klik.P2.Regular` / `grey60` | `EDTSFont.Poinku.P2.Regular` / `grey70` |
| Step counter font / color / separator | `EDTSFont.Klik.B4.Bold` / `grey60` / `"dari"` | `EDTSFont.Poinku.B3.Light` / `grey50` / `"/"` |
| Skip button | `blue50` text and border | `blue30` text and border |
| Next/finish button | `blue50` background | `blue30` background |

Both buttons use a 12pt semibold label.

---

## Animation Behavior

The coachmark animates when it appears, when the step changes, and when it is dismissed. These animations are fixed and can't be configured.

| Phase | Trigger | Animation | Duration | Notes |
|---|---|---|---|---|
| Reveal — spotlight | The overlay appears (`isPresented` becomes `true`) | Cubic Bézier `(0.215, 0.610, 0.355, 1.000)` | 0.5s | The cutout grows from a 2×2pt point at the center of the target to its full size |
| Reveal — tooltip | The overlay appears | Ease in-out | 0.2s, after a 0.5s delay | The tooltip stays hidden until the spotlight has finished growing, then fades in |
| Step change | The next/finish button advances `currentStep` | Ease in-out | 0.3s | The spotlight's rect and corner radius, the tooltip's position, and the arrow's position all move to the new target together |
| Dismiss — tooltip | Skip, or finishing the last step | Ease in-out | 0.2s | The tooltip fades out first |
| Dismiss — spotlight | 0.2s after dismissal starts, when the tooltip has faded | Cubic Bézier `(0.550, 0.055, 0.675, 0.190)` | 0.5s | The cutout shrinks back to a point at the center of the target |
| Cleanup | 0.4s after the spotlight starts shrinking | — | — | `isPresented` is set to `false` and `onDismiss` is called |

---

*For further customization, wrap `EDTSCoachmark` in your own view, or contact the UX Engineering team.*
