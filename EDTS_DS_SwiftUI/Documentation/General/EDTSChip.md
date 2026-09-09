# EDTSChip

`EDTSChip` is a SwiftUI toggle-style chip with an `inactive`/`active` state, an optional leading and/or trailing icon (each independently tappable), a full-chip tap ripple, and per-icon circular ripples. Every visual property — label color, background, icon tint/background, border, and shadow — has a separate `*Active` override that's used only when `isActive == true`, with automatic fallback to the inactive value and then to a theme default (`klikIDM` vs `poinku`). The background additionally supports an independent linear gradient for each state.

---

## Enum

```swift
public enum ChipState: String {
    case inactive = "inactive"
    case active = "active"
}
```

`ChipState` models the two visual states internally; `EDTSChip` itself is driven by the `isActive: Bool` property rather than taking a `ChipState` directly.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Basic Chip** |![Default Chip](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077809/chip_default_active_nps4ik.gif)|
| **Chip With Icon** |![Chip With iconLeading, iconTrailing, iconBgColorLeading and iconBgColorTrailing](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770101059/chip_with_icon_njdzk1.png)|

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Chip'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`)

---

## Basic Usage

### 1. Toggleable Chip

```swift
struct ExampleView: View {
    @State private var isActive = false

    var body: some View {
        EDTSChip(label: "Chip", isActive: isActive) {
            isActive.toggle()
        }
    }
}
```

### 2. With Icons

```swift
EDTSChip(
    label: "With icons",
    iconLeading: Image(systemName: "star.fill"),
    iconTrailing: Image(systemName: "xmark"),
    isActive: isActive,
    onTapChip: { isActive.toggle() },
    onTapLeadingIcon: { print("leading icon tapped") },
    onTapTrailingIcon: { print("trailing icon tapped") }
)
```

Each icon has its own tap target (`onTapLeadingIcon` / `onTapTrailingIcon`) that takes priority over the chip's own tap (`onTapChip`), so tapping an icon doesn't also toggle the chip.

### 3. Gradient Background

```swift
EDTSChip(
    label: "Gradient",
    bgColorStart: EDTSColor.skyblueLeading,
    bgColorEnd: EDTSColor.skyblueTrailing,
    bgColorOrientation: .horizontal,
    bgColorActiveStart: EDTSColor.blue40,
    bgColorActiveEnd: EDTSColor.blue50,
    isActive: isActive,
    onTapChip: { isActive.toggle() }
)
```

The inactive and active gradients are configured independently — set only `bgColorStart`/`bgColorEnd` for a gradient while inactive, only `bgColorActiveStart`/`bgColorActiveEnd` for one while active, or both.

### 4. Always-Active Chip (non-interactive display)

```swift
EDTSChip(label: "Always active", isActive: true, onTapChip: {})
```

---

## Properties Reference

### Label

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `label` | `String?` | `"Chip"` | Plain text label; ignored if `labelAttributed` is set |
| `labelAttributed` | `AttributedString?` | `nil` | Rich text label; takes precedence over `label` |
| `labelColor` | `Color?` | theme default | Label color when `isActive == false` |
| `labelColorActive` | `Color?` | falls back to `labelColor`, then theme default | Label color when `isActive == true` |

### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fontStyle` | `Font?` | `nil` | Not settable via the initializer — assign it on a `var` instance after construction. Takes precedence over `fontName`/`fontSize`/`fontWeight` and the theme default |
| `fontName` | `String` | `""` | Custom font family name |
| `fontSize` | `CGFloat` | `0` | Custom font size; resolves to `12` if left at `0` while `fontName`/`fontWeight` is set |
| `fontWeight` | `String` | `""` | Custom font weight keyword, applied via `setupFontWeight(from:)` |

> With no custom font set, the label uses `EDTSFont.Poinku.B3.Light` (poinku) or `EDTSFont.Klik.B3.Semibold` (klikIDM).

### Background

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | theme default | Solid chip background when `isActive == false` |
| `bgColorStart` | `Color?` | `nil` | Gradient start color for the inactive background; setting either start or end switches the inactive background to a gradient |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color for the inactive background; setting either start or end switches the inactive background to a gradient |
| `bgColorOrientation` | `Orientation?` | `.horizontal` | Gradient direction when inactive: `.horizontal` (leading→trailing) or `.vertical` (top→bottom) |
| `bgColorActive` | `Color?` | falls back to `bgColor`, then theme default | Solid chip background when `isActive == true` |
| `bgColorActiveStart` | `Color?` | `nil` | Gradient start color for the active background; setting either start or end switches the active background to a gradient |
| `bgColorActiveEnd` | `Color?` | `nil` | Gradient end color for the active background; setting either start or end switches the active background to a gradient |
| `bgColorActiveOrientation` | `Orientation?` | `.horizontal` | Gradient direction when active: `.horizontal` (leading→trailing) or `.vertical` (top→bottom) |

### Icon Leading

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconLeading` | `Image?` | `nil` | Icon shown before the label |
| `iconTintColorLeading` | `Color?` | theme default | Tint when inactive |
| `iconTintColorLeadingActive` | `Color?` | falls back to `iconTintColorLeading`, then theme default | Tint when active |
| `iconBgColorLeading` | `Color?` | `.clear` | Circular badge background when inactive |
| `iconBgColorLeadingActive` | `Color?` | falls back to `iconBgColorLeading`, then theme default (klikIDM only: `EDTSColor.grey20`) | Circular badge background when active |

### Icon Trailing

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconTrailing` | `Image?` | `nil` | Icon shown after the label |
| `iconTintColorTrailing` | `Color?` | theme default | Tint when inactive |
| `iconTintColorTrailingActive` | `Color?` | falls back to `iconTintColorTrailing`, then theme default | Tint when active |
| `iconBgColorTrailing` | `Color?` | `.clear` | Circular badge background when inactive |
| `iconBgColorTrailingActive` | `Color?` | falls back to `iconBgColorTrailing`, then theme default (klikIDM only: `EDTSColor.grey20`) | Circular badge background when active |

### Icon Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconSize` | `CGFloat` | `0` → resolves to `16` | Width/height of each icon glyph |
| `iconSpacing` | `CGFloat` | `0` → resolves to `4` | Spacing in the `HStack` between icon(s) and label |

### Shape & Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `cornerRadius` | `CGFloat` | `0` | `0` renders a `Capsule`; any non-zero value renders a `RoundedRectangle(cornerRadius:)` |
| `borderWidth` | `CGFloat` | `0` | Border width when inactive; used as-is (no theme fallback) |
| `borderWidthActive` | `CGFloat` | `0` → falls back to `borderWidth`, then theme default | Border width when active. Resolution order: `borderWidthActive` if non-zero → `borderWidth` if non-zero → `1` (poinku) / `0` (klikIDM) |
| `borderColor` | `Color?` | `.clear` (inactive) | Border color when inactive |
| `borderColorActive` | `Color?` | falls back to `borderColor`, then theme default (`EDTSColor.blue40` poinku / `.clear` klikIDM) | Border color when active |

### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `0` | Shadow opacity when inactive |
| `shadowOpacityActive` | `Float` | `0` → falls back to `shadowOpacity` | Shadow opacity when active |
| `shadowRadius` | `CGFloat` | `0` | Shadow blur radius when inactive |
| `shadowRadiusActive` | `CGFloat` | `0` → falls back to `shadowRadius` | Shadow blur radius when active |
| `shadowOffset` | `CGSize` | `.zero` | Shadow offset when inactive |
| `shadowOffsetActive` | `CGSize` | `.zero` → falls back to `shadowOffset` | Shadow offset when active |
| `shadowColor` | `Color?` | `.clear` | Shadow color when inactive |
| `shadowColorActive` | `Color?` | falls back to `shadowColor`, then `.clear` | Shadow color when active |

### Padding

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat?` | `nil` → `4` | Top content padding |
| `paddingBottom` | `CGFloat?` | `nil` → `4` | Bottom content padding |
| `paddingLeading` | `CGFloat?` | `nil` → `8` | Leading content padding |
| `paddingTrailing` | `CGFloat?` | `nil` → `8` | Trailing content padding |

### State & Delegates

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isActive` | `Bool` | `false` | Drives which color/border/shadow set (`*Active` vs base) is used; changes animate |
| `onTapChip` | `(() -> Void)?` | `nil` | Called when the chip body (outside the icon badges) is tapped |
| `onTapLeadingIcon` | `(() -> Void)?` | `nil` | Called when the leading icon badge is tapped |
| `onTapTrailingIcon` | `(() -> Void)?` | `nil` | Called when the trailing icon badge is tapped |

---

## Theme Defaults (Inactive / Active)

| Token | klikIDM inactive | klikIDM active | poinku inactive | poinku active |
| ----- | ------------------ | ---------------- | ------------------ | ---------------- |
| Background | `EDTSColor.grey20` | `EDTSColor.blue50` | `EDTSColor.grey20` | `EDTSColor.blue30` |
| Label / Icon tint | `EDTSColor.blue50` | `EDTSColor.white` (label), `EDTSColor.blue50` (icon) | `EDTSColor.grey80` (label), `EDTSColor.grey60` (icon) | `EDTSColor.white` |
| Icon badge background | `.clear` | `EDTSColor.grey20` | `.clear` | `.clear` |
| Border | `.clear` | `.clear` | `.clear` | `EDTSColor.blue40` |
| Border width (both unset) | `0` | `0` | `0` | `1` |

---

## Icon Badge Geometry

| Constant | Value | Description |
| -------- | ----- | ----------- |
| `iconBadgePadding` | `2` (fixed) | Padding between the icon glyph and the edge of its circular badge |
| `iconBadgeRippleBleed` | `2` (fixed) | Extra radius the ripple extends beyond the badge |
| `iconBadgeDiameter` | `resolvedIconSize + 4` | Circular badge size (glyph + padding) |
| `iconBadgeRippleSize` | `iconBadgeDiameter + 4` | Size passed to `circularRippleEffect` |

---

## Interaction & Animation

| Aspect | Value |
| ------ | ----- |
| Chip tap | `.rippleEffect(color: .black.opacity(0.12), cornerRadius: cornerRadius != 0 ? cornerRadius : 999, onTap: onTapChip)` over the whole chip |
| Icon tap | Each icon badge uses `.circularRippleEffect(size: iconBadgeRippleSize, color: .black.opacity(0.22))` plus a `.highPriorityGesture(DragGesture(minimumDistance: 0))` that fires its own `onTap` closure, taking priority over the chip-level ripple gesture so the two never both fire from one tap |
| State transition | `.animation(.easeInOut(duration: 0.25), value: isActive)` animates every resolved style value (background, label/icon color, border, shadow) together whenever `isActive` changes |

---

*For further customization, you can ask UX Engineer or wrap `EDTSChip` in a custom `View` to compose additional behavior as required.*
