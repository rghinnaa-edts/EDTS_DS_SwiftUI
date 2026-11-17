# EDTSRadioGroup

`EDTSRadioGroup` is a SwiftUI container that renders a list of [`EDTSRadioButton`](EDTSRadioButton_SwiftUI.md) items and manages single selection for you.

## Features

- **Flexible data sources:** build the group from titles only (`[String]`), title and description pairs (`[[String]]`), or `[[AttributedString]]`.
- **Single selection:** manage selection through a single `Binding<Int?>`, where `nil` means no selection.
- **Three layouts:**
  - `vertical`
  - `horizontal`
  - `spanGrid(Int)` for a fixed-column grid
- **Configurable spacing:** adjust horizontal and vertical spacing independently.
- **Radio button customization:** use the `configureRadioButton(_:)` modifier to style every radio button in the group (colors, fonts, state, etc.) without rebuilding them manually.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **RadioGroup — Vertical** | ![RadioGroup Vertical](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_vertical_pfgwax.gif) |
| **RadioGroup — Horizontal** | ![RadioGroup Horizontal](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_horizontal_lukzi3.gif) |
| **RadioGroup — Span Grid** | ![RadioGroup Span Grid](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_span_grid_bdmv8u.gif) |

---

## Basic Usage

### Title and Description

Each item is a `[title, description]` array. The description is optional.

```swift
struct ContentView: View {
    @State private var selected: Int? = 0

    var body: some View {
        EDTSRadioGroup(
            data: [
                ["Regular", "3-5 business days"],
                ["Express", "1-2 business days"],
                ["Same day", "Delivered today"]
            ],
            selectedIndex: $selected,
            displayMode: .vertical
        )
    }
}
```

### Titles Only

```swift
EDTSRadioGroup(
    titles: ["Fashion", "Electronics", "Groceries"],
    selectedIndex: $selected
)
```

### Attributed Text

```swift
EDTSRadioGroup(
    dataAttributed: [
        [AttributedString("Regular"), AttributedString("3-5 business days")],
        [AttributedString("Express"), AttributedString("1-2 business days")]
    ],
    selectedIndex: $selected
)
```

### Display Modes

```swift
// Horizontally scrolling single row
EDTSRadioGroup(titles: items, selectedIndex: $selected, displayMode: .horizontal)

// 2-column grid
EDTSRadioGroup(titles: items, selectedIndex: $selected, displayMode: .spanGrid(2))
```

### Customize Radio Button Appearance Inside Group

```swift
EDTSRadioGroup(titles: items, selectedIndex: $selected, displayMode: .spanGrid(3))
    .configureRadioButton { radioButton in
        radioButton.titleFontWeight = "light"
        radioButton.titleColorActive = .blue
        radioButton.iconBgColorActive = .blue
    }
```

### No Initial Selection

```swift
@State private var selected: Int? = nil
```

---

## Initializers

| Initializer | Description |
| ----------- | ----------- |
| `init(data:selectedIndex:displayMode:horizontalSpacing:verticalSpacing:)` | Items as `[[String]]` (`[title, description]` per item) |
| `init(dataAttributed:selectedIndex:displayMode:horizontalSpacing:verticalSpacing:)` | Items as `[[AttributedString]]` (`[title, description]` per item) |
| `init(titles:selectedIndex:displayMode:horizontalSpacing:verticalSpacing:)` | Items as `[String]`, titles only (no description) |

---

## Display Modes

| Mode | Description |
| ---- | ----------- |
| `.vertical` | Single-column vertical list (default) |
| `.horizontal` | Horizontally scrolling single-row list |
| `.spanGrid(Int)` | Multi-column grid with the specified number of columns |

**Example:**
```swift
displayMode: .spanGrid(2)  // 2-column grid
```

### `EDTSSelectionDisplayMode` Enum

```swift
public enum EDTSSelectionDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int)
}
```

| Case | Scroll Direction | Columns | Description |
| ---- | ---------------- | ------- | ----------- |
| `.vertical` | Vertical | 1 | Single-column stacked list |
| `.horizontal` | Horizontal | 1 | Single-row horizontally scrollable list |
| `.spanGrid(Int)` | Vertical | N | Multi-column grid. Values below `1` are treated as `1` |

---

## Properties Reference

### Data Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `data` | `[[String]]` | Required (or `[]`) | `[title, description]` string arrays, one per radio item. Set through `init(data:...)`. `init(titles:...)` converts each title into a single-element array |
| `dataAttributed` | `[[AttributedString]]` | Required (or `[]`) | `[title, description]` attributed string arrays. Set through `init(dataAttributed:...)`. Takes priority over `data` when both are non-empty |
| `selectedIndex` | `Binding<Int?>` | Required | Index of the currently selected item. `nil` means no selection |
| `displayMode` | `EDTSSelectionDisplayMode` | `.vertical` | Layout mode (`.vertical`, `.horizontal`, `.spanGrid(Int)`) |

### Spacing Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `horizontalSpacing` | `CGFloat` | `8` | Horizontal spacing between items (used by `.horizontal` and `.spanGrid`) |
| `verticalSpacing` | `CGFloat` | `8` | Vertical spacing between rows (used by `.vertical` and `.spanGrid`) |

---

## Public Functions

| Function | Description |
| -------- | ----------- |
| `configureRadioButton(_ configure: @escaping (inout EDTSRadioButton) -> Void) -> EDTSRadioGroup` | Customizes every [`EDTSRadioButton`](EDTSRadioButton_SwiftUI.md) rendered inside the group. Returns a new `EDTSRadioGroup`, so call it directly on the group |

> **Note:** The group sets `isActive` and `onTapRadioButton` on every button **after** your configuration closure runs. Values you set for those two properties inside `configureRadioButton` are overwritten. Title and description text cannot be changed here either, because they come from the group's data.

---

## Selection Behavior

| Behavior | Description |
| -------- | ----------- |
| Single selection | Only the item whose index equals `selectedIndex` is active |
| Tap on an item | Sets `selectedIndex` to that item's index |
| Tap on the selected item | No change (a radio button is not deselected by tapping it again) |
| Clearing the selection | Set `selectedIndex = nil` from your code |

---

## Data Row Format

| Row contents | Result |
| ------------ | ------ |
| `["Title", "Description"]` | Title and description |
| `["Title"]` | Title only. The description is hidden (the radio button's default placeholder text is **not** used) |
| `[]` | No title and no description |
| Extra elements after the second | Ignored |

---

## Animation Details

The group adds no animation of its own. Each radio button animates its own state change (bullet scale and fade, color transition) and ripple. See [`EDTSRadioButton`](EDTSRadioButton_SwiftUI.md).

---

## Notes

- `EDTSRadioGroup` is a plain SwiftUI `View`. Selection state lives in your own `@State` (or other source) and is passed in as a `Binding<Int?>`
- Each display mode wraps the items in its own `ScrollView` with hidden scroll indicators
- A small internal inset keeps the radio button ripple from being clipped at the edges of the scroll view. It is canceled out with negative padding, so it does not change the layout
- In `.spanGrid`, the cell width is `(container width - horizontalSpacing × (columns - 1)) / columns`. The container width is measured first, so the grid is hidden for the first layout pass and then appears
- Items are laid out left to right, then top to bottom
- `.vertical` ignores `horizontalSpacing`, and `.horizontal` ignores `verticalSpacing`
- Items are identified by their index, so reordering `data` changes which row is considered selected
- The group applies one configuration to all radio buttons. It has no per-item disabled state. Setting `radioButton.radioButtonState = .disabled` in `configureRadioButton` disables every item
- Unlike the UIKit version, `selectedIndex` is a `Binding<Int?>` (`nil` instead of `-1` for no selection), there is no `padding*` property for the container, the mode enum is `EDTSSelectionDisplayMode` instead of `ItemDisplayMode`, and `configureRadioButton` receives an `inout EDTSRadioButton` value instead of a class instance

---

*For further customization, you can ask UX Engineer or wrap `EDTSRadioGroup` in your own view, or add additional functionality as required.*
