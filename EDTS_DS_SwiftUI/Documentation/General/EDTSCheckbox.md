//
//  EDTSCheckbox.md
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 17/09/26.
//

# EDTSCheckbox

`EDTSCheckbox` is a SwiftUI checkbox component that supports checked and indeterminate types, default and disabled states, optional title and description text, optional custom icons, active/inactive styling, configurable borders and padding, and tap handling. Its visual defaults are theme-aware, switching between `klikIDM` and `poinku` token sets via `EDTSColor.theme`.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Default — Inactive (Checked)** | ![Checkbox Default Inactive Checked](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077901/checkbox_active_uncheck_ur62qy.gif) |
| **Default — Active (Checked)** | ![Checkbox Default Active Checked](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077899/checkbox_active_checked_arwqrs.png) |
| **Default — Active (Indeterminate)** | ![Checkbox Default Active Indeterminate](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077900/checkbox_active_indeterminated_osnuut.png) |
| **Disabled — Inactive** | ![Checkbox Disabled Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077898/checkbox_disabled_uncheck_qimqjb.png) |
| **Disabled — Active (Checked)** | ![Checkbox Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077903/checkbox_disabled_checked_qyyuch.png) |
| **Disabled — Active (Indeterminate)** | ![Checkbox Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077902/checkbox_disabled_indeterminated_ywcvbt.png) |

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Checkbox'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and the checkbox icon assets (`ic_check` and `ic_minus`) when no custom icon is supplied.

---

## Basic Usage

### 1. Basic Checkbox

```swift
struct ExampleView: View {
    @State private var isChecked = false

    var body: some View {
        EDTSCheckbox(
            title: "Title checkboxes",
            desc: "Body text goes here",
            isActive: isChecked,
            onTapCheckbox: { isChecked.toggle() }
        )
    }
}
```

### 2. Checked Checkbox

```swift
EDTSCheckbox(
    title: "Checked",
    desc: "Body text goes here",
    isActive: true,
    onTapCheckbox: {
        print("Checkbox tapped")
    }
)
```

### 3. Indeterminate Checkbox

```swift
EDTSCheckbox(
    checkboxType: .indeterminated,
    title: "Indeterminate",
    desc: "Body text goes here",
    isActive: true,
    onTapCheckbox: {
        print("Checkbox tapped")
    }
)
```

The `checkboxType` controls the icon shown inside the checkbox: `.checked` uses `ic_check`, while `.indeterminated` uses `ic_minus`, unless a custom `icon` is provided.

### 4. Disabled Checkbox

```swift
EDTSCheckbox(
    checkboxState: .disabled,
    title: "Disabled checked",
    desc: "Body text goes here",
    isActive: true
)
```

When `checkboxState` is `.disabled`, the press gesture does not invoke `onTapCheckbox`.

### 5. Custom Icon

```swift
EDTSCheckbox(
    title: "Custom icon",
    desc: "Body text goes here",
    icon: Image(systemName: "checkmark"),
    isActive: true
)
```

When `icon` is provided, it takes precedence over the icon resolved from `checkboxType`.

### 6. Attributed Title and Description

```swift
var titleAttributed: AttributedString {
    var str = AttributedString("Terms & Conditions")
    str.underlineStyle = .single
    return str
}

var descAttributed: AttributedString {
    var str = AttributedString("Additional information")
    str.foregroundColor = .gray
    return str
}

EDTSCheckbox(
    title: nil,
    titleAttributed: titleAttributed,
    desc: nil,
    descAttributed: descAttributed
)
```

When `titleAttributed` is non-`nil`, it takes precedence and `title` is forced to `nil` internally. The same behavior applies to `descAttributed` and `desc`.

---

## Enums

```swift
public enum EDTSCheckboxState: String {
    case `default` = "default"
    case disabled = "disabled"
}

public enum EDTSCheckboxType: String {
    case checked = "checked"
    case indeterminated = "indeterminated"
}
```

`EDTSCheckboxState` controls whether the checkbox is interactive or disabled.

`EDTSCheckboxType` controls the checkbox icon used by default:
- `.checked` → `ic_check`
- `.indeterminated` → `ic_minus`

---

## Properties Reference

### General

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `checkboxState` | `EDTSCheckboxState` | `.default` | Checkbox interaction state: `.default` or `.disabled` |
| `checkboxType` | `EDTSCheckboxType` | `.checked` | Checkbox icon type: `.checked` or `.indeterminated` |
| `isActive` | `Bool` | `false` | Controls whether the checkbox uses active or inactive colors |
| `onTapCheckbox` | `(() -> Void)?` | `nil` | Closure invoked when an enabled checkbox receives a completed tap |

### Title

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `title` | `String?` | `"Title Here"` | Plain text title; ignored if `titleAttributed` is set |
| `titleAttributed` | `AttributedString?` | `nil` | Rich text title; takes precedence over `title` |
| `titleColorActive` | `Color?` | theme default | Title color when `isActive == true` |
| `titleColorInactive` | `Color?` | theme default | Title color when `isActive == false` |

### Description

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `desc` | `String?` | `"Body text"` | Plain text description; ignored if `descAttributed` is set |
| `descAttributed` | `AttributedString?` | `nil` | Rich text description; takes precedence over `desc` |
| `descColorActive` | `Color?` | theme default | Description color when `isActive == true` |
| `descColorInactive` | `Color?` | theme default | Description color when `isActive == false` |

### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `titleFontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font` override for the title; takes precedence over `titleFontName`/`titleFontSize`/`titleFontWeight` and the theme default |
| `titleFontName` | `String` | `""` | Custom title font family name |
| `titleFontSize` | `CGFloat` | `0` | Custom title font size; resolves to `14` when the custom-font path is active and size is unset |
| `titleFontWeight` | `String?` | `nil` | Custom title font weight keyword, applied via `setupFontWeight(from:)` |
| `descFontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font` override for the description |
| `descFontName` | `String` | `""` | Custom description font family name |
| `descFontSize` | `CGFloat` | `0` | Custom description font size; resolves to `12` when the custom-font path is active and size is unset |
| `descFontWeight` | `String?` | `nil` | Custom description font weight keyword, applied via `setupFontWeight(from:)` |

When no custom title font is supplied, the title uses `EDTSFont.Poinku.B2.Medium` for `poinku` or `EDTSFont.Klik.B2.Medium` for `klikIDM`.

When no custom description font is supplied, the description uses `EDTSFont.Poinku.B3.Light` for `poinku` or `EDTSFont.Klik.B3.Regular` for `klikIDM`.

### Icon

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `icon` | `Image?` | `nil` | Custom icon rendered inside the checkbox; when unset, the icon is resolved from `checkboxType` |
| `iconTintColorActive` | `Color?` | theme default | Icon tint when `isActive == true` |
| `iconTintColorInactive` | `Color?` | theme default | Icon tint when `isActive == false` |

The default icon resolution is:
- `.checked` → `Image("ic_check")`
- `.indeterminated` → `Image("ic_minus")`

The icon is rendered as a template image and resized to `16pt × 16pt`.

### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `boxBgColorActive` | `Color?` | theme default | Checkbox box background when `isActive == true` |
| `boxBgColorInactive` | `Color?` | theme default | Checkbox box background when `isActive == false` |

### Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `spacing` | `CGFloat` | `0` → `8` | Spacing between the checkbox box and the title/description content |
| `labelSpacing` | `CGFloat` | `0` → `4` | Vertical spacing between title and description |
| `paddingTop` | `CGFloat` | `0` | Top content padding |
| `paddingBottom` | `CGFloat` | `0` | Bottom content padding |
| `paddingLeading` | `CGFloat` | `0` | Leading content padding |
| `paddingTrailing` | `CGFloat` | `0` | Trailing content padding |

### Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `0` → `1` | Checkbox border width; `0` uses the component's default border width |
| `borderColorActive` | `Color?` | theme default | Border color when `isActive == true` |
| `borderColorInactive` | `Color?` | theme default | Border color when `isActive == false` |

The checkbox uses a fixed `4pt` corner radius.

---

## Theme Defaults

### Default State — Inactive / Active

| Token | klikIDM inactive | klikIDM active | poinku inactive | poinku active |
| ----- | ---------------- | -------------- | -------------- | ------------- |
| Title | `EDTSColor.grey60` | `EDTSColor.grey60` | `EDTSColor.grey70` | `EDTSColor.grey70` |
| Description | `EDTSColor.grey50` | `EDTSColor.grey50` | `EDTSColor.grey60` | `EDTSColor.grey60` |
| Box background | `EDTSColor.white` | `EDTSColor.blue50` | `EDTSColor.white` | `EDTSColor.blue30` |
| Icon tint | `EDTSColor.white` | `EDTSColor.white` | `EDTSColor.white` | `EDTSColor.white` |
| Border | `EDTSColor.grey30` | `EDTSColor.blue50` | `EDTSColor.grey30` | `EDTSColor.blue30` |

### Disabled State — Inactive / Active

| Token | klikIDM inactive | klikIDM active | poinku inactive | poinku active |
| ----- | ---------------- | -------------- | -------------- | ------------- |
| Title | `EDTSColor.grey40` | `EDTSColor.grey40` | `EDTSColor.grey50` | `EDTSColor.grey50` |
| Description | `EDTSColor.grey30` | `EDTSColor.grey30` | `EDTSColor.grey30` | `EDTSColor.grey30` |
| Box background | `EDTSColor.grey20` | `EDTSColor.grey20` | `EDTSColor.grey20` | `EDTSColor.grey20` |
| Icon tint | `EDTSColor.grey20` | `EDTSColor.grey40` | `EDTSColor.grey20` | `EDTSColor.grey30` |
| Border | `EDTSColor.grey30` | `EDTSColor.grey30` | `EDTSColor.grey30` | `EDTSColor.grey30` |

---

## Sizing & Geometry

| Constant | Value | Description |
| -------- | ----- | ----------- |
| `iconContainerSize` | `20pt` | Width and height of the checkbox container |
| `iconSize` | `16pt` | Width and height of the icon glyph |
| `cornerRadius` | `4pt` | Corner radius of the checkbox box |
| `defaultBorderWidth` | `1pt` | Border width used when `borderWidth` is `0` |
| `defaultSpacing` | `8pt` | Default spacing between checkbox and label content |
| `defaultLabelSpacing` | `4pt` | Default vertical spacing between title and description |

---

## Interaction & Animation

| Aspect | Value |
| ------ | ----- |
| Tap gesture | `DragGesture(minimumDistance: 0)` |
| Press state | Internal `isPressed` state is set while an enabled gesture is active |
| Tap completion | `onTapCheckbox` is called when the gesture ends within the drag cancellation threshold |
| Drag cancellation threshold | `44pt` on both horizontal and vertical translation |
| Disabled interaction | No press state or tap action is triggered when `checkboxState == .disabled` |
| Ripple | `.circularRippleEffect(size: 36pt, color: EDTSColor.black.opacity(0.12))` on the checkbox box |
| Active-state animation | `.easeInOut(duration: 0.25)` when `isActive` changes |

A tap is considered valid when both the horizontal and vertical translations are less than `44pt` in absolute value. Larger movement cancels the checkbox action.

The active/inactive style transition is animated over `0.25s`.

---

## Notes

- `EDTSCheckbox` is a SwiftUI `View`.
- The checkbox itself is always `20pt × 20pt`; the icon inside it is `16pt × 16pt`.
- The title and description are optional. If both are empty or `nil`, only the checkbox box is rendered.
- `titleAttributed` takes precedence over `title`.
- `descAttributed` takes precedence over `desc`.
- A custom `icon` takes precedence over the icon selected by `checkboxType`.
- `checkboxType` changes the default icon but does not itself control `isActive`.
- `checkboxState == .disabled` prevents the tap callback from being invoked.
- The component uses theme-specific `EDTSColor` and `EDTSFont` tokens based on `EDTSColor.theme`.
- The preview demonstrates unchecked, checked, indeterminate, disabled unchecked, disabled checked, and disabled indeterminate configurations.

---

*For further customization, you can ask UX Engineer or wrap `EDTSCheckbox` in a custom `View` to compose additional behavior as required.*
