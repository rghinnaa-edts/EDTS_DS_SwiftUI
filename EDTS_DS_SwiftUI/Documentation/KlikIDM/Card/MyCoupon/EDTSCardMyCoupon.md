# EDTSCardMyCoupon

`EDTSCardMyCoupon` is a SwiftUI card built as a plain `View` with an optional leading icon, a title + description, an optional [`EDTSSignifier`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSSignifier.md) badge next to the title, an optional trailing icon, and a press-scale tap gesture. It supports an iOS 26+ Liquid Glass background out of the box, falling back to a custom glass-style background on earlier OS versions, or a plain solid, gradient, bordered fill when disabled. Padding, spacing, icon sizes, and shadow are all configurable.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Default Card** |![Card with leading icon, title, description, badge, and trailing chevron](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793325589/Default_zbqmma.gif)|
| **Liquid Glass Effect iOS 26** |![Card with iOS 26+ glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793325590/iOS26_vah51d.gif)|
| **Liquid Glass Effect below iOS 26** |![Card with below iOS 26 glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793325590/iOS15_u3ckbl.gif)|
| **Custom** |![Card with below iOS 26 glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1793325589/Custom_jiajoj.gif)|

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/CardMyCoupon'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`), the [`EDTSSignifier`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSSignifier.md) component (used for `badge`), and the shared `EDTSLiquidGlassBackground` view used as the pre-iOS-26 glass fallback.

---

## Basic Usage

### 1. Minimal Card

```swift
EDTSCardMyCoupon(
    title: "20% Off Voucher",
    desc: "Valid until end of month",
    iconLeading: Image(systemName: "ticket.fill"),
    onTap: {}
)
```

### 2. With Badge

```swift
EDTSCardMyCoupon(
    title: "20% Off Voucher",
    desc: "Valid until end of month",
    iconLeading: Image(systemName: "ticket.fill"),
    badge: EDTSSignifier(text: "3"),
    onTap: {}
)
```

The badge is laid out inline, directly after the title, inside the same `HStack`.

### 3. Solid Background

```swift
EDTSCardMyCoupon(
    title: "Free Shipping",
    desc: "Min. purchase Rp50.000",
    bgColor: EDTSColor.grey70,
    iconLeading: Image(systemName: "shippingbox.fill"),
    isLiquidGlassBg: false,
    onTap: {}
)
```

Setting `isLiquidGlassBg` to `false` ignores the glass effect entirely and fills the card with `bgColor` (or `.clear` when `bgColor` is `nil`).

### 4. Custom Trailing Icon

```swift
EDTSCardMyCoupon(
    title: "Cashback 10%",
    desc: "No minimum purchase",
    iconLeading: Image(systemName: "percent"),
    iconTrailing: Image(systemName: "arrow.up.right"),
    onTap: {}
)
```

### 5. Attributed Title / Description

```swift
var attributedTitle: AttributedString {
    var str = AttributedString("20% Off Voucher")
    str.foregroundColor = .white
    return str
}

EDTSCardMyCoupon(
    title: nil,
    titleAttributed: attributedTitle,
    desc: "Valid until end of month",
    iconLeading: Image(systemName: "ticket.fill"),
    onTap: {}
)
```

When `titleAttributed` / `descAttributed` is non-`nil`, it takes precedence and `title` / `desc` is ignored (internally forced to `nil`).

### 6. Skeleton / Loading State

```swift
EDTSCardMyCoupon(
    title: "20% Off Voucher",
    desc: "Valid until end of month",
    iconLeading: Image(systemName: "ticket.fill"),
    badge: EDTSSignifier(isSkeleton: true),
    onTap: {}
)
```

`EDTSCardMyCoupon` has no `isSkeleton` flag of its own; instead, pass a `badge` with `isSkeleton: true`. The skeleton only affects the badge. The card itself stays interactive, and `onTap` is still called.

### 7. Gradient Background & Border

```swift
EDTSCardMyCoupon(
    title: "Free Shipping",
    desc: "Min. purchase Rp50.000",
    bgColorStart: EDTSColor.blueLeading,
    bgColorEnd: EDTSColor.blueTrailing,
    bgColorOrientation: .horizontal,
    borderWidth: 1,
    borderColor: EDTSColor.white,
    iconLeading: Image(systemName: "shippingbox.fill"),
    isLiquidGlassBg: false,
    onTap: {}
)
```

Gradient and border only apply when `isLiquidGlassBg` is `false`. When `bgColorStart` or `bgColorEnd` is set, the gradient takes priority over `bgColor`.

### 8. Custom Padding, Spacing & Icon Size

```swift
EDTSCardMyCoupon(
    title: "Cashback 10%",
    desc: "No minimum purchase",
    paddingTop: 16,
    paddingBottom: 16,
    paddingLeading: 20,
    paddingTrailing: 12,
    iconSpacing: 12,
    textSpacing: 6,
    iconLeading: Image(systemName: "percent"),
    iconLeadingSize: 20,
    iconLeadingPadding: 6,
    iconTrailing: Image(systemName: "chevron.right"),
    iconTrailingSize: 12,
    onTap: {}
)
```

### 9. Custom Icon Background

```swift
EDTSCardMyCoupon(
    title: "Cashback 10%",
    desc: "No minimum purchase",
    iconLeading: Image(systemName: "percent"),
    iconBgColorLeading: EDTSColor.grey40.opacity(0.3),
    iconTrailing: Image(systemName: "chevron.right"),
    iconBgColorTrailing: EDTSColor.grey40.opacity(0.3),
    onTap: {}
)
```

A custom icon background color is used **exactly as given**, with no opacity applied automatically. Add `.opacity(...)` yourself if you want it translucent.

---

## Public Interface

`EDTSCardMyCoupon` is configured entirely through its initializer.

### Title

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String?` | `nil` → `"Title Text"` | Plain text title; ignored if `titleAttributed` is set. Falls back to `"Title Text"` when `nil` or empty |
| `titleAttributed` | `AttributedString?` | `nil` | Rich text title; takes precedence over `title` |
| `titleColor` | `Color?` | `EDTSColor.white` | Color applied to the title |

### Title Font

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleFontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font`; when set, it's used as-is and `titleFontName`, `titleFontSize`, and `titleFontWeight` are ignored entirely |
| `titleFontName` | `String` | `""` | Custom font family name |
| `titleFontSize` | `CGFloat?` | `nil` → `14` | Font size for the title |
| `titleFontWeight` | `String?` | `nil` → `"semibold"` | Font weight keyword (ultralight, thin, light, regular, medium, semibold, bold, heavy, black) |

### Description

| Parameter | Type | Default | Description |
|---|---|---|---|
| `desc` | `String?` | `nil` → `"Description Text"` | Plain text description; ignored if `descAttributed` is set. Falls back to `"Description Text"` when `nil` or empty |
| `descAttributed` | `AttributedString?` | `nil` | Rich text description; takes precedence over `desc` |
| `descColor` | `Color?` | `EDTSColor.grey30` | Color applied to the description |

### Description Font

| Parameter | Type | Default | Description |
|---|---|---|---|
| `descFontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font`; when set, it's used as-is and `descFontName`, `descFontSize`, and `descFontWeight` are ignored entirely |
| `descFontName` | `String` | `""` | Custom font family name |
| `descFontSize` | `CGFloat?` | `nil` → `12` | Font size for the description |
| `descFontWeight` | `String?` | `nil` → `"regular"` | Font weight keyword (ultralight, thin, light, regular, medium, semibold, bold, heavy, black) |

### Background & Shape

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color?` | `.clear` | Solid fill color, used only when `isLiquidGlassBg` is `false` and no gradient is set |
| `bgColorStart` | `Color?` | `nil` | Gradient start color. Only active when `isLiquidGlassBg` is `false`; takes priority over `bgColor` |
| `bgColorEnd` | `Color?` | `nil` | Gradient end color. Only active when `isLiquidGlassBg` is `false`; takes priority over `bgColor` |
| `bgColorOrientation` | `Orientation?` | `nil` → `.horizontal` | Gradient direction. `.horizontal` runs leading → trailing, otherwise top → bottom |
| `cornerRadius` | `CGFloat` | `8` | Corner radius applied to the background, border, and clipping |
| `isLiquidGlassBg` | `Bool` | `true` | When `true`, renders a glass background (native `.glassEffect(.clear, in:)` on iOS 26+, or `EDTSLiquidGlassBackground` below that). When `false`, renders a solid or gradient fill |

### Border

Only active when `isLiquidGlassBg` is `false`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `borderWidth` | `CGFloat` | `0` | Border thickness. No border is drawn when `0` |
| `borderColor` | `Color?` | `.clear` | Border color |

### Shadow

| Parameter | Type | Default | Description |
|---|---|---|---|
| `shadowColor` | `Color?` | `.clear` | Shadow color |
| `shadowOpacity` | `Double` | `0` | Shadow opacity |
| `shadowRadius` | `Double` | `0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `.zero` | Shadow offset (x, y) |

The shadow is applied to the whole card. On the glass background it may also shadow the text and icons, so test that variant.

### Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `paddingTop` | `CGFloat` | `12` | Top padding of the card content |
| `paddingBottom` | `CGFloat` | `12` | Bottom padding of the card content |
| `paddingLeading` | `CGFloat` | `12` | Leading padding of the card content |
| `paddingTrailing` | `CGFloat` | `12` | Trailing padding of the card content |
| `iconSpacing` | `CGFloat` | `8` | Spacing between the leading icon, the text container, and the trailing icon |
| `textSpacing` | `CGFloat` | `4` | Vertical spacing between the title row and the description |

### Icon Leading

The icon and its circular backdrop are hidden when `iconLeading` is `nil`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconLeading` | `Image?` | `nil` | Optional leading icon. When `nil`, the icon and its backdrop container are not rendered |
| `iconTintColorLeading` | `Color?` | `EDTSColor.white` | Tint applied to `iconLeading` |
| `iconBgColorLeading` | `Color?` | `nil` → `EDTSColor.white` at `15%` → `30%` radial gradient | Backdrop color. A custom value is used exactly as given (solid fill, no automatic opacity). Add `.opacity(...)` yourself for a translucent look |
| `iconLeadingSize` | `CGFloat` | `24` | Width and height of the icon |
| `iconLeadingPadding` | `CGFloat` | `4` | Uniform padding between the icon and the edge of its backdrop. Container size = `iconLeadingSize + iconLeadingPadding × 2` |

### Icon Trailing

The icon is hidden when `iconTrailing` is `nil`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTrailing` | `Image?` | `nil` | Optional trailing icon. When `nil`, nothing is rendered |
| `iconTintColorTrailing` | `Color?` | `EDTSColor.white` | Tint applied to the trailing icon |
| `iconBgColorTrailing` | `Color?` | `nil` | Optional circular backdrop behind the trailing icon. No backdrop is drawn when `nil`. A custom value is used exactly as given, with no automatic opacity |
| `iconTrailingSize` | `CGFloat` | `16` | Width and height of the icon |
| `iconTrailingPadding` | `CGFloat` | `0` | Uniform padding between the icon and the edge of its backdrop. Container size = `iconTrailingSize + iconTrailingPadding × 2` |

### Badge

| Parameter | Type | Default | Description |
|---|---|---|---|
| `badge` | `EDTSSignifier?` | `nil` | Optional signifier shown inline next to the title. A skeleton badge does not block taps on the card |

### Interaction

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onTap` | `(() -> Void)?` | `nil` | Closure invoked when a tap completes. It always runs, even when the badge is in its skeleton state |

---

## Background Resolution

| `isLiquidGlassBg` | Gradient set | OS | Background |
|---|---|---|---|
| `true` | any | iOS 26+ | Native `.glassEffect(.clear, in: RoundedRectangle(cornerRadius:style: .continuous))` |
| `true` | any | < iOS 26 | `EDTSLiquidGlassBackground(cornerRadius:)` |
| `false` | yes | any | `LinearGradient` from `bgColorStart` to `bgColorEnd`, clipped to the rounded rectangle |
| `false` | no | any | `RoundedRectangle(cornerRadius:style: .continuous).fill(bgColor ?? .clear)` |

Border (`borderWidth`, `borderColor`) is only drawn when `isLiquidGlassBg` is `false`.

---

## Animation

`EDTSCardMyCoupon` has a built-in press animation: the whole card scales down while the finger is on it and springs back on release.

| Property | Value | Description |
|---|---|---|
| Pressed scale | `0.97` | Scale applied while the card is pressed |
| Resting scale | `1` | Scale when the card is idle |
| Duration | `0.1s` | Length of the press and release transition |
| Curve | `.easeInOut` | Timing curve |
| Trigger | `DragGesture(minimumDistance: 0)` | Press starts on touch down; `onTap` is called on touch up |

The animation runs on every press, including when `onTap` is `nil` or the badge is in its skeleton state. These values are internal and not exposed as parameters. Wrap the card in your own view if you need a different press effect.

---

*For further customization, wrap `EDTSCardMyCoupon` in your own view, or contact the UX Engineering team.*
