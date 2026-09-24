# EDTSAlertbox

The `EDTSAlertbox` component is an inline alert / notification banner built for **SwiftUI** that supports five semantic states.

## Features

- Five semantic states — `default`, `info`, `success`, `error`, `warning` — each with its own icon and color set
- Optional dismiss (×) button with a ripple tap effect and an animated fade + slide-out on close
- Optional action button (`EDTSButton`) rendered below the message, with a tap callback
- Compact **ribbon style** — a full-color banner variant with no action button and no dismiss button
- Fully overridable colors, fonts, sizing, padding, and shadow — theme defaults are only used when a value isn't supplied
- `onClose` and `onButtonTap` callbacks for observing user interaction

---

## Preview

### By State

| State | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.03.53_aoqzio.jpg) |
| `info` | ![Info Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632393/WhatsApp_Image_2026-06-05_at_11.04.22_mgxitu.jpg) |
| `success` | ![Success Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.04.37_df3yke.jpg) |
| `error` | ![Error Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.04.51_cdnoax.jpg) |
| `warning` | ![Warning Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632419/WhatsApp_Image_2026-06-05_at_11.05.17_ai8f1c.jpg) |

### Ribbon Style

| Type | Preview |
|---|---|
| `ribbon` | ![Ribbon Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_60/v1780640993/Screenshot_2026-06-05_at_13.29.44_pmhntt.png) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Alertbox'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

### Basic

```swift
EDTSAlertbox(text: "Your changes have been saved.")
```

With no `state` specified, the alert renders in its `default` (neutral) styling.

### With a State

```swift
EDTSAlertbox(state: .success, text: "Payment completed successfully.")
EDTSAlertbox(state: .error, text: "Something went wrong. Please try again.")
EDTSAlertbox(state: .warning, text: "Your session will expire in 5 minutes.")
EDTSAlertbox(state: .info, text: "A new version of the app is available.")
```

### Hiding the Action Button

```swift
EDTSAlertbox(state: .success, text: "Saved.", isBtnHide: true)
```

When `isBtnHide` isn't set explicitly, it falls back to a theme default.

### With a Custom Action

```swift
EDTSAlertbox(
    state: .error,
    text: "Upload failed.",
    btnText: "Retry"
) {
    retryUpload()
}
```

### Hiding the Close Button

```swift
EDTSAlertbox(text: "This message can't be dismissed.", isBtnCloseHide: true)
```

### Ribbon Style

```swift
EDTSAlertbox(state: .error, text: "Ribbon style alert", isRibbonStyle: true)
```

Ribbon style renders as a compact, full-color banner. It always hides the action button regardless of `isBtnHide`, and has no close button.

### With Attributed Text

```swift
var message: AttributedString {
    var text = AttributedString("Read our updated ")
    var link = AttributedString("Terms of Service")
    link.foregroundColor = EDTSColor.blue50
    text += link
    return text
}

EDTSAlertbox(state: .info, textAttributed: message)
```

`textAttributed` takes precedence over `text` when both are supplied.

### Custom Colors, Sizing, and Shadow

```swift
EDTSAlertbox(
    state: .warning,
    text: "Limited storage remaining.",
    iconTintColor: EDTSColor.warningStrong,
    iconSize: 20,
    bgColor: EDTSColor.warningWeak,
    borderColor: EDTSColor.warningStrong,
    cornerRadius: 12,
    shadowOpacity: 0.1,
    shadowRadius: 4,
    shadowOffset: CGSize(width: 0, height: 2)
)
```

### With onClose

```swift
EDTSAlertbox(text: "Dismiss me.") {
    print("Alert was closed")
}
```

---

## Properties

`EDTSAlertbox` is configured entirely through its initializer.

### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `state` | `EDTSAlertboxState` | `.default` | Semantic state: `.default`, `.info`, `.success`, `.error`, `.warning`. Drives the default icon and colors |
| `text` | `String?` | `nil` | Plain-text message. Ignored when `textAttributed` is set |
| `textAttributed` | `AttributedString?` | `nil` | Attributed variant of the message; when set, rendered instead of `text` |
| `icon` | `Image?` | `nil` | Custom icon to display in place of the state's default icon |
| `btnText` | `String?` | `nil` | Label for the action button. Defaults to `"Button"` when the button is shown but no text is given |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `textColor` | `Color?` | `nil` | Overrides the theme/state-derived message text color |
| `fontStyle` | `Font?` | `nil` | Explicit `Font` for the message. Takes precedence over `fontName`/`fontSize` |
| `fontName` | `String` | `""` | Custom font name, used with `fontSize` when `fontStyle` isn't set |
| `fontSize` | `CGFloat` | `.zero` | Custom font size. When `> 0` (with no `fontStyle`), builds a `.custom` or `.system` font from `fontName`/`fontWeight` |
| `fontWeight` | `String?` | `nil` | Weight used alongside `fontSize` when no `fontName` is given (defaults to `"regular"`) |

### Icon

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTintColor` | `Color?` | `nil` | Overrides the theme/state-derived icon color |
| `iconSize` | `CGFloat` | `16.0` | Width and height of the leading icon |

### Close Button

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isBtnCloseHide` | `Bool` | `false` | Hides the close (×) button when `true` |
| `btnCloseTintColor` | `Color?` | `nil` | Overrides the close button's tint color (defaults to `EDTSColor.grey50`) |
| `btnCloseSize` | `CGFloat` | `16.0` | Width and height of the close button |

### Colors

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color?` | `nil` | Overrides the theme/state-derived background color |
| `borderColor` | `Color?` | `nil` | Overrides the theme/state-derived border color |
| `borderWidth` | `CGFloat` | `1.0` | Width of the border stroke |

### Sizing & Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `8.0` | Corner radius of the alert container |
| `paddingTop` | `CGFloat?` | `nil` | When padding top is `nil`, padding falls back to a theme default: `8` on `poinku`, `12` on `klikIDM` |
| `paddingBottom` | `CGFloat?` | `nil` | When padding bottom is `nil`, padding falls back to a theme default: `8` on `poinku`, `12` on `klikIDM` |
| `paddingLeading` | `CGFloat?` | `nil` | When padding leading is `nil`, padding falls back to a theme default: `8` on `poinku`, `12` on `klikIDM` |
| `paddingTrailing` | `CGFloat?` | `nil` | When padding trailing is `nil`, padding falls back to a theme default: `8` on `poinku`, `12` on `klikIDM` |

### Behavior

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isBtnHide` | `Bool?` | `nil` | Hides the action button when `true`. When `nil`, defaults to the current theme (`true` on `poinku`, `false` on `klikIDM`). Always treated as `true` when `isRibbonStyle` is `true` |
| `isRibbonStyle` | `Bool` | `false` | Renders the compact, full-color ribbon banner instead of the default card layout. Forces the action button hidden and ignores `isBtnCloseHide` (ribbon style has no close button) |

### Shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `shadowOpacity` | `Double` | `.zero` | Opacity of the container drop shadow |
| `shadowRadius` | `CGFloat` | `.zero` | Blur radius of the container drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the container drop shadow |
| `shadowColor` | `Color?` | `nil` | Color of the container drop shadow (defaults to `.black`) |

> Note: shadow is only applied to the default card layout; the ribbon style does not render a shadow.

### Callbacks

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onClose` | `(() -> Void)?` | `nil` | Called when the close button is tapped, before the dismiss animation begins |
| `onButtonTap` | `(() -> Void)?` | `nil` | Called when the action button is tapped |

---

## Theming

Icon, text, background, and border colors are all resolved per `state`, and additionally vary by design theme (`poinku` vs `klikIDM`):

| State | Icon | Background | Border |
|---|---|---|---|
| `.default` | Info icon (grey) | `EDTSColor.grey10` | `EDTSColor.grey30` |
| `.info` | Info icon | `EDTSColor.primaryWeak` | `EDTSColor.primaryStrong` |
| `.success` | Success icon | `EDTSColor.successWeak` | `EDTSColor.successStrong` |
| `.error` | Error icon (attention/error asset differs by theme) | `EDTSColor.errorWeak` | `EDTSColor.errorStrong` |
| `.warning` | Warning icon (attention/warning asset differs by theme) | `EDTSColor.warningWeak` | `EDTSColor.warningStrong` |

---

## Animation

Triggered when the close button is tapped.

| Property | Value | Notes |
|---|---|---|
| Type | `.easeInOut(duration: 0.3)` | Applied via `withAnimation` around opacity and vertical offset |
| Opacity | `1 → 0` | Fades the alert out |
| Offset | `0 → -8pt` (y-axis) | Slides the alert slightly upward as it fades |
| Removal | After `0.3s` | The view is removed from the layout once the animation completes |

`onClose` fires immediately on tap, before the animation and removal occur.

---

*For further customization, wrap `EDTSAlertbox` in your own view, or contact the UX Engineering team.*
