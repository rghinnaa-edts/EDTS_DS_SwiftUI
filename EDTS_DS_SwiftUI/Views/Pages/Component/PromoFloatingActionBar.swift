//
//  PromoFloatingActionBar.swift
//  EDTS_DS_SwiftUI
//

import SwiftUI

// MARK: - Sort / Filter Pill

struct SortFilterPillView: View {
    var onSortTap: () -> Void = {}
    var onFilterTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onSortTap) {
                HStack(spacing: 8) {
                    Image("ic_sort_by")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(EDTSColor.grey50)

                    Text("Urutkan")
                        .font(EDTSFont.Klik.H3.font)
                        .foregroundColor(EDTSColor.grey60)
                }
            }

            Rectangle()
                .fill(EDTSColor.grey30)
                .frame(width: 1, height: 20)

            Button(action: onFilterTap) {
                HStack(spacing: 8) {
                    Image("ic_filter")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(EDTSColor.grey50)

                    Text("Filter")
                        .font(EDTSFont.Klik.H3.font)
                        .foregroundColor(EDTSColor.grey60)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(EDTSColor.white)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Cart Summary Card

struct CartSummaryCardView: View {
    let itemCountText: String   // e.g. "(1 Barang)"
    let priceText: String       // e.g. "Rp50.000"
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image("ic_cart")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey70)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Keranjang")
                        .font(EDTSFont.Klik.H3.font)
                        .foregroundColor(EDTSColor.grey70)

                    Text(itemCountText)
                        .font(EDTSFont.Klik.B4.Regular.font)
                        .foregroundColor(EDTSColor.grey70)
                }

                Spacer(minLength: 8)

                Text(priceText)
                    .font(EDTSFont.Klik.H3.font)
                    .foregroundColor(EDTSColor.grey70)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(EDTSColor.cartDefault)
            .cornerRadius(4)
        }
    }
}

// MARK: - Floating Action Bar (both cards stacked)

struct PromoFloatingActionBar: View {
    let itemCountText: String
    let priceText: String
    var onSortTap: () -> Void = {}
    var onFilterTap: () -> Void = {}
    var onCartTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            SortFilterPillView(onSortTap: onSortTap, onFilterTap: onFilterTap)

            CartSummaryCardView(
                itemCountText: itemCountText,
                priceText: priceText,
                onTap: onCartTap
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
