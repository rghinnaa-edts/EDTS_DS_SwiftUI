//
//  SearchResultPromoView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 01/10/26.
//

import SwiftUI

struct SearchResultView: View {
    let query: String
    
    @Binding var quantities: [UUID: Int]
    
    var promoTitle: String = "Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000. Berlaku Kelipatan."
    var allProducts: [ProductCardModel] = DetailPromoView.sampleProducts
    var onChangeKeyword: () -> Void = {}

    @State private var isGridView: Bool = false
    @State private var isFloatingBarHidden: Bool = false
    @State private var hideBarWorkItem: DispatchWorkItem?
    
    private var totalProductQuantity: Int { quantities.values.reduce(0, +) }

    private let scrollHideThreshold: CGFloat = 100
    private let pointsPerUnit = 40
    private let pointsPerBar = 100
    private let progressLimit = 300

    // MARK: - Data

    private var products: [ProductCardModel] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return allProducts }
        return allProducts.filter {
            $0.title.range(of: trimmed, options: .caseInsensitive) != nil
        }
    }

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

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            StickyPromoHeaderView(
                progress: promoProgressState.progress,
                claimedCount: 1,
                multiplier: promoProgressState.multiplier,
                badgeMultiplier: promoProgressState.badgeMultiplier,
                showBadge: promoProgressState.showBadge
            )
            .zIndex(1)

            ScrollView(.vertical, showsIndicators: false) {
                if products.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: 0) {
                        promoTitleSection
                        productListHeader

                        ProductStaggeredListView(
                            products: products,
                            quantities: $quantities
                        )
                        .padding(.bottom, 16)
                    }
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        handleFloatingBarVisibility(for: value)
                    }
            )
        }
        .bottomInsetCompat {
            PromoFloatingActionBar(
                itemCountText: "(1 Barang)",
                priceText: "Rp50.000",
                showSortFilter: !products.isEmpty
            )
            .offset(y: isFloatingBarHidden ? 160 : 0)
            .opacity(isFloatingBarHidden ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isFloatingBarHidden)
        }
        .background(EDTSColor.white)
    }

    // MARK: - Empty state ("Produk tidak ditemukan")

    private var emptyState: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    Image("img_not_found")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Produk tidak ditemukan")
                            .font(EDTSFont.Klik.H2.font)
                            .foregroundColor(EDTSColor.grey70)

                        Text("Cari kata kunci lain atau cek produk rekomendasi di bawah ini, yuk!")
                            .font(EDTSFont.Klik.B2.Regular.font)
                            .foregroundColor(EDTSColor.grey50)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 0)
                }

                Button(action: onChangeKeyword) {
                    Text("Ganti Kata Kunci")
                        .font(EDTSFont.Klik.Button.Small.font)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(EDTSColor.blueDefault)
                        .cornerRadius(6)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)

            Rectangle()
                .fill(EDTSColor.grey30)
                .frame(height: 1)
        }
        .background(EDTSColor.white)
    }

    // MARK: - Floating bar visibility

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

    // MARK: - Promo title

    private var promoTitleSection: some View {
        Text(promoTitle)
            .font(EDTSFont.Klik.P1.Semibold.font)
            .foregroundColor(EDTSColor.grey70)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(EDTSColor.white)
    }

    // MARK: - Product count

    private var productListHeader: some View {
        HStack(spacing: 8) {
            Text("\(products.count) produk")
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
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 16)
        .background(EDTSColor.white)
    }
}

// MARK: - Preview

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchResultView(query: "Goreng", quantities: .constant([:]))
            SearchResultView(query: "Kurma", quantities: .constant([:]))
        }
    }
}
