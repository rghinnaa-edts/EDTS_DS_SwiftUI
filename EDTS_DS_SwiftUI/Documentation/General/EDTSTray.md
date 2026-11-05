# EDTSTray

`EDTSTray` is a bottom tray (bottom sheet) for SwiftUI, presented with the `.edtsTray(...)` view modifier. It supports three height modes (`fullScreen`, `wrapContent`, `custom`), an optional drag handle, an optional dimmed overlay (with a shadow fallback when the overlay is off), swipe-down and tap-outside dismissal, and a dismiss guard for blocking or intercepting dismissal. Internally it presents your SwiftUI content in a hosting controller with a custom `UIPresentationController`, so it can sit above navigation and tab bars.

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Wrap Content** | *(add preview)* |
| **Custom Height** | *(add preview)* |
| **Full Screen** | *(add preview)* |
| **Without Overlay (Shadow)** | *(add preview)* |

## Basic Usage

### 1. Present a Tray

Attach `.edtsTray(isPresented:)` to any view and drive it with a `Bool` binding.

```swift
struct ContentView: View {
    @State private var isPresented = false

    var body: some View {
        Button("Show Tray") { isPresented = true }
            .edtsTray(isPresented: $isPresented) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Title").font(.title3.weight(.bold))
                    Text("Tray content goes here.")
                    Button("Close") { isPresented = false }
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 16)
            }
    }
}
```

### 2. Choose a Height Mode

```swift
.edtsTray(isPresented: $isPresented, heightMode: .custom(400)) {
    TrayContent()
}
```

### 3. Customize the Tray

```swift
var config = EDTSTrayConfiguration()
config.sheetBgColor = .white
config.cornerRadius = 24
config.overlayColor = Color.black.opacity(0.5)
config.isHasDragHandle = true

Button("Show Tray") { isPresented = true }
    .edtsTray(isPresented: $isPresented,
              heightMode: .wrapContent,
              configuration: config,
              onDismiss: { print("Tray dismissed") }) {
        TrayContent()
    }
```

### 4. Intercept or Block Dismissal

```swift
var config = EDTSTrayConfiguration()

// Block dismissal while the form has unsaved changes
config.canDismiss = { [model] in !model.hasUnsavedChanges }

// Called when the user tries to dismiss (tap outside / swipe down) but canDismiss returns false
config.onDismissAttempt = { [model] in model.showDiscardAlert = true }
```

> **Note:** `heightMode` and `configuration` are read when the tray is presented. Changing them while the tray is visible has no effect until it is presented again. The tray `content` itself updates live.

## `.edtsTray` Parameters

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `isPresented` | `Binding<Bool>` | Required | Controls presentation. Set to `true` to show and `false` to dismiss. It is reset to `false` automatically when the user dismisses the tray |
| `heightMode` | `TrayHeightMode` | `.wrapContent` | Height behavior of the tray |
| `configuration` | `EDTSTrayConfiguration` | `EDTSTrayConfiguration()` | Styling and dismiss behavior |
| `onDismiss` | `(() -> Void)?` | `nil` | Called after the tray has been dismissed, whether by the user or by setting `isPresented = false` |
| `content` | `@ViewBuilder () -> Content` | Required | The SwiftUI view shown inside the tray |

## Height Modes

| Mode | Description |
| ---- | ----------- |
| `.wrapContent` | Tray height fits the content (default) |
| `.custom(CGFloat)` | Fixed tray height, clamped to the maximum allowed height |
| `.fullScreen` | Tray fills the screen below the status bar / top safe area |

**Example:**
```swift
.edtsTray(isPresented: $isPresented, heightMode: .custom(650)) { ... }
```

## Properties Reference (`EDTSTrayConfiguration`)

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `sheetBgColor` | `Color` | `EDTSColor.white` | Background color of the tray |
| `cornerRadius` | `CGFloat` | `16` | Corner radius of the tray (applied to the top-left and top-right corners only) |

### Drag Handle Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isHasDragHandle` | `Bool` | `true` | Shows/hides the drag handle (grabber) at the top of the tray |
| `dragHandleColor` | `Color` | `EDTSColor.grey30` | Drag handle color |

### Overlay Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isHasOverlay` | `Bool` | `true` | Shows/hides the dimmed overlay behind the tray |
| `overlayColor` | `Color` | `EDTSColor.black.opacity(0.75)` | Overlay color. If its alpha is `0`, the overlay is treated as not visible and the shadow is shown instead |

### Shadow Properties

The shadow is only rendered when the overlay is **not** visible (`isHasOverlay = false` or `overlayColor` alpha is `0`).

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `shadowColor` | `Color` | `EDTSColor.black` | Shadow color |
| `shadowOpacity` | `Float` | `0.2` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `12` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `CGSize(width: 0, height: -2)` | Shadow offset from the tray |

### Dismiss Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `canDismiss` | `() -> Bool` | `{ true }` | Dismiss guard. Return `false` to prevent dismissal via tap-outside or swipe-down |
| `onDismissAttempt` | `(() -> Void)?` | `nil` | Called when a user dismissal was attempted but blocked by `canDismiss` |

> **Note:** `canDismiss` only guards user gestures (tap outside, swipe down). Setting `isPresented = false` from code always dismisses the tray.

## Drag Handle Specification

| Aspect | Value |
| ------ | ----- |
| Size | `36pt` × `4pt` |
| Top offset | `8pt` |
| Corner radius | `2pt` |
| Horizontal alignment | Centered in the tray |
| Drag area height | `56pt` (measured from the top of the tray) |

## Dismiss Behavior

| Gesture | Behavior |
| ------- | -------- |
| **Tap outside** | Tapping the dimmed area behind the tray dismisses it (subject to `canDismiss`) |
| **Swipe down** | Dragging the tray down follows the finger. Only drags that start within the top `56pt` (drag area) are recognized |
| **Dismiss threshold** | On release, the tray dismisses if it was dragged more than `30%` of its height **or** the release velocity is greater than `900 pt/s` |
| **Below threshold** | The tray springs back to its original position |
| **Blocked by `canDismiss`** | The tray springs back to its original position and `onDismissAttempt` is called |
| **`isPresented = false`** | Dismisses the tray with the standard transition. Not affected by `canDismiss` |

## Animation Details

| Animation Type | Duration | Description |
| -------------- | -------- | ----------- |
| `Present` | Matches the presentation transition | Slides the tray (and shadow) up and fades in the overlay |
| `Dismiss` | Matches the dismissal transition | Slides the tray (and shadow) down and fades out the overlay |
| `Drag / Tap Dismiss` | `200ms` | Slides the tray off-screen and fades out the overlay when a swipe passes the dismiss threshold or the overlay is tapped |
| `Drag Reset` | `250ms` | Returns the tray to its original position when a swipe does not dismiss |
| `Content Height Change` | `250ms` | In `.wrapContent`, animates the tray height when the content height changes (for example, rows added or removed) |

## Notes

- When `isHasOverlay` is `false`, tapping outside the tray still triggers dismissal (subject to `canDismiss`)
- The shadow is shown only when the overlay is not visible, and its path uses `cornerRadius` on all corners
- The tray is presented from the topmost view controller of the window. If another presentation or dismissal is in progress, the tray waits `0.3s` and tries again
- The modifier must be attached to a view that is already in a window. Presentation starts once the view appears
- Only one `isPresented` binding should be `true` at a time per screen. Presenting multiple trays at once is not supported

---

*For further customization, ask UX Engineer to add additional functionality as required.*
