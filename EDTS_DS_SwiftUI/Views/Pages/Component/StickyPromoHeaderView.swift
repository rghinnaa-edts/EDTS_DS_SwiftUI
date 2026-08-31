//
//  StickyPromoHeaderView.swift
//  EDTS_DS_SwiftUI
//

import SwiftUI

struct StickyPromoHeaderView: View {
    let progress: CGFloat
    let claimedCount: Int
    var multiplier: Int = 1
    var onLihatTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProgressBarView(progress: progress, multiplier: multiplier)

            HStack(spacing: 8) {
                (
                    Text("Kamu sudah ambil ")
                        .foregroundColor(EDTSColor.grey50)
                    + Text("\(claimedCount) tebus murah")
                        .foregroundColor(EDTSColor.blue50)
                )
                .font(EDTSFont.Klik.B2.Regular.font)
                .lineLimit(1)

                Spacer(minLength: 8)

                Button(action: onLihatTap) {
                    Text("Lihat")
                        .font(EDTSFont.Klik.Button.Small.font)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(EDTSColor.blueDefault)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
        .background(EDTSColor.white)
    }
}
