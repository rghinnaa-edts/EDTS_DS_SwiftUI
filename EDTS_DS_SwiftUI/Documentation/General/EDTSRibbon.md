# EDTSRibbon

The `EDTSRibbon` component is a corner "tag" / ribbon badge built for **SwiftUI**. It renders a colored label with a folded-corner triangle beneath it, and ships with a `ribbon(_:)` view modifier for anchoring it to the corner of any view (cards, thumbnails, images, etc).

## Features

- Two horizontal positions (`.leading` / `.trailing`) that flip which side the ribbon hangs from, including which body corner stays sharp and which way the folded triangle points
- Four vertical positions (`.top` / `.center` / `.bottom` / `.defaultV`) that control placement when anchored to a host view
- Solid color or two-stop linear gradient background
- Plain `String` or `AttributedString` content
- Fully customizable corner radius, per-edge text padding, text color, font, shadow, and offset — all configured on `EDTSRibbon` itself
- A `ribbon(_:)` view modifier that overlays the ribbon on any view as a corner badge, reading its placement entirely from the ribbon instance passed in
- Works standalone (just the badge, no anchoring) or attached via the modifier

---

## Vertical Position Preview

| Position | Preview |
|---|---|
| `top` | ![Top Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1787118442/Screenshot_2026-08-19_at_12.47.17_phynkv.png) |
| `bottom` | ![Bottom Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1787118459/Screenshot_2026-08-19_at_12.47.34_sdnvpz.png) |
| `center` | ![Center Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1787118470/Screenshot_2026-08-19_at_12.47.46_npbvn2.png) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Ribbon'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`).

---

## Usage

### Basic (standalone)

```swift
EDTSRibbon(text: "New")
```

Renders the label with its default `.leading` horizontal position, blue background, and a folded triangle beneath the leading edge.

> Note: even standalone, the badge is nudged by its auto-computed default offset (see [Offset](#offset) below) unless you pass `offsetX: 0, offsetY: 0` explicitly.

### Horizontal Position

```swift
EDTSRibbon(
    text: "Sale",
    positionHorizontal: .trailing,
    triangleColor: EDTSColor.red50,
    bgColor: EDTSColor.red30
)
```

`positionHorizontal` controls which side the ribbon "hangs" from:
- `.leading` — body keeps its bottom-left corner sharp, the fold triangle sits at the bottom-left, and the view aligns its `.leading` edge in a VStack.
- `.trailing` — body keeps its bottom-right corner sharp, the fold triangle sits at the bottom-right, and the view aligns its `.trailing` edge.

### Vertical Position

```swift
someView
    .ribbon(
        EDTSRibbon(
            text: "New",
            positionVertical: .top
        )
    )
```

`positionVertical` only affects anything when the ribbon is anchored via `.ribbon(_:)` — it controls where the badge sits relative to the host view (`.top`, `.center`, `.bottom`, or `.defaultV`, a top placement with a small built-in upward nudge). It has no visible effect on a standalone ribbon, since there's no host view to position against.

### Gradient Background

```swift
EDTSRibbon(
    text: "Limited",
    bgColorStart: EDTSColor.blue50,
    bgColorEnd: EDTSColor.blue30
)
```

The body renders a leading-to-trailing `LinearGradient` as soon as *either* `bgColorStart` or `bgColorEnd` is supplied — whichever one is left `nil` defaults to `.white`. Leave both `nil` to fall back to the solid `bgColor` instead.

### Attributed Text

```swift
var attributed = AttributedString("50% OFF")
if let range = attributed.range(of: "50%") {
    attributed[range].font = .system(size: 12, weight: .heavy)
}

EDTSRibbon(
    text: "50% OFF",
    textAttributed: attributed
)
```

`textAttributed` takes precedence over `text` when both are supplied — `text` is still required as a plain-text fallback. Note that `.font()`/`.foregroundColor()` styling from `fontStyle`/`textColor` only fills in runs of the `AttributedString` that don't already specify their own attributes;
### Custom Sizing & Styling

```swift
EDTSRibbon(
    text: "Best Seller",
    textColor: EDTSColor.white,
    cornerRadius: 8,
    paddingTop: 4,
    paddingBottom: 4,
    paddingLeading: 8,
    paddingTrailing: 8,
    fontStyle: EDTSFont.Klik.B2.Medium.font
)
```

Or build the font from individual parts instead of a ready-made `Font` — `fontStyle` defaults to `nil`, so `fontName`/`fontSize`/`fontWeight` take over automatically when it's left unset:

```swift
EDTSRibbon(
    text: "Best Seller",
    fontName: "YourCustomFont",
    fontSize: 12,
    fontWeight: "semibold"
)
```

### Custom Shadow

```swift
EDTSRibbon(
    text: "Featured",
    shadowColor: .blue,
    shadowOpacity: 0.35,
    shadowRadius: 10,
    shadowOffset: CGSize(width: 0, height: 4)
)
```

### Offset

```swift
EDTSRibbon(
    text: "New",
    offsetX: 8,
    offsetY: -4
)
```

`offsetX`/`offsetY` shift the whole badge and apply whether the ribbon is standalone or anchored via `.ribbon(_:)`. Leave them unset (`nil`, the default) and they're auto-computed from `positionHorizontal`/`positionVertical`

This auto-default is what makes the anchored examples above "hang" off the corner correctly with no extra configuration. Pass explicit values to override it — including `offsetX: 0, offsetY: 0` if you want a standalone badge to sit perfectly flush with no nudge at all.

### Anchoring to a View (corner badge)

```swift
Color(uiColor: .systemGray5)
    .frame(width: 100, height: 100)
    .cornerRadius(8)
    .ribbon(
        EDTSRibbon(
            text: "New",
            positionHorizontal: .leading,
            positionVertical: .top,
            triangleColor: EDTSColor.blue50,
            bgColor: EDTSColor.blue30
        )
    )
```

`ribbon(_:)` overlays the ribbon on the corner matching its `positionHorizontal` (leading edge for `.leading`, trailing edge for `.trailing`), positioned per its `positionVertical`. All placement and offset configuration lives on the `EDTSRibbon` instance itself — the modifier takes no parameters beyond the ribbon.

### Overriding the Offset

```swift
someView
    .ribbon(
        EDTSRibbon(
            text: "Hot",
            positionVertical: .center,
            offsetX: -10,
            offsetY: 4
        )
    )
```

---

## Public Interface

### `EDTSRibbon` — Content & Styling

`EDTSRibbon` is configured entirely through its initializer.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | — (required) | Label text shown inside the ribbon body; used as a fallback whenever `textAttributed` is `nil` |
| `textAttributed` | `AttributedString?` | `nil` | Attributed content; takes precedence over `text` when set |
| `textColor` | `Color` | `EDTSColor.white` | Color applied to `text`/`textAttributed` (runs of `textAttributed` with their own color take precedence) |
| `fontStyle` | `Font?` | `nil` | A ready-made `Font` to use as-is; takes precedence over `fontName`/`fontSize`/`fontWeight` when non-`nil` |
| `fontName` | `String` | `""` | Custom font name; only used when `fontStyle` is `nil`. Empty falls back to `.system` |
| `fontSize` | `CGFloat` | `0` | Point size; only used when `fontStyle` is `nil`. `0` or less falls back to `UIFont.systemFontSize` |
| `fontWeight` | `String?` | `nil` | Weight identifier (e.g. `"regular"`, `"medium"`, `"semibold"`, `"bold"`) resolved via `setupFontWeight(from:)`; only used when `fontStyle` is `nil` |
| `positionHorizontal` | `EDTSRibbonHPosition` | `.leading` | Which side the ribbon hangs from; determines which body corner stays sharp, which side the fold triangle appears on, and (when anchored) which edge the badge is overlaid against |
| `positionVertical` | `EDTSRibbonVPositon` | `.defaultV` | Where the badge sits relative to its host view when anchored via `.ribbon(_:)`. No visible effect standalone |
| `triangleColor` | `Color` | `EDTSColor.blue50` | Fill color of the folded-corner triangle beneath the body |
| `bgColor` | `Color` | `EDTSColor.blue30` | Solid background color of the body, used when neither `bgColorStart` nor `bgColorEnd` is set |
| `bgColorStart` | `Color?` | `nil` | Gradient start color (leading edge). If set alone (without `bgColorEnd`), the gradient still renders, fading to `.white` |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color (trailing edge). If set alone (without `bgColorStart`), the gradient still renders, fading from `.white` |
| `shadowColor` | `Color` | `.black` | Drop shadow color |
| `shadowOpacity` | `Double` | `0.15` | Drop shadow opacity |
| `shadowRadius` | `CGFloat` | `6` | Drop shadow blur radius |
| `shadowOffset` | `CGSize` | `(0, 2)` | Drop shadow offset |
| `cornerRadius` | `CGFloat` | `4` | Corner radius applied to the rounded corners of the body (the corner nearest the fold triangle is always sharp, regardless of this value) |
| `paddingTop` | `CGFloat` | `2` | Padding above `text` inside the body |
| `paddingLeading` | `CGFloat` | `4` | Padding leading `text` inside the body |
| `paddingBottom` | `CGFloat` | `2` | Padding below `text` inside the body |
| `paddingTrailing` | `CGFloat` | `4` | Padding trailing `text` inside the body |
| `offsetX` | `CGFloat?` | `nil` (auto) | Horizontal offset applied to the whole badge. When `nil`, resolves to `-6` for `.leading` or `+6` for `.trailing` `positionHorizontal` |
| `offsetY` | `CGFloat?` | `nil` (auto) | Vertical offset applied to the whole badge. When `nil`, resolves to `8` for `.top`, `-8` for `.bottom`, or `0` for `.center`/`.defaultV` `positionVertical` |

If none of `fontStyle`, `fontName`, `fontSize`, or `fontWeight` resolve to anything (i.e. `fontStyle` is `nil` and the other three are left at their defaults), the label falls back to the design system default, `EDTSFont.Klik.B3.Medium.font`.

### `EDTSRibbonHPosition`

| Case | Description |
|---|---|
| `.leading` | Ribbon hangs from the leading side. Body's bottom-left corner is sharp; fold triangle renders at the bottom-left. |
| `.trailing` | Ribbon hangs from the trailing side. Body's bottom-right corner is sharp; fold triangle renders at the bottom-right. |

### `EDTSRibbonVPositon`

Only affects anything when the ribbon is anchored via `.ribbon(_:)`; positions the badge vertically against the host view.

| Case | Description |
|---|---|
| `.top` | Anchors near the top edge of the host view |
| `.center` | Anchors vertically centered on the host view |
| `.bottom` | Anchors near the bottom edge of the host view |
| `.defaultV` | Default placement; anchors near the top with a small built-in upward nudge |

---

Overlays an `EDTSRibbon` on any view as a corner badge.

```swift
func ribbon(_ ribbon: EDTSRibbon) -> some View
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `ribbon` | `EDTSRibbon` | — (required) | The ribbon instance to overlay. Its `positionHorizontal`, `positionVertical`, `offsetX`, and `offsetY` fully determine placement — the modifier itself takes no other configuration |

### Placement behavior

- **Horizontal anchor**: the overlay aligns to `.leading` for `.leading` `positionHorizontal` and `.trailing` for `.trailing`, matching the ribbon.
- **Vertical anchor**: `.top`/`.defaultV` map to `.top` overlay alignment, `.bottom` maps to `.bottom`, `.center` maps to `.center`.
- Internally, the modifier applies SwiftUI `alignmentGuide` adjustments (shifting by the ribbon's triangle dimensions) so the badge visually "hangs" off the corner rather than sitting flush inside it, then applies the ribbon's own `offsetX`/`offsetY` on top.

---

*For further customization, wrap `EDTSRibbon` in your own view, or contact the UX Engineering team.*
