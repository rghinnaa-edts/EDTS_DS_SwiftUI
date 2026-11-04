# EDTSChip

`EDTSChip` is a SwiftUI toggle-style chip with an `inactive`/`active` state, an optional leading and/or trailing icon (each independently tappable), a full-chip tap ripple, and per-icon circular ripples.

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
        EDTSChip(text: "Chip", isActive: isActive, onTapChip: {
            isActive.toggle()
        })
    }
}
```

### 2. With Icons

```swift
EDTSChip(
    text: "With icons",
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
    text: "Gradient",
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
EDTSChip(text: "Always active", isActive: true, onTapChip: {})
```

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

## Properties Reference

### Text

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `text` | `String?` | `"Chip"` | Plain text label; ignored if `textAttributed` is set |
| `textAttributed` | `AttributedString?` | `nil` | Rich text label; takes precedence over `text` |
| `textColor` | `Color?` | theme default | Text color when `isActive == false` |
| `textColorActive` | `Color?` | falls back to `textColor`, then theme default | Text color when `isActive == true` |

### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font` override, settable directly via the initializer; takes precedence over `fontName`/`fontSize`/`fontWeight` and the theme default |
| `fontName` | `String` | `""` | Custom font family name |
| `fontSize` | `Double` | `0` | Custom font size; resolves to `12` if left at `0` whenever the custom-font path is active (see note below) |
| `fontWeight` | `String` | `""` | Custom font weight keyword, applied via `setupFontWeight(from:)` |

> With no custom font set, the label uses `EDTSFont.Poinku.B3.Light` (poinku) or `EDTSFont.Klik.B3.Semibold` (klikIDM). Note that `fontWeight` alone — even with `fontName` and `fontSize` left default — is enough to switch away from the theme default and build a custom system font at that weight.

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
| `iconLeading` | `Image?` | `nil` | Icon shown before the text |
| `iconTintColorLeading` | `Color?` | theme default | Tint when inactive |
| `iconTintColorLeadingActive` | `Color?` | falls back to `iconTintColorLeading`, then theme default | Tint when active |
| `iconBgColorLeading` | `Color?` | `.clear` | Circular badge background when inactive |
| `iconBgColorLeadingActive` | `Color?` | falls back to `iconBgColorLeading`, then theme default (klikIDM only: `EDTSColor.grey20`) | Circular badge background when active |

### Icon Trailing

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconTrailing` | `Image?` | `nil` | Icon shown after the text |
| `iconTintColorTrailing` | `Color?` | theme default | Tint when inactive |
| `iconTintColorTrailingActive` | `Color?` | falls back to `iconTintColorTrailing`, then theme default | Tint when active |
| `iconBgColorTrailing` | `Color?` | `.clear` | Circular badge background when inactive |
| `iconBgColorTrailingActive` | `Color?` | falls back to `iconBgColorTrailing`, then theme default (klikIDM only: `EDTSColor.grey20`) | Circular badge background when active |

### Icon Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `iconSize` | `Double` | `0` → resolves to `16` | Width/height of each icon glyph |
| `iconSpacing` | `Double` | `0` → resolves to `4` | Spacing in the `HStack` between icon(s) and text |
| `iconPadding` | `Double` | `0` → resolves to `2` | Padding between the icon glyph and the edge of its circular badge |

### Shape & Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `cornerRadius` | `Double` | `0` | `0` renders a `Capsule`; any non-zero value renders a `RoundedRectangle(cornerRadius:)` |
| `borderWidth` | `Double` | `0` | Border width when inactive; used as-is (no theme fallback) |
| `borderWidthActive` | `Double` | `0` → falls back to `borderWidth`, then theme default | Border width when active. Resolution order: `borderWidthActive` if non-zero → `borderWidth` if non-zero → `1` (poinku) / `0` (klikIDM) |
| `borderColor` | `Color?` | `.clear` (inactive) | Border color when inactive |
| `borderColorActive` | `Color?` | falls back to `borderColor`, then theme default (`EDTSColor.blue40` poinku / `.clear` klikIDM) | Border color when active |

### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Double` | `0` | Shadow opacity when inactive |
| `shadowOpacityActive` | `Double` | `0` → falls back to `shadowOpacity` | Shadow opacity when active |
| `shadowRadius` | `Double` | `0` | Shadow blur radius when inactive |
| `shadowRadiusActive` | `Double` | `0` → falls back to `shadowRadius` | Shadow blur radius when active |
| `shadowOffset` | `CGSize` | `.zero` | Shadow offset when inactive |
| `shadowOffsetActive` | `CGSize` | `.zero` → falls back to `shadowOffset` | Shadow offset when active |
| `shadowColor` | `Color?` | `.clear` | Shadow color when inactive |
| `shadowColorActive` | `Color?` | falls back to `shadowColor`, then `.clear` | Shadow color when active |

### Padding

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `paddingTop` | `Double?` | `nil` → `4` | Top content padding |
| `paddingBottom` | `Double?` | `nil` → `4` | Bottom content padding |
| `paddingLeading` | `Double?` | `nil` → `8` | Leading content padding |
| `paddingTrailing` | `Double?` | `nil` → `8` | Trailing content padding |

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
| Text | `EDTSColor.blue50` | `EDTSColor.white` | `EDTSColor.grey80` | `EDTSColor.white` |
| Icon tint | `EDTSColor.blue50` | `EDTSColor.blue50` | `EDTSColor.grey60` | `EDTSColor.white` |
| Icon badge background | `.clear` | `EDTSColor.grey20` | `.clear` | `.clear` |
| Border | `.clear` | `.clear` | `.clear` | `EDTSColor.blue40` |
| Border width (both unset) | `0` | `0` | `0` | `1` |

---

## Icon Badge Geometry

| Constant | Value | Description |
| -------- | ----- | ----------- |
| `iconBadgeDiameter` | `resolvedIconSize + (resolvedIconPadding * 2)` | Circular badge size (glyph + padding on both sides); scales with the public `iconPadding` property, not a fixed constant |
| `iconBadgeRippleBleedMultiplier` | `1` (fixed) | Multiplier applied to `iconBadgeDiameter` to compute the ripple size |
| `iconBadgeRippleSize` | `iconBadgeDiameter * iconBadgeRippleBleedMultiplier` | Size passed to `circularRippleEffect`. With the multiplier fixed at `1`, this currently equals `iconBadgeDiameter` exactly — **the ripple no longer bleeds beyond the badge**, unlike the previous fixed `+4` bleed |

---

## Animation

| Aspect | Value |
| ------ | ----- |
| Chip tap | `.rippleEffect(color: .black.opacity(0.12), cornerRadius: cornerRadius != 0 ? cornerRadius : 999, onTap: onTapChip)` over the whole chip |
| Icon tap | Each icon badge uses `.circularRippleEffect(size: iconBadgeRippleSize, color: .black.opacity(0.22))` plus a `.highPriorityGesture(DragGesture(minimumDistance: 0))` that fires its own `onTap` closure, taking priority over the chip-level ripple gesture so the two never both fire from one tap |
| State transition | `.animation(.easeInOut(duration: 0.25), value: isActive)` animates every resolved style value (background, text/icon color, border, shadow) together whenever `isActive` changes |

---

# EDTSChipGroup

`EDTSChipGroup` is a SwiftUI container that renders a list of [`EDTSChip`](#edtschip) items as a multi-select group. It owns the selection state through a `Binding<Set<Int>>`, toggles each chip's `isActive` on tap, and lays the chips out in one of three display modes: `vertical`, `horizontal`, or `spanGrid` (auto-wrapping or fixed-column).

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Vertical** | ![Vertical Chip Group](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1792658450/vertical_yf8zqp.gif) |
| **Horizontal** | ![Horizontal Chip Group](https://res.cloudinary.com/dacnnk5j4/image/upload/w_350,c_scale,q_auto,f_auto/v1792658450/horizontal_hbrsqh.gif) |
| **Span Grid (Auto Wrap)** | ![Span Grid (Auto Wrap) Chip Group](https://res.cloudinary.com/dacnnk5j4/image/upload/w_350,c_scale,q_auto,f_auto/v1792658450/span_grid_oyrcnb.gif) |
| **Span Grid (Fixed Columns)** | ![Span Grid (Fixed Columns) Chip Group](https://res.cloudinary.com/dacnnk5j4/image/upload/w_350,c_scale,q_auto,f_auto/v1792658450/span_grid_2_uoahqk.png) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Chip Group'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on `EDTSChip` (and, through it, the design token types `EDTSColor` and `EDTSFont`) already being available in the pod.

---

## Basic Usage

### 1. Auto-Wrapping Grid (Default)

```swift
struct ExampleView: View {
    @State private var selected: Set<Int> = []

    var body: some View {
        EDTSChipGroup(
            data: ["Fashion", "Electronics", "Groceries", "Home & Living"],
            selectedIndices: $selected
        )
    }
}
```

With no `displayMode` supplied, the group uses `.spanGrid()`, which wraps chips onto new rows based on the available width.

### 2. Display Modes

```swift
// Stacked top-to-bottom, scrolls vertically
EDTSChipGroup(data: items, selectedIndices: $selected, displayMode: .vertical)

// Single row, scrolls horizontally
EDTSChipGroup(data: items, selectedIndices: $selected, displayMode: .horizontal)

// Auto-wrapping flow layout
EDTSChipGroup(data: items, selectedIndices: $selected, displayMode: .spanGrid())

// Fixed number of equal-width columns
EDTSChipGroup(data: items, selectedIndices: $selected, displayMode: .spanGrid(2))
```

### 3. Custom Spacing

```swift
EDTSChipGroup(
    data: items,
    selectedIndices: $selected,
    horizontalSpacing: 12,
    verticalSpacing: 16
)
```

### 4. Attributed Labels

```swift
var attributedItems: [AttributedString] {
    ["Fashion", "Electronics", "Groceries"].map { title in
        var str = AttributedString(title)
        str.underlineStyle = .single
        return str
    }
}

EDTSChipGroup(
    dataAttributed: attributedItems,
    selectedIndices: $selected
)
```

When `dataAttributed` is non-empty, it takes precedence and `data` is ignored entirely.

### 5. Customizing Every Chip

Use `configureChip(_:)` to apply any `EDTSChip` property to all chips in the group:

```swift
EDTSChipGroup(data: items, selectedIndices: $selected)
    .configureChip { chip in
        chip.iconLeading = Image(systemName: "star.fill")
        chip.bgColorActive = EDTSColor.blue40
        chip.textColorActive = EDTSColor.white
        chip.cornerRadius = 8
    }
```

Two limitations come from `EDTSChip` itself:
- `text` and `textAttributed` are declared as `let` on `EDTSChip`, so they cannot be changed inside `configureChip`; labels always come from `data` / `dataAttributed`.
- An icon set through `configureChip` only gets its own tap target and ripple when the matching `onTapLeadingIcon` / `onTapTrailingIcon` closure is also set. Without it, taps on the icon fall through to the chip toggle.

### 6. Reading the Selection

```swift
@State private var selected: Set<Int> = [0, 2]

EDTSChipGroup(data: items, selectedIndices: $selected)

Text("Selected: \(selected.sorted().map { items[$0] }.joined(separator: ", "))")
```

`selectedIndices` stores the **index** of each selected chip in `data` / `dataAttributed`, not the label. Selection is multi-select: tapping a chip adds its index if absent, or removes it if present.

---

## Enum

```swift
public enum ChipGroupDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int? = nil)
}
```

| Case | Behavior |
| ---- | -------- |
| `.vertical` | Chips stacked in a leading-aligned `VStack` inside a vertical `ScrollView`. Uses `verticalSpacing`; `horizontalSpacing` is not used. |
| `.horizontal` | Chips in a single `HStack` inside a horizontal `ScrollView`. Uses `horizontalSpacing`; `verticalSpacing` is not used. |
| `.spanGrid(nil)` / `.spanGrid()` | Auto-wrapping flow layout. Each chip keeps its intrinsic width and wraps to a new row when it no longer fits the container width. Uses both spacings. |
| `.spanGrid(n)` | Fixed `n` columns. Every cell gets an equal width. `n` is clamped to a minimum of `1`. Uses both spacings. |

---

## Properties Reference

### Data

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `data` | `[String]` | `[]` | Plain text labels, one chip per element; ignored if `dataAttributed` is non-empty |
| `dataAttributed` | `[AttributedString]` | `[]` | Rich text labels, one chip per element; takes precedence over `data` |

### Selection

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `selectedIndices` | `Binding<Set<Int>>` | — | Indices of the currently active chips (required). Updated by the group when a chip is tapped |

### Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `displayMode` | `ChipGroupDisplayMode` | `.spanGrid()` | Layout mode: `.vertical`, `.horizontal`, or `.spanGrid(Int?)` |
| `horizontalSpacing` | `CGFloat` | `8` | Spacing between chips in a row (`.horizontal` and `.spanGrid`) |
| `verticalSpacing` | `CGFloat` | `8` | Spacing between rows (`.vertical` and `.spanGrid`) |

### Customization

| Method | Signature | Description |
| ------ | --------- | ----------- |
| `configureChip(_:)` | `(@escaping (inout EDTSChip) -> Void) -> EDTSChipGroup` | Returns a copy of the group that applies the closure to every chip before `isActive` and `onTapChip` are set by the group. The closure receives the chip only, not its index |

---

*For further customization, you can ask UX Engineer or wrap `EDTSChip` in a custom `View` to compose additional behavior as required.*
