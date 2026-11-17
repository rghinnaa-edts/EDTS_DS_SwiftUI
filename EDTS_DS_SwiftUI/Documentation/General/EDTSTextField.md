# EDTSTextField

The `EDTSTextField` component is a form input with a title above the value inside the same box — it supports leading and trailing icons, password and clear buttons, a support message, a character counter, and four visual states (default, focus, error, disabled).

## Features

- Four states — `default`, `focus`, `error`, and `disabled` — each with its own colors, and a border and background that fade between them
- Title with an optional required marker (`*`), and an `AttributedString` title for rich text
- Leading and trailing icons, which can be tappable
- Password mode with a show/hide button, and a clear button that appears when there is text
- Support message below the field, and a character counter that stops typing at the limit
- Read-only mode, keyboard type and return key options, and focus control from outside
- Colors per state, fonts, and dimensions configurable through `EDTSTextFieldStyle`

## Preview
![Text Field Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1779176347/WhatsApp_GIF_2026-05-19_at_14.35.04_x3phsr.gif)
| State             | Preview                 |
|-------------------|-------------------------|
| `Default`         | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779176325/Screenshot_2026-05-19_at_14.38.38_mdbmmu.png) |
| `Focus`           | ![Focus Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177171/Screenshot_2026-05-19_at_14.52.46_byq8hv.png) |
| `Error`           | ![Error Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177095/Screenshot_2026-05-19_at_14.51.30_sayl05.png) |
| `Disabled`        | ![Disabled Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177130/Screenshot_2026-05-19_at_14.52.06_bsa40r.png) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/TextField'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

---

## Usage

Every text field needs a `@State` variable of type `String` bound to `text`.

### Basic

```swift
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        EDTSTextField(
            text: $name,
            title: "Nama lengkap",
            placeholder: "Masukkan nama"
        )
        .padding(.horizontal, 16)
    }
}
```

The field fills the width it is given and has no outer margin, so add your own padding.

### Required Field

```swift
EDTSTextField(
    text: $name,
    title: "Nama lengkap",
    placeholder: "Masukkan nama",
    isRequired: true
)
```

A red `*` is shown after the title. It only appears when the field has a title.

### Support Message

```swift
EDTSTextField(
    text: $name,
    title: "Nama lengkap",
    supportMessage: "Sesuai KTP"
)
```

The message is shown below the field, up to 3 lines.

### Error State

The component doesn't validate anything itself. Set `state` to `.error` when your own validation fails, and use the support message to say why.

```swift
EDTSTextField(
    text: $email,
    title: "Email",
    placeholder: "Masukkan email",
    supportMessage: isEmailValid ? nil : "Format email tidak valid",
    state: isEmailValid ? .default : .error,
    keyboardType: .emailAddress
)
```

### Disabled and Read-Only

```swift
// Greyed out, with the disabled colors
EDTSTextField(text: $value, title: "Nonaktif", state: .disabled)

// Looks normal, but the user can't type
EDTSTextField(text: $value, title: "Kode referral", isReadOnly: true)
```

### Icons

Pass an `Image` for a leading and/or trailing icon. Icons are tinted with the style colors, so the image's own colors are ignored.

```swift
EDTSTextField(
    text: $query,
    placeholder: "Cari",
    iconLeading: Image(systemName: "magnifyingglass"),
    iconTrailing: Image(systemName: "mic"),
    onIconTrailingTap: { startVoiceSearch() }
)
```

An icon is only tappable when you pass its `onIconLeadingTap` or `onIconTrailingTap`. A tappable icon shows a circle behind it while it is pressed.

### Password

```swift
EDTSTextField(
    text: $password,
    title: "Password",
    placeholder: "Masukkan password",
    isPassword: true
)
```

- The text is hidden, and a trailing eye icon shows or hides it.
- Set `isPasswordToggleHide: true` to remove the eye icon and keep the text hidden.
- In password mode the trailing icon is always the eye icon, so `iconTrailing` and `isClearable` have no effect.

### Clearable

```swift
EDTSTextField(
    text: $query,
    placeholder: "Cari produk",
    isClearable: true
)
```

A clear icon fades in on the trailing side when the field has text, and empties it when tapped. Its space is always reserved, so the text doesn't shift when the icon appears.

### Character Counter

```swift
EDTSTextField(
    text: $bio,
    title: "Bio",
    placeholder: "Ceritakan tentang kamu",
    counterMax: 50
)
```

- The counter shows `12/50` on the right below the field.
- Typing and pasting stop at `counterMax`; extra characters are cut off.
- Set `isCounterHide: true` to keep the limit but hide the counter.

### Keyboard and Submit

```swift
EDTSTextField(
    text: $email,
    title: "Email",
    keyboardType: .emailAddress,
    submitLabel: .next,
    onSubmit: { focusPassword = true }
)
```

`onSubmit` is called when the user taps the keyboard's return key.

### Controlling Focus from Code

Pass a `Binding<Bool>` as `isFocused`. It follows the field's focus, and setting it focuses or dismisses the field.

```swift
@State private var isEmailFocused = false

EDTSTextField(text: $email, title: "Email", isFocused: $isEmailFocused)

Button("Edit email") { isEmailFocused = true }
```

### With a Custom Title

```swift
var title = AttributedString("Nama ")
var bold = AttributedString("lengkap")
bold.font = .system(size: 12, weight: .bold)
title.append(bold)

EDTSTextField(text: $name, titleAttributed: title)
```

`titleAttributed` takes priority over `title`, but the title's color and font from the style still apply wherever the attributed text doesn't set its own.

### With Custom Style

Colors that depend on the state are `EDTSTextFieldStateValue`s. Set one state, or give every state the same value.

```swift
var style = EDTSTextFieldStyle()

// One state
style.borderColor.focus = EDTSColor.orange40

// All states
style.bgColor = EDTSTextFieldStateValue(EDTSColor.grey10)

// Every state spelled out
style.valueColor = EDTSTextFieldStateValue(
    default: EDTSColor.grey80,
    focus: EDTSColor.grey80,
    error: EDTSColor.red30,
    disabled: EDTSColor.grey60
)

style.cornerRadius = 12

EDTSTextField(text: $name, title: "Nama", style: style)
```

---

## Properties

### `EDTSTextField`

```swift
init(
    text: Binding<String>,
    title: String? = nil,
    titleAttributed: AttributedString? = nil,
    placeholder: String? = nil,
    supportMessage: String? = nil,
    iconLeading: Image? = nil,
    iconTrailing: Image? = nil,
    state: EDTSTextFieldState = .default,
    isRequired: Bool = false,
    isPassword: Bool = false,
    isPasswordToggleHide: Bool = false,
    isClearable: Bool = false,
    isReadOnly: Bool = false,
    counterMax: Int? = nil,
    isCounterHide: Bool = false,
    keyboardType: UIKeyboardType = .default,
    submitLabel: SubmitLabel = .done,
    style: EDTSTextFieldStyle = .init(),
    isFocused: Binding<Bool>? = nil,
    onIconLeadingTap: (() -> Void)? = nil,
    onIconTrailingTap: (() -> Void)? = nil,
    onSubmit: (() -> Void)? = nil
)
```

#### Content

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `Binding<String>` | — (required) | The text in the field |
| `title` | `String?` | `nil` | Title shown above the value, inside the box. Limited to one line |
| `titleAttributed` | `AttributedString?` | `nil` | When set, shown instead of `title` |
| `placeholder` | `String?` | `nil` | Hint shown while the field is empty |
| `supportMessage` | `String?` | `nil` | Text below the field, up to 3 lines. Use it for hints and error messages |
| `iconLeading` | `Image?` | `nil` | Icon before the text |
| `iconTrailing` | `Image?` | `nil` | Icon after the text. Not used in password mode or when `isClearable` is `true` |

#### State & Behavior

| Parameter | Type | Default | Description |
|---|---|---|---|
| `state` | `EDTSTextFieldState` | `.default` | Visual state. See "States" below |
| `isRequired` | `Bool` | `false` | Shows a `*` after the title |
| `isPassword` | `Bool` | `false` | Hides the text and shows a show/hide button |
| `isPasswordToggleHide` | `Bool` | `false` | Hides the show/hide button in password mode |
| `isClearable` | `Bool` | `false` | Shows a clear button while the field has text. Not used in password mode |
| `isReadOnly` | `Bool` | `false` | The user can't edit or focus the field, but it keeps the normal look |
| `counterMax` | `Int?` | `nil` | Maximum number of characters, shown as a counter. `nil` means no limit and no counter |
| `isCounterHide` | `Bool` | `false` | Hides the counter but keeps the limit |
| `keyboardType` | `UIKeyboardType` | `.default` | Keyboard shown when the field is focused |
| `submitLabel` | `SubmitLabel` | `.done` | Label of the keyboard's return key |
| `isFocused` | `Binding<Bool>?` | `nil` | Reads and controls whether the field is focused |

#### Appearance & Actions

| Parameter | Type | Default | Description |
|---|---|---|---|
| `style` | `EDTSTextFieldStyle` | `.init()` | Colors, fonts, and dimensions |
| `onIconLeadingTap` | `(() -> Void)?` | `nil` | Called when the leading icon is tapped. The icon is only tappable when this is set |
| `onIconTrailingTap` | `(() -> Void)?` | `nil` | Called when the trailing icon is tapped. The icon is only tappable when this is set. The password and clear buttons don't call it |
| `onSubmit` | `(() -> Void)?` | `nil` | Called when the user taps the keyboard's return key |

---

### `EDTSTextFieldState`

| Case | Description |
|---|---|
| `.default` | Normal look. Switches to the focus look by itself while the user is typing |
| `.focus` | Always shows the focus look |
| `.error` | Error look. Stays in place while the user types |
| `.disabled` | Disabled look. The user can't edit or focus the field |

The look is chosen in this order: `.disabled`, then `.error`, then `.focus` (set from code, or reached by itself from `.default` while focused), then `.default`.

---

### `EDTSTextFieldStateValue`

A set of four values, one for each state.

```swift
// The same value for every state
init(_ value: Value)

// A value for each state
init(default: Value, focus: Value, error: Value, disabled: Value)
```

Its `default`, `focus`, `error`, and `disabled` properties can be changed one at a time.

---

### `EDTSTextFieldStyle`

#### Colors per state

Each of these is an `EDTSTextFieldStateValue`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleColor` | `Color` | `grey60` in every state | Title color |
| `placeholderColor` | `Color` | `grey50` in every state | Placeholder color |
| `valueColor` | `Color` | `grey80`; `grey60` when disabled | Color of the text the user types |
| `iconLeadingTintColor` | `Color` | `grey60` in every state | Tint of the leading icon |
| `iconTrailingTintColor` | `Color` | `grey60` in every state | Tint of the trailing icon |
| `bgColor` | `Color` | `white`; `errorWeak` on error; `grey20` when disabled | Background of the field |
| `borderColor` | `Color` | `grey30`; `blue30` on focus; `errorStrong` on error | Border color |
| `borderWidth` | `CGFloat` | `1` in every state | Border thickness |
| `supportTextColor` | `Color` | `grey50`; `errorStrong` on error | Color of the support message |
| `counterTextColor` | `Color` | `grey50`; `errorStrong` on error | Color of the counter |

All defaults are `EDTSColor` values.

#### Colors for every state

| Parameter | Type | Default | Description |
|---|---|---|---|
| `requiredTextColor` | `Color` | `EDTSColor.red30` | Color of the `*` |
| `passwordIconTintColor` | `Color` | `EDTSColor.grey50` | Tint of the show/hide button |
| `clearIconTintColor` | `Color` | `EDTSColor.grey50` | Tint of the clear button |
| `iconPressColor` | `Color` | `EDTSColor.grey30` at 40% | Circle shown behind a tappable icon while it is pressed |

#### Fonts

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleFont` | `Font` | `EDTSFont.Klik.H3.font` | Title and the `*` |
| `valueFont` | `Font` | `EDTSFont.Klik.B2.Regular.font` | Text the user types |
| `placeholderFont` | `Font` | `EDTSFont.Klik.B2.Regular.font` | Placeholder |
| `supportFont` | `Font` | `EDTSFont.Klik.B4.Regular.font` | Support message |
| `counterFont` | `Font` | `EDTSFont.Klik.B4.Regular.font` | Counter |

#### Dimensions

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `4` | Corner radius of the field |
| `paddingTop` | `CGFloat` | `12` | Space between the border and the content, at the top |
| `paddingBottom` | `CGFloat` | `12` | Space between the border and the content, at the bottom |
| `paddingLeading` | `CGFloat` | `12` | Space between the border and the content, at the start |
| `paddingTrailing` | `CGFloat` | `12` | Space between the border and the content, at the end |
| `iconSize` | `CGFloat` | `24` | Width and height of icons |
| `iconSpacing` | `CGFloat` | `8` | Space between an icon and the text |
| `labelSpacing` | `CGFloat` | `8` | Space between the title and the value |
| `supportSpacing` | `CGFloat` | `4` | Space between the field and the support message or counter |

The value line is always 20pt tall.

---

## Behavior

| Situation | What happens |
|---|---|
| User taps anywhere on the field | The text field is focused and the keyboard opens. Nothing happens when the field is disabled or read-only |
| `state` is `.default` and the field is focused | The field shows the focus colors |
| `state` is `.error` and the field is focused | The error colors stay. The error state is only cleared by your code |
| Field is empty | The placeholder is shown |
| `counterMax` is set and the text gets longer | The text is cut to `counterMax` characters, and the counter shows `count/counterMax` |
| `isClearable` and the field has text | The clear icon is shown. Tapping it empties `text` |
| `isPassword` and the eye icon is tapped | The text switches between hidden and visible. A focused field stays focused |
| Tappable icon is tapped | Its `onIconLeadingTap` or `onIconTrailingTap` is called |
| User taps the keyboard's return key | `onSubmit` is called |
| `supportMessage` is set or the counter is visible | A row is shown below the field. The message is on the left and the counter on the right |
| No support message and no counter | No row is shown, and no space is reserved for it |

### Trailing icon

Only one icon is shown on the trailing side. The first one that applies wins:

1. The show/hide button, when `isPassword` is `true` (hidden by `isPasswordToggleHide`)
2. The clear button, when `isClearable` is `true`
3. `iconTrailing`

The password and clear buttons use the `ic_visibility_on`, `ic_visibility_off`, and `ic_error` images from the design system bundle.

### Accessibility

The field is labeled with its `title`, or its `placeholder` when there is no title. The password button is announced as "Show password" or "Hide password", and the clear button as "Clear text". Icons without an action are hidden from VoiceOver.

---

## Animation Behavior

These animations are fixed and can't be configured.

| Phase | Trigger | Animation | Duration | Notes |
|---|---|---|---|---|
| State change | The state changes, for example on focus or error | Ease in-out | 0.25s | The background, border, and text colors fade to the new state |
| Clear button | The field becomes empty or gets text | Ease in-out | 0.2s | The clear icon fades in and out |
| Icon press | A tappable icon is pressed | None | — | A circle appears behind the icon while it is held |

---

*For further customization, wrap `EDTSTextField` in your own view, or contact the UX Engineering team.*
