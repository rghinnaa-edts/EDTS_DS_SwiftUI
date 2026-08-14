# EDTSTooltip

The `EDTSTooltip` component is a lightweight, positionable tooltip built for **SwiftUI**. It attaches to any view, points an arrow back at that view from one of four directions, and supports both long-press and tap-driven presentation, auto-dismiss, and full style customization.

## Features

- Attach a tooltip to any view via a single view modifier — no manual frame math required
- Four pointing directions (`top`, `bottom`, `leading`, `trailing`), with the bubble automatically clamped inside its container so it never renders off-screen
- Built-in long-press-to-show / release-to-dismiss gesture, or drive presentation yourself with a plain `Binding<Bool>` (e.g. tap-to-toggle)
- Optional auto-dismiss after a configurable duration
- Animated show/dismiss with a directional slide + fade, matching the direction the tooltip points
- Plain `String` or `AttributedString` content
- Fully configurable styling via `EDTSTooltipStyle`: colors, font, padding, corner radius, spacing, max width, arrow size, and drop shadow
- Tapping the tooltip bubble itself dismisses it

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Tooltip'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`).

---

## Setup

Every screen that shows a tooltip needs a container applied **once**, near the screen root. This plays the same role as `parentView` / the enclosing view controller did in the old UIKit component — it defines the coordinate space the tooltip positions and clamps itself against.

```swift
struct MyScreen: View {
    var body: some View {
        VStack {
            // ...your content, including any .edtsTooltip(...) attachments
        }
        .edtsTooltipContainer() // apply once, near the screen root
    }
}
```

If `.edtsTooltipContainer()` is missing, tooltips attached inside that tree won't render.

---

## Usage

### Basic (long press)

```swift
@State private var showTooltip = false

Button("Long-press me") { }
    .edtsTooltip(
        isPresented: $showTooltip,
        text: "Here's a hint about this button",
        direction: .top,
        minimumPressDuration: 0.35
    )
```

Passing `minimumPressDuration` wires up press-and-hold-to-show / release-to-dismiss automatically — you don't need your own gesture.

### Tap to toggle

```swift
@State private var showTooltip = false

Text("Tap to toggle")
    .onTapGesture {
        withAnimation(.easeInOut(duration: 0.15)) {
            showTooltip.toggle()
        }
    }
    .edtsTooltip(
        isPresented: $showTooltip,
        text: "Tap the button again to close me",
        direction: .bottom
    )
```

Omitting `minimumPressDuration` means the tooltip is fully driven by your own `isPresented` binding — attach any gesture or logic you like to flip it.

### Auto-dismiss

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    text: "This closes itself after 3 seconds",
    direction: .top,
    autoDismissAfter: 3
)
```

### Custom style

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    text: "Styled tooltip",
    direction: .leading,
    style: EDTSTooltipStyle(
        labelColor: EDTSColor.white,
        font: EDTSFont.Klik.B3.Regular.font,
        backgroundColor: EDTSColor.grey70,
        cornerRadius: 8,
        spacing: 12,
        maxWidth: 220
    )
)
```

### Attributed text

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    attributedText: myAttributedString,
    direction: .top
)
```

`attributedText` takes precedence over `text` when both are supplied.

---

## Public Interface

### `View.edtsTooltipContainer()`

Marks the coordinate space that hosts tooltips and renders them above the rest of the tree. Apply once, high up in the screen.

### `View.edtsTooltip(...)`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isPresented` | `Binding<Bool>` | — (required) | Drives and reflects tooltip visibility |
| `text` | `String?` | `nil` | Plain-text content |
| `attributedText` | `AttributedString?` | `nil` | Attributed content; takes precedence over `text` when set |
| `direction` | `EDTSTooltipDirection` | `.top` | Which side of the target the tooltip renders on, and which side the arrow points from |
| `style` | `EDTSTooltipStyle` | `.default` | Visual styling — see below |
| `minimumPressDuration` | `TimeInterval?` | `nil` | When set, a long press on the target shows the tooltip and release dismisses it. When `nil`, presentation is fully controlled by `isPresented` |
| `dismissOnRelease` | `Bool` | `true` | Whether releasing a long press dismisses the tooltip (only relevant when `minimumPressDuration` is set) |
| `dismissOnReleaseDelay` | `TimeInterval` | `0.5` | Delay before dismissing after release |
| `autoDismissAfter` | `TimeInterval?` | `nil` | When set, the tooltip dismisses itself automatically after this duration, independent of user interaction |

### `EDTSTooltipDirection`

| Case | Description |
|---|---|
| `.top` | Tooltip renders above the target; arrow points down |
| `.bottom` | Tooltip renders below the target; arrow points up |
| `.leading` | Tooltip renders before (left of) the target; arrow points right |
| `.trailing` | Tooltip renders after (right of) the target; arrow points left |

### `EDTSTooltipStyle`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `labelColor` | `Color` | `.white` | Text color |
| `font` | `Font` | `.system(size: 12)` | Text font |
| `backgroundColor` | `Color` | `.black` | Bubble fill color |
| `cornerRadius` | `CGFloat` | `4` | Corner radius of the bubble |
| `shadowColor` | `Color` | mid-gray | Drop shadow color |
| `shadowOpacity` | `Double` | `0.18` | Drop shadow opacity |
| `shadowRadius` | `CGFloat` | `5` | Drop shadow blur radius |
| `shadowOffset` | `CGSize` | `(0, 4)` | Drop shadow offset |
| `padding` | `EdgeInsets` | `8` all sides | Inset between the bubble edge and the text |
| `spacing` | `CGFloat` | `8` | Gap between the target and the tooltip bubble (excluding the arrow) |
| `maxWidth` | `CGFloat` | screen width − 32 | Maximum width the bubble can grow to before text wraps |
| `arrowSize` | `CGSize` | `(12, 8)` | Width and height (base and length) of the pointing arrow |

---

## Positioning & Clamping

The tooltip's bubble is placed adjacent to its target on the side given by `direction`, offset by `style.spacing` plus the arrow's length, then clamped so it stays fully inside the container marked by `.edtsTooltipContainer()` with an 8pt inset on every edge. The arrow itself stays anchored to the target's center but slides along the bubble's facing edge (respecting `cornerRadius`) so it keeps pointing at the target even when the bubble has been shifted to stay on-screen — mirroring how the tooltip behaves near screen edges.

---

## Animation

Triggered whenever `isPresented` becomes `true` or `false`.

| Property | Value | Notes |
|---|---|---|
| Type | `.easeOut(duration: 0.15)` on show, `.easeIn(duration: 0.15)` on dismiss | Applied via `withAnimation` around the state change |
| Opacity | `0 → 1` on show, `1 → 0` on dismiss | |
| Scale | `0.98 → 1` on show | Subtle pop-in |
| Offset | `4pt` in the direction opposite the arrow → `0` | e.g. a `.top` tooltip slides up 4pt into place; a `.leading` tooltip slides in from the right |

---

*For further customization, wrap `EDTSTooltip` in your own view, or contact the UX Engineering team.*
