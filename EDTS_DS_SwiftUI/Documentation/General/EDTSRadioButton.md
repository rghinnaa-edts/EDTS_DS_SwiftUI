# EDTSRadioButton (SwiftUI)

`EDTSRadioButton` is a customizable single radio button `View` for SwiftUI featuring a bullet indicator (or custom icon), title, and description text with full active/inactive state styling. It supports two states (`default`, `disabled`), plain or attributed text, custom fonts, and a circular ripple on tap. Selection is controlled by the caller through `isActive` and `onTapRadioButton`.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **RadioButton — Default (Inactive)** | ![RadioButton Default Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_rest_Inactive_q80akz.png) |
| **RadioButton — Default (Active)** | ![RadioButton Default Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_rest_active_nsqncr.png) |
| **RadioButton — Disabled (Inactive)** | ![RadioButton Disabled Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_disabled_Inactive_yjv6gt.png) |
| **RadioButton — Disabled (Active)** | ![RadioButton Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_disabled_active_k1koev.png) |

---

## Basic Usage

### Single Radio Button

`EDTSRadioButton` does not change `isActive` by itself. Own the selection state in your view and toggle it in `onTapRadioButton`.

```swift
struct ContentView: View {
    @State private var isSelected = false

    var body: some View {
        EDTSRadioButton(
            title: "Option A",
            desc: "This is the description for option A",
            isActive: isSelected,
            onTapRadioButton: { isSelected.toggle() }
        )
    }
}
```

### Single Selection Across Several Options

To manage single selection manually with standalone buttons, keep the selection in your own state (or use `EDTSRadioGroup`, documented in `EDTSRadioGroup_SwiftUI.md`):

```swift
struct OptionsView: View {
    @State private var selected = 0
    private let options = ["Option A", "Option B", "Option C"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(options.indices, id: \.self) { index in
                EDTSRadioButton(
                    title: options[index],
                    desc: "Description for \(options[index])",
                    isActive: selected == index,
                    onTapRadioButton: { selected = index }
                )
            }
        }
    }
}
```

### Custom Icon

```swift
EDTSRadioButton(
    title: "Favorite",
    desc: "Body text goes here",
    iconActive: Image(systemName: "star.fill"),
    iconInactive: Image(systemName: "star"),
    iconPadding: 3,
    isActive: isSelected,
    onTapRadioButton: { isSelected.toggle() }
)
```

### Without Description

```swift
EDTSRadioButton(
    title: "Unselected, no description",
    desc: nil,
    isActive: false
)
```

### Disabled

```swift
EDTSRadioButton(
    radioButtonState: .disabled,
    title: "Disabled option",
    desc: "Body text goes here",
    isActive: true
)
```

---

## RadioButton States

| State Name | Value | Description |
| ---------- | ----- | ----------- |
| `.default` | `"default"` | Default interactive state |
| `.disabled` | `"disabled"` | Non-interactive state |

### `EDTSSelectionState` Enum

```swift
public enum EDTSSelectionState: String {
    case `default` = "default"
    case disabled = "disabled"
}
```

---

## Properties Reference

All properties are set through the initializer. Every parameter is optional and has a default.

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `radioButtonState` | `EDTSSelectionState` | `.default` | Button state (`.default`, `.disabled`) |
| `isActive` | `Bool` | `false` | Controls active/inactive selection state |
| `onTapRadioButton` | `(() -> Void)?` | `nil` | Called when the radio button is tapped. Not called when disabled |
| `spacing` | `Double?` | `8` | Spacing between the bullet/icon and the text stack |
| `textSpacing` | `Double?` | `4` | Spacing between title and description |

### Title Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `title` | `String?` | `"Title radio button"` | Title text. Hidden when `nil` or empty |
| `titleAttributed` | `AttributedString?` | `nil` | Attributed title text (overrides `title`) |
| `titleFontStyle` | `Font?` | `nil` | SwiftUI `Font` for the title. Takes priority over `titleFontName`, `titleFontSize` and `titleFontWeight` |
| `titleFontName` | `String` | `""` (theme font) | Custom font name |
| `titleFontSize` | `Double` | `.zero` (`14` when other title font properties are set) | Font size for title |
| `titleFontWeight` | `String?` | `nil` | Font weight (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |
| `titleColorInactive` | `Color?` | State/theme-dependent | Title color when inactive |
| `titleColorActive` | `Color?` | State/theme-dependent | Title color when active |

### Description Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `desc` | `String?` | `"Body text goes here"` | Description text. Hidden when `nil` or empty |
| `descAttributed` | `AttributedString?` | `nil` | Attributed description text (overrides `desc`) |
| `descFontStyle` | `Font?` | `nil` | SwiftUI `Font` for the description. Takes priority over `descFontName`, `descFontSize` and `descFontWeight` |
| `descFontName` | `String` | `""` (theme font) | Custom font name |
| `descFontSize` | `Double` | `.zero` (`12` when other description font properties are set) | Font size for description |
| `descFontWeight` | `String?` | `nil` | Font weight (same values as title) |
| `descColorInactive` | `Color?` | State/theme-dependent | Description color when inactive |
| `descColorActive` | `Color?` | State/theme-dependent | Description color when active |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconInactive` | `Image?` | `nil` | Custom icon for the inactive state |
| `iconActive` | `Image?` | `nil` | Custom icon for the active state |
| `iconTintColorInactive` | `Color?` | `EDTSColor.white` (`EDTSColor.blue50` when `iconInactive` is set) | Icon / bullet tint color when inactive |
| `iconTintColorActive` | `Color?` | `EDTSColor.white` | Icon / bullet tint color when active |
| `iconBgColorInactive` | `Color?` | `EDTSColor.white` | Box background color when inactive |
| `iconBgColorActive` | `Color?` | Theme-dependent (`blue50` / `blue30`) | Box background color when active |
| `iconPadding` | `Double` | `0` | Padding inside the box around the custom icon |
| `boxSize` | `Double?` | `20` | Width and height of the box (circle) |

### Border Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `borderWidth` | `Double?` | `1` | Border width of the box |
| `borderColorInactive` | `Color?` | `EDTSColor.grey30` | Border color when inactive |
| `borderColorActive` | `Color?` | Theme-dependent (`clear` / `blue30`) | Border color when active |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `Double` | `0` | Top inset around the radio button content |
| `paddingBottom` | `Double` | `0` | Bottom inset around the radio button content |
| `paddingLeading` | `Double` | `0` | Leading inset around the radio button content |
| `paddingTrailing` | `Double` | `0` | Trailing inset around the radio button content |

---

## State-Specific Styling

Defaults depend on `EDTSColor.theme`.

### Default State: `klikIDM` Theme

| Sub-state | Title Color | Desc Color | Box BG | Bullet / Icon Tint | Border |
| --------- | ----------- | ---------- | ------ | ------------------ | ------ |
| Inactive | `grey60` | `grey50` | `white` | `white` | `grey30` |
| Active | `grey60` | `grey50` | `blue50` | `white` | `clear` |

### Default State: `poinku` Theme

| Sub-state | Title Color | Desc Color | Box BG | Bullet / Icon Tint | Border |
| --------- | ----------- | ---------- | ------ | ------------------ | ------ |
| Inactive | `grey70` | `grey60` | `white` | `white` | `grey30` |
| Active | `grey70` | `grey60` | `blue30` | `white` | `blue30` |

### Disabled State

| Sub-state | Theme | Title Color | Desc Color | Box BG | Bullet / Icon Tint | Border |
| --------- | ----- | ----------- | ---------- | ------ | ------------------ | ------ |
| Inactive | `klikIDM` | `grey40` | `grey30` | `grey20` | `grey20` | `grey30` |
| Inactive | `poinku` | `grey50` | `grey30` | `grey20` | `grey20` | `grey30` |
| Active | `klikIDM` | `grey40` | `grey30` | `grey20` | `grey40` | `grey40` |
| Active | `poinku` | `grey50` | `grey30` | `grey20` | `grey30` | `grey30` |

> **Note:** In the default state, setting a color property to a non-nil value overrides the state default for that property. In the **disabled** state, custom color properties are ignored and the disabled colors above are always used.

---

## Default Fonts

| Element | `klikIDM` | `poinku` |
| ------- | --------- | -------- |
| Title | `EDTSFont.Klik.B2.Medium` | `EDTSFont.Poinku.B2.Medium` |
| Description | `EDTSFont.Klik.B3.Regular` | `EDTSFont.Poinku.B3.Light` |

The theme font is used until you set `titleFontStyle`, `titleFontName`, `titleFontSize` or `titleFontWeight` (and the equivalent description properties). Setting any of them switches to the custom font.

### Font Resolution

| Condition | Result |
| --------- | ------ |
| `titleFontStyle` is set | `titleFontStyle` is used; other title font properties are ignored |
| `titleFontName` is set | `Font.custom(titleFontName, size:)`. The weight is applied only when `titleFontWeight` is set |
| Only size and/or weight is set | System font with the given size (`14` if `0`) and weight |
| Weight string is empty or not recognized | `semibold` is used for system fonts |

The same rules apply to the description (default size `12`).

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| Bullet scale | `250ms` | `EaseInOut` | Scales the inner bullet from 50% to 100% on activation |
| Bullet fade | `250ms` | `EaseInOut` | Fades the inner bullet from 50% to full opacity on activation |
| Box color transition | `250ms` | `EaseInOut` | Animates the box background, border and bullet/icon color on `isActive` change |
| Ripple Effect | Defined by `circularRippleEffect` | — | Circular ripple (`black` at `12%` opacity) centered on the box, sized at `1.8×` the box size |

---

## Notes

- `EDTSRadioButton` is a plain SwiftUI `View`. It does not toggle `isActive` itself, so update your own state in `onTapRadioButton`
- The whole row (box and text) is tappable. The ripple is centered on the box
- When `iconActive` or `iconInactive` is set, the bullet is replaced by the custom icon, rendered as a template (tintable). If the icon for the current state is `nil`, no icon is shown in that state, so set both icons
- `title`, `desc`, `titleAttributed`, `descAttributed`, `iconActive`, `iconInactive` and `iconPadding` are set through the initializer only
- Passing `titleAttributed` or `descAttributed` discards the plain `title` or `desc`
- The `disabled` state disables the tap, the ripple and hit testing on the box
- Unlike the UIKit version, there is no delegate (use `onTapRadioButton`), the state type is `EDTSSelectionState` instead of a `String`, `paddingLeading` defaults to `0` instead of `2`, and the group container is documented separately in `EDTSRadioGroup_SwiftUI.md`

---

*For further customization, you can ask UX Engineer or wrap `EDTSRadioButton` in your own view, or add additional functionality as required.*
