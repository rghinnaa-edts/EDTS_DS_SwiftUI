# EDTSSkeleton

The `EDTSSkeleton` component is an animated shimmer placeholder used to indicate loading state — built for **SwiftUI**. It ships both as a standalone view (`EDTSSkeleton`) and as a view modifier (`.edtsSkeleton(active:...)`) that swaps any existing view out for a shimmer placeholder while `active` is `true`.

## Features

- Continuous left-to-right shimmer animation, looping indefinitely while active
- Configurable corner radius, including independent per-corner radii, base/highlight colors, and animation duration
- Can be used directly as a shaped placeholder view, or applied to existing content via `.edtsSkeleton(...)`
- Automatically starts/stops the shimmer loop when `isActive` changes

---

## Preview

![Skeleton Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_200/v1786440947/skeleton_sqwu98.gif)

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Skeleton'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`) and the shared `UnevenRoundedShape` used for per-corner rounding.

---

## Usage

### Basic

```swift
EDTSSkeleton()
    .frame(height: 60)
```

`EDTSSkeleton` has no intrinsic size — always constrain it with `.frame(...)` (or place it inside a layout that sizes it), the same way you'd size any shape.

### Custom Colors & Duration

```swift
EDTSSkeleton(
    cornerRadius: 12,
    baseColor: EDTSColor.grey20,
    highlightColor: EDTSColor.grey30,
    duration: 1.5
)
.frame(width: 48, height: 48)
```

`duration` is the time for one shimmer sweep across the view; the sweep then repeats indefinitely (`repeatForever(autoreverses: false)`) for as long as `isActive` is `true`.

### Per-Corner Radius

```swift
EDTSSkeleton(
    cornerRadiusTopLeft: 16,
    cornerRadiusTopRight: 16,
    cornerRadiusBottomLeft: 0,
    cornerRadiusBottomRight: 0
)
.frame(height: 60)
```

### Composing a Loading Layout

```swift
VStack(alignment: .leading, spacing: 16) {
    EDTSSkeleton(cornerRadius: 12)
        .frame(height: 60)
    HStack(spacing: 12) {
        EDTSSkeleton(cornerRadius: 8)
            .frame(width: 48, height: 48)
        VStack(alignment: .leading, spacing: 8) {
            EDTSSkeleton(cornerRadius: 6)
                .frame(height: 14)
            EDTSSkeleton(cornerRadius: 6)
                .frame(width: 120, height: 14)
        }
    }
}
```

Since `EDTSSkeleton` is just a shaped view, compose several instances with different frames to mock the layout of the content that's still loading (an avatar, a couple of text lines, etc).

### As a Modifier on Existing Content

```swift
Text("Loaded content")
    .edtsSkeleton(active: isLoading, cornerRadius: 6)
    .frame(height: 16)
```

`.edtsSkeleton(active:...)` wraps the view in a `ZStack`: the original content is set to `opacity(0)` (so it still reserves its layout size) and an `EDTSSkeleton` is overlaid on top while `active` is `true`. When `active` is `false`, only the original content is shown at full opacity.

---

## Public Interface — `EDTSSkeleton`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `8` | Uniform corner radius of the shimmer shape, used when none of the four per-corner parameters below are set |
| `cornerRadiusTopLeft` | `CGFloat?` | `nil` | Top-left corner radius override. If set alone (or with only some of the other three), the unset corners default to `0`, not to `cornerRadius` |
| `cornerRadiusTopRight` | `CGFloat?` | `nil` | Top-right corner radius override. Same fallback-to-`0` behavior as above |
| `cornerRadiusBottomLeft` | `CGFloat?` | `nil` | Bottom-left corner radius override. Same fallback-to-`0` behavior as above |
| `cornerRadiusBottomRight` | `CGFloat?` | `nil` | Bottom-right corner radius override. Same fallback-to-`0` behavior as above |
| `baseColor` | `Color` | `EDTSColor.grey20` | Base fill color of the shimmer shape |
| `highlightColor` | `Color` | `EDTSColor.grey30` | Color of the moving highlight band that sweeps across the shape |
| `duration` | `Double` | `1.5` | Duration in seconds of one shimmer sweep. The sweep repeats indefinitely while `isActive` is `true` |
| `isActive` | `Bool` | `true` | Whether the shimmer animation is running. Setting this to `false` freezes the shape at its base color |

---

## Public Interface — `.edtsSkeleton(...)` Modifier

```swift
func edtsSkeleton(
    active: Bool,
    cornerRadius: CGFloat = 8,
    cornerRadiusTopLeft: CGFloat? = nil,
    cornerRadiusTopRight: CGFloat? = nil,
    cornerRadiusBottomLeft: CGFloat? = nil,
    cornerRadiusBottomRight: CGFloat? = nil,
    baseColor: Color = EDTSColor.grey20,
    highlightColor: Color = EDTSColor.grey30,
    duration: Double = 1.5
) -> some View
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `active` | `Bool` | — (required) | When `true`, replaces the visible content with an `EDTSSkeleton` overlay sized to match the content's own frame; when `false`, shows the original content |
| `cornerRadius` | `CGFloat` | `8` | Uniform corner radius of the overlaid `EDTSSkeleton`, used when none of the four per-corner parameters below are set |
| `cornerRadiusTopLeft` | `CGFloat?` | `nil` | Forwarded to the overlaid `EDTSSkeleton`; see the per-corner behavior notes above |
| `cornerRadiusTopRight` | `CGFloat?` | `nil` | Forwarded to the overlaid `EDTSSkeleton`; see the per-corner behavior notes above |
| `cornerRadiusBottomLeft` | `CGFloat?` | `nil` | Forwarded to the overlaid `EDTSSkeleton`; see the per-corner behavior notes above |
| `cornerRadiusBottomRight` | `CGFloat?` | `nil` | Forwarded to the overlaid `EDTSSkeleton`; see the per-corner behavior notes above |
| `baseColor` | `Color` | `EDTSColor.grey20` | Base fill color of the overlaid `EDTSSkeleton` |
| `highlightColor` | `Color` | `EDTSColor.grey30` | Highlight sweep color of the overlaid `EDTSSkeleton` |
| `duration` | `Double` | `1.5` | Shimmer sweep duration of the overlaid `EDTSSkeleton` |

---

## Animation

| Property | Value | Notes |
|---|---|---|
| Type | `.linear(duration: duration).repeatForever(autoreverses: false)` | Started in `onAppear` and whenever `isActive` becomes `true` |
| Mechanism | An internal `phase` value animates from `-1` to `1`; a gradient band (`baseColor → highlightColor → baseColor`) twice the view's width is offset by `phase * width * 2` | Produces a continuous left-to-right sweep, masked to the shape (a `UnevenRoundedShape` built from the resolved corner radii) |
| Stopping | Setting `isActive` to `false` calls `withAnimation(.none) { phase = -1 }`, snapping the shimmer back to its resting position immediately rather than easing out | The shape remains visible at `baseColor`; it isn't hidden or removed |

---

*For further customization, wrap `EDTSSkeleton` in your own view, or contact the UX Engineering team.*
