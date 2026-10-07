# EDTSCardMyCoupon

`EDTSCardMyCoupon` is a SwiftUI card built as a plain `View` with a leading icon, a title + description, an optional [`EDTSSignifier`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSSignifier.md) badge next to the title, a trailing chevron (or custom icon), and a press-scale tap gesture. It supports an iOS 26+ Liquid Glass background out of the box, falling back to a custom glass-style background on earlier OS versions, or a plain solid/clear fill when disabled.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Default Card** |![Card with leading icon, title, description, badge, and trailing chevron](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1768880622/default_card_e2tql3.gif)|
| **Liquid Glass Effect iOS 26** |![Card with iOS 26+ glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1768880622/liquid_glass_effect_nlcqlt.gif)|
| **Liquid Glass Effect below iOS 26** |![Card with below iOS 26 glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1770104549/liquid_glass_effect_below26_xtbx1h.gif)|

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

`EDTSCardMyCoupon` has no `isSkeleton` flag of its own; instead, pass a `badge` with `isSkeleton: true`. While that badge is in its skeleton state, taps on the card are suppressed and `onTap` is not called.

---

## Public Interface

`EDTSCardMyCoupon` is configured entirely through its initializer.

### Title

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String?` | `nil` | Plain text title; ignored if `titleAttributed` is set. Renders an empty string when `nil` |
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
| `desc` | `String?` | `nil` | Plain text description; ignored if `descAttributed` is set. Renders an empty string when `nil` |
| `descAttributed` | `AttributedString?` | `nil` | Rich text description; takes precedence over `desc` |
| `descColor` | `Color?` | `EDTSColor.grey30` | Color applied to the description |

### Description Font

| Parameter | Type | Default | Description |
|---|---|---|---|
| `descFontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font`; when set, it's used as-is and `descFontName`, `descFontSize`, and `descFontWeight` are ignored entirely |
| `descFontName` | `String` | `""` | Custom font family name |
| `descFontSize` | `CGFloat?` | `nil` → `12` | Font size for the description |
| `descFontWeight` | `String?` | `nil` → `"regular"` | Font weight keyword (ultralight, thin, light, regular, medium, semibold, bold, heavy, black)` |

### Background & Shape

| Parameter | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `Color?` | `.clear` | Solid fill color, used only when `isLiquidGlassBg` is `false` |
| `cornerRadius` | `CGFloat` | `8` | Corner radius applied to the background |
| `isLiquidGlassBg` | `Bool` | `true` | When `true`, renders a glass background (native `.glassEffect(.clear, in:)` on iOS 26+, or `EDTSLiquidGlassBackground` below that). When `false`, renders a plain `bgColor` fill |

### Icon Leading

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconLeading` | `Image?` | `nil` | Optional icon shown inside the leading circular badge, rendered at a fixed `24x24` |
| `iconTintColorLeading` | `Color?` | `EDTSColor.white` | Tint applied to `iconLeading` |
| `iconBgColorLeading` | `Color?` | `EDTSColor.white` | Base color of the leading icon's circular backdrop, used in a top-leading radial gradient (`50%` → `100%` opacity of this color), itself drawn at `30%` overall opacity |

### Icon Trailing

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconTrailing` | `Image?` | `nil` | Optional trailing icon, rendered at a fixed `16x16`. Falls back to `Image(systemName: "chevron.right")` when `nil` |
| `iconTintColorTrailing` | `Color?` | `EDTSColor.white` | Tint applied to the trailing icon |

### Badge

| Parameter | Type | Default | Description |
|---|---|---|---|
| `badge` | `EDTSSignifier?` | `nil` | Optional signifier shown inline next to the title. When its `isSkeleton` is `true`, tapping the card does not call `onTap` |

### Interaction

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onTap` | `(() -> Void)?` | `nil` | Closure invoked when a tap completes, unless `badge?.isSkeleton == true` |

---

## Background Resolution

| `isLiquidGlassBg` | OS | Background |
|---|---|---|
| `true` | iOS 26+ | Native `.glassEffect(.clear, in: RoundedRectangle(cornerRadius:style: .continuous))` |
| `true` | < iOS 26 | `EDTSLiquidGlassBackground(cornerRadius:)` |
| `false` | any | `RoundedRectangle(cornerRadius:style: .continuous).fill(bgColor ?? .clear)` |

---

*For further customization, wrap `EDTSCardMyCoupon` in your own view, or contact the UX Engineering team.*
