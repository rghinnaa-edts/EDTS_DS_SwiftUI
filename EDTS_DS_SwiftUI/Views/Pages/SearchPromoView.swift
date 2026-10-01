//
//  SearchPromoView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 28/09/26.
//

import SwiftUI

// MARK: - Suggestion model

struct SearchSuggestion: Identifiable {
    let id = UUID()
    let term: String
    let context: String
}

struct SearchPromoView: View {
    @Binding var quantities: [UUID: Int]

    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool
    @State private var query: String = ""

    @State private var searchedTerm: String = ""
    @State private var showResults: Bool = false
    var promoTitle: String = "Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000"
    var onSearch: (String) -> Void = { _ in }

    private let allSuggestions: [SearchSuggestion] = [
        SearchSuggestion(
            term: "Kurma",
            context: "di Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000. Berlaku Kelipatan."
        ),
        SearchSuggestion(
            term: "Kurma",
            context: "di Klik Indomaret"
        ),
        SearchSuggestion(
            term: "Indomie",
            context: "di Belanja All Item Klik Indomaret Senilai Rp50.000 Dapat Tebus Murah Rp5.000. Berlaku Kelipatan."
        ),
        SearchSuggestion(
            term: "Indomie",
            context: "di Klik Indomaret"
        )
    ]

    private var matchingSuggestions: [SearchSuggestion] {
        guard !query.isEmpty else { return [] }
        return allSuggestions.filter {
            $0.term.range(of: query, options: .caseInsensitive) != nil
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            searchToolbar
                .zIndex(1)

            if showResults {
                SearchResultView(
                    query: searchedTerm,
                    quantities: $quantities,
                    onChangeKeyword: {
                        query = ""
                        showResults = false
                        isSearchFocused = true
                    }
                )
            } else if matchingSuggestions.isEmpty {
                Spacer()
            } else {
                suggestionsList
            }
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

    // MARK: - Search action

    private func performSearch(_ term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        searchedTerm = trimmed
        isSearchFocused = false
        onSearch(trimmed)
        showResults = true
    }

    // MARK: - Suggestions list

    private var suggestionsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(matchingSuggestions) { suggestion in
                    suggestionRow(suggestion)
                }
            }
        }
    }

    private func suggestionRow(_ suggestion: SearchSuggestion) -> some View {
        Button(action: {
            query = suggestion.term
            performSearch(suggestion.term)
        }) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundColor(EDTSColor.grey50)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(suggestion.term)
                        .font(EDTSFont.Klik.B3.Regular.font)
                        .foregroundColor(EDTSColor.grey60)

                    Text(suggestion.context)
                        .font(EDTSFont.Klik.B4.Regular.font)
                        .foregroundColor(EDTSColor.grey50)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
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
        .overlay(
            Rectangle()
                .fill(EDTSColor.grey30)
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 2),
            alignment: .bottom
        )
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
                    // Placeholder
                    Text("Cari di \(promoTitle)")
                        .font(EDTSFont.Klik.B3.Regular.font)
                        .foregroundColor(EDTSColor.grey40)
                        .lineLimit(1)
                }

                TextField("", text: Binding(
                    get: { query },
                    set: { newValue in
                        query = newValue
                        showResults = false
                    }
                ))
                    .font(EDTSFont.Klik.B3.Regular.font)
                    .foregroundColor(EDTSColor.grey70)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        performSearch(query)
                    }
            }

            if !query.isEmpty {
                Button(action: {
                    query = ""
                    showResults = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(EDTSColor.grey40)
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
        SearchPromoView(quantities: .constant([:]))
    }
}
