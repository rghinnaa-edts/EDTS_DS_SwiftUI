# EDTSSkeleton

The `EDTSSkeleton` component is an animated shimmer placeholder used to indicate loading state — built for **SwiftUI**. It ships both as a standalone view (`EDTSSkeleton`) and as a view modifier (`.edtsSkeleton(active:...)`) that swaps any existing view out for a shimmer placeholder while `active` is `true`.

## Features

- Continuous left-to-right shimmer animation, looping indefinitely while active
- Configurable corner radius, base/highlight colors, and animation duration
- Can be used directly as a shaped placeholder view, or applied to existing content via `.edtsSkeleton(...)`
- Automatically starts/stops the shimmer loop when `isActive` changes
- Hidden from accessibility (`accessibilityHidden`), since it's a purely visual loading indicator
- Includes internal iOS-version compatibility shims for `onChange` and `accessibilityHidden`, so it works on older deployment targets

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

This relies on the design token types already available in the pod (`EDTSColor`).

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

`.edtsSkeleton(active:...)` wraps the view in a `ZStack`: the original content is set to `opacity(0)` (so it still reserves its layout size) and an `EDTSSkeleton` is overlaid on top while `active` is `true`. When `active` is `false`, only the original content is shown at full opacity. This is the preferred way to skeleton-ize existing UI, since the placeholder automatically matches the content's frame instead of needing a manually-sized `EDTSSkeleton()`.

---

## Public Interface — `EDTSSkeleton`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `8` | Corner radius of the shimmer shape |
| `baseColor` | `Color` | `EDTSColor.grey20` | Base fill color of the shimmer shape |
| `highlightColor` | `Color` | `EDTSColor.grey30` | Color of the moving highlight band that sweeps across the shape |
| `duration` | `Double` | `1.5` | Duration in seconds of one shimmer sweep. The sweep repeats indefinitely while `isActive` is `true` |
| `isActive` | `Bool` | `true` | Whether the shimmer animation is running. Setting this to `false` freezes the shape at its base color (see [Animation](#animation) below) |

---

## Public Interface — `.edtsSkeleton(...)` Modifier

```swift
func edtsSkeleton(
    active: Bool,
    cornerRadius: CGFloat = 8,
    baseColor: Color = EDTSColor.grey20,
    highlightColor: Color = EDTSColor.grey30,
    duration: Double = 1.5
) -> some View
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `active` | `Bool` | — (required) | When `true`, replaces the visible content with an `EDTSSkeleton` overlay sized to match the content's own frame; when `false`, shows the original content |
| `cornerRadius` | `CGFloat` | `8` | Corner radius of the overlaid `EDTSSkeleton` |
| `baseColor` | `Color` | `EDTSColor.grey20` | Base fill color of the overlaid `EDTSSkeleton` |
| `highlightColor` | `Color` | `EDTSColor.grey30` | Highlight sweep color of the overlaid `EDTSSkeleton` |
| `duration` | `Double` | `1.5` | Shimmer sweep duration of the overlaid `EDTSSkeleton` |

> Note: the modifier always passes `isActive: true` to the internal `EDTSSkeleton` it creates — the shimmer only starts looping once `active` makes the skeleton visible in the first place, so there's no separate "visible but frozen" state reachable through the modifier the way there is with the standalone view's `isActive` parameter.

---

## Animation

| Property | Value | Notes |
|---|---|---|
| Type | `.linear(duration: duration).repeatForever(autoreverses: false)` | Started in `onAppear` and whenever `isActive` becomes `true` |
| Mechanism | An internal `phase` value animates from `-1` to `1`; a gradient band (`baseColor → highlightColor → baseColor`) twice the view's width is offset by `phase * width * 2` | Produces a continuous left-to-right sweep, masked to the shape's rounded rectangle |
| Stopping | Setting `isActive` to `false` calls `withAnimation(.none) { phase = -1 }`, snapping the shimmer back to its resting position immediately rather than easing out | The shape remains visible at `baseColor`; it isn't hidden or removed |

---

## Compatibility

`EDTSSkeleton` includes two private fallback helpers so it can be used below the platform's native availability for certain modifiers:

- **`onChangeCompat`** — uses `.onChange(of:perform:)` on iOS 14+, and falls back to `.onReceive(Just(value).removeDuplicates())` (via Combine) on earlier versions, to react to `isActive` changes.
- **`accessibilityHiddenCompat`** — uses `.accessibilityHidden(_:)` on iOS 14 / macOS 11 / tvOS 14 / watchOS 7+, and falls back to the older `.accessibility(hidden:)` modifier otherwise.

Both are internal implementation details — consumers don't need to call them directly, but they're why `EDTSSkeleton` can be dropped into projects with a lower minimum deployment target without extra `#available` handling at the call site.

---

## Accessibility

`EDTSSkeleton` is always marked `accessibilityHidden(true)`, since it's a transient visual loading state with no meaningful content for assistive technologies to announce.

---

*For further customization, wrap `EDTSSkeleton` in your own view, or contact the UX Engineering team.*
