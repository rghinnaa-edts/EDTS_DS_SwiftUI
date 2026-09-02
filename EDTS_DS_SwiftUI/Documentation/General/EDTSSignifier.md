# EDTSSignifier

`EDTSSignifier` is a single SwiftUI `View` that renders three mutually exclusive visual modes — a text **badge**, a small dot **indicator**, or a **skeleton** placeholder — selected by the `isSkeleton` / `isIndicator` flags. It's theme-aware (`klikIDM` vs `poinku`), supports either a plain string or `AttributedString` label, a solid background, capsule or rounded-rect shape, border, and drop shadow. A companion `edtsSignifier(_:)` view modifier is used to overlay a signifier on top of another view, positioned via `offsetX`/`offsetY`.

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Signifier — Label (Default)** | ![Default](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764955/badge_wdszhr.png) |
| **Signifier — Indicator** | ![Indicator](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764955/indicator_zfa8qv.png) |
| **Signifier — Skeleton** | ![Skeleton](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764956/skeleton_vzc0hd.gif) |

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS_SwiftUI/Signifier'
```

Then import it wherever you use the component:

```swift
import EDTS_DS_SwiftUI
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`) and the shared `edtsSkeleton(active:cornerRadius:)` view modifier used for the loading state.

---

## Basic Usage

### 1. Numeric Badge

```swift
EDTSSignifier(label: "3")
EDTSSignifier(label: "99+")
```

### 2. Dot Indicator

```swift
EDTSSignifier(isIndicator: true)
EDTSSignifier(bgColor: EDTSColor.green30, isIndicator: true)
```

### 3. Skeleton Placeholder

```swift
EDTSSignifier(isSkeleton: true)
EDTSSignifier(isSkeleton: true, isIndicator: true) // sizes as an indicator-shaped skeleton
```

### 4. Overlaying on Another View

```swift
Image(systemName: "bell.fill")
    .resizable()
    .scaledToFit()
    .frame(width: 32, height: 32)
    .foregroundColor(EDTSColor.greyText)
    .edtsSignifier(EDTSSignifier(label: "3", offsetY: 4, offsetX: 2))
```

### 5. Attributed Label

```swift
var attributed: AttributedString {
    var str = AttributedString("NEW")
    str.foregroundColor = .white
    return str
}

EDTSSignifier(label: nil, labelAttributed: attributed)
```

`labelAttributed` takes precedence over `label` when both are provided (`label` is forced to `nil` internally in that case).

---

## Properties Reference

### Label

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `label` | `String?` | `"0"` | Plain text label of the signifier; ignored if `labelAttributed` is set |
| `labelAttributed` | `AttributedString?` | `nil` | Rich text label; takes precedence over `label` |
| `labelColor` | `Color?` | `EDTSColor.white` | Text color of the badge label |

### Font

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fontStyle` | `Font?` | `nil` | Explicit SwiftUI `Font` override; takes precedence over `fontName`/`fontSize`/`fontWeight` and the theme default |
| `fontName` | `String` | `""` | Custom font family name; used only if `fontStyle` is `nil` or `fontSize` is non-default |
| `fontSize` | `CGFloat` | `0` | Custom font size; resolves to `16` if left at `0` |
| `fontWeight` | `String?` | `nil` | Custom font weight keyword, applied via `setupFontWeight(from:)` |

> When none of `fontStyle`, `fontName`, `fontSize`, `fontWeight` are customized, the label uses the theme default: `EDTSFont.Poinku.B5.Medium` (poinku) or `EDTSFont.Klik.B4.Semibold` (klikIDM).

### Background & Shape

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `bgColor` | `Color?` | `EDTSColor.red30` | Fill color of the signifier |
| `cornerRadius` | `CGFloat?` | `nil` | Corner radius of the signifier |

### Border

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `0` | Stroke width of the signifier |
| `borderColor` | `Color?` | `EDTSColor.white` (poinku) / `.clear` (klikIDM) — badge & indicator use slightly different fallback logic, see Notes | Stroke color |

### Shadow

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `0` | Opacity of the shadow |
| `shadowOffset` | `CGSize` | `.zero` | Shadow x/y offset |
| `shadowRadius` | `CGFloat` | `0` | Shadow blur radius |
| `shadowColor` | `Color?` | `nil` (resolves to `.clear`) | Shadow color |

### Padding & Position

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat?` | `nil` → `0` (poinku) / `1` (klikIDM) | Top inset inside the badge, around the label |
| `paddingBottom` | `CGFloat?` | `nil` → `0` (poinku) / `1` (klikIDM) | Bottom inset inside the badge, around the label |
| `paddingLeading` | `CGFloat` | `2` | Leading inset inside the badge |
| `paddingTrailing` | `CGFloat` | `2` | Trailing inset inside the badge |
| `offsetX` | `CGFloat` | `0` | Horizontal offset, used by the `edtsSignifier` overlay modifier |
| `offsetY` | `CGFloat` | `0` | Vertical offset, used by the `edtsSignifier` overlay modifier |

### Mode Flags

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isSkeleton` | `Bool` | `false` | Renders an `EDTSSkeleton` placeholder instead of badge/indicator content; takes priority over `isIndicator` |
| `isIndicator` | `Bool` | `false` | Renders a plain filled dot instead of a text badge (no label is shown) |

---

## Sizing

| Mode | klikIDM | poinku |
| ---- | ------- | ------ |
| Badge (`isIndicator == false`) | `16pt` min width/height | `12pt` min width/height |
| Indicator (`isIndicator == true`) | `8pt` fixed width/height | `12pt` fixed width/height |
| Skeleton | matches the size the flags above would produce, with `cornerRadius = resolvedHeight / 2` | same |

---

## Notes

- The badge view uses `.frame(minWidth:minHeight:)` (label can grow the badge horizontally for multi-character text like `"99+"`), while the indicator view uses a fixed `.frame(width:height:)` since it has no label content.
- Border color fallback differs slightly by mode: the badge's `resolvedBorderColor` computed property resolves `nil` to `EDTSColor.white` (poinku) or `.clear` (klikIDM), while the indicator view reads `borderColor` directly and falls back to `.clear` regardless of theme.
- `EDTSShape` is a small type-erasing wrapper around any SwiftUI `Shape`, letting `resolvedShape` return either a `Capsule` or a `RoundedRectangle` from a single computed property.
- This view has no built-in animation; state changes (e.g. toggling `isSkeleton` or updating `label`) render immediately unless wrapped in an external `withAnimation` by the caller.

---

*For further customization, you can ask UX Engineer or wrap `EDTSSignifier` in a custom `View` to compose additional behavior as required.*
