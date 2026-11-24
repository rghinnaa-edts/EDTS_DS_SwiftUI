# EDTSAnimation

`EDTSAnimation` is a set of SwiftUI view modifiers that add animated visual effects to any view: a rotating gradient border (`animateGradientBorder`), a pulsing neon glow (`animateNeonPulse`), and a selected-card state with an animated border and corner check marker (`animateCardSelected`). Each modifier is driven by a single `Bool` and can be applied to any view.

---

## Table of Contents

- [`animateGradientBorder`](#animategradientborder)
- [`animateNeonPulse`](#animateneonpulse)
- [`animateCardSelected`](#animatecardselected)
- [Animation Details](#animation-details)

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Animate Card Selected** | ![Animate Card Selected](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1793094259/card_selected_animation_l8fpad.gif) |
| **Gradient Border** | ![Gradient Border](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1784874442/gradient_border_n6tevb.gif) |
| **Neon Pulse** | ![Neon Pulse](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1784874441/neon_pulse_b9fn46.gif) |

---

## Basic Usage

### 1. Gradient Border

```swift
@State private var isAnimating = true

MyCard()
    .animateGradientBorder(isAnimating: isAnimating, cornerRadius: 12)
```

### 2. Neon Pulse

```swift
@State private var isActive = true

MyCard()
    .animateNeonPulse(isActive: isActive)
```

### 3. Card Selected

```swift
@State private var selected = 0

ForEach(options.indices, id: \.self) { index in
    MyCard(title: options[index])
        .animateCardSelected(isSelected: selected == index, cornerRadius: 12)
        .contentShape(Rectangle())
        .onTapGesture { selected = index }
}
```

### 4. Full Configuration

```swift
MyCard()
    .animateGradientBorder(
        isAnimating: isAnimating,
        width: 3,
        colors: [EDTSColor.white, EDTSColor.blue30, EDTSColor.blue50],
        cornerRadius: 12,
        duration: 3.0,
        stopDuration: 0.5,
        settleColor: EDTSColor.blue30
    )

MyCard()
    .animateCardSelected(
        isSelected: isSelected,
        cornerRadius: 12,
        tintColor: EDTSColor.blue50,
        unselectedBorderColor: EDTSColor.grey30,
        icon: UIImage(systemName: "checkmark"),
        iconTintColor: EDTSColor.white,
        iconSize: 16,
        triangleSize: 32,
        borderWidth: 1,
        durationAnimation: 0.25,
        animated: true
    )
```

---

## `animateGradientBorder`

Draws a border that holds a static `settleColor` and, while `isAnimating` is `true`, overlays a gradient that rotates continuously around the view. When `isAnimating` becomes `false`, the gradient fades out and the border settles to `settleColor`.

### Properties Reference

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isAnimating` | `Bool` | Required | Starts the rotating gradient when `true`, fades it out when `false` |
| `width` | `CGFloat` | `2` | Border width |
| `colors` | `[Color]` | `[EDTSColor.white, EDTSColor.blue30]` | Gradient colors. The list is mirrored automatically so the rotation loops seamlessly |
| `cornerRadius` | `CGFloat` | `0` | Corner radius of the border. Match it to the corner radius of the view |
| `duration` | `TimeInterval` | `2.0` | Time for one full gradient rotation (seconds) |
| `stopDuration` | `TimeInterval` | `0.5` | Fade-out time of the gradient when `isAnimating` becomes `false` (seconds) |
| `settleColor` | `Color` | `EDTSColor.blue30` | Static border color shown behind the gradient and left in place after the animation stops |

### Behavior

| State | Result |
| ----- | ------ |
| `isAnimating` becomes `true` | The gradient appears immediately (no fade in) and rotates continuously, clockwise, with constant speed |
| `isAnimating` becomes `false` | The gradient fades out over `stopDuration`, leaving the static `settleColor` border |
| `isAnimating` toggles back to `true` before the fade-out finishes | The rotation restarts from the beginning |

## Animation Details

| Modifier | Animation Type | Duration | Easing | Description |
| -------- | -------------- | -------- | ------ | ----------- |
| `animateGradientBorder` | `Gradient Rotation` | `duration` (default `2.0s`) per revolution | `Linear` | Rotates the angular gradient continuously while `isAnimating` is `true` |
| `animateGradientBorder` | `Gradient Fade Out` | `stopDuration` (default `0.5s`) | `EaseInOut` | Fades the gradient out, leaving the `settleColor` border |

---

## `animateNeonPulse`

Adds a glow (shadow) around the view that pulses between a soft and a strong state while `isActive` is `true`.

### Properties Reference

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isActive` | `Bool` | Required | Starts the pulse when `true`, removes the glow when `false` |
| `color` | `Color` | `EDTSColor.blue30` | Glow color |
| `duration` | `TimeInterval` | `1.0` | Time for one pulse direction (seconds). A full cycle (grow and shrink) takes `2 × duration` |

### Pulse Values

| Phase | Shadow Opacity | Shadow Radius |
| ----- | -------------- | ------------- |
| Soft | `0.1` | `0.5` |
| Strong | `0.5` | `12` |
| Inactive | `0` | `0` |

## Animation Details

| Modifier | Animation Type | Duration | Easing | Description |
| -------- | -------------- | -------- | ------ | ----------- |
| `animateNeonPulse` | `Glow Pulse` | `duration` (default `1.0s`) each direction | `EaseInOut` | Repeats forever, growing and shrinking the shadow opacity and radius |

---

## `animateCardSelected`

Marks a card as selected. The border color changes from `unselectedBorderColor` to `tintColor`, and a triangle with a check icon slides in at the top-leading corner. The modifier also clips the view to a rounded rectangle.

### Properties Reference

#### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isSelected` | `Bool` | Required | Selected state |
| `cornerRadius` | `CGFloat` | `0` | Corner radius of the border and the clip shape |
| `durationAnimation` | `TimeInterval` | `0.25` | Duration of the border and triangle animations (seconds) |
| `animated` | `Bool` | `true` | Set to `false` to change state without animation |

#### Color Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `tintColor` | `Color` | `EDTSColor.blue50` | Border color and triangle color when selected |
| `unselectedBorderColor` | `Color` | `EDTSColor.grey30` | Border color when not selected |

#### Border Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `1` | Border width |

#### Marker (Triangle) Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `triangleSize` | `CGFloat` | `32` | Width and height of the corner triangle |
| `icon` | `UIImage?` | `UIImage(named: "ic_check")` | Icon shown in the triangle, rendered as a template (tintable) |
| `iconTintColor` | `Color` | `EDTSColor.white` | Icon tint color |
| `iconSize` | `CGFloat` | `16` | Width and height of the icon |

## Animation Details

| Modifier | Animation Type | Duration | Easing | Description |
| -------- | -------------- | -------- | ------ | ----------- |
| `animateCardSelected` | `Border Color` | `durationAnimation` (default `0.25s`) | `Linear` | Animates the border color between selected and unselected |
| `animateCardSelected` | `Triangle In` | `durationAnimation` (default `0.25s`) | `EaseOut` | Slides and fades the triangle in on selection |
| `animateCardSelected` | `Triangle Out` | `durationAnimation` (default `0.25s`) | `EaseIn` | Slides and fades the triangle out on deselection |

## Notes

- `animateGradientBorder` and `animateCardSelected` draw the border inside the view's bounds, so the view's size does not change
- `animateGradientBorder` and `animateCardSelected` ignore touches on their overlays, so taps pass through to the view

---

*For further customization, ask UX Engineer to add additional functionality as required.*
