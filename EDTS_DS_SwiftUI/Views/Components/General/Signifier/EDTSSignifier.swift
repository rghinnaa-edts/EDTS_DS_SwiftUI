//
//  EDTSSignifier.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 01/09/26.
//

import SwiftUI

private struct EDTSShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.pathBuilder = { rect in shape.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

public struct EDTSSignifier: View {
    // MARK: - Properties
    public let label: String?
    public let labelAttributed: AttributedString?
    public var labelColor: Color?
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?

    public var bgColor: Color?
    public var cornerRadius: CGFloat?
    public var borderWidth: CGFloat
    public var borderColor: Color?
    
    public var shadowOpacity: Float
    public var shadowOffset: CGSize
    public var shadowRadius: CGFloat
    public var shadowColor: Color?

    public var paddingTop: CGFloat?
    public var paddingBottom: CGFloat?
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var offsetY: CGFloat
    public var offsetX: CGFloat

    public var isSkeleton: Bool
    public var isIndicator: Bool
    
    // MARK: - Private Variable
    private var customFont: Font? {
        if let fontStyle { return fontStyle }
        guard !fontName.isEmpty || fontSize != .zero else { return nil }
        let resolvedSize = fontSize == .zero ? 16 : fontSize
        var font: Font = fontName.isEmpty
        ? .system(size: resolvedSize)
        : .custom(fontName, size: resolvedSize)
        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }
        return font
    }
    
    private var resolvedHeight: CGFloat {
        if isIndicator {
            return EDTSColor.theme == .poinku ? 12 : 8
        } else {
            return EDTSColor.theme == .poinku ? 12 : 16
        }
    }
    
    private var resolvedLabelColor: Color {
        labelColor ?? EDTSColor.white
    }
    
    private var resolvedFontStyle: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.B5.Medium : EDTSFont.Klik.B4.Semibold
    }
    
    private var resolvedBgColor: Color {
        bgColor ?? EDTSColor.red30
    }
    
    private var resolvedBorderColor: Color {
        if let borderColor { return borderColor }
        return EDTSColor.theme == .poinku ? EDTSColor.white : .clear
    }
    
    private var resolvedPaddingTop: CGFloat {
        if let paddingTop { return paddingTop }
        return EDTSColor.theme == .poinku ? 0 : 1
    }
    
    private var resolvedPaddingBottom: CGFloat {
        if let paddingBottom { return paddingBottom }
        return EDTSColor.theme == .poinku ? 0 : 1
    }
    
    private var resolvedShape: EDTSShape {
        if let cornerRadius {
            return EDTSShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        return EDTSShape(Capsule())
    }
    
    // MARK: - Initializers
    public init(
        label: String? = "0",
        labelAttributed: AttributedString? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        labelColor: Color? = nil,
        bgColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat = .zero,
        borderColor: Color? = nil,
        shadowOpacity: Float = .zero,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = .zero,
        shadowColor: Color? = nil,
        paddingTop: CGFloat? = nil,
        paddingBottom: CGFloat? = nil,
        paddingLeading: CGFloat = 2,
        paddingTrailing: CGFloat = 2,
        offsetY: CGFloat = .zero,
        offsetX: CGFloat = .zero,
        isSkeleton: Bool = false,
        isIndicator: Bool = false
    ) {
        self.label = labelAttributed == nil ? (label ?? "0") : nil
        self.labelAttributed = labelAttributed
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.labelColor = labelColor
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
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.isSkeleton = isSkeleton
        self.isIndicator = isIndicator
    }

    // MARK: - Body
    public var body: some View {
        Group {
            if isSkeleton {
                skeletonView
            } else if isIndicator {
                indicatorView
            } else {
                badgeView
            }
        }
    }

    @ViewBuilder
    private var badgeView: some View {
        labelView
            .padding(.top, resolvedPaddingTop)
            .padding(.bottom, resolvedPaddingBottom)
            .padding(.leading, paddingLeading)
            .padding(.trailing, paddingTrailing)
            .frame(minWidth: resolvedHeight, minHeight: resolvedHeight)
            .background(resolvedBgColor)
            .clipShape(resolvedShape)
            .overlay(resolvedShape.stroke(resolvedBorderColor ?? .clear, lineWidth: borderWidth))
            .shadow(
                color: (shadowColor ?? .clear).opacity(Double(shadowOpacity)),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }

    @ViewBuilder
    private var labelView: some View {
        Group {
            if let labelAttributed {
                Text(labelAttributed)
            } else {
                Text(label ?? "0")
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(resolvedLabelColor)
        .edtsFont(resolvedFontStyle, custom: customFont)
    }

    @ViewBuilder
    private var indicatorView: some View {
        resolvedShape
            .fill(resolvedBgColor)
            .overlay(resolvedShape.stroke(resolvedBorderColor ?? .clear, lineWidth: borderWidth))
            .frame(width: resolvedHeight, height: resolvedHeight)
            .shadow(
                color: (shadowColor ?? .clear).opacity(Double(shadowOpacity)),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }

    @ViewBuilder
    private var skeletonView: some View {
        EDTSSkeleton(cornerRadius: resolvedHeight / 2)
            .frame(width: resolvedHeight, height: resolvedHeight)
    }
}

// MARK: - Preview
#Preview("Badge") {
    VStack(spacing: 24) {
        EDTSSignifier(label: "0")
        EDTSSignifier(label: "9")
        EDTSSignifier(label: "99+")
        EDTSSignifier(isIndicator: true)
        EDTSSignifier(bgColor: EDTSColor.green30, isIndicator: true)
        EDTSSignifier(bgColor: EDTSColor.grey40, isIndicator: true)
        EDTSSignifier(isSkeleton: true)
        EDTSSignifier(isSkeleton: true, isIndicator: true)
        Image(systemName: "bell.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .foregroundColor(EDTSColor.greyText)
            .edtsSignifier(EDTSSignifier(label: "3", offsetY: 4, offsetX: 2))
    }
}
