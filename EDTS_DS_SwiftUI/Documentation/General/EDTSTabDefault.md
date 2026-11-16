# EDTSTabDefault

The `EDTSTabDefault` component is a horizontally scrolling tab bar with a sliding underline indicator — it shows a row of text tabs, highlights the selected one, and keeps it centered as the user taps through.

## Features

- Binding-driven selection with `selectedId`, so the parent screen always knows the active tab
- Sliding underline indicator that moves between tabs when the selection changes
- Fixed, dynamic (text-based), or intrinsic tab widths
- Colors, font, paddings, and indicator shape configurable through `EDTSTabDefaultStyle`

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/TabDefault'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

Every tab bar needs two things:

1. A model type that conforms to `EDTSTabDefaultModelProtocol` (an `id` and a `title`).
2. A `@State` variable of type `String?` bound to `selectedId`.

### Basic

```swift
struct TabItem: EDTSTabDefaultModelProtocol {
    let id: String
    let title: String
}

struct ContentView: View {
    @State private var selectedId: String?

    private let items = [
        TabItem(id: "all", title: "Semua"),
        TabItem(id: "promo", title: "Promo"),
        TabItem(id: "voucher", title: "Voucher"),
        TabItem(id: "history", title: "Riwayat")
    ]

    var body: some View {
        EDTSTabDefaultView(
            data: items,
            selectedId: $selectedId,
            onSelect: { index, id in
                print("Selected tab \(index) with id \(id)")
            }
        )
    }
}
```

- You don't need to set `selectedId` yourself. When it is `nil`, or holds an id that isn't in `data`, the first tab is selected automatically.
- `onSelect` is only called when the user taps a tab that isn't already selected.

### Dynamic Width

Each tab is as wide as its title, kept between `minWidth` and `maxWidth`.

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    sizing: EDTSTabDefaultSizing(
        useDynamicWidth: true,
        minWidth: 60,
        maxWidth: 200
    )
)
```

Titles wider than `maxWidth` are truncated to a single line.

### Fixed Size

Give every tab the same width and/or height.

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    sizing: EDTSTabDefaultSizing(width: 100, height: 40)
)
```

`width` and `height` are ignored when they are `0`, which means the tab uses its own intrinsic size. `width` is also ignored when `useDynamicWidth` is `true`.

### Selecting a Tab from Code

Set `selectedId` yourself. The bar scrolls the new tab to the center.

```swift
Button("Go to Promo") {
    withAnimation(.easeOut(duration: 0.3)) {
        selectedId = "promo"
    }
}
```

- Wrap the change in `withAnimation` if you want the indicator to slide. Without it the indicator jumps to the new tab.
- `onSelect` is not called for changes made from code, only for taps.

### Without Scrolling

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    isScrollable: false
)
```

### Loading State

While your data loads, show shimmering placeholders in place of the tabs.

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    isSkeleton: isLoading,
    skeletonItemTotal: 4
)
```

- The skeleton fades in and out as `isSkeleton` changes.
- Each placeholder is `57 × 24` by default. It uses `sizing.width` and `sizing.height` when those are set.
- `data` can be an empty array while `isSkeleton` is `true`.

### With Custom Style

```swift
var style = EDTSTabDefaultStyle()
style.indicatorColor = EDTSColor.orange40
style.textColor = EDTSColor.grey50
style.textActiveColor = EDTSColor.orange40
style.backgroundColor = EDTSColor.grey10

EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    style: style
)
```

The default `textColor` and `textActiveColor` are both `EDTSColor.blue50`, so out of the box the selected tab is told apart only by its indicator. Set different values if you also want the text to change.

### With Custom Layout

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    layout: EDTSTabDefaultLayout(
        top: 4,
        leading: 24,
        bottom: 0,
        trailing: 24,
        itemSpacing: 20
    )
)
```

### With a Custom Cell

Pass a `cell` closure to draw each tab yourself. It receives the item and whether it is selected.

```swift
EDTSTabDefaultView(
    data: items,
    selectedId: $selectedId,
    backgroundColor: EDTSColor.white
) { item, isSelected in
    VStack(spacing: 4) {
        Text(item.title)
            .font(isSelected ? EDTSFont.Klik.B3.Bold.font : EDTSFont.Klik.B3.Regular.font)
            .foregroundColor(isSelected ? EDTSColor.blue50 : EDTSColor.grey50)

        Capsule()
            .fill(isSelected ? EDTSColor.blue50 : .clear)
            .frame(height: 2)
    }
    .padding(.horizontal, 8)
}
```

- With a custom cell, `style` does not apply, so set the bar's background with `backgroundColor`.
- The sliding indicator belongs to the default cell. A custom cell draws its own selected state.
- Tapping, scrolling to center, and `onSelect` still work the same way.

---

## Public Interface

### `EDTSTabDefaultModelProtocol`

```swift
public protocol EDTSTabDefaultModelProtocol {
    var id: String { get }
    var title: String { get }
}
```

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique identifier of the tab. Must be unique within `data`; it is what `selectedId` holds |
| `title` | `String` | Text shown in the tab |

---

### `EDTSTabDefaultView`

The component has two initializers: one that uses the default cell, and one that takes a custom cell.

```swift
// Default cell
init(
    data: [Item],
    selectedId: Binding<String?>,
    style: EDTSTabDefaultStyle = .init(),
    layout: EDTSTabDefaultLayout = .init(),
    sizing: EDTSTabDefaultSizing = .init(),
    isScrollable: Bool = true,
    isSkeleton: Bool = false,
    skeletonItemTotal: Int = 0,
    onSelect: ((_ index: Int, _ id: String) -> Void)? = nil
)

// Custom cell
init(
    data: [Item],
    selectedId: Binding<String?>,
    layout: EDTSTabDefaultLayout = .init(),
    sizing: EDTSTabDefaultSizing = .init(),
    backgroundColor: Color = EDTSColor.white,
    isScrollable: Bool = true,
    isSkeleton: Bool = false,
    skeletonItemTotal: Int = 0,
    onSelect: ((_ index: Int, _ id: String) -> Void)? = nil,
    @ViewBuilder cell: @escaping (Item, Bool) -> Cell
)
```

#### Content & Selection

| Parameter | Type | Default | Description |
|---|---|---|---|
| `data` | `[Item]` | — (required) | The tabs. `Item` is any type conforming to `EDTSTabDefaultModelProtocol` |
| `selectedId` | `Binding<String?>` | — (required) | The `id` of the selected tab. The first tab is selected automatically when it is `nil` or not found in `data` |
| `onSelect` | `((Int, String) -> Void)?` | `nil` | Called with the tab's index and id when the user taps a tab that isn't already selected. Not called for changes made through `selectedId` |

#### Appearance

| Parameter | Type | Default | Description |
|---|---|---|---|
| `style` | `EDTSTabDefaultStyle` | `.init()` | Colors, font, padding, and indicator shape. Default-cell initializer only |
| `backgroundColor` | `Color` | `EDTSColor.white` | Background of the whole bar. Custom-cell initializer only. The default-cell initializer uses `style.backgroundColor` |
| `cell` | `(Item, Bool) -> Cell` | — (required) | Builds a tab from the item and its selected state. Custom-cell initializer only |

#### Behavior

| Parameter | Type | Default | Description |
|---|---|---|---|
| `layout` | `EDTSTabDefaultLayout` | `.init()` | Insets around the row and spacing between tabs |
| `sizing` | `EDTSTabDefaultSizing` | `.init()` | Width and height rules for each tab |
| `isScrollable` | `Bool` | `true` | When `false`, the user can't scroll the bar |
| `isSkeleton` | `Bool` | `false` | Replaces the tabs with shimmering placeholders |
| `skeletonItemTotal` | `Int` | `0` | Number of placeholders to show while `isSkeleton` is `true` |

---

### `EDTSTabDefaultStyle`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `indicatorColor` | `Color` | `EDTSColor.blue50` | Color of the underline under the selected tab |
| `textColor` | `Color` | `EDTSColor.blue50` | Title color of unselected tabs |
| `textActiveColor` | `Color` | `EDTSColor.blue50` | Title color of the selected tab |
| `cellBackgroundColor` | `Color` | `.clear` | Background behind each individual tab |
| `backgroundColor` | `Color` | `EDTSColor.white` | Background of the whole bar |
| `paddingTop` | `CGFloat` | `8` | Space above the title |
| `paddingBottom` | `CGFloat` | `6` | Space between the title and the indicator |
| `indicatorHeight` | `CGFloat` | `2` | Thickness of the indicator |
| `indicatorCornerRadius` | `CGFloat` | `2` | Corner radius of the indicator |
| `font` | `Font` | `EDTSFont.Klik.B3.Regular.font` | Title font |

---

### `EDTSTabDefaultLayout`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `top` | `CGFloat` | `0` | Space above the row of tabs |
| `leading` | `CGFloat` | `16` | Space before the first tab |
| `bottom` | `CGFloat` | `0` | Space below the row of tabs |
| `trailing` | `CGFloat` | `16` | Space after the last tab |
| `itemSpacing` | `CGFloat` | `12` | Space between neighboring tabs |

---

### `EDTSTabDefaultSizing`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `width` | `CGFloat` | `0` | Fixed width of every tab. `0` uses the title's intrinsic width. Ignored when `useDynamicWidth` is `true` |
| `height` | `CGFloat` | `0` | Fixed height of every tab. `0` uses the tab's intrinsic height |
| `useDynamicWidth` | `Bool` | `false` | Sizes each tab to its title, kept between `minWidth` and `maxWidth` |
| `minWidth` | `CGFloat` | `60` | Smallest width of a tab. Only used when `useDynamicWidth` is `true` |
| `maxWidth` | `CGFloat` | `200` | Largest width of a tab. Longer titles are truncated. Only used when `useDynamicWidth` is `true` |
| `horizontalPadding` | `CGFloat` | `16` | Reserved. Accepted but not applied yet. To add space around a title, use `layout.itemSpacing` or a custom cell |

---

### `EDTSTabDefaultCellView`

The default tab. You normally don't create it yourself, but you can reuse it inside a custom `cell` closure.

```swift
init(title: String, isSelected: Bool, style: EDTSTabDefaultStyle = .init())
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | — (required) | Text of the tab, limited to one line |
| `isSelected` | `Bool` | — (required) | Whether the tab shows its active color and indicator |
| `style` | `EDTSTabDefaultStyle` | `.init()` | Colors, font, paddings, and indicator shape |

---

## Behavior

| Situation | What happens |
|---|---|
| `selectedId` is `nil` or not in `data` | The first tab is selected. This is checked when the view appears and whenever the list of ids changes |
| User taps an unselected tab | `selectedId` updates, the indicator slides over, the tab scrolls to the center, and `onSelect` is called |
| User taps the selected tab | Nothing happens, and `onSelect` is not called |
| `selectedId` changes from code | The tab scrolls to the center. The indicator slides only if the change is inside `withAnimation`. `onSelect` is not called |
| `isScrollable` is `false` | Scrolling is disabled. Taps still work. Uses `scrollDisabled` on iOS 16 and later, and a drag-gesture fallback on earlier versions |
| `isSkeleton` is `true` | The skeleton replaces the tabs. Tabs and skeleton cross-fade as the flag changes |

---

## Animation Behavior

These animations are fixed and can't be configured.

| Phase | Trigger | Animation | Duration | Notes |
|---|---|---|---|---|
| Indicator slide | User taps a tab | Ease out | 0.3s | The underline slides from the old tab to the new one. Code-driven changes slide only inside `withAnimation` |
| Title color | A tab becomes selected or unselected | Ease in-out | 0.3s | The title color cross-fades between `textColor` and `textActiveColor` |
| Scroll to center | `selectedId` changes | Ease in-out | 0.3s | The selected tab is scrolled to the horizontal center of the bar |
| Skeleton switch | `isSkeleton` changes | Ease out | 0.2s | Tabs and skeleton fade into each other |
| Skeleton shimmer | The skeleton is visible | Linear, repeating | 1.5s per sweep | `EDTSSkeleton`'s highlight sweeps across each placeholder without stopping |

---

*For further customization, use the custom-cell initializer, or contact the UX Engineering team.*
