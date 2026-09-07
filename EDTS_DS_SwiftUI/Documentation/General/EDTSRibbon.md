# EDTSRibbon

The `EDTSRibbon` component is a corner "tag" / ribbon badge built for **SwiftUI**. It renders a colored label with a folded-corner triangle beneath it, and ships with a `ribbon(_:verticalAlignment:offsetX:offsetY:)` view modifier for anchoring it to the corner of any view (cards, thumbnails, images, etc).

## Features

- Two gravities (`.start` / `.end`) that flip which side the ribbon hangs from, including which body corner stays sharp and which way the folded triangle points
- Solid color or two-stop linear gradient container background
- Fully customizable corner radius, text padding, text color, and font
- A `ribbon(_:)` view modifier that overlays the ribbon on any view as a corner badge, with configurable vertical alignment (`top`, `center`, `bottom`, `defaultV`) and manual offset overrides
- Works standalone (just the badge, no anchoring) or attached via the modifier

---

## Feature

| Gravity | Preview |
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

Renders the label with its default `.start` gravity, blue container, and a folded triangle beneath the leading edge.

### Gravity

```swift
EDTSRibbon(
    text: "Sale",
    gravity: .end,
    triangleColor: EDTSColor.red50,
    containerColor: EDTSColor.red30
)
```

`gravity` controls which side the ribbon "hangs" from:
- `.start` — body keeps its bottom-left corner sharp, the fold triangle sits at the bottom-left, and the view aligns its `.leading` edge in a VStack.
- `.end` — body keeps its bottom-right corner sharp, the fold triangle sits at the bottom-right, and the view aligns its `.trailing` edge.

### Gradient Background

```swift
EDTSRibbon(
    text: "Limited",
    containerStartColor: EDTSColor.blue50,
    containerEndColor: EDTSColor.blue30
)
```

When both `containerStartColor` and `containerEndColor` are supplied, the body renders a leading-to-trailing `LinearGradient` instead of the flat `containerColor`. Leave either one `nil` to fall back to the solid `containerColor`.

### Custom Sizing & Styling

```swift
EDTSRibbon(
    text: "Best Seller",
    textColor: EDTSColor.white,
    cornerRadius: 8,
    textVerticalPadding: 4,
    textHorizontalPadding: 8,
    font: EDTSFont.Klik.B2.Medium.font
)
```

### Anchoring to a View (corner badge)

```swift
Color(uiColor: .systemGray5)
    .frame(width: 100, height: 100)
    .cornerRadius(8)
    .ribbon(
        EDTSRibbon(
            text: "New",
            gravity: .start,
            triangleColor: EDTSColor.blue50,
            containerColor: EDTSColor.blue30
        ),
        verticalAlignment: .top
    )
```

The `ribbon(_:verticalAlignment:offsetX:offsetY:)` modifier overlays the ribbon on the corner matching its `gravity` (leading for `.start`, trailing for `.end`), positioned per `verticalAlignment`.

### Overriding the Offset

```swift
someView
    .ribbon(
        EDTSRibbon(text: "Hot"),
        verticalAlignment: .center,
        offsetX: -10,
        offsetY: 4
    )
```

Passing `offsetX`/`offsetY` explicitly overrides the automatically resolved offsets described below.

---

## Public Interface

### `EDTSRibbon` — Content & Styling

`EDTSRibbon` is configured entirely through its initializer.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | — (required) | Label text shown inside the ribbon body |
| `gravity` | `EDTSRibbonGravity` | `.start` | Which side the ribbon hangs from; determines which body corner stays sharp and which side the fold triangle appears on |
| `triangleColor` | `Color` | `EDTSColor.blue50` | Fill color of the folded-corner triangle beneath the body |
| `containerColor` | `Color` | `EDTSColor.blue30` | Solid background color of the body, used when `containerStartColor`/`containerEndColor` are not both set |
| `containerStartColor` | `Color?` | `nil` | Gradient start color (leading edge). Requires `containerEndColor` to also be set to take effect |
| `containerEndColor` | `Color?` | `nil` | Gradient end color (trailing edge). Requires `containerStartColor` to also be set to take effect |
| `textColor` | `Color` | `EDTSColor.white` | Color applied to `text` |
| `cornerRadius` | `CGFloat` | `4` | Corner radius applied to the rounded corners of the body (the corner nearest the fold triangle is always sharp, regardless of this value) |
| `textVerticalPadding` | `CGFloat` | `2` | Vertical padding around `text` inside the body |
| `textHorizontalPadding` | `CGFloat` | `4` | Horizontal padding around `text` inside the body |
| `font` | `Font` | `EDTSFont.Klik.B3.Medium.font` | Font applied to `text` |

### `EDTSRibbonGravity`

| Case | Description |
|---|---|
| `.start` | Ribbon hangs from the leading side. Body's bottom-left corner is sharp; fold triangle renders at the bottom-left. |
| `.end` | Ribbon hangs from the trailing side. Body's bottom-right corner is sharp; fold triangle renders at the bottom-right. |

### `EDTSRibbonVerticalAlignment`

Used only with the `ribbon(_:)` modifier, to position the badge vertically against the host view.

| Case | Description |
|---|---|
| `.top` | Anchors near the top edge of the host view |
| `.center` | Anchors vertically centered on the host view |
| `.bottom` | Anchors near the bottom edge of the host view |
| `.defaultV` | Default placement; anchors near the top with a small built-in upward nudge |

---

Overlays an `EDTSRibbon` on any view as a corner badge.

```swift
func ribbon(
    _ ribbon: EDTSRibbon,
    verticalAlignment: EDTSRibbonVerticalAlignment = .defaultV,
    offsetX: CGFloat? = nil,
    offsetY: CGFloat? = nil
) -> some View
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `ribbon` | `EDTSRibbon` | — (required) | The ribbon instance to overlay |
| `verticalAlignment` | `EDTSRibbonVerticalAlignment` | `.defaultV` | Vertical placement of the ribbon against the host view |
| `offsetX` | `CGFloat?` | `nil` | Manual horizontal offset. When `nil`, resolves automatically to `-6` for `.start` gravity or `+6` for `.end` gravity (i.e. the ribbon's triangle width), nudging the badge slightly outside the host view's edge |
| `offsetY` | `CGFloat?` | `nil` | Manual vertical offset. When `nil`, resolves automatically based on `verticalAlignment`: `8` for `.top`, `-8` for `.bottom`, `0` for `.center`/`.defaultV` |

### Placement behavior

- **Horizontal anchor**: the overlay aligns to `.leading` for `.start` gravity and `.trailing` for `.end` gravity, matching the ribbon's `gravity`.
- **Vertical anchor**: `.top`/`.defaultV` map to `.top` overlay alignment, `.bottom` maps to `.bottom`, `.center` maps to `.center`.
- Internally, the modifier applies SwiftUI `alignmentGuide` adjustments (shifting by the ribbon's triangle dimensions) so the badge visually "hangs" off the corner rather than sitting flush inside it.

---

## Rendering Details

- **Body shape** (`RibbonBodyShape`): a rounded rectangle with three rounded corners and one sharp corner. For `.start` gravity, `topLeft`/`topRight`/`bottomRight` are rounded and `bottomLeft` stays sharp. For `.end` gravity, `topLeft`/`topRight`/`bottomLeft` are rounded and `bottomRight` stays sharp.
- **Fold triangle** (`RibbonTriangleShape`): a small right triangle rendered directly beneath the body, on the same side as the body's sharp corner, giving the classic "folded ribbon/tag" look.
- The body and triangle are stacked in a `VStack` with `spacing: 0` and `.fixedSize()`, so the overall badge sizes itself to its text content.

---

*For further customization, wrap `EDTSRibbon` in your own view, or contact the UX Engineering team.*
