//
//  LiquidGlassBackgroundView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 05/10/26.
//

import SwiftUI

public struct EDTSLiquidGlassBackground: View {
    // MARK: - Properties
    public let cornerRadius: CGFloat

    // MARK: - Private Variable
    private let materialOpacity: Double = 0.5
    private let borderWidth: CGFloat = 1
    private let borderHighlightOpacity: Double = 0.9
    private let borderHighlightFade: Double = 0.05

    // MARK: - Initializer
    public init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    // MARK: - Body
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Material.ultraThin.opacity(materialOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: EDTSColor.white.opacity(borderHighlightOpacity), location: 0.0),
                                .init(color: .clear, location: borderHighlightFade),
                                .init(color: .clear, location: 1 - borderHighlightFade),
                                .init(color: EDTSColor.white.opacity(borderHighlightOpacity), location: 1.0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: borderWidth
                    )
            )
    }
}
