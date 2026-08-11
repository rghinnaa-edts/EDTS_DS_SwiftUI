# EDTSToggle

The `EDTSToggle` component is a lightweight, animated on/off switch built for **SwiftUI**. It supports a sliding indicator with spring-based animation, optional state-specific icons, fully customizable sizing and colors, and optional title/description labels.

## Features

- Animated on/off states with spring-based indicator transition
- Configurable track and indicator colors for both `off` and `on` states
- Optional icon swap between `off` and `on` states, with independent tint colors per state
- Adjustable sizing: track width, indicator size, and indicator padding
- Configurable drop shadow on the track container
- Optional title / description labels rendered alongside the track, with independent font/color styling and `AttributedString` support
- Two-way state binding (`@Binding<Bool>`) plus an optional `onToggle` closure for observing taps

---

| Type | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1782803702/WhatsApp_GIF_2026-06-30_at_14.03.36_mfqfss.gif) |
| `with icon` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1782803703/WhatsApp_GIF_2026-06-30_at_14.05.08_rkqjry.gif) |

---
 
## Installation
 
Add to your `Podfile`:
 
```ruby
pod 'EDTS_DS_SwiftUI/Toggle'
```
 
Then import it wherever you use the component:
 
```swift
import EDTS_DS_SwiftUI
```
 
This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`)
 
---

## Usage

### Basic

```swift
@State private var isOn = false

EDTSToggle(isActive: $isOn)
```

`isActive` is a `Binding<Bool>`, so the toggle's state lives in the caller — update the bound `@State` value to change it programmatically.

### With Active State Colors

```swift
EDTSToggle(
    isActive: $isOn,
    trackTintColor: EDTSColor.grey30,
    trackActiveTintColor: EDTSColor.blue50
)
```

### With Icons

```swift
EDTSToggle(
    isActive: $isOn,
    icon: Image("ic_moon"),
    iconActive: Image("ic_sun"),
    iconTintColor: EDTSColor.white,
    iconActiveTintColor: EDTSColor.white,
    iconPadding: 2
)
```

### Custom Sizing

```swift
EDTSToggle(
    isActive: $isOn,
    trackWidth: 52,
    indicatorSize: 20,
    indicatorPadding: 3
)
```

`trackWidth` and `indicatorSize` are independent, plain stored properties — setting one has no effect on the other.

### With Title / Description

```swift
EDTSToggle(
    isActive: $isOn,
    title: "Dark Mode",
    titleColor: EDTSColor.grey70,
    titleFont: EDTSFont.Klik.B2.Medium.font,
    desc: "Switch to a darker color theme",
    descColor: EDTSColor.grey60,
    descFont: EDTSFont.Klik.B3.Regular.font
)
```

Labels only appear when `title`, `desc`, `titleAttributed`, or `descAttributed` is non-empty/non-nil; the track-to-label spacing is `8pt` when a label is shown and `0` otherwise.

### With onToggle Closure

```swift
EDTSToggle(isActive: $isOn) { newValue in
    print("Toggle is now \(newValue)")
}
```

---

## Public Interface

`EDTSToggle` is configured entirely through its initializer.

### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String?` | `nil` | Optional title label shown next to the track |
| `titleAttributed` | `AttributedString?` | `nil` | Attributed variant of the title; when set, rendered instead of `title` |
| `desc` | `String?` | `nil` | Optional description label shown below the title |
| `descAttributed` | `AttributedString?` | `nil` | Attributed variant of the description; when set, rendered instead of `desc` |
| `icon` | `Image?` | `nil` | Image displayed inside the indicator while the toggle is `off` |
| `iconActive` | `Image?` | `nil` | Image displayed inside the indicator while the toggle is `on` |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleColor` | `Color` | `EDTSColor.grey70` | Color applied to `title` |
| `titleFont` | `Font` | `EDTSFont.Klik.B2.Medium.font` | Font applied to `title` |
| `descColor` | `Color` | `EDTSColor.grey60` | Color applied to `desc` |
| `descFont` | `Font` | `EDTSFont.Klik.B3.Regular.font` | Font applied to `desc` |

> Note: `titleColor`/`titleFont`/`descColor`/`descFont` have no effect when `titleAttributed`/`descAttributed` is used, since those render as-is via `Text(_:)`.

### State

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isActive` | `Binding<Bool>` | — (required) | Current on/off state of the toggle. Tapping the track toggles this binding and animates the transition |

### Colors

| Parameter | Type | Default | Description |
|---|---|---|---|
| `trackTintColor` | `Color` | `EDTSColor.grey30` | Track background color while `off` |
| `trackActiveTintColor` | `Color` | `EDTSColor.blue50` | Track background color while `on` |
| `indicatorTintColor` | `Color` | `EDTSColor.white` | Indicator (knob) color while `off` |
| `indicatorActiveTintColor` | `Color` | `EDTSColor.white` | Indicator (knob) color while `on` |
| `iconTintColor` | `Color` | `EDTSColor.white` | Tint color applied to `icon` while `off` |
| `iconActiveTintColor` | `Color` | `EDTSColor.white` | Tint color applied to `iconActive` while `on` |

### Sizing

| Parameter | Type | Default | Description |
|---|---|---|---|
| `trackWidth` | `CGFloat` | `44` | Width of the track container. Independent of `indicatorSize` — no auto-derivation |
| `indicatorSize` | `CGFloat` | `16` | Width and height of the indicator (knob), and of any icon rendered inside it |
| `indicatorPadding` | `CGFloat` | `2` | Inset between the indicator and the edge of the track. Also used to derive the track's height (`indicatorSize + indicatorPadding * 2`) |
| `cornerRadius` | `CGFloat?` | `nil` | Corner radius applied to the track. When `nil`, it's derived automatically as `(indicatorSize + indicatorPadding * 2) / 2` (i.e. half the track height), producing a fully rounded pill |
| `iconPadding` | `CGFloat` | `0` | Inset applied to the icon (`icon`/`iconActive`) within its `indicatorSize x indicatorSize` frame. Larger values shrink the icon relative to the indicator |

### Shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `shadowOpacity` | `Double` | `0.0` | Opacity of the track container drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the track container drop shadow |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the track container drop shadow |
| `shadowColor` | `Color` | `.black` | Color of the track container drop shadow |

> Note: the indicator (knob) itself always renders with a fixed built-in shadow (`opacity: 0.15`, `offset: (0, 1)`, `radius: 3.0`, `color: EDTSColor.grey50`), separate from the configurable track shadow above.

---

## Animation

Triggered when `isActive` changes (via tap or externally through the binding).

| Property | Value | Notes |
|---|---|---|
| Type | `.spring(response: 0.25, dampingFraction: 0.75)` | Applied via SwiftUI's `.animation(_:value:)` modifier keyed on `isActive` |
| Indicator Position | `ZStack` alignment flips between `.leading` and `.trailing` | SwiftUI animates the alignment/padding change directly |
| Track / Indicator Color | `off` color → `on` color | Animated implicitly alongside the position change |

---

*For further customization, wrap `EDTSToggle` in your own view, or contact the UX Engineering team.*
