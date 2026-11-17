# EDTSSearchField

The `EDTSSearchField` component is a single-line search input — it shows a search icon, a text field, and a clear button, and can animate its placeholder to hint at what the user can search for.

## Features

- Search icon, and a clear button that appears while the field is focused and has text
- Border that changes color while the field is focused, with an optional active background
- `onSubmit` callback for the keyboard's search key
- Colors, font, icon, and dimensions configurable through `EDTSSearchFieldStyle`

## Preview

| Placeholder Type | Preview |
| ------------------- | ------- |
| Default | ![Default](https://res.cloudinary.com/dr6cm6n5f/image/upload/h_80,c_scale/v1794902158/WhatsApp_Image_2026-11-17_at_14.54.27_qnngxn.jpg) |
| Append | ![Append](https://res.cloudinary.com/dr6cm6n5f/image/upload/h_80,c_scale/v1794902260/WhatsApp_GIF_2026-11-17_at_14.57.18_mpcjrc.gif) |
| Append Prefix | ![Append Prefix](https://res.cloudinary.com/dr6cm6n5f/image/upload/h_80,c_scale/v1794902480/WhatsApp_GIF_2026-11-17_at_14.59.01_hmycvg.gif) |
| Slide Top Bottom | ![Slide Top Bottom](https://res.cloudinary.com/dr6cm6n5f/image/upload/h_80,c_scale/v1794902442/WhatsApp_GIF_2026-11-17_at_15.00.03_tbydxk.gif) |
| Slide Top Bottom Prefix | ![Slide Top Bottom Prefix](https://res.cloudinary.com/dr6cm6n5f/image/upload/h_80,c_scale/v1794902592/WhatsApp_GIF_2026-11-17_at_15.02.13_oefyue.gif) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/SearchField'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

Every search field needs a `@State` variable of type `String` bound to `text`.

### Basic

```swift
struct ContentView: View {
    @State private var query = ""

    var body: some View {
        EDTSSearchField(
            text: $query,
            placeholder: "Cari produk"
        )
        .padding(.horizontal, 16)
    }
}
```

The field fills the width it is given and has no outer margin, so add your own padding.

### Searching on Submit

`onSubmit` is called when the user taps the keyboard's search key.

```swift
EDTSSearchField(
    text: $query,
    placeholder: "Cari produk",
    onSubmit: { search(for: query) }
)
```

### Searching as the User Types

Observe the bound text.

```swift
EDTSSearchField(text: $query, placeholder: "Cari produk")
    .onChange(of: query) { newValue in
        search(for: newValue)
    }
```

### Animated Placeholder

Pass a `placeholderAnimation` to animate the placeholder while the field is empty.

```swift
EDTSSearchField(
    text: $query,
    placeholder: "Cari produk",
    placeholderAnimation: EDTSSearchFieldAnimation(type: .append)
)
```

| Type | Result |
|---|---|
| `.append` | The placeholder is typed one letter at a time: "C", "Ca", "Car", "Cari"… |
| `.appendPrefix` | A `prefix` stays in place, and the placeholder after it is typed out with a cursor: "Cari pro\|" |
| `.slideTopBottom` | Each letter slides in from the top, one after another |
| `.slideTopBottomPrefix` | A `prefix` stays in place, and the letters of the placeholder after it slide in from the top |

Change the pace with `speed`:

```swift
EDTSSearchFieldAnimation(type: .append, speed: 0.15)
```

#### Fixed Prefix

With `.appendPrefix` or `.slideTopBottomPrefix`, the word you pass as `prefix` always stays visible, and only the `placeholder` is animated after it. The prefix and the placeholder are separated by a space.

```swift
EDTSSearchField(
    text: $query,
    placeholder: "produk",
    placeholderAnimation: EDTSSearchFieldAnimation(type: .appendPrefix, prefix: "Cari")
)
```

This shows "Cari |", then "Cari p|", "Cari pr|", and so on until "Cari produk|".

Change the cursor with `cursorSymbol`:

```swift
EDTSSearchFieldAnimation(type: .appendPrefix, cursorSymbol: "_", prefix: "Cari")
```

To have the letters slide in instead of being typed, use `.slideTopBottomPrefix`. It has no cursor.

```swift
EDTSSearchField(
    text: $query,
    placeholder: "produk",
    placeholderAnimation: EDTSSearchFieldAnimation(type: .slideTopBottomPrefix, prefix: "Cari")
)
```

- The animation runs only while the field is empty. It stops as soon as the user types, and starts over if they clear the field.
- When the whole placeholder is shown, it holds for 2 seconds and then starts again.

### Clearing from Code

Set the bound text to an empty string. The clear button does the same when tapped.

```swift
Button("Reset") {
    query = ""
}
```

### With Custom Style

```swift
var style = EDTSSearchFieldStyle()
style.bgColor = EDTSColor.grey10
style.bgActiveColor = EDTSColor.white
style.borderColor = EDTSColor.grey20
style.borderActiveColor = EDTSColor.orange40
style.iconTintColor = EDTSColor.orange40
style.cornerRadius = 20

EDTSSearchField(
    text: $query,
    placeholder: "Cari produk",
    style: style
)
```

---

## Public Interface

### `EDTSSearchField`

```swift
init(
    text: Binding<String>,
    placeholder: String = "Search",
    placeholderAnimation: EDTSSearchFieldAnimation? = nil,
    style: EDTSSearchFieldStyle = .init(),
    onSubmit: (() -> Void)? = nil
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `Binding<String>` | — (required) | The text in the field |
| `placeholder` | `String` | `"Search"` | Hint shown while the field is empty. With `.appendPrefix` or `.slideTopBottomPrefix`, this is the animated part that follows `prefix`. It is also the field's accessibility label |
| `placeholderAnimation` | `EDTSSearchFieldAnimation?` | `nil` | Animates the placeholder while the field is empty. `nil` shows it as plain text |
| `style` | `EDTSSearchFieldStyle` | `.init()` | Colors, font, and dimensions |
| `onSubmit` | `(() -> Void)?` | `nil` | Called when the user taps the keyboard's search key |

---

### `EDTSSearchFieldAnimation`

```swift
init(
    type: EDTSPlaceholderAnimationType,
    speed: TimeInterval = 0.1,
    cursorSymbol: String = "|",
    prefix: String = ""
)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | `EDTSPlaceholderAnimationType` | — (required) | `.append`, `.appendPrefix`, `.slideTopBottom`, or `.slideTopBottomPrefix` |
| `speed` | `TimeInterval` | `0.1` | Seconds between two letters. Values below `0.01` are treated as `0.01` |
| `cursorSymbol` | `String` | `"\|"` | Symbol shown after the typed part. Only used by `.appendPrefix` |
| `prefix` | `String` | `""` | Text that stays in place before the animated placeholder, separated from it by a space. Only used by `.appendPrefix` and `.slideTopBottomPrefix` |

---

### `EDTSSearchFieldStyle`

#### Colors

| Parameter | Type | Default | Description |
|---|---|---|---|
| `textColor` | `Color` | `.primary` | Color of the text the user types |
| `placeholderColor` | `Color` | System placeholder color | Color of the placeholder |
| `bgColor` | `Color` | `EDTSColor.white` | Background of the field |
| `bgActiveColor` | `Color` | `Color.clear` | Background of the field while it is focused |
| `borderColor` | `Color` | `EDTSColor.grey30` | Border color |
| `borderActiveColor` | `Color` | `EDTSColor.blue10` | Border color while the field is focused |
| `iconTintColor` | `Color` | `EDTSColor.grey60` | Tint of the search icon |
| `btnClearColor` | `Color` | `EDTSColor.grey60` | Color of the clear button |

#### Font

| Parameter | Type | Default | Description |
|---|---|---|---|
| `fontStyle` | `Font` | `EDTSFont.Klik.B3.Regular.font` | Font of the text and the placeholder |

#### Dimensions

| Parameter | Type | Default | Description |
|---|---|---|---|
| `borderWidth` | `CGFloat` | `1` | Border thickness |
| `iconSize` | `CGFloat` | `24` | Width and height of the search icon |
| `btnClearSize` | `CGFloat` | `20` | Width and height of the clear button |
| `height` | `CGFloat` | `36` | Minimum height of the field |
| `cornerRadius` | `CGFloat` | `8` | Corner radius of the field |
| `verticalPadding` | `CGFloat` | `8` | Space above and below the content, inside the border |
| `horizontalPadding` | `CGFloat` | `8` | Space between the border and the icon, and between the clear button and the border |

The field is as tall as its content plus `verticalPadding` on both sides, but never shorter than `height`. With the defaults that is 40pt (24pt icon plus 8pt above and below). Set `verticalPadding` to `6` to get 36pt.

---

### `EDTSPlaceholderAnimationType`

| Case | Description |
|---|---|
| `.append` | The placeholder is typed one letter at a time |
| `.appendPrefix` | Like `.append`, but `prefix` stays in place before the typed part, and `cursorSymbol` follows it |
| `.slideTopBottom` | Each letter slides in from the top |
| `.slideTopBottomPrefix` | Like `.slideTopBottom`, but `prefix` stays in place before the sliding letters |

---

## Behavior

| Situation | What happens |
|---|---|
| User taps anywhere on the field | The text field is focused and the keyboard opens |
| Field is focused | The border changes to `borderActiveColor` and the background to `bgActiveColor` |
| Field is focused and has text | The clear button is shown. Tapping it empties `text` |
| Field is empty | The placeholder is shown, animated if `placeholderAnimation` is set |
| User types | The placeholder and its animation stop |
| User clears the field | The placeholder comes back and its animation starts over |
| User taps the keyboard's search key | `onSubmit` is called |
| `placeholder` or `placeholderAnimation` changes | The animation restarts from the first letter |

The placeholder is the field's accessibility label (with `.appendPrefix` or `.slideTopBottomPrefix` the `prefix` is read first), and the clear button is announced as "Clear text".

---

## Animation Behavior

These animations are fixed and can't be configured, apart from the letter speed.

| Phase | Trigger | Animation | Duration | Notes |
|---|---|---|---|---|
| Letter reveal | The field is empty and `placeholderAnimation` is set | Step by step | `speed` per letter | Each letter is added after `speed` seconds. With `.appendPrefix` or `.slideTopBottomPrefix`, the `prefix` stays and only the letters after it are added |
| Hold | All letters are shown | — | 2s | The full placeholder stays before the animation starts over |
| Letter slide | `.slideTopBottom` or `.slideTopBottomPrefix` reveals a letter | Ease out | 0.2s | The letter moves 8pt down into place while fading in |

---

*For further customization, wrap `EDTSSearchField` in your own view, or contact the UX Engineering team.*
