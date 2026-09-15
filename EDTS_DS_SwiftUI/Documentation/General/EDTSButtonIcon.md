# EDTSButtonIcon

`EDTSButtonIcon` is a SwiftUI icon-only button built as a plain `View` (not `ButtonStyle`), reusing the same `BtnType` / `BtnSize` / `BtnState` enums, press-gesture, ripple, and gradient/solid background machinery as `EDTSButton`, but rendering a single centered icon instead of a label. It also supports an optional [`EDTSSignifier`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSSignifier.md) badge overlaid at the top-trailing corner.

---

## Preview

| Feature / Variation | Preview | Default | Disabled |
| ------------------- | ------- | ---- | -------- |
| **Primary Button** |![Primary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)|![Primary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)|![Primary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077886/button_icon_primary_disabled_qr4rqj.png)|
| **Secondary Button** |![Secondary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077894/button_icon_secondary_default_ud96d1.gif)|![Secondary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077894/button_icon_secondary_default_ud96d1.gif)|![Secondary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077896/button_icon_secondary_disabled_zjo8sa.png)|
| **Tertiary Button** |![Tertiary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077887/button_icon_tertiary_default_nhboaj.gif)|![Tertiary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077887/button_icon_tertiary_default_nhboaj.gif)|![Tertiary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077883/button_icon_tertiary_disabled_mbwpnk.png)|
| **Default** |![Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)| | | |
| **Gradient Background and With Badge** |![Button With Gradient Background And Badge](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077897/button_icon_gradient_badge_ky0axx.gif)| | | |
| **Icon Only** |![Icon Only Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077895/button_icon_only_hvdepa.gif)| | | |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Button Icon'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and the `BtnType` / `BtnSize` / `BtnState` enums declared alongside `EDTSButton`.

---

## Basic Usage

### 1. Minimal Icon Button

```swift
EDTSButtonIcon(icon: Image(systemName: "heart.fill")) {
    print("Tapped")
}
```

If `icon` is `nil`, the button falls back to `Image("ic_placeholder")` as a placeholder.

### 2. Type, Size, and State

```swift
EDTSButtonIcon(
    btnType: .secondary,
    btnSize: .medium,
    btnState: .danger,
    icon: Image(systemName: "trash")
) {
    deleteItem()
}
```

### 3. Gradient Background

```swift
EDTSButtonIcon(
    icon: Image(systemName: "star.fill"),
    bgColorStart: EDTSColor.skyblueLeading,
    bgColorEnd: EDTSColor.skyblueTrailing,
    bgColorOrientation: .vertical,
    cornerRadius: 20
) {}
```

Setting either `bgColorStart` or `bgColorEnd` switches the background to a `LinearGradient` and disables the ripple effect, exactly as in `EDTSButton`.

### 4. With a Badge

```swift
EDTSButtonIcon(
    icon: Image(systemName: "bell.fill"),
    badge: EDTSSignifier(label: "3", offsetY: 4, offsetX: 2)
) {}
```

The badge is drawn as a `.topTrailing` overlay, offset by `badge.offsetX` and `-badge.offsetY`.

---

## Properties Reference

### General

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `btnType` | `BtnType` | `.primary` | Visual style: `primary`, `secondary`, or `tertiary` |
| `btnSize` | `BtnSize` | `.large` | Controls padding, corner radius, and icon size |
| `btnState` | `BtnState` | `.default` | `default`, `danger`, or `disabled`; disabled also blocks the press gesture and action |
| `action` | `() -> Void` | — | Closure invoked on a completed tap (required) |

### Icon

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `icon` | `Image?` | `nil` | Icon rendered as a template image; falls back to `ic_placeholder` when `nil` |
| `iconTintColor` | `Color?` | theme/type default | Tint in `.default` state |
| `iconDangerTintColor` | `Color?` | theme/type default | Tint in `.danger` state |
| `iconDisabledTintColor` | `Color?` | theme/type default | Tint in `.disabled` state |
| `iconSize` | `CGFloat` | `16` (small/medium), `24` (large) | Width/height of the icon glyph |

### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | theme/type default | Solid background in `.default` state |
| `bgDangerColor` | `Color?` | theme/type default | Solid background in `.danger` state |
| `bgDisabledColor` | `Color?` | theme/type default | Solid background in `.disabled` state |
| `bgColorStart` | `Color?` | `nil` | Gradient start color; setting either start or end switches to a gradient background |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color; setting either start or end switches to a gradient background |
| `bgColorOrientation` | `Orientation?` | `.vertical` | Gradient direction: `.horizontal` (leading→trailing) or `.vertical` (top→bottom) |

### Ripple

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `rippleColor` | `Color?` | auto-resolved | Ripple tint. If unset: `iconTintColor` at 12% opacity when background is white/clear, otherwise `EDTSColor.grey70` at 12%. Forced to `.clear` when `btnState == .disabled`, and suppressed entirely for gradient backgrounds. Passing `.clear` explicitly disables ripple without opacity applied |

### Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `0` (primary), `1` (secondary/tertiary) | Stroke width of the button outline |
| `borderColor` | `Color?` | theme/type default | Border color in `.default` state |
| `borderDangerColor` | `Color?` | theme/type default | Border color in `.danger` state |
| `borderDisabledColor` | `Color?` | theme/type default | Border color in `.disabled` state |

### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Double` | `0` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `.zero` | Shadow x/y offset |
| `shadowColor` | `Color?` | `nil` | Shadow color in `.default` state |
| `shadowDangerColor` | `Color?` | `nil`, falls back to `shadowColor` | Shadow color in `.danger` state |
| `shadowDisabledColor` | `Color?` | `nil`, falls back to `shadowColor` | Shadow color in `.disabled` state |

### Padding & Shape

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `cornerRadius` | `CGFloat` | size/theme default (see table below) | Button corner radius |
| `paddingTop` | `CGFloat` | size default | Top content padding |
| `paddingBottom` | `CGFloat` | size default | Bottom content padding |
| `paddingLeading` | `CGFloat` | size default | Leading content padding |
| `paddingTrailing` | `CGFloat` | size default | Trailing content padding |

### Badge

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `badge` | `EDTSSignifier?` | `nil` | Optional signifier drawn as a `.topTrailing` overlay, offset by `(badge.offsetX, -badge.offsetY)` |

---

## Size Defaults

| `btnSize` | Corner Radius (klikIDM / poinku) | Padding (all sides) | Icon Size |
| --------- | --------------------------------- | --------------------- | --------- |
| `small` | `4` / `8` | `4` (both themes) | `16` |
| `medium` | `4` / `8` | `8` (klikIDM) / `6` (poinku) | `16` |
| `large` | `4` / `8` | `8` (both themes) | `24` |

---

## Type & State Color Defaults

| `btnType` | State | Background | Icon Tint | Border |
| --------- | ----- | ---------- | --------- | ------ |
| `primary` | default | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) | `EDTSColor.white` | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) |
| `primary` | danger | `EDTSColor.red30` | `EDTSColor.white` | `EDTSColor.red30` |
| `primary` | disabled | `EDTSColor.grey30` | `EDTSColor.white` | `EDTSColor.grey30` |
| `secondary` | default | `EDTSColor.white` | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) |
| `secondary` | danger | `EDTSColor.white` | `EDTSColor.red30` | `EDTSColor.red30` |
| `secondary` | disabled | `EDTSColor.white` | `EDTSColor.grey30` | `EDTSColor.grey30` |
| `tertiary` | default | `EDTSColor.white` | `EDTSColor.grey60` | `EDTSColor.grey60` |
| `tertiary` | danger | `EDTSColor.white` | `EDTSColor.red30` | `EDTSColor.red30` |
| `tertiary` | disabled | `EDTSColor.white` | `EDTSColor.grey30` | `EDTSColor.grey30` |

---

## Animation

### Scale Animation

| Aspect | Value |
| ------ | ----- |
| Trigger | `tempResolvedButtonState` changing from `nil` → current state (press) or state → `nil` (release/cancel) |
| Effect | `.scaleEffect(tempResolvedButtonState != nil ? 0.95 : 1.0)` |
| Timing | `.animation(.easeInOut(duration: 0.1), value: tempResolvedButtonState)` |
| Scope | Applied to the whole button view (icon, background, border, shadow, and badge all scale together) |
| Disabled state | Gesture never sets `tempResolvedButtonState`, so no scale animation occurs when `btnState == .disabled` |

### Ripple Animation

| Aspect | Value |
| ------ | ----- |
| Trigger | `DragGesture(minimumDistance: 0).onEnded` — fires at the tap/release location |
| Opacity in | `.easeOut(duration: 0.10)` → `opacity = 1` |
| Scale out | `.easeOut(duration: 0.40)` → `scale` grows from `0.01` to `maxRadius` (distance from tap point to the farthest corner of the view) |
| Opacity out | `.easeOut(duration: 0.22).delay(0.40)` → `opacity = 0`, starting as the scale animation finishes |
| Cleanup | Ripple instance removed from state after a fixed `0.62s` lifetime via `DispatchQueue.main.asyncAfter` |
| Multiplicity | Each tap adds a new `RippleInstance` (`Identifiable`), so multiple ripples can overlap and animate independently |

---

*For further customization, you can ask UX Engineer or wrap `EDTSButtonIcon` in a custom `View` to compose additional behavior as required.*
