//
//  SearchPromoView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 28/09/26.
//

import SwiftUI

struct SearchPromoView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool
    @State private var query: String = ""

    var promoTitle: String = "Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000"
    var onSearch: (String) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 0) {
            searchToolbar
                .zIndex(1)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EDTSColor.white)
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isSearchFocused = true
            }
        }
    }

    // MARK: - Toolbar

    private var searchToolbar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                Image("ic_arrow_left")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(EDTSColor.grey50)
            }

            searchField
        }
        .padding(.leading, 12)
        .padding(.trailing, 16)
        .padding(.vertical, 12)
        .background(EDTSColor.white)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    private var searchField: some View {
        HStack(spacing: 4) {
            Image("ic_search")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(EDTSColor.grey50)

            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text("Cari di \(promoTitle)")
                        .font(EDTSFont.Klik.B2.Regular.font)
                        .foregroundColor(EDTSColor.grey40)
                        .lineLimit(1)
                }

                TextField("", text: $query)
                    .font(EDTSFont.Klik.B2.Regular.font)
                    .foregroundColor(EDTSColor.grey70)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch(query)
                    }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(EDTSColor.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(EDTSColor.grey30, lineWidth: 1)
        )
    }
}

// MARK: - Preview

struct SearchPromoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPromoView()
    }
}
