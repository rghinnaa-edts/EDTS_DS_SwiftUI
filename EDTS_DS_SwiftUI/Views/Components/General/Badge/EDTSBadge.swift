//
//  EDTSBadge.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

public struct EDTSBadge: View {
    public var text: String
    public var textAttributed: AttributedString?
    public var textColor: Color
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?
    public var iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconTrailing: Image?
    public var iconTintColorTrailing: Color?
    public var iconSize: CGFloat?
    public var iconSpacing: CGFloat
    public var bgColor: Color
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    public var cornerRadius: CGFloat
    public var cornerRadiusTopLeft: CGFloat
    public var cornerRadiusTopRight: CGFloat
    public var cornerRadiusBottomLeft: CGFloat
    public var cornerRadiusBottomRight: CGFloat
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
    
    private let minimumSize: CGFloat = 16
    private let minimumScale: CGFloat = 0.8

    // MARK: - Init
    
    public init(
        text: String,
        textAttributed: AttributedString? = nil,
        textColor: Color = EDTSColor.grey70,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
        iconSize: CGFloat = 16.0,
        iconSpacing: CGFloat = 4.0,
        bgColor: Color = EDTSColor.grey20,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        cornerRadius: CGFloat = 8.0,
        cornerRadiusTopLeft: CGFloat? = nil,
        cornerRadiusTopRight: CGFloat? = nil,
        cornerRadiusBottomLeft: CGFloat? = nil,
        cornerRadiusBottomRight: CGFloat? = nil,
        borderWidth: CGFloat = 0.0,
        borderColor: Color = .clear,
        shadowOpacity: Double = 0.0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0.0,
        shadowColor: Color = .black,
        paddingTop: CGFloat = 2.0,
        paddingBottom: CGFloat = 2.0,
        paddingLeading: CGFloat = 8.0,
        paddingTrailing: CGFloat = 8.0,
        isSkeleton: Bool = false
    ) {
        self.text = text
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.iconSize = iconSize
        self.iconSpacing = iconSpacing
        self.bgColor = bgColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
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
        
        let hasCustomCorner = cornerRadiusTopLeft != nil
            || cornerRadiusTopRight != nil
            || cornerRadiusBottomLeft != nil
            || cornerRadiusBottomRight != nil

        if hasCustomCorner {
            self.cornerRadiusTopLeft = cornerRadiusTopLeft ?? 0.0
            self.cornerRadiusTopRight = cornerRadiusTopRight ?? 0.0
            self.cornerRadiusBottomLeft = cornerRadiusBottomLeft ?? 0.0
            self.cornerRadiusBottomRight = cornerRadiusBottomRight ?? 0.0
        } else {
            self.cornerRadiusTopLeft = cornerRadius
            self.cornerRadiusTopRight = cornerRadius
            self.cornerRadiusBottomLeft = cornerRadius
            self.cornerRadiusBottomRight = cornerRadius
        }
    }
    
    private var containerBackgroundStyle: AnyShapeStyle {
        if bgColorStart != nil || bgColorEnd != nil {
            let orientation = bgColorOrientation ?? .horizontal
            return AnyShapeStyle(
                LinearGradient(
                    colors: [bgColorStart ?? .clear, bgColorEnd ?? .clear],
                    startPoint: orientation == .horizontal ? .leading : .top,
                    endPoint: orientation == .horizontal ? .trailing : .bottom
                )
            )
        } else {
            return AnyShapeStyle(bgColor)
        }
    }
    
    private var badgeShape: UnevenRoundedShape {
        UnevenRoundedShape(
            topLeft: cornerRadiusTopLeft,
            topRight: cornerRadiusTopRight,
            bottomLeft: cornerRadiusBottomLeft,
            bottomRight: cornerRadiusBottomRight
        )
    }

    private var contentSpacing: CGFloat {
        (iconLeading != nil || iconTrailing != nil) ? iconSpacing : 0
    }
    
    func resolvedFont() -> Font {
        if let fontStyle {
            return fontStyle
        }

        if fontName.isEmpty && fontSize <= 0 && fontWeight == nil {
            if EDTSColor.theme == .poinku {
                return EDTSFont.Poinku.B4.Medium.font
            } else {
                return EDTSFont.Klik.B4.Semibold.font
            }
        }

        let size = fontSize > 0 ? fontSize : UIFont.systemFontSize
        var font: Font = fontName.isEmpty ? .system(size: size) : .custom(fontName, size: size)

        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }

        return font
    }

    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: contentSpacing) {
            if let iconLeading {
                iconLeading
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(iconTintColorLeading ?? textColor)
            }

            if let attributed = textAttributed {
                Text(attributed)
                    .font(resolvedFont())
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(minimumScale)
            } else {
                Text(text)
                    .font(resolvedFont())
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(minimumScale)
            }

            if let iconTrailing {
                iconTrailing
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(iconTintColorTrailing ?? textColor)
            }
        }
        .padding(EdgeInsets(top: paddingTop, leading: paddingLeading, bottom: paddingBottom, trailing: paddingTrailing))
        .frame(minWidth: minimumSize, minHeight: minimumSize, alignment: .center)
        .background(
            badgeShape
                .fill(containerBackgroundStyle)
        )
        .overlay(
            badgeShape
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height)
        .edtsSkeleton(active: isSkeleton, cornerRadius: cornerRadius)
    }
}

#Preview {
    VStack(spacing: 12) {
        EDTSBadge(text: "Label")
        EDTSBadge(text: "Label", iconLeading: Image(systemName: "tag.fill"))
        EDTSBadge(text: "Label", iconTrailing: Image(systemName: "tag.fill"))
    }
    .padding()
}
