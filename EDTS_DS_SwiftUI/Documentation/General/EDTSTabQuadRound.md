# EDTSTabQuadRound

The `EDTSTabQuadRound` component is a folder-style tab bar — the selected tab is raised, white, and rounded on top, and its neighbors curve inward at the bottom so the selected tab looks like it flows into the content below. Each tab can show a badge counter.

## Features

- Binding-driven selection with `selectedId`, so the parent screen always knows the active tab
- Raised selected tab with a soft shadow, and inward-curved neighbors for the "quad round" look
- Optional numeric badge on every tab, hidden automatically when the count is `0`
- Colors, fonts, and dimensions configurable through `EDTSTabQuadRoundStyle`

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/TabQuadRound'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

Every tab bar needs two things:

1. An array of `EDTSTabQuadRoundModel`, each with an `id`, a `title`, and a `badge` count.
2. A `@State` variable of type `String?` bound to `selectedId`.

### Basic

```swift
struct ContentView: View {
    @State private var selectedId: String?

    private let tabs = [
        EDTSTabQuadRoundModel(id: "all", title: "Semua", badge: 0),
        EDTSTabQuadRoundModel(id: "promo", title: "Promo", badge: 3),
        EDTSTabQuadRoundModel(id: "voucher", title: "Voucher", badge: 0)
    ]

    var body: some View {
        EDTSTabQuadRoundView(
            data: tabs,
            selectedId: $selectedId,
            onSelect: { index, id in
                print("Selected tab \(index) with id \(id)")
            }
        )
    }
}
```

- You don't need to set `selectedId` yourself. When it is `nil`, or holds an id that isn't in `data`, the first tab is selected automatically.
- `onSelect` is called on every tap, including a tap on the tab that is already selected.

### Showing the Selected Content

Switch your content on `selectedId`.

```swift
VStack(spacing: 0) {
    EDTSTabQuadRoundView(data: tabs, selectedId: $selectedId)

    switch selectedId {
    case "promo": PromoList()
    case "voucher": VoucherList()
    default: AllList()
    }
}
```

The selected tab is white (`backgroundActiveColor`), so give the content below it the same color for the tab to blend into it.

### Badges

A tab shows a badge when its `badge` is greater than `0`. Update the model to change or remove it.

```swift
EDTSTabQuadRoundModel(id: "promo", title: "Promo", badge: 12)  // shows "12"
EDTSTabQuadRoundModel(id: "all", title: "Semua", badge: 0)     // no badge
```

The badge grows with its number, so larger counts get a wider capsule. Cap the number yourself if you want something like "99+".

### Selecting a Tab from Code

Set `selectedId` yourself. The bar updates, and with four or more tabs it scrolls the new tab to the center.

```swift
Button("Go to Voucher") {
    selectedId = "voucher"
}
```

`onSelect` is not called for changes made from code, only for taps.

### With a Custom Height

The height is the height of the whole bar. The tabs sit at the bottom of it, with the strip color above them.

```swift
EDTSTabQuadRoundView(
    data: tabs,
    selectedId: $selectedId,
    height: 48
)
```

### With Custom Style

```swift
var style = EDTSTabQuadRoundStyle()
style.containerBackgroundColor = EDTSColor.orange40
style.textActiveColor = EDTSColor.orange40
style.badgeActiveColor = EDTSColor.orange40
style.backgroundColor = EDTSColor.orange10

EDTSTabQuadRoundView(
    data: tabs,
    selectedId: $selectedId,
    style: style
)
```

---

## Public Interface

### `EDTSTabQuadRoundModel`

```swift
public struct EDTSTabQuadRoundModel {
    public var id: String
    public var title: String
    public var badge: Int

    public init(id: String, title: String, badge: Int)
}
```

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique identifier of the tab. Must be unique within `data`; it is what `selectedId` holds |
| `title` | `String` | Text shown in the tab, limited to one line |
| `badge` | `Int` | Number shown in a badge next to the title. `0` or less hides the badge |

---

### `EDTSTabQuadRoundView`

```swift
init(
    data: [EDTSTabQuadRoundModel],
    selectedId: Binding<String?>,
    style: EDTSTabQuadRoundStyle = .init(),
    height: CGFloat = 40,
    onSelect: ((_ index: Int, _ id: String) -> Void)? = nil
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `data` | `[EDTSTabQuadRoundModel]` | — (required) | The tabs |
| `selectedId` | `Binding<String?>` | — (required) | The `id` of the selected tab. The first tab is selected automatically when it is `nil` or not found in `data` |
| `style` | `EDTSTabQuadRoundStyle` | `.init()` | Colors, fonts, and dimensions |
| `height` | `CGFloat` | `40` | Height of the whole bar. The tabs are bottom-aligned inside it, so a `height` taller than the selected tab leaves a strip of `containerBackgroundColor` above |
| `onSelect` | `((Int, String) -> Void)?` | `nil` | Called with the tab's index and id every time the user taps a tab. Not called for changes made through `selectedId` |

---

### `EDTSTabQuadRoundStyle`

#### Colors

| Parameter | Type | Default | Description |
|---|---|---|---|
| `backgroundColor` | `Color` | `EDTSColor.blue20` | Background of unselected tabs |
| `backgroundActiveColor` | `Color` | `EDTSColor.white` | Background of the selected tab. It also shows in the inward curves of the neighboring tabs |
| `textColor` | `Color` | `EDTSColor.grey50` | Title color of unselected tabs |
| `textActiveColor` | `Color` | `EDTSColor.blue50` | Title color of the selected tab |
| `badgeColor` | `Color` | `EDTSColor.grey50` | Badge background on unselected tabs |
| `badgeActiveColor` | `Color` | `EDTSColor.blue50` | Badge background on the selected tab |
| `badgeTextColor` | `Color` | `EDTSColor.white` | Badge number color on unselected tabs |
| `badgeTextActiveColor` | `Color` | `EDTSColor.white` | Badge number color on the selected tab |
| `containerBackgroundColor` | `Color` | `EDTSColor.blue50` | Background of the whole bar, behind all tabs |

#### Fonts

| Parameter | Type | Default | Description |
|---|---|---|---|
| `selectedFont` | `Font` | `EDTSFont.Klik.B3.Semibold.font` | Title font of the selected tab |
| `unselectedFont` | `Font` | `EDTSFont.Klik.B4.Medium.font` | Title font of unselected tabs |
| `badgeFont` | `Font` | `EDTSFont.Klik.B4.Semibold.font` | Font of the badge number |

#### Dimensions

| Parameter | Type | Default | Description |
|---|---|---|---|
| `selectedWidth` | `CGFloat` | `150` | Width of the selected tab, when the width isn't shared equally (see "Tab Widths") |
| `unselectedWidth` | `CGFloat` | `86` | Width of unselected tabs, when the width isn't shared equally |
| `selectedHeight` | `CGFloat` | `32` | Height of the selected tab |
| `unselectedHeight` | `CGFloat` | `28` | Height of unselected tabs |
| `cornerRadius` | `CGFloat` | `12` | Radius of the tab's rounded corners, outer and inward |
| `badgeSize` | `CGFloat` | `14` | Minimum width and height of the badge capsule |

---

## Behavior

### Tab Widths

The width of each tab depends on how many tabs there are.

| Tabs | Width of each tab | Scrolls |
|---|---|---|
| 1 | `selectedWidth`, aligned to the left | No |
| 2 | Half of the bar each | No |
| 3 | The selected tab is `selectedWidth`; the other two share the remaining width | Yes |
| 4 | The selected tab is `selectedWidth`; the others are `unselectedWidth` | Yes |
| 5 or more | If all tabs fit at `unselectedWidth` (wide screens), the bar's width is shared equally with 20% extra per tab. Otherwise the selected tab is `selectedWidth` and the others are `unselectedWidth` | Yes |

On a phone, five or more tabs always use `selectedWidth` and `unselectedWidth`.

### Shapes

| Tab | Shape |
|---|---|
| Selected | White, rounded top corners, soft shadow, drawn above its neighbors |
| Neighbor of the selected tab | The bottom corner facing the selected tab is rounded inward, so the selected tab's color shows in the curve |
| Other tabs | Square, with a faint shade along the bottom edge |
| Two tabs | The outer top corner of the unselected tab is rounded too |

### Selection & Scrolling

| Situation | What happens |
|---|---|
| `selectedId` is `nil` or not in `data` | The first tab is selected. This is checked when the view appears and whenever the list of ids changes |
| User taps a tab | `selectedId` updates, the tabs resize, and `onSelect` is called, even if the tab was already selected |
| `selectedId` changes from code | The tabs resize. `onSelect` is not called |
| Four or more tabs | The selected tab is scrolled to the horizontal center of the bar |
| Three tabs | The row scrolls, but the selected tab isn't re-centered |
| One or two tabs | The row doesn't scroll |

The selected tab is also exposed to VoiceOver with the selected trait.

---

## Animation Behavior

These animations are fixed and can't be configured.

| Phase | Trigger | Animation | Duration | Notes |
|---|---|---|---|---|
| Tab resize | `selectedId` changes | Ease in-out | 0.2s | The selected tab grows and the previous one shrinks. Applies to taps and to changes from code |
| Scroll to center | `selectedId` changes with four or more tabs | Ease in-out | 0.3s | The selected tab is scrolled to the center of the bar |
| Shape change | `selectedId` changes | None | — | Corner shapes and shadows switch immediately, while the widths animate |

---

## Not Included

`EDTSTabQuadRound` has a fixed look and doesn't support custom cells, a skeleton loading state, or dynamic widths based on the title. If you need those, use `EDTSTabDefault`.

---

*For further customization, contact the UX Engineering team.*
