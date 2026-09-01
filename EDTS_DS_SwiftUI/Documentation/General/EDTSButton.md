# EDTSButton

`EDTSButton` is a SwiftUI button built as a plain `View` (not `ButtonStyle`), combining a `DragGesture(minimumDistance: 0)` for press handling with a custom ripple effect, gradient/solid background support, and per-state (`default` / `danger` / `disabled`) color resolution across label, icon, border, and shadow. Its visual defaults are theme-aware, switching between `klikIDM` and `poinku` token sets via `EDTSColor.theme`.

## Enums

```swift
public enum BtnState: String {
    case `default`, danger, disabled
}

public enum BtnType: String {
    case primary, secondary, tertiary
}

public enum BtnSize: String {
    case small, medium, large
}
```

---

## Preview

| Feature / Variation | Preview | Default | Danger | Disabled |
| ------------------- | ------- | ---- | ------ | -------- |
| **Primary Button** |![Primary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077893/button_primary_large_default_fbqfti.gif)|![Primary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077893/button_primary_large_default_fbqfti.gif)|![Primary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077893/button_primary_large_danger_z6wpft.gif)|![Primary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077882/button_primary_large_disabled_mdkixh.png)|
| **Secondary Button** |![Secondary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077894/button_secondary_medium_default_ytxwtt.gif)|![Secondary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077894/button_secondary_medium_default_ytxwtt.gif)|![Secondary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077885/button_secondary_medium_danger_cwutnq.gif)|![Secondary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077884/button_secondary_medium_disabled_sijvbq.png)|
| **Tertiary Button** |![Tertiary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077889/button_tertiary_small_default_thclgc.gif)|![Tertiary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077889/button_tertiary_small_default_thclgc.gif)|![Tertiary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077888/button_tertiary_small_danger_dqkebl.gif)|![Tertiary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077881/button_tertiary_small_disabled_k1rw1p.png)|
| **Default** |![Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077891/button_default_op2mcu.gif)| | | |
| **Gradient Background** |![Button With Gradient Background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077883/button_gradient_ep3tgs.gif)| | | |
| **Text Button** |![Text Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077879/button_text_ix8nnr.gif)| | | |

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Button'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`)

---

## Basic Usage

### 1. Minimal Button

```swift
EDTSButton(label: "Continue") {
    print("Tapped")
}
```

### 2. Type, Size, and State

```swift
EDTSButton(
    btnType: .secondary,
    btnSize: .medium,
    btnState: .danger,
    label: "Delete"
) {
    deleteItem()
}
```

### 3. Icons

```swift
EDTSButton(
    label: "Favorite",
    iconLeading: Image(systemName: "star.fill"),
    iconTrailing: Image(systemName: "chevron.right")
) {}
```

### 4. Gradient Background

```swift
EDTSButton(
    label: "Gradient",
    bgColorStart: EDTSColor.skyblueLeading,
    bgColorEnd: EDTSColor.skyblueTrailing,
    bgColorOrientation: .vertical,
    cornerRadius: 20
) {}
```

Setting either `bgColorStart` or `bgColorEnd` switches the background to a `LinearGradient` and disables the ripple effect (ripple only renders over a solid background).

### 5. Attributed Label

```swift
var attributed: AttributedString {
    var str = AttributedString("Terms & Conditions")
    str.underlineStyle = .single
    return str
}

EDTSButton(label: nil, labelAttributed: attributed) {}
```

When `labelAttributed` is non-`nil`, it takes precedence and `label` is ignored (internally forced to `nil`).

---

## Properties Reference

### General

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `btnType` | `BtnType` | `.primary` | Visual style: `primary`, `secondary`, or `tertiary` |
| `btnSize` | `BtnSize` | `.large` | Controls padding, corner radius, icon size, and font style |
| `btnState` | `BtnState` | `.default` | `default`, `danger`, or `disabled`; disabled also blocks the press gesture and action |
| `action` | `() -> Void` | — | Closure invoked on a completed tap (required) |

### Label

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `label` | `String?` | `"Button"` | Plain text label; ignored if `labelAttributed` is set |
| `labelAttributed` | `AttributedString?` | `nil` | Rich text label; takes precedence over `label` |
| `labelColor` | `Color?` | theme/type default | Label color in `.default` state |
| `labelDangerColor` | `Color?` | theme/type default | Label color in `.danger` state |
| `labelDisabledColor` | `Color?` | theme/type default | Label color in `.disabled` state |

### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font`; when set, it's used as-is and `fontName`, `fontSize`, and `fontWeight` are ignored entirely |
| `fontName` | `String` | `System font` | Custom font name (falls back to system font if not found) |
| `fontSize` | `CGFloat` | `Size-dependent` | Font size for title text |
| `fontWeight` | `String?` | `Size-dependent` | Font weight (ultralight, thin, light, regular, medium, semibold, bold, heavy, black) |

### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | theme/type default | Solid background in `.default` state |
| `bgDangerColor` | `Color?` | theme/type default | Solid background in `.danger` state |
| `bgDisabledColor` | `Color?` | theme/type default | Solid background in `.disabled` state |
| `bgColorStart` | `Color?` | `nil` | Gradient start color; setting either start or end switches to a gradient background |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color |
| `bgColorOrientation` | `Orientation?` | `.vertical` | Gradient direction: `.horizontal` (leading→trailing) or `.vertical` (top→bottom) |

### Ripple

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `rippleColor` | `Color?` | auto-resolved | Ripple tint. If unset: `labelColor` at 12% opacity when background is white/clear, otherwise `EDTSColor.grey70` at 12%. Forced to `.clear` when `btnState == .disabled`, and suppressed entirely for gradient backgrounds. Passing `.clear` explicitly disables ripple without opacity applied |

### Icon Leading

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconLeading` | `Image?` | `nil` | Icon shown before the label, rendered as a template image |
| `iconTintColorLeading` | `Color?` | theme/type default | Tint in `.default` state |
| `iconDangerTintColorLeading` | `Color?` | theme/type default | Tint in `.danger` state |
| `iconDisabledTintColorLeading` | `Color?` | theme/type default | Tint in `.disabled` state |

### Icon Trailing

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconTrailing` | `Image?` | `nil` | Icon shown after the label, rendered as a template image |
| `iconTintColorTrailing` | `Color?` | theme/type default | Tint in `.default` state |
| `iconDangerTintColorTrailing` | `Color?` | theme/type default | Tint in `.danger` state |
| `iconDisabledTintColorTrailing` | `Color?` | theme/type default | Tint in `.disabled` state |

### Icon Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconSpacing` | `CGFloat` | `8` (all sizes) | Spacing between icon(s) and label in the `HStack` |
| `iconSize` | `CGFloat` | `16` (small/medium), `24` (large) | Width/height applied to both leading and trailing icons |

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
| `shadowOpacity` | `Double` | `0` | Shadow Opacity |
| `shadowRadius` | `CGFloat` | `0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `.zero` | Shadow x/y offset |
| `shadowColor` | `Color?` | `nil` | Shadow color in `.default` state |
| `shadowDangerColor` | `Color?` | `nil`, falls back to `shadowColor` | Shadow color in `.danger` state |
| `shadowDisabledColor` | `Color?` | `nil`, falls back to `shadowColor` | Shadow color in `.disabled` state |

### Padding & Shape

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `cornerRadius` | `CGFloat` | size/theme default (see table below) | Button Corner radius |
| `paddingTop` | `CGFloat` | size default | Top content padding |
| `paddingBottom` | `CGFloat` | size default | Bottom content padding |
| `paddingLeading` | `CGFloat` | size default | Leading content padding |
| `paddingTrailing` | `CGFloat` | size default | Trailing content padding |

> All of the above use `-1.0` (or `.zero` for spacing/size values) as an internal "unset" sentinel, so any explicitly-passed value overrides the computed default.

---

## Size Defaults

| `btnSize` | Corner Radius (klikIDM / poinku) | Padding Top/Bottom | Padding Leading/Trailing | Icon Size |
| --------- | --------------------------------- | ------------------- | -------------------------- | --------- |
| `small` | `6` / `4` | `6` | `12` (klikIDM) / `8` (poinku) | `16` |
| `medium` | `6` / `4` | `8` | `12` | `16` |
| `large` | `6` / `8` | `8` | `12` | `24` |

---

## Type & State Color Defaults

| `btnType` | State | Background | Label / Icon | Border |
| --------- | ----- | ---------- | ------------- | ------ |
| `primary` | default | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) | `EDTSColor.white` | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) |
| `primary` | danger | `EDTSColor.red30` | `EDTSColor.white` | `EDTSColor.red30` |
| `primary` | disabled | `EDTSColor.grey30` | `EDTSColor.white` | `EDTSColor.grey30` |
| `secondary` | default | `EDTSColor.white` | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) | `EDTSColor.blue50` (klikIDM) / `.blue30` (poinku) |
| `secondary` | danger | `EDTSColor.white` | `EDTSColor.red30` | `EDTSColor.red30` |
| `secondary` | disabled | `EDTSColor.white` | `EDTSColor.grey30` | `EDTSColor.grey30` |
| `tertiary` | default | `EDTSColor.white` | `EDTSColor.grey60` | `EDTSColor.grey60` |
| `tertiary` | danger | `EDTSColor.white` | `EDTSColor.errorStrong` | `EDTSColor.disabled` |
| `tertiary` | disabled | `EDTSColor.white` | `EDTSColor.grey30` | `EDTSColor.grey30` |

For `secondary` and `tertiary` types, if a custom `labelColor` is supplied but `iconTintColorLeading` / `iconTintColorTrailing` / `borderColor` are not, those unset values inherit the resolved label color automatically.

---

## Animation

### Scale Animation

| Aspect | Value |
| ------ | ----- |
| Trigger | `tempResolvedButtonState` changing from `nil` → current state (press) or state → `nil` (release/cancel) |
| Effect | `.scaleEffect(tempResolvedButtonState != nil ? 0.95 : 1.0)` |
| Timing | `.animation(.easeInOut(duration: 0.1), value: tempResolvedButtonState)` |
| Scope | Applied to the whole button view (label, icons, background, border, shadow all scale together) |
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

*For further customization, you can ask UX Engineer or wrap `EDTSButton` in a custom `View` to compose additional behavior as required.*
