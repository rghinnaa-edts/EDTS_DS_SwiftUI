# EDTSToast

`EDTSToast` is a SwiftUI toast message built as a plain `View`, with an `info` / `danger` state, an optional leading icon, a plain or `AttributedString` label, and optional trailing action slots (an [`EDTSButton`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSButton.md) and/or an [`EDTSButtonIcon`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSButtonIcon.md)).

---

## Preview

### 1. Toast State Variation

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Info State** | ![Toast Info State](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/toast-info_digyta.gif) |
| **Danger State** | ![Toast Danger State](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/toast-danger_go9qf9.gif) |

### 2. Toast Show Animation
| Show Animation | Preview | Top | Bottom |
| ------------------- | ------- | ------- | ------- |
| **Fade** | ![Toast Fade Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/fade_jplpho.gif) |  |  |
| **Slide** | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/slide-bottom_pdrpaa.gif) | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/slide-top_jdyhae.gif) | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/slide-bottom_pdrpaa.gif) |

### 3. Toast Dismiss Animation
| Dismiss Animation | Preview | Top | Bottom | Right |
| ------------------- | ------- | ------- | ------- | ------- |
| **Swipe** | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-right_ap3k6c.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-up_anychh.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-down_oaf87i.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-right_ap3k6c.gif) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Toast'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and on the `EDTSButton` / `EDTSButtonIcon` components, which are embedded directly when you pass them as `button` / `buttonIcon`.

---

## Basic Usage

### 1. Minimal Toast

```swift
EDTSToastManager.show(
    EDTSToast(text: "Saved successfully")
)
```

### 2. State and Icon

```swift
EDTSToastManager.show(
    EDTSToast(
        toastState: .danger,
        text: "Something went wrong",
        icon: Image(systemName: "exclamationmark.triangle.fill")
    )
)
```

### 3. With Action Button

```swift
EDTSToastManager.show(
    EDTSToast(
        toastState: .danger,
        text: "Failed to upload file",
        icon: Image(systemName: "exclamationmark.triangle.fill"),
        button: EDTSButton(
            btnType: .primary,
            btnSize: .small,
            btnState: .default,
            text: "Retry",
            textColor: EDTSColor.white,
            fontSize: 12,
            fontWeight: "semibold",
            bgColor: .clear,
            rippleColor: .clear,
            paddingTop: 0,
            paddingBottom: 0,
            paddingLeading: 0,
            paddingTrailing: 0
        ) {
            retryUpload()
        }
    )
)
```

`EDTSButton` and `EDTSButtonIcon` keep their own defaults when embedded (for example a filled blue background). To get the flat "text action" look shown above, override `bgColor` and `rippleColor` to `.clear` and set the padding to `0`.

### 4. With Dismiss Button Icon

```swift
EDTSToastManager.show(
    EDTSToast(
        text: "Item added to cart",
        icon: Image(systemName: "checkmark.circle.fill"),
        buttonIcon: EDTSButtonIcon(
            btnType: .primary,
            btnSize: .small,
            btnState: .default,
            icon: Image(systemName: "xmark"),
            iconTintColor: EDTSColor.white,
            bgColor: .clear,
            rippleColor: .clear,
            paddingTop: 0,
            paddingBottom: 0,
            paddingLeading: 0,
            paddingTrailing: 0
        ) {
            EDTSToastManager.dismiss()
        }
    ),
    duration: .indefinite
)
```

`button` and `buttonIcon` can be used together. When both are set, `button` is laid out first, followed by `buttonIcon`.

### 5. Duration

```swift
EDTSToastManager.show(EDTSToast(text: "Quick"), duration: .short)          // 1.5s
EDTSToastManager.show(EDTSToast(text: "Default"), duration: .long)         // 2.75s
EDTSToastManager.show(EDTSToast(text: "Custom"), duration: .custom(5))     // 5s
EDTSToastManager.show(EDTSToast(text: "Stays"), duration: .indefinite)     // until dismissed
```

### 6. Position, Animation, and Swipe Direction

```swift
EDTSToastManager.show(
    EDTSToast(text: "Top toast"),
    horizontalPadding: 24,
    offsetY: .top(60),
    animation: .slide,
    swipeDirection: .vertical
)
```

### 7. Attributed Label

```swift
var attributed: AttributedString {
    var str = AttributedString("Order placed. View details")
    if let range = str.range(of: "View details") {
        str[range].underlineStyle = .single
    }
    return str
}

EDTSToastManager.show(
    EDTSToast(text: nil, textAttributed: attributed)
)
```

When `textAttributed` is non-`nil`, it takes precedence and `text` is ignored (internally forced to `nil`).

### 8. Manual Dismiss

```swift
EDTSToastManager.dismiss()                  // animated
EDTSToastManager.dismiss(animated: false)   // immediate
```

### 9. Toast as a Standalone View

`EDTSToast` is a regular `View`, so it can also be embedded directly in your own layout without the manager (no auto-dismiss, positioning, or swipe handling in that case):

```swift
EDTSToast(
    toastState: .info,
    text: "This is an info toast message",
    icon: Image(systemName: "info.circle.fill")
)
```

---

## Enums

```swift
public enum EDTSToastState: String {
    case info, danger
}

public enum EDTSToastAnimation: String {
    case fade, slide
}

public enum EDTSToastDuration {
    case short
    case long
    case indefinite
    case custom(TimeInterval)
}

public enum EDTSToastSwipeDirection: String {
    case horizontal, vertical
}

public enum EDTSToastOffsetDirection {
    case top(Double)
    case bottom(Double)
}

public enum EDTSToastDismissEdge {
    case trailing
    case top
    case bottom
}
```

| Enum | Case | Meaning |
| ---- | ---- | ------- |
| `EDTSToastDuration` | `.short` | Auto-dismiss after `1.5s` |
| `EDTSToastDuration` | `.long` | Auto-dismiss after `2.75s` |
| `EDTSToastDuration` | `.indefinite` | No auto-dismiss; must be dismissed by swipe, `dismiss()`, or by showing another toast |
| `EDTSToastDuration` | `.custom(TimeInterval)` | Auto-dismiss after the given number of seconds |
| `EDTSToastOffsetDirection` | `.top(value)` / `.bottom(value)` | Anchors the toast to the top or bottom edge, `value` pt away from that edge |
| `EDTSToastDismissEdge` | `.trailing` / `.top` / `.bottom` | The edge the toast is swiped toward when dismissed. Resolved automatically from `swipeDirection` and `offsetY` (`.horizontal` → `.trailing`; `.vertical` → `.top` or `.bottom` to match the anchored edge); you normally don't pass it yourself |

---

## Properties Reference

### `EDTSToast`

#### General

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `toastState` | `EDTSToastState` | `.info` | Visual style: `info` or `danger`. Drives the default background color |

#### Text

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `text` | `String?` | `nil` | Plain text label; ignored if `textAttributed` is set. Renders an empty string when `nil` |
| `textAttributed` | `AttributedString?` | `nil` | Rich text label; takes precedence over `text` |
| `textColor` | `Color?` | `EDTSColor.white` | Text color of the label |

#### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font`; when set, it's used as-is and `fontName`, `fontSize`, and `fontWeight` are ignored entirely |
| `fontName` | `String?` | `nil` | Custom font family name. When set, it builds a `.custom` font and `fontWeight` is not applied |
| `fontSize` | `Double?` | `nil` | Custom font size; resolves to `12` if left `nil` whenever the custom-font path is active |
| `fontWeight` | `String?` | `nil` | Font weight keyword (ultralight, thin, light, regular, medium, semibold, bold, heavy, black), applied via `setupFontWeight(from:)` to the system font |

> With no custom font set, the label uses `EDTSFont.Poinku.B3.Light` (poinku) or `EDTSFont.Klik.B3.Regular` (klikIDM). Setting any of `fontName`, `fontSize`, or `fontWeight` switches away from the theme default and builds a custom font.

#### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | theme/state default (see table below) | Solid background color |
| `cornerRadius` | `Double?` | `nil` → `8` | Corner radius of the background, border, and clip shape |

#### Icon

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `icon` | `Image?` | `nil` | Icon shown before the label, rendered as a template image |
| `iconTintColor` | `Color?` | `EDTSColor.white` | Tint applied to `icon` |
| `iconSize` | `Double?` | `nil` → `16` | Width/height of the icon |
| `spacing` | `Double?` | `nil` → `8` | Spacing between the icon, label, and trailing actions in the `HStack` |

#### Action Slots

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `button` | `EDTSButton?` | `nil` | Optional text action shown after the label |
| `buttonIcon` | `EDTSButtonIcon?` | `nil` | Optional icon action shown after the label (and after `button`, if both are set) |

#### Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `borderWidth` | `Double?` | `nil` → `0` | Stroke width of the toast outline |
| `borderColor` | `Color?` | `.clear` | Stroke color of the toast outline |

#### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Double?` | `nil` → `1.0` | Multiplier applied on top of `shadowColor`'s own opacity. Pass `0` to remove the shadow |
| `shadowRadius` | `Double?` | `nil` → `4` | Shadow blur radius |
| `shadowOffset` | `CGSize?` | `nil` → `(0, 2)` | Shadow x/y offset. `nil` falls back to `(0, 2)`; pass `.zero` explicitly for no offset |
| `shadowColor` | `Color?` | `EDTSColor.grey50` at `18%` opacity | Shadow color |

#### Padding

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `paddingTop` | `Double?` | `nil` → `16` | Top content padding |
| `paddingBottom` | `Double?` | `nil` → `16` | Bottom content padding |
| `paddingLeading` | `Double?` | `nil` → `16` | Leading content padding |
| `paddingTrailing` | `Double?` | `nil` → `16` | Trailing content padding |

---

### `EDTSToastManager`

`EDTSToastManager` is a singleton whose functionality is exposed through static methods — `EDTSToastManager.show(...)` and `EDTSToastManager.dismiss(...)` — rather than an instance property. Only one toast is shown at a time.

- `EDTSToastManager` is marked `@MainActor`, so `show(...)` and `dismiss(...)` must be called from the main actor (e.g. from a SwiftUI action or `MainActor.run`).
- The toast is rendered in its own passthrough `UIWindow` (window level `.alert + 1`) created on the foreground-active `UIWindowScene` (or the first connected scene). Because of this it appears above sheets and full-screen covers, and touches outside the toast pass through to the content beneath. If no window scene is available, nothing is shown.

#### `show(_:duration:horizontalPadding:offsetY:animation:swipeDirection:)`

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `toast` | `EDTSToast` | — (required) | The toast to display |
| `duration` | `EDTSToastDuration` | `.long` | How long the toast stays before auto-dismissing |
| `horizontalPadding` | `Double` | `16.0` | Horizontal margin between the toast and the screen edges |
| `offsetY` | `EDTSToastOffsetDirection` | `.bottom(60.0)` | Which edge the toast anchors to, and its distance from that edge |
| `animation` | `EDTSToastAnimation` | `.fade` | Show/hide animation style |
| `swipeDirection` | `EDTSToastSwipeDirection` | `.horizontal` | Direction in which the user can swipe the toast away |

Calling `show` while another toast is visible cancels the pending auto-dismiss timer and replaces the current toast immediately, without a dismiss animation. The new toast is then shown with its own `animation` (it becomes visible after a short `0.05s` delay).

#### `dismiss(animated:)`

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `animated` | `Bool` | `true` | Whether the toast animates out. Also cancels any pending auto-dismiss timer |

When `animated` is `true`, the toast is removed after the hide animation finishes (`0.075s` for `.fade`, `0.25s` for `.slide`). When `false`, it is removed immediately. Calling `dismiss` while no toast is visible does nothing.

## Theme & State Color Defaults

| `toastState` | Background (klikIDM) | Background (poinku) | Text | Icon Tint |
| ------------ | -------------------- | ------------------- | ---- | --------- |
| `info` | `EDTSColor.grey60` | `EDTSColor.grey70` | `EDTSColor.white` | `EDTSColor.white` |
| `danger` | `EDTSColor.errorStrong` | `EDTSColor.errorStrong` | `EDTSColor.white` | `EDTSColor.white` |

---

## Animation

### Show / Hide Animation

| `animation` | Curve | Transition |
| ----------- | ----- | ---------- |
| `.fade` | Opacity: `.linear`, `0.15s` in / `0.075s` out. Scale: cubic-bezier `(0, 0, 0.2, 1)`, `0.15s`, on show only | Fades in while scaling up from `0.8`; fades out without scaling |
| `.slide` | `.easeInOut(duration: 0.25)` | Slides in/out by a full screen height from the anchored edge (`.top` slides from above, `.bottom` slides from below); opacity and scale are not animated |

### Swipe-to-Dismiss

| Aspect | Value |
| ------ | ----- |
| `.horizontal` | Toast can only be dragged toward the trailing edge; leftward and vertical movement is ignored |
| `.vertical` | Toast can only be dragged toward its anchored edge (down for `.bottom`, up for `.top`); the opposite direction and horizontal movement are ignored |
| Distance threshold | `40%` of the screen width (horizontal) / `50pt` (vertical). Before the screen size has been measured, a fallback of `400 × 800` is used |
| Momentum threshold | Predicted extra travel of more than `80pt` counts as a fast swipe |
| Dismiss condition | Either the distance threshold **or** the momentum threshold is met |
| Dismiss animation | `.easeInOut(duration: 0.25)`, sliding the toast fully off-screen, then removed without further animation |
| Cancel animation | `.spring(response: 0.3, dampingFraction: 0.7)`, snapping back to its resting position |

### Auto-Dismiss Timer

| Aspect | Value |
| ------ | ----- |
| Scheduling | A `DispatchWorkItem` is scheduled on the main queue for `duration.timeInterval` seconds |
| Cancellation | Cancelled by any call to `dismiss(...)`, and also by `show(...)` itself, which cancels the previous timer before presenting the new toast (it does not call `dismiss(...)` internally) |
| `.indefinite` | No timer is scheduled |

---

*For further customization, you can ask UX Engineer or wrap `EDTSToast` in a custom `View` to compose additional behavior as required.*
