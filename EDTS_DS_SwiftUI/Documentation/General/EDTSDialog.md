# EDTSDialog

The `EDTSDialog` component is a modal dialog that appears in front of app content to deliver critical information or prompt for a decision — built for **SwiftUI**.

## Features

- Title, description, and supporting text, each with plain or `AttributedString` content
- Independent color, font, size, weight, and alignment control per text block
- Optional image with two layouts: standard (text-first) and image (centered, buttons above text)
- Primary and secondary buttons in a vertical or horizontal arrangement
- Optional close button with an enlarged hit area
- Configurable background, corner radius, and drop shadow
- Built-in presentation via the `.edtsDialog(isPresented:dialog:)` modifier, with dimmed backdrop and scale/fade animation
- Optional dismiss on tap outside

---

## Preview

| Type | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_300/v1782372942/WhatsApp_GIF_2026-06-25_at_14.27.13_mveimy.gif) |
| `dialog image` | ![Dialog Image Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_300/v1782372942/WhatsApp_GIF_2026-06-25_at_14.28.34_bi31lb.gif) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Dialog'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

`EDTSDialog` is normally presented with the `.edtsDialog(isPresented:dialog:)` view modifier, which handles the dimmed backdrop, animation, and dismissal.

### Basic

```swift
struct ContentView: View {
    @State private var showDialog = false

    var body: some View {
        Button("Show dialog") { showDialog = true }
            .edtsDialog(isPresented: $showDialog) {
                EDTSDialog(
                    title: "Basic dialog title",
                    desc: "A dialog is a type of modal window that appears in front of app content.",
                    onPrimaryTap: { showDialog = false },
                    onSecondaryTap: { showDialog = false }
                )
            }
    }
}
```

> **Important:** `onPrimaryTap` and `onSecondaryTap` do **not** dismiss the dialog automatically. Set your `isPresented` binding to `false` inside them. Only the close button and tap-outside dismissal are handled for you.

### Horizontal Buttons

```swift
EDTSDialog(
    title: "Delete this item?",
    desc: "This action can't be undone.",
    btnOrientation: .horizontal,
    btnPrimaryText: "Delete",
    btnPrimaryState: .danger,
    btnSecondaryText: "Cancel",
    onPrimaryTap: { showDialog = false },
    onSecondaryTap: { showDialog = false }
)
```

In horizontal orientation the secondary button is placed first (leading) and the primary button last (trailing). In vertical orientation the primary button is on top.

### With Supporting Text

```swift
EDTSDialog(
    title: "Session expired",
    desc: "Please sign in again to continue.",
    support: "Your unsaved changes were kept."
)
```

### Image Dialog

```swift
EDTSDialog(
    title: "Dialog with image",
    desc: "Centered layout with the image on top and buttons above the text.",
    support: "Supporting text sits below the description.",
    isDialogImage: true,
    onPrimaryTap: { showDialog = false },
    onSecondaryTap: { showDialog = false }
)
```

Setting `isDialogImage` to `true` switches several defaults at once. If `image` is `nil`, the `ic_placeholder` asset is shown.

### Dismiss on Tap Outside

```swift
EDTSDialog(
    title: "Tap outside to close",
    isDismissOnTapOutside: true,
    onClose: { print("Dialog closed") }
)
```

### Hiding the Close Button or Buttons

```swift
// No close button
EDTSDialog(title: "No close", isHasBtnClose: false)

// Primary only
EDTSDialog(title: "Confirm", isHasBtnSecondary: false)

// Text only, no action buttons
EDTSDialog(
    title: "Heads up",
    isHasBtnPrimary: false,
    isHasBtnSecondary: false
)
```

### Custom Background and Shadow

```swift
EDTSDialog(
    title: "Custom style",
    bgColor: EDTSColor.grey10,
    cornerRadius: 20,
    shadowColor: .black,
    shadowOpacity: 0.25,
    shadowRadius: 16,
    shadowOffset: CGSize(width: 0, height: 8)
)
```

### Using Without the Modifier

`EDTSDialog` is a regular `View`, so it can be embedded directly (for example in a custom overlay or a preview). In that case there is no backdrop and no automatic dismissal: the close button only triggers `onClose`, so you are responsible for hiding the view yourself.

---

## Layout Modes

The `isDialogImage` flag selects between two layouts and changes the defaults of several parameters. Each default below can still be overridden explicitly.

| Behavior | Standard (`isDialogImage: false`) | Image (`isDialogImage: true`) |
|---|---|---|
| Image shown | Only if `image` is set | Always (placeholder if `image` is `nil`) |
| Close button (`isHasBtnClose`) | Shown | Hidden |
| Button position (`isBtnPositionAtTopLabel`) | Below text | Above text (below image) |
| Text alignment | `.leading` | `.center` |
| Title font token | `EDTSFont.Klik.H1` | `EDTSFont.Klik.D4` |

Description and supporting text always default to `EDTSFont.Klik.P1.Regular` and `EDTSFont.Klik.P2.Regular` respectively.

---

## Properties

`EDTSDialog` is configured entirely through its initializer. All parameters are optional and have defaults.

### Title

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String?` | `nil` | Title text. Ignored when `titleAttributed` is set |
| `titleAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `title` |
| `titleColor` | `Color?` | `EDTSColor.grey70` | Title text color |
| `titleFontStyle` | `Font?` | `nil` | Explicit font. When set, takes priority over `titleFontName`/`titleFontSize`/`titleFontWeight` |
| `titleFontName` | `String` | `""` | Custom font family name. Ignored if `titleFontStyle` is set |
| `titleFontSize` | `Double` | `0` | Custom font size. Ignored if `titleFontStyle` is set. Falls back to `UIFont.systemFontSize` if `0` while `titleFontName` or `titleFontWeight` is set |
| `titleFontWeight` | `String?` | `nil` | Custom font weight, applied via `setupFontWeight(from:)`. Ignored if `titleFontStyle` is set |
| `titleAlignment` | `TextAlignment?` | `.leading` (`.center` when `isDialogImage`) | Multiline text alignment |

If `titleFontStyle`, `titleFontName`, `titleFontSize`, and `titleFontWeight` are all unset, the design-token font for the current layout mode is used.

### Description

| Parameter | Type | Default | Description |
|---|---|---|---|
| `desc` | `String?` | `nil` | Description text. Ignored when `descAttributed` is set |
| `descAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `desc` |
| `descColor` | `Color?` | `EDTSColor.grey50` | Description text color |
| `descFontStyle` | `Font?` | `nil` | Explicit font. Takes priority over the name/size/weight parameters |
| `descFontName` | `String` | `""` | Custom font family name. Ignored if `descFontStyle` is set |
| `descFontSize` | `Double` | `0` | Custom font size. Same fallback rules as `titleFontSize` |
| `descFontWeight` | `String?` | `nil` | Custom font weight. Ignored if `descFontStyle` is set |
| `descAlignment` | `TextAlignment?` | `.leading` (`.center` when `isDialogImage`) | Multiline text alignment |

### Support Text

| Parameter | Type | Default | Description |
|---|---|---|---|
| `support` | `String?` | `nil` | Supporting text shown below the description. Ignored when `supportAttributed` is set |
| `supportAttributed` | `AttributedString?` | `nil` | When set, rendered instead of `support` |
| `supportColor` | `Color?` | `EDTSColor.grey40` | Supporting text color |
| `supportFontStyle` | `Font?` | `nil` | Explicit font. Takes priority over the name/size/weight parameters |
| `supportFontName` | `String` | `""` | Custom font family name. Ignored if `supportFontStyle` is set |
| `supportFontSize` | `Double` | `0` | Custom font size. Same fallback rules as `titleFontSize` |
| `supportFontWeight` | `String?` | `nil` | Custom font weight. Ignored if `supportFontStyle` is set |
| `supportAlignment` | `TextAlignment?` | `.leading` (`.center` when `isDialogImage`) | Multiline text alignment |

### Image

| Parameter | Type | Default | Description |
|---|---|---|---|
| `image` | `Image?` | `nil` | Image shown at the top of the dialog. Falls back to the `ic_placeholder` asset when `isDialogImage` is `true` and this is `nil` |
| `imageSize` | `Double?` | `256` | Width and height of the image (rendered as a square, scaled to fit). Values `<= 0` or `nil` use the default |

### Close Button

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isHasBtnClose` | `Bool?` | `nil` | Show or hide the close button. When `nil`, shown unless `isDialogImage` is `true` |
| `btnCloseSize` | `Double` | `16` | Size of the close icon. The tappable area is `2×` this size |
| `btnCloseTintColor` | `Color?` | `EDTSColor.grey50` | Tint of the close icon |
| `onClose` | `(() -> Void)?` | `nil` | Called when the close button is tapped, or on tap outside when `isDismissOnTapOutside` is `true` |

The close button is inset `16` pt from the top and trailing edges, and pressing it shows a circular ripple. When it is visible, the title reserves trailing space so it never overlaps the icon.

### Buttons

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isHasBtnPrimary` | `Bool` | `true` | Show or hide the primary button |
| `isHasBtnSecondary` | `Bool` | `true` | Show or hide the secondary button |
| `btnOrientation` | `Orientation` | `.vertical` | `.vertical` stacks buttons (primary on top). `.horizontal` places them side by side (secondary leading, primary trailing) |
| `btnPrimaryText` | `String?` | `"Button"` | Primary button label |
| `btnPrimaryState` | `BtnState` | `.default` | Primary button state (for example `.danger`) |
| `btnSecondaryText` | `String?` | `"Button"` | Secondary button label |
| `btnSecondaryState` | `BtnState` | `.default` | Secondary button state |
| `isBtnPositionAtTopLabel` | `Bool?` | `nil` | Place the buttons above the text block. When `nil`, `true` if `isDialogImage` is `true`, otherwise `false` |
| `onPrimaryTap` | `(() -> Void)?` | `nil` | Called when the primary button is tapped. Does not dismiss the dialog |
| `onSecondaryTap` | `(() -> Void)?` | `nil` | Called when the secondary button is tapped. Does not dismiss the dialog |

Both buttons are rendered as `EDTSButton` with `.large` size.

### Layout Mode

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isDialogImage` | `Bool` | `false` | Switches to the image layout. |

### Background & Shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color?` | `EDTSColor.white` | Dialog background color |
| `cornerRadius` | `Double` | `12` | Corner radius of the dialog background |
| `shadowColor` | `Color?` | `.black` | Color of the drop shadow |
| `shadowOpacity` | `Double` | `0.15` | Opacity of the drop shadow |
| `shadowRadius` | `Double` | `12` | Blur radius of the drop shadow |
| `shadowOffset` | `CGSize` | `(0, 4)` | Offset of the drop shadow |

### Presentation

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isDismissOnTapOutside` | `Bool` | `false` | Dismiss the dialog (and call `onClose`) when the dimmed backdrop is tapped. Only applies when presented via `.edtsDialog` |

---

## Presentation Modifier

```swift
func edtsDialog(
    isPresented: Binding<Bool>,
    dialog: @escaping () -> EDTSDialog
) -> some View
```

| Parameter | Description |
|---|---|
| `isPresented` | Binding that controls visibility. Set to `true` to show, `false` to hide |
| `dialog` | Closure returning the `EDTSDialog` to display |

### Animation

| Setting | Value |
|---|---|
| Backdrop dim opacity | `0.5` (black) |
| Present animation | `easeOut`, `0.25s`, scale from `0.8` plus fade |
| Dismiss animation | `easeIn`, `0.2s` after a `0.25s` delay |
| Horizontal margin | `24` pt on each side |

The close button and tap-outside gesture both set `isPresented` to `false` for you. Because the dialog closure is re-evaluated each time the dialog is presented, values captured in it (such as `title`) are always current.

---

*For further customization, wrap `EDTSDialog` in your own view, or contact the UX Engineering team.*
