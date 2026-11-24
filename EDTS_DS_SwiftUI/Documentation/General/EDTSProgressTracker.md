# EDTSProgressTracker

`EDTSProgressTracker` is a customizable progress bar that supports single-lap and multi-lap progress (values that exceed `maxValue`), an optional trailing indicator dot, an optional lap-count badge, gradient colors, a simplified loading mode, and a continuous intermittent (indeterminate) animation. Rapid value updates are debounced and queued so the fill animates smoothly instead of janking.

## Features

- **Single-lap and multi-lap progress:** `maxValue` is the length of one lap. Values above it complete laps, up to `limitValue`.
- **Lap badge:** shows the completed lap count (`x1`, `x2`, ...) with a scale-in and pulse animation, or your own custom label.
- **Trailing indicator:** a dot that follows the leading edge of the fill.
- **Loading mode:** a simplified, interruptible single-lap fill (`isLoadingState`).
- **Intermittent mode:** `stretch` and `fixed` looping animations for indeterminate progress.
- **Solid or gradient colors:** for the track, fill, completed-lap track, indicator and badge, each with its own orientation.
- **Shadows:** inner shadows (theme-aware defaults) and an optional drop shadow on the track.
- **Smooth updates:** rapid value changes are debounced and animations run sequentially.
- **Theme-aware defaults:** `klikIDM` and `poinku` have different default styling.

---

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Single-Lap** | ![Single-Lap Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1783924407/progress_tracker_limit_100_w6rw42.gif) |
| **Multi-Lap** | ![Multi-Lap Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1783924410/progress_tracker_limit_500_dte4bz.gif) |
| **Intermittent-Stretch** | ![Intermittent-Stretch Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784535807/stretch_crpiqe.gif) |
| **Intermittent-Fixed** | ![Intermittent-Fixed Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784535807/fixed_kpuqma.gif) |

## Anatomy

![Progress Tracker Anatomy](https://res.cloudinary.com/dacnnk5j4/image/upload/w_1000,c_scale,q_auto,f_auto/v1784182909/Docs_n1dare.png)

---

## Basic Usage

### Single Lap

```swift
struct ContentView: View {
    @State private var value: CGFloat = 45

    var body: some View {
        EDTSProgressTracker(value: value, maxValue: 100)
    }
}
```

### Multi-Lap with Indicator and Badge

Set `limitValue` above `maxValue` to allow progress beyond one lap.

```swift
EDTSProgressTracker(
    value: value,
    maxValue: 100,
    limitValue: 300,        // allows up to 3 laps
    isHasIndicator: true,
    isHasBadge: true
)
```

### Custom Colors

```swift
EDTSProgressTracker(
    trackFillTintColorStart: .purple,
    trackFillTintColorEnd: .pink,
    trackFillColorOrientation: .horizontal,
    trackFullTintColor: .purple,
    value: value,
    limitValue: 800,
    indicatorTintColorStart: .purple,
    indicatorTintColorEnd: .pink,
    indicatorColorOrientation: .horizontal,
    badgeTintColorStart: .purple,
    badgeTintColorEnd: .pink,
    badgeColorOrientation: .horizontal
)
```

### Loading Mode

```swift
EDTSProgressTracker(value: min(value, 100), isLoadingState: true)
```

### Intermittent (Indeterminate)

```swift
EDTSProgressTracker(
    isIntermittentState: true,
    intermittentAnimationType: .stretch   // or .fixed
)
```

### Custom Badge Label

```swift
EDTSProgressTracker(
    value: value,
    limitValue: 300,
    badgeLabel: "Bonus",
    badgeFontSize: 10,
    badgeFontWeight: .semibold
)
```

---

## Progress Behavior

`EDTSProgressTracker` treats `maxValue` as the length of a single "lap" of the track. Setting `value` higher than `maxValue` completes one or more laps:

- Each time `value` crosses a multiple of `maxValue`, the fill animates to 100%, the badge (if enabled) updates its lap count label (`x1`, `x2`, ...) and pulses, and the fill then resets to animate the remaining partial lap.
- `limitValue` caps the maximum value the tracker will accept (values above it are clamped). It defaults to `maxValue`, so progress is single-lap unless you set `limitValue` above `maxValue`.
- Rapid, successive value changes within a `300ms` window are debounced. If several updates land in the same debounce window (or the jump between the last processed value and the new target exceeds two laps), intermediate lap animations are compressed into a single "spam" animation instead of animating every lap individually.
- All lap and partial-fill animations are queued and run sequentially, so overlapping updates never interrupt an in-flight animation.
- Decreasing `value` animates back through the laps (a single handover when the change is compressed).
- Setting `isLoadingState` to `true` switches the tracker into a simplified loading mode: it cancels any pending debounce and queued animations, hides the full-track (completed lap) layer, and pins the limit to `maxValue`. While active, `value` changes bypass the debounced multi-lap logic and animate as a single interruptible fill.
- Setting `isIntermittentState` to `true` starts a continuous, looping animation that ignores `value` (useful for indeterminate progress). Setting it back to `false` resets the fill and animates to the current `value` again.

---

## Properties Reference

All properties are set through the initializer. Every parameter is optional and has a default.

### General Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `value` | `CGFloat` | `0` | Current progress value. Clamped to `limitValue` and triggers a debounced fill animation |
| `maxValue` | `CGFloat` | `100` | The value that represents one full "lap" of the track |
| `limitValue` | `CGFloat?` | `nil` (`maxValue`) | Maximum value the tracker will accept. Set above `maxValue` to enable multi-lap |
| `isLoadingState` | `Bool` | `false` | Simplified loading mode (see Progress Behavior) |
| `isHasIndicator` | `Bool?` | `nil` (theme-dependent) | Shows/hides the trailing indicator dot. `nil` uses the theme default |
| `isHasBadge` | `Bool?` | `nil` (theme-dependent) | Shows/hides the lap-count badge. `nil` uses the theme default |

### Intermittent Animation Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isIntermittentState` | `Bool` | `false` | Starts/stops a continuous looping animation that ignores `value` |
| `intermittentAnimationType` | `EDTSIntermittentAnimationType` | `.stretch` | Style of the looping animation. `.stretch` grows the fill from empty to full track width, then shrinks it back down. `.fixed` slides a fixed-width bar (1/3 of the track width) across the track |

### Track Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackTintColor` | `Color?` | Theme-dependent (`grey20` / `white`) | Track background color (ignored if gradient is set) |
| `trackTintColorStart` | `Color?` | `nil` | Start color for track gradient |
| `trackTintColorEnd` | `Color?` | `nil` | End color for track gradient |
| `trackColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the track |
| `trackHeight` | `CGFloat` | `-1` (`6`) | Height of the track; any negative value resolves to `6` |
| `trackCornerRadius` | `CGFloat` | `-1` | Corner radius for track, full-track and fill; when `< 0`, corners are fully rounded (pill shape) |
| `trackPaddingTop` | `CGFloat` | `-1` (theme-dependent) | Top inset applied to the full-track and fill; when `< 0`, uses the theme default |
| `trackPaddingBottom` | `CGFloat` | `-1` (theme-dependent) | Bottom inset applied to the full-track and fill; when `< 0`, uses the theme default |
| `trackPaddingLeading` | `CGFloat` | `-1` (theme-dependent) | Leading inset applied to the full-track and fill; when `< 0`, uses the theme default |
| `trackPaddingTrailing` | `CGFloat` | `-1` (theme-dependent) | Trailing inset applied to the full-track and fill; when `< 0`, uses the theme default |

### Track Fill Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFillTintColor` | `Color?` | `nil` | Solid fill color (ignored if gradient is set) |
| `trackFillTintColorStart` | `Color?` | `nil` (`skyblueLeading` when no fill color is set) | Start color for fill gradient |
| `trackFillTintColorEnd` | `Color?` | `nil` (`skyblueTrailing` when no fill color is set) | End color for fill gradient |
| `trackFillColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the fill |

### Track Full (Completed Lap) Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFullTintColor` | `Color?` | Theme-dependent | Background color shown once a lap is completed (ignored if gradient is set) |
| `trackFullTintColorStart` | `Color?` | `nil` | Start color for full-track gradient |
| `trackFullTintColorEnd` | `Color?` | `nil` | End color for full-track gradient |
| `trackFullColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the full-track |

### Track Inner Shadow Properties

If any of these properties is set, a single inner shadow is used instead of the theme default.

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackInnerShadowOpacity` | `Float?` | `nil` (theme-dependent) | Inner shadow opacity for the track |
| `trackInnerShadowRadius` | `CGFloat?` | `nil` (theme-dependent) | Inner shadow blur radius |
| `trackInnerShadowOffset` | `CGSize?` | `nil` (theme-dependent) | Inner shadow offset |
| `trackInnerShadowColor` | `Color?` | `nil` (black) | Inner shadow color |

### Track Shadow Properties

The drop shadow is only rendered when `trackShadowOpacity > 0`.

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackShadowOpacity` | `Float` | `0` | Drop shadow opacity for the track |
| `trackShadowRadius` | `CGFloat` | `3` | Drop shadow blur radius |
| `trackShadowOffset` | `CGSize` | `CGSize(width: 0, height: -3)` | Drop shadow offset |
| `trackShadowColor` | `Color?` | `nil` (black) | Drop shadow color |

### Indicator Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `indicatorTintColor` | `Color?` | `nil` | Indicator solid color (ignored if gradient is set) |
| `indicatorTintColorStart` | `Color?` | `nil` (`skyblueLeading` when no color is set) | Start color for indicator gradient |
| `indicatorTintColorEnd` | `Color?` | `nil` (`skyblueTrailing` when no color is set) | End color for indicator gradient |
| `indicatorColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the indicator |
| `indicatorSize` | `CGFloat` | `8` | Width/height of the indicator dot |
| `indicatorCornerRadius` | `CGFloat` | `-1` | Corner radius of the indicator; when `< 0`, the indicator is fully circular |

### Badge Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `badgeLabel` | `String?` | `nil` | Custom badge text |
| `badgeLabelAttributed` | `AttributedString?` | `nil` | Attributed badge text (takes priority over `badgeLabel`) |
| `badgeLabelColor` | `Color?` | `EDTSColor.white` | Badge label text color |
| `badgeFontStyle` | `Font?` | `nil` | Design-system font style for the badge label. When set, it takes priority over `badgeFontName`, `badgeFontSize` and `badgeFontWeight` |
| `badgeFontName` | `String` | `""` (system font) | Custom font name for the badge label. When set, `badgeFontWeight` is not applied |
| `badgeFontSize` | `CGFloat` | `8` | Font size for the badge label |
| `badgeFontWeight` | `Font.Weight` | `.bold` | Font weight for the badge label (system font only) |
| `badgeTintColor` | `Color?` | `nil` | Badge solid color (ignored if gradient is set) |
| `badgeTintColorStart` | `Color?` | `nil` (`skyblueLeading` when no color is set) | Start color for badge gradient |
| `badgeTintColorEnd` | `Color?` | `nil` (`skyblueTrailing` when no color is set) | End color for badge gradient |
| `badgeColorOrientation` | `EDTSGradientOrientation?` | `.horizontal` | Gradient direction for the badge |
| `badgeSize` | `CGFloat` | `16` | Minimum width/height of the badge (grows to fit text + padding) |
| `badgeCornerRadius` | `CGFloat` | `-1` | Corner radius of the badge; when `< 0`, the badge is fully circular |
| `badgePaddingTop` | `CGFloat` | `2` | Top inset inside the badge |
| `badgePaddingBottom` | `CGFloat` | `2` | Bottom inset inside the badge |
| `badgePaddingLeading` | `CGFloat` | `4` | Leading inset inside the badge |
| `badgePaddingTrailing` | `CGFloat` | `4` | Trailing inset inside the badge |

> **Note:** If `badgeLabel` and `badgeLabelAttributed` are both `nil`, the badge label is generated automatically on each completed lap (`x1`, `x2`, `x3`, ...). Setting either one disables the auto-generated lap text.

---

## Theme-Dependent Default Styling

Defaults depend on `EDTSColor.theme`:

| Theme | Track Padding | Full Track Color | Track Color | Indicator | Badge | Inner Shadow |
| ----- | ------------- | ----------------- | ----------- | --------- | ----- | ------------ |
| `.klikIDM` | `1pt` all sides | `blue30` | `grey20` | Enabled | Enabled | Single inner shadow, `10%` opacity, `2pt` radius |
| `.poinku` | `0pt` all sides | `blue10` when `limitValue > maxValue`, otherwise `clear` | `white` | Disabled | Disabled | Dual inner shadow (top `8%`/`2pt` and bottom `10%`/`2pt`) |

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| `Value Debounce` | `300ms` | — | Rapid successive `value` updates are debounced before triggering fill animations |
| `Fill Width (Partial)` | `800ms` | `EaseInOut` | Animates the fill width to the target value within the current lap |
| `Fill Width (Lap Complete)` | `800ms` | `EaseInOut` | Animates the fill to 100% width when a lap is completed |
| `Indicator Scale Down` | `200ms` | `EaseInOut` | Scales the indicator dot down to near-zero before the fill animates |
| `Indicator Scale Up` | `200ms` | `EaseInOut` | Scales the indicator dot back up to full size once the fill animation completes |
| `Badge Scale In` | `200ms` | `EaseInOut` | Scales the badge in from zero on the first completed lap |
| `Badge Pulse` | `200ms` + `200ms` | `EaseInOut` | Scales the badge up to `110%` then back to `100%` on each subsequent completed lap |
| `Full Track Fade` | `400ms` | `EaseInOut` | Fades the fill out while the full-track (completed) layer shows between laps, followed by a `300ms` pause |
| `Intermittent Stretch (Grow/Shrink)` | `700ms` grow + `700ms` shrink | `EaseInOut` | Fill grows from empty to the full track width, then its leading edge catches up to shrink it back to zero width. Repeats continuously |
| `Intermittent Fixed (Grow/Slide/Shrink)` | `2100ms` total (`700ms` × 3) | `Linear` | A fixed-width bar (1/3 of the track width) grows in from the leading edge, slides across the track, then shrinks off the trailing edge. Repeats continuously |

---

## Notes

- The lap badge appears once the first lap is completed (when `isHasBadge` is enabled), and the full-track layer becomes visible at the same time
- In loading mode the full-track layer stays hidden, and the badge only appears when the value reaches `maxValue`
- While an intermittent `stretch` or `fixed` animation is running, the indicator, badge and full-track layer are hidden, and queued animations are canceled
- When `isIntermittentState` returns to `false`, the lap state is reset and the tracker animates to the current `value`
- On first appearance with a non-zero `value`, the fill animates from empty to the value
- `maxValue <= 0` disables fill animation and reports `0 percent` for accessibility

---

*For further customization, you can ask UX Engineer or wrap `EDTSProgressTracker` in your own view, or add additional functionality as required.*
