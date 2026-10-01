//
//  BadgeView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI

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
