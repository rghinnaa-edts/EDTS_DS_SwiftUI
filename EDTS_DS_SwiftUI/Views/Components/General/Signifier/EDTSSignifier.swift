//
//  EDTSSignifier.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 01/09/26.
//

import SwiftUI

public struct EDTSSignifier: View {
    // MARK: - Properties
    public let text: String?
    public let textAttributed: AttributedString?
    public var textColor: Color?
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: Double
    public var fontWeight: String?

    public var bgColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    public var cornerRadius: Double?
    public var borderWidth: Double
    public var borderColor: Color?
    
    public var shadowOpacity: Double
    public var shadowOffset: CGSize
    public var shadowRadius: Double
    public var shadowColor: Color?

    public var paddingTop: Double?
    public var paddingBottom: Double?
    public var paddingLeading: Double
    public var paddingTrailing: Double

    public var offsetY: Double
    public var offsetX: Double

    public var isSkeleton: Bool
    public var isIndicator: Bool
    
    // MARK: - Private Variable
    private static let defaultFontSize: Double = 16
    private static let poinkuHeight: Double = 12
    private static let poinkuPaddingVertical: Double = 0
    private static let klikIndicatorHeight: Double = 8
    private static let klikBadgeHeight: Double = 16
    private static let klikPaddingVertical: Double = 1
    
    private var customFont: Font? {
        if let fontStyle { return fontStyle }
        guard !fontName.isEmpty || fontSize != .zero else { return nil }
        let resolvedSize = fontSize == .zero ? Self.defaultFontSize : fontSize
        var font: Font = fontName.isEmpty
        ? .system(size: resolvedSize)
        : .custom(fontName, size: resolvedSize)
        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }
        return font
    }
    
    private struct ResolvedValues {
        var tempHeight: Double = .zero
        var tempTextColor: Color?
        var tempFontStyle: Font?
        var tempBgColor: Color?
        var tempBorderColor: Color?
        var tempPaddingTop: Double = .zero
        var tempPaddingBottom: Double = .zero
    }
    
    private var resolvedShape: EDTSShape {
        if let cornerRadius {
            return EDTSShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        return EDTSShape(Capsule())
    }
    
    // MARK: - Initializers
    public init(
        text: String? = "0",
        textAttributed: AttributedString? = nil,
        textColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: Double = .zero,
        fontWeight: String? = nil,
        bgColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        cornerRadius: Double? = nil,
        borderWidth: Double = .zero,
        borderColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowOffset: CGSize = .zero,
        shadowRadius: Double = .zero,
        shadowColor: Color? = nil,
        paddingTop: Double? = nil,
        paddingBottom: Double? = nil,
        paddingLeading: Double = 2,
        paddingTrailing: Double = 2,
        offsetY: Double = 4.5,
        offsetX: Double = 2.5,
        isSkeleton: Bool = false,
        isIndicator: Bool = false
    ) {
        self.text = textAttributed == nil ? text : nil
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
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
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.isSkeleton = isSkeleton
        self.isIndicator = isIndicator
    }
    
    // MARK: - Body
    public var body: some View {
        let values = setupDefaultTheming()
        
        Group {
            if isSkeleton {
                skeletonView(values: values)
            } else if isIndicator {
                indicatorView(values: values)
            } else {
                badgeView(values: values)
            }
        }
    }

    @ViewBuilder
    private func badgeView(values: ResolvedValues) -> some View {
        textView(values: values)
            .padding(.top, values.tempPaddingTop)
            .padding(.bottom, values.tempPaddingBottom)
            .padding(.leading, paddingLeading)
            .padding(.trailing, paddingTrailing)
            .frame(minWidth: values.tempHeight, minHeight: values.tempHeight)
            .background(setupBackground(values: values))
            .clipShape(resolvedShape)
            .overlay(resolvedShape.stroke(values.tempBorderColor ?? .clear, lineWidth: borderWidth))
            .shadow(
                color: (shadowColor ?? .clear).opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }

    @ViewBuilder
    private func textView(values: ResolvedValues) -> some View {
        Group {
            if let textAttributed {
                Text(textAttributed)
            } else {
                Text(text ?? "0")
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(values.tempTextColor)
        .font(customFont ?? values.tempFontStyle)
    }

    @ViewBuilder
    private func indicatorView(values: ResolvedValues) -> some View {
        Color.clear
            .frame(width: values.tempHeight, height: values.tempHeight)
            .background(setupBackground(values: values))
            .clipShape(resolvedShape)
            .overlay(resolvedShape.stroke(values.tempBorderColor ?? .clear, lineWidth: borderWidth))
            .shadow(
                color: (shadowColor ?? .clear).opacity(Double(shadowOpacity)),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }

    @ViewBuilder
    private func skeletonView(values: ResolvedValues) -> some View {
        EDTSSkeleton(cornerRadius: values.tempHeight / 2)
            .frame(width: values.tempHeight, height: values.tempHeight)
    }
    
    // MARK: - Setup & Styling
    @ViewBuilder
    private func setupBackground(values: ResolvedValues) -> some View {
        if bgColorStart != nil || bgColorEnd != nil {
            let orientation = bgColorOrientation ?? .horizontal
            LinearGradient(
                colors: [bgColorStart ?? .clear, bgColorEnd ?? .clear],
                startPoint: orientation == .horizontal ? .leading : .top,
                endPoint: orientation == .horizontal ? .trailing : .bottom
            )
        } else {
            values.tempBgColor ?? EDTSColor.red30
        }
    }
    
    private func setupDefaultTheming() -> ResolvedValues {
        var values = ResolvedValues()
        
        if EDTSColor.theme == .poinku {
            values.tempHeight = Self.poinkuHeight
            values.tempFontStyle = EDTSFont.Poinku.B5.Medium.font
            values.tempBorderColor = borderColor ?? EDTSColor.white
            values.tempPaddingTop = paddingTop ?? Self.poinkuPaddingVertical
            values.tempPaddingBottom = paddingBottom ?? Self.poinkuPaddingVertical
        } else {
            values.tempHeight = isIndicator ? Self.klikIndicatorHeight : Self.klikBadgeHeight
            values.tempFontStyle = EDTSFont.Klik.B4.Semibold.font
            values.tempBorderColor = borderColor ?? .clear
            values.tempPaddingTop = paddingTop ?? Self.klikPaddingVertical
            values.tempPaddingBottom = paddingBottom ?? Self.klikPaddingVertical
        }
        
        values.tempTextColor = textColor ?? EDTSColor.white
        values.tempBgColor = bgColor ?? EDTSColor.red30
        
        return values
    }
    
}

extension View{
    public func edtsSignifier(_ signifier: EDTSSignifier) -> some View {
        self.overlay(alignment: .topTrailing) {
            signifier
                .offset(x: signifier.offsetX, y: -signifier.offsetY)
        }
    }
}

// MARK: - Preview
#Preview("Preview") {
    VStack(spacing: 24) {
        EDTSSignifier(text: "0")
        EDTSSignifier(text: "9")
        EDTSSignifier(text: "99+")
        EDTSSignifier(isIndicator: true)
        EDTSSignifier(bgColor: EDTSColor.green30, isIndicator: true)
        EDTSSignifier(bgColor: EDTSColor.grey40, isIndicator: true)
        EDTSSignifier(isSkeleton: true)
        EDTSSignifier(isSkeleton: true, isIndicator: true)
        EDTSSignifier(bgColorStart: EDTSColor.blueLeading, bgColorEnd: EDTSColor.blueTrailing)
        Image(systemName: "bell.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(EDTSColor.greyText)
            .edtsSignifier(EDTSSignifier(text: "3", offsetY: 4, offsetX: 2))
    }
}
