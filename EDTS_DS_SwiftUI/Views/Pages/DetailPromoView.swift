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

struct ProgressBarView: View {
    let progress: CGFloat
    var multiplier: Int = 1
    var badgeMultiplier: Int = 0
    var showBadge: Bool = false

    var trackColor: Color = EDTSColor.grey20
    var completedTrackColor: Color = EDTSColor.blue30

    private let indicatorSize: CGFloat = 8
    private let badgeSize: CGFloat = 16
    private let trackHeight: CGFloat = 6
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
            let trackWidth = max(0, geometry.size.width - badgeSize / 2)
            let clampedProgress = max(0, min(progress, 1))

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)
                    .frame(width: trackWidth, height: trackHeight)

                LapFillView(
                    targetProgress: clampedProgress,
                    multiplier: multiplier,
                    trackWidth: trackWidth,
                    trackHeight: trackHeight,
                    trackFillPadding: trackFillPadding,
                    indicatorSize: indicatorSize,
                    gradient: gradient,
                    completedTrackColor: completedTrackColor,
                    showBadge: showBadge
                )

                if showBadge {
                    ZStack {
                        Circle()
                            .fill(gradient)
                            .frame(width: badgeSize, height: badgeSize)

                        Text("x\(badgeMultiplier)")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: trackWidth - badgeSize / 2)
                    .transition(.opacity)
                }
            }
            .frame(width: geometry.size.width, height: badgeSize)
            .animation(.easeInOut(duration: 0.2), value: showBadge)
        }
        .frame(height: badgeSize)
    }
}

// MARK: - Lap Fill (internal — grows the current lap's gradient fill

private struct LapFillView: View {
    let targetProgress: CGFloat
    let multiplier: Int
    let trackWidth: CGFloat
    let trackHeight: CGFloat
    let trackFillPadding: CGFloat
    let indicatorSize: CGFloat
    let gradient: LinearGradient
    let completedTrackColor: Color
    let showBadge: Bool

    @State private var displayProgress: CGFloat = 0
    @State private var lastHandledProgress: CGFloat = -1
    @State private var lastHandledMultiplier: Int = -1

    private let growDuration = 0.3
    private let shrinkDuration = 0.25
    private let overlayFadeDuration = 0.2

    private var showCompletedOverlay: Bool {
        showBadge && displayProgress > 0
    }

    var body: some View {
        let innerWidth = max(0, trackWidth - trackFillPadding * 2)
        let innerHeight = max(0, trackHeight - trackFillPadding * 2)
        let fillWidth = innerWidth * displayProgress

        ZStack(alignment: .leading) {
            Capsule()
                .fill(completedTrackColor)
                .frame(width: innerWidth, height: innerHeight)
                .opacity(showCompletedOverlay ? 1 : 0)
                .animation(.easeInOut(duration: overlayFadeDuration), value: showCompletedOverlay)

            Capsule()
                .fill(gradient)
                .frame(width: fillWidth, height: innerHeight)

            Circle()
                .fill(gradient)
                .frame(width: indicatorSize, height: indicatorSize)
                .offset(x: max(0, fillWidth - indicatorSize / 2))
                .opacity(displayProgress >= 1 ? 0 : 1)
        }
        .padding(trackFillPadding)
        .onAppear {
            lastHandledMultiplier = multiplier
            advance(to: targetProgress)
        }
        .onReceive(Just(multiplier)) { newMultiplier in
            guard newMultiplier != lastHandledMultiplier else { return }
            let didIncreaseLap = newMultiplier > lastHandledMultiplier
            lastHandledMultiplier = newMultiplier

            if didIncreaseLap {
                displayProgress = 0
                advance(to: targetProgress)
            } else {
                withAnimation(.easeInOut(duration: shrinkDuration)) {
                    displayProgress = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + shrinkDuration) {
                    advance(to: targetProgress)
                }
            }
        }
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
    }
}

// MARK: - Detail Promo View

struct DetailPromoView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isGridView: Bool = false
    @State private var isFloatingBarHidden: Bool = false
    @State private var hideBarWorkItem: DispatchWorkItem?
    private let scrollHideThreshold: CGFloat = 100
    @State private var lastDragTranslationY: CGFloat = 0
    @State private var approximateScrollOffset: CGFloat = 0
    @State private var totalProductQuantity: Int = 0
    private let pointsPerUnit = 40
    private let pointsPerBar = 100
    private let progressLimit = 300

    private var promoProgressState: (multiplier: Int, progress: CGFloat, badgeMultiplier: Int, showBadge: Bool) {
        let totalPoints = min(totalProductQuantity * pointsPerUnit, progressLimit)

        guard totalPoints > 0 else {
            return (multiplier: 1, progress: 0, badgeMultiplier: 0, showBadge: false)
        }

        let remainder = totalPoints % pointsPerBar
        if remainder == 0 {
            let lap = totalPoints / pointsPerBar
            return (multiplier: lap, progress: 1, badgeMultiplier: lap, showBadge: lap >= 1)
        } else {
            let lap = totalPoints / pointsPerBar + 1
            let completedLaps = lap - 1
            return (
                multiplier: lap,
                progress: CGFloat(remainder) / CGFloat(pointsPerBar),
                badgeMultiplier: completedLaps,
                showBadge: completedLaps >= 1
            )
        }
    }

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

    private func updateApproximateScrollOffset(with value: DragGesture.Value) {
        let deltaSinceLastCallback = value.translation.height - lastDragTranslationY
        lastDragTranslationY = value.translation.height
        approximateScrollOffset -= deltaSinceLastCallback
    }

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
            }) {
                Image("ic_search")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey50)
            }

            Button(action: {
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
    private var nestedCard: some View {
        VStack(spacing: -12) {
            nestedCardTop
                .zIndex(1)

            nestedCardBottom
                .zIndex(0)
        }
    }

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
                multiplier: promoProgressState.multiplier,
                badgeMultiplier: promoProgressState.badgeMultiplier,
                showBadge: promoProgressState.showBadge
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
