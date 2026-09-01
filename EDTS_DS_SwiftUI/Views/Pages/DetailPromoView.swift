//
//  DetailPromoView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI
import Combine

// MARK: - Reusable Badge Component

struct BadgeView: View {
    let text: String
    let textColor: Color
    let backgroundColor: Color
    var horizontalPadding: CGFloat = 10
    var verticalPadding: CGFloat = 6

    var body: some View {
        Text(text)
            .font(EDTSFont.Klik.B3.Semibold.font)
            .foregroundColor(textColor)
            .lineLimit(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(6)
    }
}

// MARK: - Reusable Progress Bar Component
//
// A "reward path" style progress bar:
// - The track fills with a gradient up to the current progress.
// - A small 8x8 gradient dot rides right at the leading edge of the fill.
// - A 16x16 gradient badge (e.g. "x1") sits pinned at the trailing end.
// - Once progress reaches 1.0, the gradient fill finishes growing to 100%
//   FIRST, then a solid blue30 overlay crossfades in on top.
// - Whenever `multiplier` changes (a new lap starts), the fill always
//   resets to 0 and animates forward — it never slides backward from a
//   previous lap's higher fill percentage.

struct ProgressBarView: View {
    /// Progress within the current tier, 0...1. 1 means this tier is complete.
    let progress: CGFloat
    /// Shown inside the trailing badge, e.g. 1 -> "x1". Changing this also
    /// resets the fill animation to start fresh from 0 (see LapFillView).
    var multiplier: Int = 1

    var trackColor: Color = EDTSColor.grey20
    var completedTrackColor: Color = EDTSColor.blue30

    private let indicatorSize: CGFloat = 8
    private let badgeSize: CGFloat = 16
    private let trackHeight: CGFloat = 8
    private let trackFillPadding: CGFloat = 1

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [EDTSColor.skyblueLeading, EDTSColor.skyblueTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { geometry in
            // Track runs all the way to the badge's CENTER, so the badge
            // visually overlaps the last half of the track.
            let trackWidth = max(0, geometry.size.width - badgeSize / 2)
            let clampedProgress = max(0, min(progress, 1))

            ZStack(alignment: .leading) {
                // Base track background — always grey20 underneath.
                Capsule()
                    .fill(trackColor)
                    .frame(width: trackWidth, height: trackHeight)

                // Fill + indicator + completed overlay for the current lap.
                // Direction-aware: increasing (more qty, or a new higher
                // lap) always animates forward; decreasing (minus qty, or
                // dropping back a lap) animates a genuine backward slide
                // rather than resetting instantly.
                LapFillView(
                    targetProgress: clampedProgress,
                    multiplier: multiplier,
                    trackWidth: trackWidth,
                    trackHeight: trackHeight,
                    trackFillPadding: trackFillPadding,
                    indicatorSize: indicatorSize,
                    gradient: gradient,
                    completedTrackColor: completedTrackColor
                )

                // Trailing multiplier badge — offset so its center lands
                // exactly on the track's right edge.
                ZStack {
                    Circle()
                        .fill(gradient)
                        .frame(width: badgeSize, height: badgeSize)

                    Text("x\(multiplier)")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: trackWidth - badgeSize / 2)
            }
            .frame(width: geometry.size.width, height: badgeSize)
        }
        .frame(height: badgeSize)
    }
}

// MARK: - Lap Fill (internal — handles the forward-only grow + staged
// completion crossfade for a single lap of ProgressBarView)

private struct LapFillView: View {
    let targetProgress: CGFloat
    let multiplier: Int
    let trackWidth: CGFloat
    let trackHeight: CGFloat
    let trackFillPadding: CGFloat
    let indicatorSize: CGFloat
    let gradient: LinearGradient
    let completedTrackColor: Color

    @State private var displayProgress: CGFloat = 0
    @State private var showCompletedOverlay = false
    @State private var lastHandledProgress: CGFloat = -1
    @State private var lastHandledMultiplier: Int = -1

    private let growDuration = 0.3
    private let shrinkDuration = 0.25
    private let completeFadeDuration = 0.25

    var body: some View {
        let fillWidth = trackWidth * displayProgress

        ZStack(alignment: .leading) {
            Capsule()
                .fill(gradient)
                .frame(
                    width: max(0, fillWidth - trackFillPadding * 2),
                    height: trackHeight - trackFillPadding * 2
                )
                .padding(trackFillPadding)

            Circle()
                .fill(gradient)
                .frame(width: indicatorSize, height: indicatorSize)
                .offset(x: max(0, fillWidth - indicatorSize / 2))
                .opacity(showCompletedOverlay ? 0 : 1)

            // Solid "completed" overlay — only crossfades in AFTER the
            // gradient fill above has finished animating to 100%. Same
            // 1pt inset as the gradient fill, so both sit flush inside
            // the base track rather than covering it edge-to-edge.
            Capsule()
                .fill(completedTrackColor)
                .frame(width: trackWidth, height: trackHeight)
                .padding(trackFillPadding)
                .opacity(showCompletedOverlay ? 1 : 0)
        }
        .onAppear {
            lastHandledMultiplier = multiplier
            advance(to: targetProgress)
        }
        // iOS 13-compatible stand-in for .onChange(of:) (iOS 14+).
        // Handles the LAP boundary specifically: going to a higher lap
        // resets to 0 and grows forward; going to a lower lap slides the
        // current fill back down to 0 first, then settles into the new lap.
        .onReceive(Just(multiplier)) { newMultiplier in
            guard newMultiplier != lastHandledMultiplier else { return }
            let didIncreaseLap = newMultiplier > lastHandledMultiplier
            lastHandledMultiplier = newMultiplier

            if didIncreaseLap {
                showCompletedOverlay = false
                displayProgress = 0
                advance(to: targetProgress)
            } else {
                showCompletedOverlay = false
                withAnimation(.easeInOut(duration: shrinkDuration)) {
                    displayProgress = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + shrinkDuration) {
                    advance(to: targetProgress)
                }
            }
        }
        // Same-lap progress changes (both increases and decreases) —
        // decreases here animate as a normal backward slide since
        // `displayProgress` just interpolates directly to the new value.
        .onReceive(Just(targetProgress)) { newProgress in
            guard multiplier == lastHandledMultiplier else { return }
            guard newProgress != lastHandledProgress else { return }
            advance(to: newProgress)
        }
    }

    private func advance(to newProgress: CGFloat) {
        lastHandledProgress = newProgress

        withAnimation(.easeInOut(duration: growDuration)) {
            displayProgress = newProgress
        }

        if newProgress >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + growDuration) {
                withAnimation(.easeInOut(duration: completeFadeDuration)) {
                    showCompletedOverlay = true
                }
            }
        } else {
            showCompletedOverlay = false
        }
    }
}

// MARK: - Detail Promo View

struct DetailPromoView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isGridView: Bool = false

    // Floating bar hide-on-scroll state
    @State private var isFloatingBarHidden: Bool = false
    @State private var hideBarWorkItem: DispatchWorkItem?
    /// Minimum finger travel (points) before the bar hides. Keeps small,
    /// accidental nudges from triggering it — only a deliberate scroll does.
    private let scrollHideThreshold: CGFloat = 100

    // Approximate scroll offset, built purely from DragGesture deltas —
    // same mechanism as the floating bar above, no GeometryReader/
    // PreferenceKey stream involved (that doesn't fire reliably here).
    // `lastDragTranslationY` lets us compute the delta *since the
    // previous onChanged callback* (not since the gesture began), so we
    // can accumulate it persistently across separate drag gestures.
    @State private var lastDragTranslationY: CGFloat = 0
    @State private var approximateScrollOffset: CGFloat = 0

    // Progress is now driven by real product quantities rather than a
    // fixed value. Business rule: each unit of quantity across all
    // product cards contributes `pointsPerUnit` points; the bar fills
    // per "lap" of `pointsPerBar`; the whole path caps at `progressLimit`
    // (i.e. `progressLimit / pointsPerBar` laps total).
    @State private var totalProductQuantity: Int = 0
    private let pointsPerUnit = 40
    private let pointsPerBar = 100
    private let progressLimit = 300

    /// (which lap's badge to show, how full that lap's bar currently is).
    /// Example with the values above: qty 1 -> 40/100 in lap "x1"; qty 3
    /// -> 120 total -> lap "x2" at 20/100; qty 8 -> 320 capped to 300 ->
    /// lap "x3" fully complete (progress == 1).
    private var promoProgressState: (multiplier: Int, progress: CGFloat) {
        let totalPoints = min(totalProductQuantity * pointsPerUnit, progressLimit)

        guard totalPoints > 0 else {
            return (multiplier: 1, progress: 0)
        }

        let remainder = totalPoints % pointsPerBar
        if remainder == 0 {
            // Landed exactly on a lap boundary — that lap is fully complete.
            let lap = totalPoints / pointsPerBar
            return (multiplier: lap, progress: 1)
        } else {
            let lap = totalPoints / pointsPerBar + 1
            return (multiplier: lap, progress: CGFloat(remainder) / CGFloat(pointsPerBar))
        }
    }

    // Sticky header visibility — shown once the scroll offset has passed
    // nestedCard's bottom edge, hidden again once nestedCard is back in
    // view. The threshold is measured once via .onAppear (a lifecycle
    // event, not a continuous preference update).
    @State private var showStickyHeader: Bool = false
    @State private var nestedCardBottomThreshold: CGFloat = .greatestFiniteMagnitude

    var body: some View {
        VStack(spacing: 0) {
            toolbar

            if showStickyHeader {
                StickyPromoHeaderView(
                    progress: promoProgressState.progress,
                    claimedCount: 1,
                    multiplier: promoProgressState.multiplier
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    banner

                    nestedCard
                        .padding(.top, 16)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        // Captured once, at initial layout (offset
                                        // == 0), so this equals exactly the scroll
                                        // distance needed to bring nestedCard's
                                        // bottom edge to the top of the viewport.
                                        nestedCardBottomThreshold = geo.frame(in: .named("promoScroll")).maxY
                                    }
                            }
                        )

                    infoSection
                    divider
                    productListHeader

                    ProductStaggeredListView(
                        products: Self.sampleProducts,
                        onQuantityChange: { total in
                            totalProductQuantity = total
                        }
                    )
                        .padding(.bottom, 16)
                }
            }
            .coordinateSpace(name: "promoScroll")
            // Detect active scrolling directly via drag updates on the
            // ScrollView itself. Floating-bar hide is gated on
            // `translation` (cumulative distance since the finger touched
            // down) so a tiny nudge doesn't immediately hide it — only a
            // real, deliberate scroll does. The sticky header's
            // visibility is driven separately, by comparing the
            // accumulated approximate offset against nestedCard's
            // precomputed threshold — no gating needed there since it's
            // a straightforward position check, not a "is scrolling"
            // detection.
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateApproximateScrollOffset(with: value)
                        handleFloatingBarVisibility(for: value)
                        handleStickyHeaderVisibility()
                    }
                    .onEnded { _ in
                        lastDragTranslationY = 0
                    }
            )
        }
        .safeAreaInset(edge: .bottom) {
            PromoFloatingActionBar(
                itemCountText: "(1 Barang)",
                priceText: "Rp50.000"
            )
            .offset(y: isFloatingBarHidden ? 120 : 0)
            .opacity(isFloatingBarHidden ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isFloatingBarHidden)
        }
        .background(EDTSColor.white)
        .navigationBarHidden(true)
    }

    // MARK: - Scroll handling

    /// Accumulates an approximate absolute scroll offset purely from
    /// DragGesture deltas (delta since the *previous* callback, not since
    /// the gesture began), so it persists correctly across separate drags.
    private func updateApproximateScrollOffset(with value: DragGesture.Value) {
        let deltaSinceLastCallback = value.translation.height - lastDragTranslationY
        lastDragTranslationY = value.translation.height
        approximateScrollOffset -= deltaSinceLastCallback
    }

    /// Called on every drag update while the user's finger is moving on the
    /// ScrollView. Hides the floating bar immediately once movement passes
    /// `scrollHideThreshold`, then (re)schedules a debounced timer that
    /// brings it back after scrolling/dragging has been idle for a short
    /// pause. The timer also covers the momentum-scroll tail after the
    /// finger lifts, since DragGesture alone can't observe that.
    private func handleFloatingBarVisibility(for value: DragGesture.Value) {
        guard abs(value.translation.height) > scrollHideThreshold else { return }

        if !isFloatingBarHidden {
            isFloatingBarHidden = true
        }

        hideBarWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            isFloatingBarHidden = false
        }
        hideBarWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: workItem)
    }

    /// Shows the sticky header once the approximate scroll offset has
    /// passed nestedCard's bottom edge, hides it once scrolled back above
    /// that point — animated as a slide-down-from-top reveal / reverse.
    private func handleStickyHeaderVisibility() {
        let shouldShowSticky = approximateScrollOffset > nestedCardBottomThreshold
        guard shouldShowSticky != showStickyHeader else { return }

        withAnimation(.easeInOut(duration: 0.25)) {
            showStickyHeader = shouldShowSticky
        }
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        HStack(spacing: 8) {
            Button(action: {
                dismiss()
            }) {
                Image("ic_arrow_left")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey50)
            }

            Text("Detail Promo")
                .font(EDTSFont.Klik.H1.font)
                .foregroundColor(EDTSColor.grey50)

            Spacer()

            Button(action: {
                // handle search action
            }) {
                Image("ic_search")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey50)
            }

            Button(action: {
                // handle share action
            }) {
                Image("ic_share")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey50)
            }
        }
        .padding(12)
        .background(EDTSColor.white)
    }

    // MARK: - Banner

    private var banner: some View {
        Image("img_banner_promo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
    }

    // MARK: - Nested Promo Card (top + bottom stacked)
    //
    // FIX: instead of measuring topCard's height at runtime via
    // GeometryReader + PreferenceKey (unreliable, reported 0 inside
    // ScrollView), we use a VStack with negative spacing so the two
    // cards overlap by exactly 12pt automatically. zIndex ensures
    // nestedCardTop draws above the hidden portion of nestedCardBottom.
    private var nestedCard: some View {
        VStack(spacing: -12) {
            nestedCardTop
                .zIndex(1)

            nestedCardBottom
                .zIndex(0)
        }
    }

    // First card: badges, info icon, progress bar, helper text
    private var nestedCardTop: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                BadgeView(
                    text: "Luminarc Soup Idaman Fair",
                    textColor: EDTSColor.blue50,
                    backgroundColor: EDTSColor.blue20
                )
                .lineLimit(1)

                BadgeView(
                    text: "Kuota Promo 25%",
                    textColor: EDTSColor.red50,
                    backgroundColor: EDTSColor.red10
                )

                Spacer()

                Image("ic_information")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(EDTSColor.grey50)
            }

            ProgressBarView(
                progress: promoProgressState.progress,
                multiplier: promoProgressState.multiplier
            )

            Text("Tambah produk dulu, yuk!")
                .font(EDTSFont.Klik.B3.Medium.font)
                .foregroundColor(EDTSColor.grey50)
        }
        .padding(12)
        .background(EDTSColor.grey10)
        .cornerRadius(6, corners: [.topLeft, .topRight])
        .overlay(
            RoundedCorner(radius: 6, corners: [.topLeft, .topRight])
                .stroke(EDTSColor.grey30, lineWidth: 1)
        )
    }

    // Second card: product image list
    // NOTE: top padding is 8 (not 20) — the extra 12pt gap is now
    // provided by nestedCard's negative spacing overlap, not by this
    // card's own internal padding.
    private var nestedCardBottom: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image("img_soup_bowl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Image("img_noodle_bowl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Spacer()

            HStack(spacing: 4) {
                Text("Lihat")
                    .font(EDTSFont.Klik.B3.Semibold.font)
                    .foregroundColor(EDTSColor.blue50)

                Image("ic_chevron_right")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(EDTSColor.blue50)
            }
        }
        .padding(.top, 20)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 8)
        .background(EDTSColor.blue20)
        .cornerRadius(6, corners: [.bottomLeft, .bottomRight])
        .overlay(
            RoundedCorner(radius: 6, corners: [.bottomLeft, .bottomRight])
                .stroke(EDTSColor.grey30, lineWidth: 1)
        )
    }

    // MARK: - Promo Info Section (title + detail rows)

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000. Tidak Berlaku Kel...")
                .font(EDTSFont.Klik.P1.Semibold.font)
                .foregroundColor(EDTSColor.grey70)
                .multilineTextAlignment(.leading)

            VStack(alignment: .leading, spacing: 12) {
                infoRow(
                    icon: "ic_clock",
                    label: "Periode",
                    value: "03 Jan 2025 - 31 Des 2025"
                )

                infoRow(
                    icon: "ic_bag",
                    label: "Minimum Transaksi",
                    value: "Rp100.000"
                )

                infoRow(
                    icon: "ic_assignment",
                    label: "Syarat dan Ketentuan",
                    value: "Selengkapnya",
                    isLink: true
                )
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
        .background(EDTSColor.white)
    }

    private func infoRow(icon: String, label: String, value: String, isLink: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 8) {
            HStack(spacing: 8) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(EDTSColor.grey40)

                Text(label)
                    .font(EDTSFont.Klik.B3.Semibold.font)
                    .foregroundColor(EDTSColor.grey40)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            if isLink {
                Text(value)
                    .font(EDTSFont.Klik.Button.Small.font)
                    .foregroundColor(EDTSColor.blueDefault)
                    .underline()
                    .multilineTextAlignment(.trailing)
            } else {
                Text(value)
                    .font(EDTSFont.Klik.B3.Semibold.font)
                    .foregroundColor(EDTSColor.grey40)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .fill(EDTSColor.grey30)
            .frame(height: 1)
    }

    // MARK: - Product List Header

    private var productListHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daftar Produk Promo")
                .font(EDTSFont.Klik.H2.font)
                .foregroundColor(EDTSColor.grey70)

            HStack(spacing: 8) {
                Text("6 produk")
                    .font(EDTSFont.Klik.B3.Semibold.font)
                    .foregroundColor(EDTSColor.grey50)

                Spacer()

                Text("Tampilan")
                    .font(EDTSFont.Klik.B3.Semibold.font)
                    .foregroundColor(EDTSColor.grey50)

                HStack(spacing: 8) {
                    Button(action: {
                        isGridView = false
                    }) {
                        Image("ic_2_column")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(isGridView ? EDTSColor.grey50 : EDTSColor.blue50)
                    }

                    Button(action: {
                        isGridView = true
                    }) {
                        Image("ic_3_column")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(isGridView ? EDTSColor.blue50 : EDTSColor.grey50)
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(EDTSColor.white)
    }
}

extension DetailPromoView {
    // IMPORTANT: this must be `static let`, not a computed `var`.
    // ProductCardModel.id is `let id = UUID()`, generated fresh inside its
    // initializer — so a computed `var` here would build brand-new
    // ProductCardModel instances (with brand-new random UUIDs) every time
    // it's accessed. Since `body` re-reads this on every re-render (e.g.
    // whenever `totalProductQuantity` changes from tapping a stepper),
    // that constantly handed ProductStaggeredListView products with
    // different ids than before — which made its `quantities` dictionary
    // and `activeProductID` (both keyed by id) stop matching anything,
    // so every stepper appeared to reset even though nothing was actually
    // cleared. `static let` computes this array exactly once for the
    // lifetime of the app, so ids stay stable across re-renders.
    static let sampleProducts: [ProductCardModel] = [
        ProductCardModel(
            image: "img_filma",
            giftBadgeText: "Gratis Hadiah",
            giftBadgeLeadingColor: EDTSColor.greenforestLeading,
            giftBadgeTrailingColor: EDTSColor.greenforestTrailing,
            title: "Filma Minyak Goreng Refill 2000ml",
            price: 50000,
            originalPrice: 100000,
            discountText: "50%",
            hematBadgeText: "Banyak Lebih Hemat",
            bundlingBadgeText: "Paket Bundling",
            poin: 10,
            stamp: 99
        ),
        ProductCardModel(
            image: "img_mie_goreng",
            giftBadgeText: "Paket Bundling",
            giftBadgeLeadingColor: EDTSColor.sunsetLeading,
            giftBadgeTrailingColor: EDTSColor.sunsetTrailing,
            title: "Indomie Mi Instan Goreng Plus Special...",
            price: 10000,
            originalPrice: nil,
            discountText: nil,
            hematBadgeText: nil,
            bundlingBadgeText: nil,
            poin: nil,
            stamp: 10,
            buyQuantityForStamp: 3
        ),
        ProductCardModel(
            image: "img_mie_aceh",
            giftBadgeText: nil,
            giftBadgeLeadingColor: nil,
            giftBadgeTrailingColor: nil,
            title: "Indomie Mi Instan Goreng Aceh 90g",
            price: 10000,
            originalPrice: 6400,
            discountText: "50%",
            hematBadgeText: nil,
            bundlingBadgeText: nil,
            poin: 99,
            stamp: nil,
            buyQuantityForPoin: 5
        ),
        ProductCardModel(
            image: "img_mie_goreng_jumbo",
            giftBadgeText: "Banyak Lebih Hemat",
            giftBadgeLeadingColor: EDTSColor.redLeading,
            giftBadgeTrailingColor: EDTSColor.redTrailing,
            title: "Indomie Mi Instan Goreng Jumbo Spec...",
            price: 10000,
            originalPrice: nil,
            discountText: nil,
            hematBadgeText: nil,
            bundlingBadgeText: "Paket Bundling",
            poin: nil,
            stamp: 10,
            buyQuantityForStamp: 3
        ),
        ProductCardModel(
            image: "img_mie_ayam_geprek",
            giftBadgeText: nil,
            giftBadgeLeadingColor: nil,
            giftBadgeTrailingColor: nil,
            title: "Indomie Mi Instan Goreng Ayam Geprek...",
            price: 3200,
            originalPrice: 6400,
            discountText: "50%",
            hematBadgeText: nil,
            bundlingBadgeText: nil,
            poin: 99,
            stamp: nil
        ),
        ProductCardModel(
            image: "img_mie_ramyeon",
            giftBadgeText: "Gratis Hadiah",
            giftBadgeLeadingColor: EDTSColor.greenforestLeading,
            giftBadgeTrailingColor: EDTSColor.greenforestTrailing,
            title: "Indomie Mie Instant Premium Korean Spi...",
            price: 6400,
            originalPrice: nil,
            discountText: nil,
            hematBadgeText: nil,
            bundlingBadgeText: "Paket Bundling",
            poin: 99,
            stamp: nil
        )
    ]
}

// MARK: - Preview

struct DetailPromoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailPromoView()
    }
}
