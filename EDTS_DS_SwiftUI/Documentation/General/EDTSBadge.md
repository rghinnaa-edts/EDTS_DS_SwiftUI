# EDTSBadge

The `EDTSBadge` component is a small, compact label used to surface status, category, or count information inline — built for **SwiftUI**.

## Features

- Text label with an optional leading icon
- Independent tint for the icon, defaulting to the label color when unset
- Solid color or two-stop linear gradient background
- Configurable corner radius (uniform or per-corner), border, and drop shadow
- Per-edge padding control (top / bottom / leading / trailing)
- Built-in skeleton loading state via `isSkeleton`

---

## Preview

| Type | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1786441559/badge_rscpxc.jpg) |
| `with icon` | ![With Icon Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1786441559/badge_with_icon_eoqzgl.jpg) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Badge'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and the shared `edtsSkeleton(active:cornerRadius:)` view modifier used for the loading state.

---

## Usage

### Basic

```swift
EDTSBadge(text: "New")
```

### With Icon

```swift
EDTSBadge(
    text: "Promo",
    icon: Image(systemName: "tag.fill")
)
```

### With Custom Colors

```swift
EDTSBadge(
    text: "Sale",
    textColor: EDTSColor.white,
    bgColor: EDTSColor.red50
)
```

### Gradient Background

```swift
EDTSBadge(
    text: "Limited",
    bgColorStart: EDTSColor.blueLeading,
    bgColorEnd: EDTSColor.blueTrailing
)
```

The background renders a leading-to-trailing `LinearGradient` as soon as *either* `bgColorStart` or `bgColorEnd` is supplied — whichever one is left `nil` falls back to `.clear`. Leave both `nil` to use the solid `bgColor` instead.

### With Border

```swift
EDTSBadge(
    text: "Draft",
    bgColor: .clear,
    borderWidth: 1,
    borderColor: EDTSColor.grey40
)
```

### With Shadow

```swift
EDTSBadge(
    text: "Featured",
    shadowOpacity: 0.15,
    shadowOffset: CGSize(width: 0, height: 1),
    shadowRadius: 2
)
```

### With Per-Corner Radius

```swift
EDTSBadge(
    text: "Top Rounded",
    cornerRadiusTopLeft: 12,
    cornerRadiusTopRight: 12
)
```

```swift
EDTSBadge(
    text: "One Corner",
    cornerRadiusTopLeft: 16
)
```

Leave all four corner parameters unset to use a uniform radius everywhere, controlled by `cornerRadius` alone:

```swift
EDTSBadge(text: "Uniform", cornerRadius: 12)
```

### Skeleton / Loading State

```swift
EDTSBadge(text: "New", isSkeleton: true)
```

---

## Public Interface

`EDTSBadge` is configured entirely through its initializer.

### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | — (required) | Text shown in the badge. Still required even when `textAttributed` is set, since it's used to size the placeholder |
| `textAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `text` |
| `iconLeading` | `Image?` | `nil` | Optional leading icon, rendered at a fixed `16x16` |
| `iconTrailing` | `Image?` | `nil` | Optional trialing icon, rendered at a fixed `16x16` |
| `isSkeleton` | `Bool?` | `nil` | For show or hide skeleton on the badge |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `textColor` | `Color` | `EDTSColor.grey70` | Color applied to `text`, and to `icon` when `iconTint` is unset |
| `fontStyle` | `Font?` | `nil` | Explicit font for `text`. When set, this takes priority over `fontName`/`fontSize`/`fontWeight` |
| `fontName` | `String` | `""` | Custom font family name for `text`. Ignored if `fontStyle` is set. |
| `fontSize` | `CGFloat` | `0` | Custom font size for `text`. Ignored if `fontStyle` is set. Falls back to `UIFont.systemFontSize` if `0` while `fontName` or `fontWeight` is set |
| `fontWeight` | `String?` | `nil` | Custom font weight for `text`, applied via `setupFontWeight(from:)`. Ignored if `fontStyle` is set |

### Icon

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTintColorLeading` | `Color?` | `nil` | Tint applied to `icon` leading. Falls back to `textColor` when `nil` |
| `iconTintColorTrailing` | `Color?` | `nil` | Tint applied to `icon` trailing. Falls back to `textColor` when `nil` |
| `iconSpacing` | `CGFloat` | `4.0` | Spacing between the icon and the label. Ignored when `icon` is `nil` (no gap is reserved) |
| `iconSize` | `CGFloat` | `16.0` | Size of the `icon` |

### Background & Border

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color` | `EDTSColor.grey20` | Solid fill color of the badge background, used when neither `bgColorStart` nor `bgColorEnd` is set |
| `bgColorStart` | `Color?` | `nil` | Gradient start color (leading edge). If set alone, the gradient still renders, fading to `.clear` |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color (trailing edge). If set alone, the gradient still renders, fading from `.clear` |
| `bgColorOrientation` | `Orientation?` | `.vertical` | Gradient direction: .horizontal (leading→trailing) or .vertical (top→bottom) |
| `cornerRadius` | `CGFloat` | `8.0` | Uniform corner radius applied to the background, border, and skeleton shape, unless overridden by a per-corner value below |
| `cornerRadiusTopLeft` | `CGFloat?` | `nil` | Radius of the top-left corner. If `nil` and no other corner is set, falls back to `cornerRadius`; if `nil` but another corner *is* set, falls back to `0` |
| `cornerRadiusTopRight` | `CGFloat?` | `nil` | Radius of the top-left corner. If `nil` and no other corner is set, falls back to `cornerRadius`; if `nil` but another corner *is* set, falls back to `0` |
| `cornerRadiusBottomLeft` | `CGFloat?` | `nil` | Radius of the top-left corner. If `nil` and no other corner is set, falls back to `cornerRadius`; if `nil` but another corner *is* set, falls back to `0` |
| `cornerRadiusBottomRight` | `CGFloat?` | `nil` | Radius of the top-left corner. If `nil` and no other corner is set, falls back to `cornerRadius`; if `nil` but another corner *is* set, falls back to `0` |
| `borderWidth` | `CGFloat` | `0.0` | Width of the badge's stroke border |
| `borderColor` | `Color` | `.clear` | Color of the badge's stroke border |

### Shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `shadowOpacity` | `Double` | `0.0` | Opacity of the badge's drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the badge's drop shadow |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the badge's drop shadow |
| `shadowColor` | `Color` | `.black` | Color of the badge's drop shadow |

### Padding

| Parameter | Type | Default | Description |
|---|---|---|---|
| `paddingTop` | `CGFloat` | `2.0` | Padding above the content |
| `paddingBottom` | `CGFloat` | `2.0` | Padding below the content |
| `paddingLeading` | `CGFloat` | `8.0` | Padding before the content (icon or label) |
| `paddingTrailing` | `CGFloat` | `8.0` | Padding after the content (label) |

---

*For further customization, wrap `EDTSBadge` in your own view, or contact the UX Engineering team.*
