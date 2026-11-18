# EDTSCircularLoading

`EDTSCircularLoadingView` is a SwiftUI circular progress ring drawn with masked solid or gradient fills. It supports determinate progress with an animated fill, solid or gradient track/fill colors, inner and drop shadows, and an indeterminate "intermittent" mode with three animation styles (`stretch`, `fixed`, `doubleArc`).

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Loading (Determinate)** | *(add preview)* |
| **Loading — Gradient Fill + Inner Shadow** | *(add preview)* |
| **Intermittent — Stretch** | *(add preview)* |
| **Intermittent — Fixed** | *(add preview)* |
| **Intermittent — Double Arc** | *(add preview)* |

## Basic Usage

### 1. Determinate Progress

```swift
struct ContentView: View {
    @State private var value: CGFloat = 40

    var body: some View {
        EDTSCircularLoadingView(
            value: value,        // animates the fill from its current position
            maxValue: 100,
            trackTintColor: Color(.systemGray5),
            trackFillTintColor: .blue
        )
    }
}
```

### 2. Custom Size, Gradient Fill and Inner Shadow

```swift
EDTSCircularLoadingView(
    value: value,
    trackFillTintColorStart: .purple,
    trackFillTintColorEnd: .pink,
    trackFillColorOrientation: .diagonalUp,
    trackSize: 80,
    trackThickness: 10,
    trackInnerShadowOpacity: 1,
    trackInnerShadowRadius: 8,
    trackInnerShadowOffset: CGSize(width: 4, height: 4),
    trackInnerShadowColor: EDTSColor.red50
)
```

### 3. Indeterminate ("Intermittent") Progress

```swift
EDTSCircularLoadingView(
    isIntermittentState: true,
    intermittentAnimationType: .stretch   // or .fixed, .doubleArc
)
```

### 4. Double Arc

```swift
EDTSCircularLoadingView(
    trackSize: 64,
    isIntermittentState: true,
    intermittentAnimationType: .doubleArc
)
```

## Properties Reference

All properties are set through the initializer. Every parameter is optional and has a default.

### Progress Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `value` | `CGFloat` | `0` | Current progress value; clamped between `0` and `maxValue` |
| `maxValue` | `CGFloat` | `100` | Upper bound for `value`. If `maxValue <= 0`, progress is `0` |
| `trackSize` | `CGFloat` | `50` | Outer diameter of the ring (the view is `trackSize` × `trackSize`) |
| `trackThickness` | `CGFloat` | `-1` | Stroke width of the ring; any negative value resolves to a default of `6` |
| `lineCapStyle` | `CGLineCap` | `.round` | Stroke line cap: `.round`, `.square`, or `.butt` |
| `trackPaddingTop` | `CGFloat` | `0` | Inset applied to the fill ring's outer edge relative to the track |
| `trackPaddingBottom` | `CGFloat` | `0` | Inset applied to the fill ring's inner edge relative to the track |

### Track Color Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackTintColor` | `Color?` | `EDTSColor.grey20` | Solid track color, used when no gradient start/end is set |
| `trackTintColorStart` | `Color?` | `nil` | Gradient start color for the track; setting either start or end switches the track to a gradient |
| `trackTintColorEnd` | `Color?` | `nil` | Gradient end color for the track; setting either start or end switches the track to a gradient |
| `trackColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the track |

### Fill Color Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFillTintColor` | `Color?` | `nil` | Solid fill color, used when no gradient start/end is set |
| `trackFillTintColorStart` | `Color?` | `nil` | Gradient start color for the fill; setting either start or end switches the fill to a gradient |
| `trackFillTintColorEnd` | `Color?` | `nil` | Gradient end color for the fill; setting either start or end switches the fill to a gradient |
| `trackFillColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the fill |

> **Note:** When no fill color is set at all (solid or gradient), the fill uses a default horizontal gradient from `EDTSColor.skyblueLeading` to `EDTSColor.skyblueTrailing`. If only one of start/end is set, the missing color is `clear`.

### `EDTSGradientOrientation` Enum

| Case | Direction |
| ---- | --------- |
| `.horizontal` | Left to right |
| `.vertical` | Top to bottom |
| `.diagonalUp` | Rising left-to-right (like `/`), at a 10° angle |
| `.diagonalDown` | Falling left-to-right (like `\`), at a 170° angle |

> **Note:** The gradient is applied across the whole view frame, then masked by the ring. It is not applied along the arc.

### Track Shadow Properties

The drop shadow is only rendered when `trackShadowOpacity > 0`.

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackShadowOpacity` | `Float` | `0` | Drop shadow opacity applied to the track |
| `trackShadowRadius` | `CGFloat` | `0` | Drop shadow blur radius |
| `trackShadowOffset` | `CGSize` | `.zero` | Drop shadow offset |
| `trackShadowColor` | `Color?` | `nil` (`EDTSColor.black`) | Drop shadow color |

### Track Inner Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackInnerShadowOpacity` | `Float?` | `0.10` | Inner shadow opacity. Set `0` to hide the inner shadow |
| `trackInnerShadowRadius` | `CGFloat?` | `2` | Inner shadow blur radius |
| `trackInnerShadowOffset` | `CGSize?` | `.zero` | Inner shadow offset |
| `trackInnerShadowColor` | `Color?` | `nil` (`EDTSColor.black`) | Inner shadow color |

### Intermittent Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isIntermittentState` | `Bool` | `false` | Enables/disables the indeterminate looping animation |
| `intermittentAnimationType` | `EDTSIntermittentAnimationType` | `.stretch` | Animation type for the intermittent state: `.stretch`, `.fixed`, `.doubleArc` |
| `doubleArcGap` | `CGFloat` | `4` | Radial gap between the outer fill ring and the inner double-arc ring, used only in `.doubleArc` mode |

### `EDTSIntermittentAnimationType` Enum

```swift
public enum EDTSIntermittentAnimationType {
    case stretch
    case fixed
    case doubleArc
}
```

## Intermittent Animation Types

| Type | Behavior |
| ---- | -------- |
| `.stretch` | The fill ring rotates continuously (`2.4s`/revolution) while its start/end animate through a 4-keyframe stretch-and-catch-up cycle (`1.33s` loop, ease-in-out) |
| `.fixed` | The fill ring rotates continuously (`1.0s`/revolution) holding a fixed arc length (`25%` of the ring) |
| `.doubleArc` | Track and inner shadow are hidden. Two arcs, the outer fill ring and a separate inner ring offset by `doubleArcGap`, each hold a fixed arc length (`75%` of the ring) and counter-rotate at `1.4s`/revolution (outer clockwise, inner counter-clockwise) |

> **Note:** In `.doubleArc`, the inner ring is only drawn when its radius is greater than `0` (so a very small `trackSize` or a large `trackThickness`/`doubleArcGap` hides it).

## Animation Details

| Aspect | Value |
| ------ | ----- |
| Determinate fill change | `1.0s` ease-in-ease-out animation of the fill amount. Retargeting mid-animation continues from the current position |
| Initial fill | On first appearance the fill animates from `0` to the current `value` |
| Fill at zero | No arc is drawn at `0`, so a round cap does not leave a residual dot |
| Fill at 100% | Drawn as a full closed ring (no cap seam) |
| Intermittent animation | Continuous, time-based loop driven by a `TimelineView`. It restarts when the view appears or when `intermittentAnimationType` changes |

## Notes

- While `isIntermittentState` is `true`, `value` is ignored visually. Changes to it are tracked without animation, so the determinate ring starts from the latest value when you switch back
- The inner shadow is rendered only when its opacity is greater than `0`. It is not drawn in `.doubleArc` mode
- `trackPaddingTop` and `trackPaddingBottom` reduce the fill thickness (`thickness - paddingTop - paddingBottom`). The fill thickness never goes below `0`

---

*For further customization, you can ask UX Engineer or wrap `EDTSCircularLoadingView` in your own view, or add additional functionality as required.*
