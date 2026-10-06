# EDTSToggle

The `EDTSToggle` component is a lightweight, animated on/off switch built for **SwiftUI**.

## Features

- Animated on/off states, with the animation curve itself configurable (`toggleAnimation`)
- Configurable track and indicator colors for both `off` and `on` states
- Optional icon swap between `off` and `on` states, with independent tint colors per state
- Two-way state binding (`@Binding<Bool>`) plus an optional `onToggle` closure for observing taps

---

| Type | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1786442330/toggle_vakt7v.gif) |
| `with label` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1786442330/toggle_with_text_chhtpa.gif) |
| `with icon` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_150/v1786442329/toggle_with_icon_mjrqgu.gif) |

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

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`).

---

## Usage

### Basic

```swift
@State private var isOn = false

EDTSToggle(isActive: $isOn)
```

`isActive` is a `Binding<Bool>`, so the toggle's state lives in the caller — update the bound `@State` value to change it programmatically.

### With Title / Description

```swift
EDTSToggle(
    isActive: $isOn,
    title: "Dark Mode",
    titleColor: EDTSColor.grey70,
    desc: "Switch to a darker color theme",
    descColor: EDTSColor.grey60
)
```

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

### Custom Corner Radius (track + indicator)

```swift
EDTSToggle(
    isActive: $isOn,
    title: "Squared toggle",
    desc: "Indicator shares the track's corner radius",
    cornerRadius: 6
)
```

`cornerRadius` is applied to **both** the track and the indicator. When left `nil`, it's derived automatically as `(indicatorSize + indicatorPadding * 2) / 2` (half the track height), producing a fully rounded pill and a circular indicator — the original look. Passing a smaller value, like `6`, squares off both shapes together.

### Custom Spacing

```swift
EDTSToggle(
    isActive: $isOn,
    title: "Dark Mode",
    desc: "Switch to a darker color theme",
    spacing: 16,     // distance between the track and the label stack
    textSpacing: 8   // distance between title and desc
)
```

### Custom Shadows

The track and the indicator each have their own, independently configurable drop shadow:

```swift
EDTSToggle(
    isActive: $isOn,
    shadowColor: .black,
    shadowOpacity: 0.1,
    shadowOffset: CGSize(width: 0, height: 2),
    shadowRadius: 4,
    indicatorShadowColor: EDTSColor.grey50,
    indicatorShadowOpacity: 0.15,
    indicatorShadowOffset: CGSize(width: 0, height: 1),
    indicatorShadowRadius: 3
)
```

### Custom Animation

```swift
EDTSToggle(
    isActive: $isOn,
    toggleAnimation: .easeInOut(duration: 0.2)
)
```

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
| `titleAttributed` | `AttributedString?` | `nil` | Attributed variant of the title; when set, rendered instead of `title` (and ignores all title font parameters below) |
| `desc` | `String?` | `nil` | Optional description label shown below the title |
| `descAttributed` | `AttributedString?` | `nil` | Attributed variant of the description; when set, rendered instead of `desc` (and ignores all desc font parameters below) |
| `icon` | `Image?` | `nil` | Image displayed inside the indicator while the toggle is `off` |
| `iconActive` | `Image?` | `nil` | Image displayed inside the indicator while the toggle is `on` |

### Text Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleColor` | `Color` | `EDTSColor.grey70` | Color applied to `title` |
| `titleFontStyle` | `Font?` | `nil` | Explicit font for the title. **Takes priority** over `titleFontName`/`titleFontSize` when set |
| `titleFontName` | `String` | `""` | Named font used for the title when `titleFontStyle` is `nil`. Ignored if empty |
| `titleFontSize` | `Double` | `0` | Point size used for the title when `titleFontStyle` is `nil`. A value `<= 0` is treated as "unset" |
| `descColor` | `Color` | `EDTSColor.grey60` | Color applied to `desc` |
| `descFontStyle` | `Font?` | `nil` | Explicit font for the description. **Takes priority** over `descFontName`/`descFontSize` when set |
| `descFontName` | `String` | `""` | Named font used for the description when `descFontStyle` is `nil`. Ignored if empty |
| `descFontSize` | `Double` | `0` | Point size used for the description when `descFontStyle` is `nil`. A value `<= 0` is treated as "unset" |

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

### Sizing & Corner Radius

| Parameter | Type | Default | Description |
|---|---|---|---|
| `trackWidth` | `Double` | `44` | Width of the track container. Independent of `indicatorSize` — no auto-derivation |
| `indicatorSize` | `Double` | `16` | Width and height of the indicator (knob), and of any icon rendered inside it |
| `indicatorPadding` | `Double` | `2` | Inset between the indicator and the edge of the track. Also used to derive the track's height (`indicatorSize + indicatorPadding * 2`) |
| `cornerRadius` | `Double?` | `nil` | Corner radius applied to **both** the track and the indicator. When `nil`, derived automatically as `(indicatorSize + indicatorPadding * 2) / 2` (half the track height) — a fully rounded pill track and a circular indicator |
| `iconPadding` | `CGFloat` | `0` | Inset applied to the icon (`icon`/`iconActive`) within its `indicatorSize x indicatorSize` frame. Larger values shrink the icon relative to the indicator |

### Spacing

| Parameter | Type | Default | Description |
|---|---|---|---|
| `spacing` | `Double` | `8` | Horizontal distance between the track and the label stack (title/desc). Only applied when a label is shown; ignored (no gap) when there's no `title`, `desc`, `titleAttributed`, or `descAttributed` |
| `textSpacing` | `Double` | `4` | Vertical distance between `title`/`titleAttributed` and `desc`/`descAttributed` within the label stack |

### Shadow — Track

| Parameter | Type | Default | Description |
|---|---|---|---|
| `shadowColor` | `Color` | `.black` | Color of the track container drop shadow |
| `shadowOpacity` | `Double` | `0.0` | Opacity of the track container drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the track container drop shadow |
| `shadowRadius` | `Double` | `0.0` | Blur radius of the track container drop shadow |

### Shadow — Indicator

| Parameter | Type | Default | Description |
|---|---|---|---|
| `indicatorShadowColor` | `Color` | `EDTSColor.grey50` | Color of the indicator (knob) drop shadow |
| `indicatorShadowOpacity` | `Double` | `0.15` | Opacity of the indicator drop shadow |
| `indicatorShadowOffset` | `CGSize` | `CGSize(width: 0, height: 1)` | Offset of the indicator drop shadow |
| `indicatorShadowRadius` | `Double` | `3` | Blur radius of the indicator drop shadow |

### Animation

| Parameter | Type | Default | Description |
|---|---|---|---|
| `toggleAnimation` | `Animation` | `.spring(response: 0.25, dampingFraction: 0.75)` | Animation applied when `isActive` changes, keyed via `.animation(_:value:)` |

---

## Animation Behavior

Triggered when `isActive` changes (via tap or externally through the binding).

| Property | Value | Notes |
|---|---|---|
| Type | `toggleAnimation` (default `.spring(response: 0.25, dampingFraction: 0.75)`) | Applied via SwiftUI's `.animation(_:value:)` modifier keyed on `isActive` |
| Indicator Position | `ZStack` alignment flips between `.leading` and `.trailing` | SwiftUI animates the alignment/padding change directly |
| Track / Indicator Color | `off` color → `on` color | Animated implicitly alongside the position change |

---

*For further customization, wrap `EDTSToggle` in your own view, or contact the UX Engineering team.*
