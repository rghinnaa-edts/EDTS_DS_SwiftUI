# EDTSCoachmark

The `EDTSCoachmark` component is a multi-step spotlight overlay used for onboarding and feature walkthroughs — it dims the screen, cuts a highlighted "spotlight" hole around a target view, and shows a tooltip card beside it with a title, description, and navigation controls, built for **SwiftUI**.

## Features

- Multi-step guided tours with a `targetID`-based spotlight, driven entirely by SwiftUI preferences — no view references required
- Automatic tooltip placement above or below the target, with an arrow that tracks the target's center
- `.single` and `.multiple` step presentation types, each with their own layout
- Icon, divider, font, and button styling that adapts automatically to `EDTSColor.theme` (klikIDM / poinku), overridable per call
- Combined spotlight across two targets via `endTargetID`, for highlighting a range
- Per-step spotlight padding for list-row targets via `isTargetAList`
- Step-to-step transitions animate the spotlight and tooltip together

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
            ]
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
    targetID: "someTarget"
)
```

```swift
.edtsCoachmark(
    isPresented: $showCoachmark,
    steps: [singleStepConfig],
    type: .single
)
```

`.single` drops the icon, divider, step counter, and skip button. A close (×) icon sits next to the title instead, and the action button stretches to the tooltip's full width.

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

### With Custom Colors

```swift
.edtsCoachmark(
    isPresented: $showCoachmark,
    steps: steps,
    iconTint: EDTSColor.orange40,
    iconBgColor: EDTSColor.orange10,
    bgColor: EDTSColor.grey10,
    btnFilledTint: EDTSColor.orange40
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
| `icon` | `Image?` | `nil` | Falls back to `Image("ic_placeholder")` from your asset catalog. Only rendered when the icon isn't hidden — see [Theming](#theming-defaults) |
| `title` | `String?` | `nil` | Title text. Ignored if `titleAttributed` is set |
| `titleAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `title` |
| `description` | `String?` | `nil` | Description text, clamped to 3 lines. Ignored if `descriptionAttributed` is set |
| `descriptionAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `description` |
| `targetID` | `String` | — (required) | The id passed to `.coachmarkTarget(_:)` on the view to spotlight |
| `endTargetID` | `String?` | `nil` | When set, the spotlight expands to cover both `targetID` and this view's union, with 16pt padding |

#### Buttons

| Parameter | Type | Default | Description |
|---|---|---|---|
| `btnOutlinedText` | `String?` | `"Tutup"` | Skip/dismiss button label. Not shown for `.single` type |
| `btnFilledText` | `String?` | `"Berikutnya"`, or `"Mengerti"` on the last step | Next/finish button label |
| `isBtnOutlinedHide` | `Bool?` | `nil` | Explicit value always wins. If unset, the skip button auto-hides on the last step |
| `isBtnFilledHide` | `Bool?` | `nil` | No auto-hide behavior — only hides when you say so |

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
    btnOutlinedTint: Color? = nil,
    btnFilledTint: Color? = nil,
    onDismiss: (() -> Void)? = nil
) -> some View
```

#### Presentation

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isPresented` | `Binding<Bool>` | — (required) | Shows/hides the whole overlay |
| `currentStep` | `Binding<Int>` | `.constant(1)` | 1-indexed. Advancing it is animated automatically |
| `steps` | `[EDTSCoachmarkStepConfig]` | — (required) | The step list. If empty, the overlay never renders |
| `onDismiss` | `(() -> Void)?` | `nil` | Called once, after the close animation finishes — on finishing the last step, tapping skip, or tapping the `.single` type's close icon. Good place to reset `currentStep` back to `1` |

#### Type & Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | `EDTSCoachmarkType` | `.multiple` | `.multiple` shows icon/divider/step-counter/skip+next; `.single` shows just a title, close icon, description, and a full-width action button |
| `stepConjunction` | `String?` | `nil` | Text between the step numbers, e.g. `"1 dari 3"`. `nil` uses the theme default |

#### Styling Overrides

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTint` | `Color?` | `nil` | Overrides the icon's tint for every step. Falls back to `EDTSColor.blue50` |
| `iconBgColor` | `Color?` | `nil` | Overrides the icon circle's background for every step. Falls back to `EDTSColor.grey20` |
| `isIconHide` | `Bool?` | `nil` | Explicit override; `nil` falls back to the theme default — see [Theming](#theming-defaults) |
| `isDividerHide` | `Bool?` | `nil` | Explicit override; `nil` falls back to the theme default — see [Theming](#theming-defaults) |
| `bgColor` | `Color?` | `nil` | Overrides the tooltip card's background for every step. Falls back to `EDTSColor.white`. Since the card and its arrow tail are drawn as a single merged shape, this one color fills both |
| `btnOutlinedTint` | `Color?` | `nil` | Overrides *both* the skip button's text color and border color for every step |
| `btnFilledTint` | `Color?` | `nil` | Overrides the next/finish button's background color for every step |

---

### `coachmarkTarget(_:)`

```swift
func coachmarkTarget(_ id: String) -> some View
```

Registers this view's bounds under `id`, so a step's `targetID` or `endTargetID` can reference it. Must be applied to any view an `.edtsCoachmark(...)` overlay elsewhere in the hierarchy needs to spotlight.

---

## Theming Defaults

Icon visibility, divider visibility, fonts, and skip-button styling all resolve the same way: an explicit value you pass always wins; if you don't pass one, the current `EDTSColor.theme` decides.

| | klikIDM | poinku |
|---|---|---|
| Icon | shown (40×40 circle, `grey20` bg, drop shadow, `blue50` tint) | hidden by default |
| Divider | shown | hidden by default |
| Title font / color | `EDTSFont.Klik.H1` / `grey70` | `EDTSFont.Poinku.H3.Medium` / `grey80` |
| Description font / color | `EDTSFont.Klik.P2.Regular` / `grey60` | `EDTSFont.Poinku.P2.Regular` / `grey70` |
| Step counter font / color / separator | `EDTSFont.Klik.B4.Bold` / `grey60` / `"dari"` | `EDTSFont.Poinku.B3.Light` / `grey50` / `"/"` |
| Skip button | `grey30` border, `grey60` text | no visible border, `blue30` text |

---

*For further customization, wrap `EDTSCoachmark` in your own view, or contact the UX Engineering team.*
