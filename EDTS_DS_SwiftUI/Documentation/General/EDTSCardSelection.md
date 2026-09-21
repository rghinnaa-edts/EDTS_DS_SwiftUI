# EDTSCardSelection

The `EDTSCardSelection` component is a horizontally-scrolling card picker built for **SwiftUI**. Each card shows a title and description, supports a selected / unselected / disabled state, and ships as both a single-card view and a ready-to-use scrollable list that manages selection for you.

## Features

- A `EDTSCardSelectionModel` per card with `title`/`description` strings, optional `AttributedString` overrides for rich text, and an `isEnabled` flag
- Selected, unselected, and disabled visual states — each independently configurable for title color, description color, background, border, and shadow
- Solid background per state (no gradient); disabled state gets its own background, border, and text color so it reads clearly as non-interactive
- Fully customizable via `EDTSCardSelectionConfig`: colors, border width, corner radius, and shadow (color, opacity, radius, offset)
- `EDTSCardSelectionView` for a single standalone card, and `EDTSCardSelectionListView` for a horizontally-scrolling, tap-to-select list
- Auto-selects the first enabled item on appear when no selection is bound in yet
- Disabled cards are skipped entirely by selection (tapping one is a no-op)

---

## Preview

![Card Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1789373659/card_selection_bpnpqm.gif)

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/EDTSCardSelection'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

### Basic (list)

```swift
@State private var selectedIndex: Int? = nil

let items: [EDTSCardSelectionModel] = [
    EDTSCardSelectionModel(title: "Debit Card", description: "Instant transfer"),
    EDTSCardSelectionModel(title: "Credit Card", description: "Pay later"),
    EDTSCardSelectionModel(title: "E-Wallet", description: "Top up balance"),
    EDTSCardSelectionModel(title: "Bank Transfer", description: "Not available", isEnabled: false)
]

EDTSCardSelectionListView(data: items, selectedIndex: $selectedIndex) { index in
    print("Selected index: \(index)")
}
```

Renders a horizontally-scrolling row of cards. If `selectedIndex` is `nil` when the view appears, the first enabled item is auto-selected and `onSelect` fires for it.

### Standalone (single card)

```swift
EDTSCardSelectionView(
    model: EDTSCardSelectionModel(title: "Debit Card", description: "Instant transfer"),
    isSelected: true
)
```

Useful when you want to lay cards out yourself (e.g. in a grid) instead of using the built-in horizontal list.

### Disabled Cards

```swift
EDTSCardSelectionModel(title: "Bank Transfer", description: "Not available", isEnabled: false)
```

Disabled cards render with `disabledColor` text, `disabledBgColor` background, and `disabledBorderColor`/`disabledBorderWidth` border regardless of selection state, and are ignored by `EDTSCardSelectionListView`'s tap handling and auto-select logic.

### Custom Styling

```swift
let config = EDTSCardSelectionConfig(
    titleColor: EDTSColor.grey70,
    titleActiveColor: EDTSColor.blueDefault,
    descColor: EDTSColor.grey50,
    descActiveColor: EDTSColor.grey50,
    bgColor: EDTSColor.white,
    bgActiveColor: EDTSColor.white,
    borderColor: EDTSColor.grey20,
    borderActiveColor: EDTSColor.blueDefault,
    borderWidth: 1,
    cornerRadius: 8,
    disabledColor: EDTSColor.disabled,
    disabledBgColor: EDTSColor.white,
    disabledBorderColor: EDTSColor.grey20,
    disabledBorderWidth: 0.5
)

EDTSCardSelectionListView(data: items, selectedIndex: $selectedIndex, style: config)
```

---

## Public Interface

### `EDTSCardSelectionModel` — Card Data

| Parameter | Type | Default | Description |
|---|---|---|---|
| `id` | `String` | `UUID().uuidString` | Stable identity for the card, used by `ForEach` in the list |
| `title` | `String` | — (required) | Plain-text title, shown when `titleAttributed` is `nil` |
| `description` | `String` | — (required) | Plain-text description, shown when `descriptionAttributed` is `nil` |
| `isEnabled` | `Bool` | `true` | When `false`, the card renders in its disabled style and can't be selected |
| `titleAttributed` | `AttributedString?` | `nil` | Rich-text override for the title; takes precedence over `title` and carries its own styling |
| `descriptionAttributed` | `AttributedString?` | `nil` | Rich-text override for the description; takes precedence over `description` and carries its own styling |

### `EDTSCardSelectionConfig` — Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleColor` | `Color` | `EDTSColor.grey70` | Title color when unselected and enabled |
| `titleActiveColor` | `Color` | `EDTSColor.blueDefault` | Title color when selected and enabled |
| `descColor` | `Color` | `EDTSColor.grey50` | Description color when unselected and enabled |
| `descActiveColor` | `Color` | `EDTSColor.grey50` | Description color when selected and enabled |
| `bgColor` | `Color` | `EDTSColor.white` | Background color when unselected |
| `bgActiveColor` | `Color` | `EDTSColor.white` | Background color when selected |
| `borderColor` | `Color` | `EDTSColor.grey20` | Border color when unselected and enabled |
| `borderActiveColor` | `Color` | `EDTSColor.blueDefault` | Border color when selected and enabled |
| `borderWidth` | `CGFloat` | `1` | Border width when enabled |
| `cornerRadius` | `CGFloat` | `8` | Corner radius of the card body |
| `shadowColor` | `Color` | `EDTSColor.grey50` | Shadow color when unselected |
| `shadowActiveColor` | `Color` | `EDTSColor.grey50` | Shadow color when selected |
| `shadowOpacity` | `Double` | `0` | Shadow opacity; `0` means no visible shadow |
| `shadowRadius` | `CGFloat` | `0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `.zero` | Shadow offset |
| `disabledColor` | `Color` | `EDTSColor.disabled` | Title and description color when `isEnabled` is `false` |
| `disabledBgColor` | `Color` | `EDTSColor.white` | Background color when `isEnabled` is `false` |
| `disabledBorderColor` | `Color` | `EDTSColor.grey20` | Border color when `isEnabled` is `false` |
| `disabledBorderWidth` | `CGFloat` | `0.5` | Border width when `isEnabled` is `false` |

`EDTSCardSelectionConfig.default` provides an instance with every parameter left at its default.

### `EDTSCardSelectionView` — Single Card

```swift
init(
    model: EDTSCardSelectionModel,
    isSelected: Bool,
    style: EDTSCardSelectionConfig = .default
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `model` | `EDTSCardSelectionModel` | — (required) | The card's content and enabled state |
| `isSelected` | `Bool` | — (required) | Whether the card is currently selected |
| `style` | `EDTSCardSelectionConfig` | `.default` | Visual styling to apply |

The card's title/description color, background, border, and shadow all resolve from `isEnabled` first (disabled wins outright), then from `isSelected`. Border color changes animate with an `.easeOut` curve.

### `EDTSCardSelectionListView` — Scrollable List

```swift
init(
    data: [EDTSCardSelectionModel],
    selectedIndex: Binding<Int?>,
    style: EDTSCardSelectionConfig = .default,
    onSelect: ((Int) -> Void)? = nil
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `data` | `[EDTSCardSelectionModel]` | — (required) | Cards to render, left to right |
| `selectedIndex` | `Binding<Int?>` | — (required) | Currently selected index; `nil` means nothing selected |
| `style` | `EDTSCardSelectionConfig` | `.default` | Visual styling applied to every card |
| `onSelect` | `((Int) -> Void)?` | `nil` | Called with the new index whenever selection changes, including the initial auto-select |

---

*For further customization, wrap `EDTSCardSelectionView`/`EDTSCardSelectionListView` in your own view, or contact the UX Engineering team.*
