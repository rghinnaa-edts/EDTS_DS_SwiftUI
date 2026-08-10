//
//  EDTSBadge.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

public struct EDTSBadge: View {
    // MARK: - Public API
    public var label: String
    public var icon: Image?

    // Styling
    public var labelColor: Color
    public var labelFont: Font
    public var iconTint: Color?
    public var iconPadding: CGFloat

    public var bgColor: Color
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var borderColor: Color

    public var shadowOpacity: Double
    public var shadowOffset: CGSize
    public var shadowRadius: CGFloat
    public var shadowColor: Color

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var isSkeleton: Bool

    // MARK: - Init
    public init(
        label: String,
        icon: Image? = nil,
        labelColor: Color = EDTSColor.grey70,
        labelFont: Font = EDTSFont.Klik.B4.Regular.font,
        iconTint: Color? = nil,
        iconPadding: CGFloat = 2.0,
        bgColor: Color = EDTSColor.grey20,
        cornerRadius: CGFloat = 9.0,
        borderWidth: CGFloat = 0.0,
        borderColor: Color = .clear,
        shadowOpacity: Double = 0.0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0.0,
        shadowColor: Color = .black,
        paddingTop: CGFloat = 1.0,
        paddingBottom: CGFloat = 1.0,
        paddingLeading: CGFloat = 4.0,
        paddingTrailing: CGFloat = 4.0,
        isSkeleton: Bool = false
    ) {
        self.label = label
        self.icon = icon
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.iconTint = iconTint
        self.iconPadding = iconPadding
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.isSkeleton = isSkeleton
    }

    // MARK: - Body
    public var body: some View {
        HStack(spacing: icon == nil ? 0 : iconPadding) {
            if let icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(iconTint ?? labelColor)
            }

            Text(label)
                .font(labelFont)
                .foregroundStyle(labelColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(EdgeInsets(top: paddingTop, leading: paddingLeading, bottom: paddingBottom, trailing: paddingTrailing))
        .frame(minWidth: 18, minHeight: 18, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(bgColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height)
        .edtsSkeleton(active: isSkeleton, cornerRadius: cornerRadius)
    }
}

#Preview {
    VStack(spacing: 12) {
        EDTSBadge(label: "New")
        EDTSBadge(label: "Promo", icon: Image(systemName: "tag.fill"))
    }
    .padding()
}
