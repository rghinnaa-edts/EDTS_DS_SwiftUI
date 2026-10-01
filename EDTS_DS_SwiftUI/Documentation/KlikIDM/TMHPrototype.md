# Tebus Murah & Hadiah Page Prototype

SwiftUI prototype in the EDTS_DS_SwiftUI project. Documented October 1, 2026.

## Open and demonstrate

**Project:** EDTS_DS_SwiftUI. Build and run any scheme that presents `DetailPromoView` inside a `NavigationView` or `NavigationStack`. The file's Xcode preview already wraps it in a `NavigationView`. The search flow is reached from the search icon in the Detail Promo toolbar.

**Suggested presentation:**

1. Open Detail Promo and tap **+** on Filma Minyak Goreng. The stepper expands, quantity is 1, and the progress bar in the promo card moves to 40%.
2. Add a second item: the bar reaches 80%. Add a third: the bar completes its first lap and restarts at 20%, the **x1** badge appears at the end of the bar, and the blue completed track shows behind it.
3. Scroll past the promo card. The compact sticky progress header slides in under the toolbar with the same progress and badge. While dragging, the floating cart bar slides away and returns about 0.45s after the drag stops.
4. Tap the search icon. The keyboard opens automatically. Type **Kur** to see the Kurma suggestions, then clear the field and type **Indomie**.
5. Tap an Indomie suggestion. Results appear inline under the search toolbar (no new page), the keyboard closes, and the list shows 5 products. The header keeps the progress and badge from the detail page, and product steppers show the quantities already added.
6. Add more items on the results page, then tap the back arrow. Detail Promo shows the updated progress and quantities.
7. Search a term with no matching product, for example **Kurma**. The empty state "Produk tidak ditemukan" appears, the Urutkan/Filter pill is hidden, and the cart card stays. Tap **Ganti Kata Kunci** to clear the field and reopen the keyboard.
8. With results showing, type in the field or tap the **x** button. The results disappear and the suggestions come back.

## Source and decisions

**Source:** the design screenshots, spacing overlays (16 / 12 / 24 for the empty state), and typography/color specs supplied during the build. A Figma link was not captured in this project; add it here when available.

- **Inline results, not a new page.** Search results render below the existing search toolbar. `SearchResultView` is content only and has no toolbar of its own.
- **One source of truth for quantities.** `DetailPromoView` owns `quantities: [UUID: Int]` and passes it down as a `Binding`. Progress, steppers, and badges therefore agree on every screen.
- **Sticky header is always visible on the search page.** On Detail Promo it appears only after the promo card has scrolled away.
- **Sort/filter is hidden when nothing matches** through `PromoFloatingActionBar(showSortFilter:)`; it defaults to `true`, so the detail page is unchanged.
- **Progress badge counts completed laps.** The header must be given `badgeMultiplier` and `showBadge`; without them the compact bar never shows the badge.
- **Fixture mismatch with the design.** The reference result screenshot shows 4 products for the search term "Goreng," while the sample data has 5 titles containing it. The count is computed, so it follows real data.
- **Timings and hide thresholds are proposals.** No authored motion specs were available; every duration below is the value coded in the prototype.

## Reward progress rules

Progress is derived from the total quantity of all products: `pointsPerUnit = 40`, `pointsPerBar = 100`, `progressLimit = 300`, `totalPoints = min(quantity × 40, 300)`. One lap is a full bar; the badge shows how many laps are complete.

| Total quantity | Points | Bar fill | Lap | Badge |
|---|---|---|---|---|
| 0 | 0 | 0% | 1 | none |
| 1 | 40 | 40% | 1 | none |
| 2 | 80 | 80% | 1 | none |
| 3 | 120 | 20% | 2 | x1 |
| 4 | 160 | 60% | 2 | x1 |
| 5 | 200 | 100% | 2 | x2 |
| 6 | 240 | 40% | 3 | x2 |
| 7 | 280 | 80% | 3 | x2 |
| 8 or more | 300 (cap) | 100% | 3 | x3 |

## Reusable composition

| Part | Implementation | Reuse and responsibilities |
|---|---|---|
| Detail page | `DetailPromoView` in `DetailPromoView.swift` | Toolbar, banner, nested promo card, info rows, product list; owns `quantities` and the hidden `NavigationLink` to search |
| Search page | `SearchPromoView` in `SearchPromoView.swift` | Search toolbar and field, suggestion list, switching between idle, suggestions and results; `performSearch(_:)` is the single entry for tap and keyboard Search |
| Results content | `SearchResultView` in `SearchResultView.swift` | Sticky header, promo title, product count, product list, empty state; filters products by title; no toolbar |
| Sticky header | `StickyPromoHeaderView` | Progress bar plus claimed text and Lihat; shadow is applied to the background only, never to the progress bar |
| Progress bar | `ProgressBarView`, private `LapFillView` | Gradient fill, indicator dot, lap badge, completed overlay; reused in the promo card and the sticky header |
| Product list | `ProductStaggeredListView` in `ProductCardView.swift` | Two staggered columns bound to the shared quantities; one expanded stepper at a time |
| Product card | `ProductCardView`, `ButtonStepperView`, `GradientBadgeView`, `BadgeView` | Square image with overlay stepper, price and discount, badges, poin/stamp footer |
| Floating bar | `PromoFloatingActionBar` | Optional `SortFilterPillView` above `CartSummaryCardView`; `showSortFilter`, `onSortTap`, `onFilterTap`, `onCartTap` |
| Bottom inset | `bottomInsetCompat` | `safeAreaInset` on iOS 15+, padded overlay on older versions |
| State | `quantities: [UUID: Int]` | Each screen derives its own total and progress state from the same dictionary |

```
DetailPromoView  @State quantities
  - ProductStaggeredListView(quantities: $quantities)
  - SearchPromoView(quantities: $quantities)
      - SearchResultView(quantities: $quantities)
          - ProductStaggeredListView(quantities: $quantities)
```

This is composition inside the app target. No design-system component (`EDTSColor`, `EDTSFont`) is modified.

## Tap, scroll and typing behavior

| Element | Tap | Scroll / drag | Typing and other |
|---|---|---|---|
| Plus / minus (stepper) | Updates the shared quantity at once, totals and progress follow; reaching 0 collapses the stepper | Stays anchored to the product image | No hold-to-repeat |
| Search icon (Detail) | Pushes Search Promo | Stays in the toolbar | Keyboard focus 0.3s after the page appears |
| Search field | Edits the term | None | Any typing hides results and shows suggestions; Search key runs the search |
| Clear (x) | Empties the field and hides results | None | Keeps the keyboard open |
| Suggestion row | Fills the field with the term and shows results | List scrolls | Case-insensitive match on the term |
| Back arrow (search) | Returns to Detail Promo | None | Does not close results first |
| Ganti Kata Kunci | Clears the field, shows suggestions, refocuses | None | Empty state only |
| Lihat, info, share, cart, Urutkan, Filter | Actions are not implemented yet | Floating bar hides while dragging | Placeholders |
| 2 / 3 column toggle | Changes only the highlighted icon | None | The list stays at two columns |
| Sticky header (Detail) | Not interactive beyond Lihat | Appears after the promo card scrolls past the top, using an approximate offset from drag gestures | Hidden again when scrolling back |

## Motion contract

| Change | Motion | Constraint |
|---|---|---|
| Stepper 0 to positive and back | Width 32 to 100pt, ease-in-out 0.2s | One persistent background shape animates its width, no cross-fade |
| Progress growth | Ease-in-out 0.3s | Driven by `Just` publishers inside `LapFillView` |
| New lap | Fill resets to 0, then grows 0.3s | Fires when the multiplier increases |
| Lap decrease | Shrinks to 0 in 0.25s, then grows 0.3s | Fires when the multiplier drops |
| Completed overlay and badge | Fade 0.2s | Badge shows only after at least one completed lap |
| Sticky header (Detail) | Slides from the top with fade, 0.25s | Toggled only when the threshold is crossed |
| Floating bar hide | Offset down (120pt detail, 160pt search) plus fade, 0.25s | Returns 0.45s after the last drag past 100pt |
| Keyboard focus | Delayed 0.3s after appear | Gives the push animation time to finish |

Reduced motion is not handled separately: these animations run even when the system Reduce Motion setting is on. This is a follow-up item.

## Layout constraints

- **Portrait phone layouts only.** Content uses `maxWidth: .infinity` and 16pt horizontal padding; the product grid uses two equal columns with 8pt gaps and square (1:1) product images.
- **Fixed control sizes:** toolbar and search icons 24pt, view-toggle icons 20pt, stepper 32pt high (100pt wide when expanded), empty-state illustration 80 x 80pt.
- **Empty state spacing** follows the overlay: 16pt top and sides, 12pt between the text block and the button, 24pt below the button, then a 1pt grey30 divider.
- The search placeholder is single line and truncates; suggestion context text wraps.
- The floating bar sits in a bottom safe-area inset, so list content scrolls above it. On iOS 14 and below the fallback reserves a fixed 80pt, which should match the real bar height.
- Dynamic Type, landscape, iPad, and large-text behavior have not been designed or checked.

## Accessibility and fidelity limits

- Icon-only buttons (back, search, share, clear, stepper plus/minus, view toggles) have no explicit accessibility labels yet. VoiceOver names depend on the image assets and are not verified.
- Several tap targets (24pt icons, 20pt toggles) are smaller than the usual 44pt guideline. The prototype keeps the design's visual sizes and does not claim accessibility compliance.
- Colors come from the design system tokens; contrast has not been audited. Reduce Motion is not respected (see Motion contract).
- Data is local and fixed. Six sample products with repeated artwork, static suggestions (Kurma, Indomie), no network, no persistence. One sample row is inconsistent: Indomie Aceh shows an original price (Rp6.400) lower than the price (Rp10.000) next to a 50% badge.
- **Placeholders.** The cart bar always reads "(1 Barang)" and "Rp50.000," `claimedCount` is fixed at 1, and the detail page says "6 produk" regardless of data.
- **Platform.** The navigation, state sharing, and bottom inset are written for older iOS versions. `SearchPromoView` still uses `@FocusState`, `.onSubmit`, `.submitLabel`, and `@Environment(\.dismiss)` (iOS 15+), and `ProductCardView` uses `overlay(alignment:content:)` (iOS 15+) and `if let` shorthand (Swift 5.7).
- **Not built:** sort and filter sheets, product detail, cart screen, gift selection, 3-column grid, server-side search, pagination, and real quota updates.

## Validation

**What was checked:** a screen recording of the prototype (about 26 seconds, portrait simulator) shows adding products and the stepper expanding, the progress bar and badge advancing, opening search, typing "Kur" and "Indomie" with suggestions, opening results with quantities carried over, and returning to Detail Promo with progress preserved.

**What was not run as part of this documentation:** a full build, unit tests, lint, UI tests, VoiceOver or Switch Control, performance profiling, or other devices and OS versions. The project has no automated tests yet.

**Suggested checks before sign-off:**

1. Unit-test the progress rules in the table above (quantities 0 to 9), since the logic is pure and duplicated in two views.
2. Confirm quantities survive navigating Detail, Search, results and back, including after the empty state.
3. Check the sticky header threshold on devices with different safe areas and with fast flicks, because it relies on approximate drag offsets.
4. Run VoiceOver across both pages and add labels to icon-only buttons.
5. Test on the lowest supported iOS version, where the compatibility paths and the iOS 15+ APIs listed above matter.
