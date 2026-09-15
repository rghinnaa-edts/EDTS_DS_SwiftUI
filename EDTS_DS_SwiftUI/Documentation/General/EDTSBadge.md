# EDTSBadge

The `EDTSBadge` component is a small, compact label used to surface status, category, or count information inline — built for **SwiftUI**.

## Features

- Text label with an optional leading icon
- Independent tint for the icon, defaulting to the label color when unset
- Solid color or two-stop linear gradient background
- Configurable corner radius, border, and drop shadow
- Per-edge padding control (top / bottom / leading / trailing)
- Minimum tap-friendly size (`18x18`) regardless of content
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

The icon renders at a fixed `12x12` and is tinted with `textColor` unless `iconTint` is set explicitly. `iconPadding` controls the gap between the icon and the label — it has no effect when there's no icon.

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

### Skeleton / Loading State

```swift
EDTSBadge(text: "New", isSkeleton: true)
```

When `isSkeleton` is `true`, the badge's content is replaced by the shared `edtsSkeleton` shimmer treatment, matching the badge's `cornerRadius`. `text` is still required even in skeleton state, since it's used to size the placeholder.

---

## Public Interface

`EDTSBadge` is configured entirely through its initializer.

### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | — (required) | Text shown in the badge. Truncates to one line, scaling down to `80%` before clipping |
| `attributedText` | `AttributedString?` | `nil` | ⚠️ Accepted and stored, but not currently rendered — see [Known Limitations](#known-limitations) below |
| `icon` | `Image?` | `nil` | Optional leading icon, rendered at a fixed `12x12` |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `textColor` | `Color` | `EDTSColor.grey70` | Color applied to `text`, and to `icon` when `iconTint` is unset |
| `fontStyle` | `Font` | `EDTSFont.Klik.B4.Regular.font` | Font applied to `text`. This is the only font parameter that currently has an effect — see [Known Limitations](#known-limitations) |
| `fontName` | `String` | `""` | ⚠️ Accepted and stored, but not currently applied |
| `fontSize` | `CGFloat` | `0` | ⚠️ Accepted and stored, but not currently applied |
| `fontWeight` | `String?` | `nil` | ⚠️ Accepted and stored, but not currently applied |

### Icon

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTint` | `Color?` | `nil` | Tint applied to `icon`. Falls back to `textColor` when `nil` |
| `iconPadding` | `CGFloat` | `2.0` | Spacing between the icon and the label. Ignored when `icon` is `nil` (no gap is reserved) |

### Background & Border

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color` | `EDTSColor.grey20` | Solid fill color of the badge background, used when neither `bgColorStart` nor `bgColorEnd` is set |
| `bgColorStart` | `Color?` | `nil` | Gradient start color (leading edge). If set alone, the gradient still renders, fading to `.clear` |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color (trailing edge). If set alone, the gradient still renders, fading from `.clear` |
| `cornerRadius` | `CGFloat` | `9.0` | Corner radius applied to the background, border, and skeleton shape |
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
| `paddingTop` | `CGFloat` | `1.0` | Padding above the content |
| `paddingBottom` | `CGFloat` | `1.0` | Padding below the content |
| `paddingLeading` | `CGFloat` | `4.0` | Padding before the content (icon or label) |
| `paddingTrailing` | `CGFloat` | `4.0` | Padding after the content (label) |

> Note: regardless of padding and content size, the badge enforces a minimum frame of `18x18`, so very short labels (or icon-only-looking badges) still render as a comfortably sized pill rather than collapsing to the text's natural size.

### Loading State

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isSkeleton` | `Bool` | `false` | When `true`, renders a shimmering skeleton placeholder (via `edtsSkeleton`) in place of the badge's content, using the same `cornerRadius` |

---

*For further customization, wrap `EDTSBadge` in your own view, or contact the UX Engineering team.*
