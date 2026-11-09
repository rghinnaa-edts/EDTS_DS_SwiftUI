# EDTSCheckboxGroup

`EDTSCheckboxGroup` is a SwiftUI container that renders a list of [`EDTSCheckbox`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSCheckbox.md) items.

## Features

- **Flexible data sources:** build the group from a plain `[String]` or an `[AttributedString]` array.
- **Multi-selection:** manage selection through a single `Binding<Set<Int>>` of selected indices.
- **Three layouts:**
  - `vertical`
  - `horizontal`
  - `spanGrid(Int)` for a fixed-column grid
- **Configurable spacing:** adjust horizontal and vertical spacing independently.
- **Checkbox customization:** use the `configureCheckbox(_:)` modifier to style every checkbox in the group (type, state, colors, fonts, etc.) without rebuilding them manually.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Vertical** | ![Vertical](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1793774321/vertical_tmnx3u.gif) |
| **Horizontal** | ![Horizontal](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793774300/horizontal_djqhu8.gif) |
| **Span Grid (2 columns)** | ![Span Grid (2 columns)](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793774299/span_z1e1gk.gif) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/CheckboxGroup'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and on [`EDTSCheckbox`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSCheckbox.md), which is instantiated internally for every item.

---

## Basic Usage

### 1. Vertical Group

```swift
struct ExampleView: View {
    @State private var selected: Set<Int> = [0]

    var body: some View {
        EDTSCheckboxGroup(
            data: ["Fashion", "Electronics", "Groceries", "Home & Living"],
            selectedIndices: $selected,
            displayMode: .vertical
        )
    }
}
```

### 2. Horizontal Group

```swift
EDTSCheckboxGroup(
    data: ["Fashion", "Electronics", "Groceries", "Home & Living"],
    selectedIndices: $selected,
    displayMode: .horizontal
)
```

### 3. Span Grid

```swift
EDTSCheckboxGroup(
    data: items,
    selectedIndices: $selected,
    displayMode: .spanGrid(2),
    horizontalSpacing: 16,
    verticalSpacing: 12
)
```

### 4. Custom Spacing

```swift
EDTSCheckboxGroup(
    data: items,
    selectedIndices: $selected,
    displayMode: .vertical,
    verticalSpacing: 16
)
```

### 5. Attributed Data

```swift
var attributedItems: [AttributedString] {
    ["Fashion", "Electronics", "Groceries"].map {
        var str = AttributedString($0)
        str.underlineStyle = .single
        return str
    }
}

EDTSCheckboxGroup(
    dataAttributed: attributedItems,
    selectedIndices: $selected,
    displayMode: .vertical
)
```

When `dataAttributed` is non-empty, it takes precedence and `data` is ignored entirely (the item count is also derived from `dataAttributed`).

### 6. Configuring Every Checkbox

```swift
EDTSCheckboxGroup(
    data: items,
    selectedIndices: $selected,
    displayMode: .vertical
)
.configureCheckbox { checkbox in
    checkbox.checkboxType = .indeterminated
    checkbox.titleColorActive = EDTSColor.blue50
    checkbox.spacing = 12
}
```

`configureCheckbox(_:)` is called once per item, receiving the `EDTSCheckbox` as `inout`. It returns a copy of the group, so it can be chained like a regular modifier.

> **Note:** the group sets `isActive` and `onTapCheckbox` **after** the configurator runs. Any value assigned to these two properties inside the closure is overwritten, because selection is fully controlled by `selectedIndices`.

### 7. Reading the Selection

```swift
let selectedTitles = selected.sorted().map { items[$0] }
```

`selectedIndices` stores the **index** of each selected item in `data` (or `dataAttributed`), not the item itself.

---

## Enum

```swift
public enum CheckboxGroupDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int)
}
```

| Case | Description |
| ---- | ----------- |
| `.vertical` | Items stacked in a `VStack` (leading-aligned) inside a vertical `ScrollView` |
| `.horizontal` | Items in a single `HStack` inside a horizontal `ScrollView` |
| `.spanGrid(Int)` | Items arranged in rows with the given number of equal-width columns, inside a vertical `ScrollView`. Values below `1` are clamped to `1` |

---

## Properties Reference

### General

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `data` | `[String]` | `[]` | Plain-text titles, one per checkbox; ignored if `dataAttributed` is non-empty |
| `dataAttributed` | `[AttributedString]` | `[]` | Rich-text titles, one per checkbox; takes precedence over `data` |
| `selectedIndices` | `Binding<Set<Int>>` | — | Indices of the currently selected items (required). Updated automatically when a checkbox is tapped |
| `displayMode` | `CheckboxGroupDisplayMode` | .vertical | Layout of the group: `.vertical`, `.horizontal`, or `.spanGrid(Int)` (required) |

### Layout

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `horizontalSpacing` | `CGFloat` | `8` | Spacing between items on the horizontal axis. Used by `.horizontal` and `.spanGrid`; has no effect on `.vertical` |
| `verticalSpacing` | `CGFloat` | `8` | Spacing between items on the vertical axis. Used by `.vertical` and `.spanGrid`; has no effect on `.horizontal` |

### Functions

| Function | Returns | Description |
| -------- | ------- | ----------- |
| `configureCheckbox(_ configure: @escaping (inout EDTSCheckbox) -> Void)` | `EDTSCheckboxGroup` | Registers a closure applied to every `EDTSCheckbox` in the group before selection state is applied. Use it to set `checkboxType`, `checkboxState`, colors, fonts, icon, padding, etc. |

---

## Checkbox Defaults

Each item is created as an `EDTSCheckbox` with the following base configuration before `configureCheckbox(_:)` is applied:

| Property | Value |
| -------- | ----- |
| `title` / `titleAttributed` | The item's `data[index]` / `dataAttributed[index]` |
| `desc` | `nil` (no description is shown) |
| `isActive` | `selectedIndices.contains(index)` — always overwritten after the configurator |
| `onTapCheckbox` | Toggles the index in `selectedIndices` — always overwritten after the configurator |

All other `EDTSCheckbox` properties keep their own defaults (see [`EDTSCheckbox`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSCheckbox.md)). If `configureCheckbox(_:)` sets `checkboxState = .disabled`, the tap gesture is blocked by the checkbox itself, so the selection will not change for those items.

---

## Notes

- Selection is **index-based**. Items are identified by their position (`ForEach(0..<itemCount, id: \.self)`), so if the data source is reordered, filtered, or has items inserted, update `selectedIndices` accordingly.
- Each layout wraps its content in its own `ScrollView`. When placing the group inside another `ScrollView` of the same axis, give it a bounded height/width (or use a layout that does not need nested scrolling) to avoid unexpected sizing.
- `EDTSCheckboxGroup` currently supports multi-selection only (`Set<Int>`). For single-selection behavior, constrain `selectedIndices` to at most one element in the binding's setter or on the caller side.
- `configureCheckbox(_:)` replaces any previously registered configurator — only the last call applies.

---

*For further customization, you can ask UX Engineer or wrap `EDTSCheckboxGroup` in a custom `View` to compose additional behavior as required.*
