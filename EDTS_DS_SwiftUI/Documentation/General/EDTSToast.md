# EDTSToast

`EDTSToast` is a SwiftUI toast message built as a plain `View`, with an `info` / `danger` state, an optional leading icon, a plain or `AttributedString` label, and optional trailing action slots (an [`EDTSButton`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSButton.md) and/or an [`EDTSButtonIcon`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSButtonIcon.md)). Its visual defaults are theme-aware, switching between `klikIDM` and `poinku` token sets via `EDTSColor.theme`.

Toasts are presented through the companion `EDTSToastManager` singleton and the `edtsToastHost()` view modifier, which handle placement, auto-dismiss, show/hide animation, and swipe-to-dismiss.

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

## Setup

Attach the toast host **once** at the root of your view hierarchy. Without it, `EDTSToastManager.toast.show(...)` has nowhere to render.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .edtsToastHost()
        }
    }
}
```

---

## Basic Usage

### 1. Minimal Toast

```swift
EDTSToastManager.toast.show(
    EDTSToast(text: "Saved successfully")
)
```

### 2. State and Icon

```swift
EDTSToastManager.toast.show(
    EDTSToast(
        toastState: .danger,
        text: "Something went wrong",
        iconLeading: Image(systemName: "exclamationmark.triangle.fill")
    )
)
```

### 3. With Action Button

```swift
EDTSToastManager.toast.show(
    EDTSToast(
        toastState: .danger,
        text: "Failed to upload file",
        iconLeading: Image(systemName: "exclamationmark.triangle.fill"),
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
EDTSToastManager.toast.show(
    EDTSToast(
        text: "Item added to cart",
        iconLeading: Image(systemName: "checkmark.circle.fill"),
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
            EDTSToastManager.toast.dismiss()
        }
    ),
    duration: .indefinite
)
```

`button` and `buttonIcon` can be used together. When both are set, `button` is laid out first, followed by `buttonIcon`.

### 5. Duration

```swift
EDTSToastManager.toast.show(EDTSToast(text: "Quick"), duration: .short)          // 1.5s
EDTSToastManager.toast.show(EDTSToast(text: "Default"), duration: .long)         // 2.75s
EDTSToastManager.toast.show(EDTSToast(text: "Custom"), duration: .custom(5))     // 5s
EDTSToastManager.toast.show(EDTSToast(text: "Stays"), duration: .indefinite)     // until dismissed
```

### 6. Position, Animation, and Swipe Direction

```swift
EDTSToastManager.toast.show(
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

EDTSToastManager.toast.show(
    EDTSToast(text: nil, textAttributed: attributed)
)
```

When `textAttributed` is non-`nil`, it takes precedence and `text` is ignored (internally forced to `nil`).

### 8. Manual Dismiss

```swift
EDTSToastManager.toast.dismiss()                  // animated
EDTSToastManager.toast.dismiss(animated: false)   // immediate
```

### 9. Toast as a Standalone View

`EDTSToast` is a regular `View`, so it can also be embedded directly in your own layout without the manager (no auto-dismiss, positioning, or swipe handling in that case):

```swift
EDTSToast(
    toastState: .info,
    text: "This is an info toast message",
    iconLeading: Image(systemName: "info.circle.fill")
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
    case top(CGFloat)
    case bottom(CGFloat)
}
```

| Enum | Case | Meaning |
| ---- | ---- | ------- |
| `EDTSToastDuration` | `.short` | Auto-dismiss after `1.5s` |
| `EDTSToastDuration` | `.long` | Auto-dismiss after `2.75s` |
| `EDTSToastDuration` | `.indefinite` | No auto-dismiss; must be dismissed by swipe, `dismiss()`, or by showing another toast |
| `EDTSToastDuration` | `.custom(TimeInterval)` | Auto-dismiss after the given number of seconds |
| `EDTSToastOffsetDirection` | `.top(value)` / `.bottom(value)` | Anchors the toast to the top or bottom edge, `value` pt away from that edge |

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
| `fontName` | `String` | `""` | Custom font family name. When set, it builds a `.custom` font and `fontWeight` is not applied |
| `fontSize` | `CGFloat` | `-1.0` (unset) | Custom font size; resolves to `12` if left unset whenever the custom-font path is active |
| `fontWeight` | `String?` | `nil` | Font weight keyword (ultralight, thin, light, regular, medium, semibold, bold, heavy, black), applied via `setupFontWeight(from:)` to the system font |

> With no custom font set, the label uses `EDTSFont.Poinku.B3.Light` (poinku) or `EDTSFont.Klik.B3.Regular` (klikIDM). Setting any of `fontName`, `fontSize`, or `fontWeight` switches away from the theme default and builds a custom font. Note that when `fontName` is set, `fontWeight` has no effect.

#### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | theme/state default (see table below) | Solid background color |
| `cornerRadius` | `CGFloat` | `8` | Corner radius of the background, border, and clip shape |

#### Icon Leading

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconLeading` | `Image?` | `nil` | Icon shown before the label, rendered as a template image |
| `iconTintColorLeading` | `Color?` | `EDTSColor.white` | Tint applied to `iconLeading` |
| `iconSize` | `CGFloat` | `16` | Width/height of the icon |
| `spacing` | `CGFloat` | `8` | Spacing between the icon, label, and trailing actions in the `HStack` |

#### Action Slots

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `button` | `EDTSButton?` | `nil` | Optional text action shown after the label |
| `buttonIcon` | `EDTSButtonIcon?` | `nil` | Optional icon action shown after the label (and after `button`, if both are set) |

#### Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `0` | Stroke width of the toast outline |
| `borderColor` | `Color?` | `.clear` | Stroke color of the toast outline |

#### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `1.0` | Multiplier applied on top of `shadowColor`'s own opacity. Pass `0` to remove the shadow |
| `shadowRadius` | `CGFloat` | `4` | Shadow blur radius |
| `shadowOffset` | `CGSize?` | `nil` → `(0, 2)` | Shadow x/y offset. `nil` falls back to `(0, 2)`; pass `.zero` explicitly for no offset |
| `shadowColor` | `Color?` | `EDTSColor.grey50` at `18%` opacity | Shadow color |

#### Padding

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `16` | Top content padding |
| `paddingBottom` | `CGFloat` | `16` | Bottom content padding |
| `paddingLeading` | `CGFloat` | `16` | Leading content padding |
| `paddingTrailing` | `CGFloat` | `16` | Trailing content padding |

---

### `EDTSToastManager`

`EDTSToastManager` is a singleton accessed via `EDTSToastManager.toast`. Only one toast is shown at a time.

#### `show(_:duration:horizontalPadding:offsetY:animation:swipeDirection:)`

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `toast` | `EDTSToast` | — (required) | The toast to display |
| `duration` | `EDTSToastDuration` | `.long` | How long the toast stays before auto-dismissing |
| `horizontalPadding` | `CGFloat` | `16.0` | Horizontal margin between the toast and the screen edges |
| `offsetY` | `EDTSToastOffsetDirection` | `.bottom(60.0)` | Which edge the toast anchors to, and its distance from that edge |
| `animation` | `EDTSToastAnimation` | `.fade` | Show/hide animation style |
| `swipeDirection` | `EDTSToastSwipeDirection` | `.horizontal` | Direction in which the user can swipe the toast away |

Calling `show` while another toast is visible dismisses the current one immediately (without animation) and replaces it.

#### `dismiss(animated:)`

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `animated` | `Bool` | `true` | Whether the toast animates out. Also cancels any pending auto-dismiss timer |

#### Host Modifier

| API | Description |
| --- | ----------- |
| `View.edtsToastHost()` | Overlays the current toast on top of the modified view (`zIndex 999`). Apply once at the root of your hierarchy |

---

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
| `.fade` | `.easeInOut(duration: 0.15)` | Opacity combined with a scale from `0.8` |
| `.slide` | `.easeInOut(duration: 0.25)` | Moves in/out from the anchored edge (`.top` slides from top, `.bottom` slides from bottom) |

### Swipe-to-Dismiss

| Aspect | Value |
| ------ | ----- |
| `.horizontal` | Toast can only be dragged toward the trailing edge; leftward and vertical movement is ignored |
| `.vertical` | Toast can only be dragged toward its anchored edge (down for `.bottom`, up for `.top`); the opposite direction and horizontal movement are ignored |
| Distance threshold | `40%` of screen width (horizontal) / `50pt` (vertical) |
| Momentum threshold | Predicted extra travel of more than `80pt` counts as a fast swipe |
| Dismiss condition | Either the distance threshold **or** the momentum threshold is met |
| Dismiss animation | `.easeInOut(duration: 0.2)`, sliding the toast fully off-screen, then removed without further animation |
| Cancel animation | `.interpolatingSpring(stiffness: 300, damping: 20)`, snapping back to its resting position |

### Auto-Dismiss Timer

| Aspect | Value |
| ------ | ----- |
| Scheduling | A `DispatchWorkItem` is scheduled on the main queue for `duration.timeInterval` seconds |
| Cancellation | Cancelled by any call to `dismiss(...)`, including the implicit one at the start of `show(...)` |
| `.indefinite` | No timer is scheduled |

---

*For further customization, you can ask UX Engineer or wrap `EDTSToast` in a custom `View` to compose additional behavior as required.*
