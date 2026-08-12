# EDTSBadge

The `EDTSBadge` component is a small, compact label used to surface status, category, or count information inline — built for **SwiftUI**. It supports an optional leading icon, fully customizable colors, border, shadow, and padding, and a built-in skeleton loading state.

## Features

- Text label with an optional leading icon
- Independent tint for the icon, defaulting to the label color when unset
- Configurable background color, corner radius, border, and drop shadow
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
EDTSBadge(label: "New")
```

### With Icon

```swift
EDTSBadge(
    label: "Promo",
    icon: Image(systemName: "tag.fill")
)
```

The icon renders at a fixed `12x12` and is tinted with `labelColor` unless `iconTint` is set explicitly. `iconPadding` controls the gap between the icon and the label — it has no effect when there's no icon.

### With Custom Colors

```swift
EDTSBadge(
    label: "Sale",
    labelColor: EDTSColor.white,
    bgColor: EDTSColor.red50
)
```

### With Border

```swift
EDTSBadge(
    label: "Draft",
    bgColor: .clear,
    borderWidth: 1,
    borderColor: EDTSColor.grey40
)
```

### With Shadow

```swift
EDTSBadge(
    label: "Featured",
    shadowOpacity: 0.15,
    shadowOffset: CGSize(width: 0, height: 1),
    shadowRadius: 2
)
```

### Skeleton / Loading State

```swift
EDTSBadge(label: "New", isSkeleton: true)
```

When `isSkeleton` is `true`, the badge's content is replaced by the shared `edtsSkeleton` shimmer treatment, matching the badge's `cornerRadius`. The `label` value is still required even in skeleton state, since it's used to size the placeholder.

---

## Public Interface

`EDTSBadge` is configured entirely through its initializer.

### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | — (required) | Text shown in the badge. Truncates to one line, scaling down to `80%` before clipping |
| `icon` | `Image?` | `nil` | Optional leading icon, rendered at a fixed `12x12` |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `labelColor` | `Color` | `EDTSColor.grey70` | Color applied to `label`, and to `icon` when `iconTint` is unset |
| `labelFont` | `Font` | `EDTSFont.Klik.B4.Regular.font` | Font applied to `label` |

### Icon

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTint` | `Color?` | `nil` | Tint applied to `icon`. Falls back to `labelColor` when `nil` |
| `iconPadding` | `CGFloat` | `2.0` | Spacing between the icon and the label. Ignored when `icon` is `nil` (no gap is reserved) |

### Background & Border

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color` | `EDTSColor.grey20` | Fill color of the badge background |
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

## Layout Notes

- The badge is a plain `HStack` (icon + label) wrapped in padding, a minimum-size frame, a rounded background, a rounded stroke overlay, and a shadow — there's no internal animation; changes to any property apply immediately.
- Icon spacing (`iconPadding`) is only used as the `HStack`'s `spacing` value, and only when `icon` is non-`nil` — passing an `iconPadding` with no `icon` has no visible effect.

---

*For further customization, wrap `EDTSBadge` in your own view, or contact the UX Engineering team.*
