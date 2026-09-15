# EDTSTooltip

The `EDTSTooltip` component is a lightweight, positionable tooltip built for **SwiftUI**. It attaches to any view, points an arrow back at that view from one of four directions, and supports both long-press and tap-driven presentation, auto-dismiss, and full style customization.

## Features

- Attach a tooltip to any view via a single view modifier — no manual frame math required
- Four pointing directions (`top`, `bottom`, `leading`, `trailing`) via the shared `Position` type, with the bubble automatically clamped inside its container so it never renders off-screen
- Built-in long-press-to-show / release-to-dismiss gesture, or drive presentation yourself with a plain `Binding<Bool>` (e.g. tap-to-toggle)
- Optional auto-dismiss after a configurable duration
- Animated show/dismiss with a directional slide + fade, matching the direction the tooltip points — handled entirely inside the component, so you never need to wrap your own `isPresented` change in `withAnimation`
- Plain `String` or `AttributedString` content
- Fully configurable styling — colors, font, padding, corner radius, spacing, max width, arrow size, and drop shadow — passed directly as parameters on `.edtsTooltip(...)`
- Falls back to the design system's default type style (`EDTSFont.Klik.P2.Regular.font`) when no custom font is supplied
- Renders itself in its own overlay window, so no container modifier or setup step is required on the hosting screen
- Tapping the tooltip bubble itself dismisses it

---

## Preview

| Type | Preview |
|---|---|
| `show` | ![Show Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1788949465/tap_tooltip_cvrrw3.gif) |
| `long press` | ![Long Press Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1788949388/hold_tooltip_mwojdj.gif) |

___

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Tooltip'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and the shared `Position` type.

---

## How it renders

`EDTSTooltip` doesn't need a container modifier on your screen. Presentation is managed by an internal `EDTSTooltipPresenter` singleton, which lazily creates a transparent, pass-through `UIWindow` above the app's key window the first time any tooltip is shown, and tears that window down again once no tooltips are visible. Just attach `.edtsTooltip(...)` to the view you want the tooltip anchored to — that's the only setup needed.

---

## Usage

### Basic (long press)

```swift
@State private var showTooltip = false

Button("Long-press me") { }
    .edtsTooltip(
        isPresented: $showTooltip,
        text: "Here's a hint about this button",
        position: .top,
        minimumPressDuration: 0.35
    )
```

Passing `minimumPressDuration` wires up press-and-hold-to-show / release-to-dismiss automatically — you don't need your own gesture.

### Tap to toggle

```swift
@State private var showTooltip = false

Text("Tap to toggle")
    .onTapGesture {
        showTooltip.toggle()
    }
    .edtsTooltip(
        isPresented: $showTooltip,
        text: "Tap the button again to close me",
        position: .bottom
    )
```

Omitting `minimumPressDuration` means the tooltip is fully driven by your own `isPresented` binding — attach any gesture or logic you like to flip it. You don't need to wrap the toggle in `withAnimation`; the component animates its own appearance and dismissal regardless of how `isPresented` changes.

### Auto-dismiss

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    text: "This closes itself after 3 seconds",
    position: .top,
    autoDismissAfter: 3
)
```

### Custom style

Styling is passed as flat parameters directly on `.edtsTooltip(...)` — there's no separate style object to construct:

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    text: "Styled tooltip",
    position: .leading,
    textColor: EDTSColor.white,
    fontName: "YourCustomFont",
    fontSize: 13,
    fontWeight: "semibold",
    bgColor: EDTSColor.grey70,
    cornerRadius: 8,
    spacing: 12,
    maxWidth: 220
)
```

Or hand it a ready-made `Font` directly with `fontStyle`, which takes precedence over `fontName` / `fontSize` / `fontWeight`:

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    text: "Styled tooltip",
    position: .leading,
    fontStyle: EDTSFont.Klik.B3.Regular.font,
    bgColor: EDTSColor.grey70
)
```

If none of `fontStyle`, `fontName`, `fontSize`, or `fontWeight` are supplied, the tooltip falls back to the design system default, `EDTSFont.Klik.P2.Regular.font`.

### Attributed text

```swift
.edtsTooltip(
    isPresented: $showTooltip,
    attributedText: myAttributedString,
    position: .top
)
```

`attributedText` takes precedence over `text` when both are supplied.

---

## Public Interface

### `View.edtsTooltip(...)`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isPresented` | `Binding<Bool>` | — (required) | Drives and reflects tooltip visibility |
| `text` | `String?` | `"Text here"` | Plain-text content |
| `attributedText` | `AttributedString?` | `nil` | Attributed content; takes precedence over `text` when set |
| `textColor` | `Color` | `.white` | Text color |
| `fontStyle` | `Font?` | `nil` | A ready-made `Font` to use as-is; takes precedence over `fontName`/`fontSize`/`fontWeight` when set |
| `fontName` | `String` | `""` | Custom font name; ignored when `fontStyle` is set. Empty falls back to `.system` |
| `fontSize` | `CGFloat` | `0` | Point size; `0` or less falls back to `UIFont.systemFontSize` |
| `fontWeight` | `String?` | `nil` | Weight identifier (e.g. `"regular"`, `"medium"`, `"semibold"`, `"bold"`) resolved via `setupFontWeight(from:)` |
| `bgColor` | `Color` | `.black` | Bubble fill color |
| `cornerRadius` | `CGFloat` | `4` | Corner radius of the bubble |
| `shadowColor` | `Color` | mid-gray | Drop shadow color |
| `shadowOpacity` | `Double` | `0.18` | Drop shadow opacity |
| `shadowRadius` | `CGFloat` | `5` | Drop shadow blur radius |
| `shadowOffset` | `CGSize` | `(0, 4)` | Drop shadow offset |
| `padding` | `EdgeInsets` | `8` all sides | Inset between the bubble edge and the text |
| `spacing` | `CGFloat` | `8` | Gap between the target and the tooltip bubble (excluding the arrow) |
| `maxWidth` | `CGFloat` | screen width − 32 | Maximum width the bubble can grow to before text wraps |
| `arrowSize` | `CGSize` | `(12, 8)` | Width and height (base and length) of the pointing arrow |
| `containerMargin` | `CGFloat` | `8` | Inset kept between the bubble and the edges of its container while clamping |
| `position` | `Position` | `.top` | Which side of the target the tooltip renders on, and which side the arrow points from |
| `minimumPressDuration` | `TimeInterval?` | `nil` | When set, a long press on the target shows the tooltip and release dismisses it. When `nil`, presentation is fully controlled by `isPresented` |
| `dismissOnRelease` | `Bool` | `true` | Whether releasing a long press dismisses the tooltip (only relevant when `minimumPressDuration` is set) |
| `dismissOnReleaseDelay` | `TimeInterval` | `0.5` | Delay before dismissing after release |
| `autoDismissAfter` | `TimeInterval?` | `nil` | When set, the tooltip dismisses itself automatically after this duration, independent of user interaction |

If you need to build styling programmatically rather than passing individual parameters, the extension assembles all of the style-related parameters above into an internal `EDTSTooltipConfig` value on your behalf — you don't construct one directly.

### `Position`

The shared design-system type used to describe which side of the target the tooltip renders on:

| Case | Description |
|---|---|
| `.top` | Tooltip renders above the target; arrow points down |
| `.bottom` | Tooltip renders below the target; arrow points up |
| `.leading` | Tooltip renders before (left of) the target; arrow points right |
| `.trailing` | Tooltip renders after (right of) the target; arrow points left |

---

## Positioning & Clamping

The tooltip's bubble is placed adjacent to its target on the side given by `position`, offset by `spacing` plus the arrow's length, then clamped so it stays fully inside its container with a `containerMargin` (default `8pt`) inset on every edge. The arrow itself stays anchored to the target's center but slides along the bubble's facing edge (respecting `cornerRadius`) so it keeps pointing at the target even when the bubble has been shifted to stay on-screen — mirroring how the tooltip behaves near screen edges.

If there isn't enough room on the requested side, the tooltip automatically flips to the opposite side:
- `.top` flips to `.bottom` when there's insufficient space above but enough below (and vice versa)
- `.leading` flips to `.trailing` when the available leading space is less than the minimum side space, and vice versa

---

## Animation

Show and dismiss animation is owned entirely by the component — you never need to wrap your `isPresented` change (or `.toggle()`) in `withAnimation` yourself; it animates the same way no matter how `isPresented` changes.

**On show:** as soon as the tooltip bubble appears (or is reused for a new `id`), it animates itself in.

**On dismiss:** setting `isPresented = false` (however that happens — tapping the bubble, releasing a long press, `autoDismissAfter` firing, or your own binding logic) marks the tooltip as dismissing. That plays the exit animation below, and only after it's had time to finish does the tooltip actually get removed — it never just vanishes.

| Property | Value | Notes |
|---|---|---|
| Type | `.easeOut(duration: 0.15)` on show, `.easeIn(duration: 0.15)` on dismiss | Applied internally by the bubble itself |
| Opacity | `0 → 1` on show, `1 → 0` on dismiss | |
| Scale | `0.98 → 1` on show | Subtle pop-in |
| Offset | `4pt` in the direction opposite the arrow → `0` | e.g. a `.top` tooltip slides up 4pt into place; a `.leading` tooltip slides in from the right |

---

*For further customization, wrap `EDTSTooltip` in your own view, or contact the UX Engineering team.*
