//
//  EDTSSignifier.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 01/09/26.
//

import SwiftUI

private struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.pathBuilder = { rect in shape.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

public struct EDTSSignifier: View {

    private let label: String?
    private let labelAttributed: AttributedString?

    private var labelFontName: String
    private var labelFontSize: CGFloat
    private var labelFontWeight: String

    private var labelColor: Color?

    private var bgColor: Color?
    private var cornerRadius: CGFloat?
    private var borderWidth: CGFloat
    private var borderColor: Color?
    private var shadowOpacity: Float
    private var shadowOffset: CGSize
    private var shadowRadius: CGFloat
    private var shadowColor: Color?

    private var paddingTop: CGFloat?
    private var paddingBottom: CGFloat?
    private var paddingLeading: CGFloat
    private var paddingTrailing: CGFloat

    public var topOffset: CGFloat
    public var trailingOffset: CGFloat

    private var isSkeleton: Bool
    private var isIndicator: Bool

    // MARK: - Init
    public init(
        label: String? = "0",
        labelAttributed: AttributedString? = nil,
        labelFontName: String = "",
        labelFontSize: CGFloat = .zero,
        labelFontWeight: String = "",
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
        topOffset: CGFloat = .zero,
        trailingOffset: CGFloat = .zero,
        isSkeleton: Bool = false,
        isIndicator: Bool = false
    ) {
        self.label = labelAttributed == nil ? (label ?? "0") : nil
        self.labelAttributed = labelAttributed
        self.labelFontName = labelFontName
        self.labelFontSize = labelFontSize
        self.labelFontWeight = labelFontWeight
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
        self.topOffset = topOffset
        self.trailingOffset = trailingOffset
        self.isSkeleton = isSkeleton
        self.isIndicator = isIndicator
    }

    private var resolvedSignifierHeight: CGFloat {
        if isIndicator {
            return EDTSColor.theme == .poinku ? 12 : 8
        } else {
            return EDTSColor.theme == .poinku ? 12 : 16
        }
    }

    private var resolvedBgColor: Color {
        bgColor ?? EDTSColor.red30
    }

    private var resolvedLabelColor: Color {
        labelColor ?? EDTSColor.white
    }

    private var resolvedPaddingTop: CGFloat {
        if let paddingTop { return paddingTop }
        return EDTSColor.theme == .poinku ? 0 : 1
    }

    private var resolvedPaddingBottom: CGFloat {
        if let paddingBottom { return paddingBottom }
        return EDTSColor.theme == .poinku ? 0 : 1
    }

    private var resolvedFontStyle: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.B5.Medium : EDTSFont.Klik.B4.Semibold
    }

    private var hasCustomFont: Bool {
        !labelFontName.isEmpty || labelFontSize != .zero || !labelFontWeight.isEmpty
    }

    private var customFont: Font {
        let weight = setupFontWeight(from: labelFontWeight)
        if !labelFontName.isEmpty {
            return .custom(labelFontName, size: labelFontSize == .zero ? 12 : labelFontSize)
        }
        return .system(size: labelFontSize == .zero ? 12 : labelFontSize, weight: weight)
    }

    private var resolvedShape: AnyShape {
        if let cornerRadius {
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        return AnyShape(Capsule())
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
            .frame(minWidth: resolvedSignifierHeight, minHeight: resolvedSignifierHeight)
            .background(resolvedBgColor)
            .clipShape(resolvedShape)
            .overlay(resolvedShape.stroke(borderColor ?? .clear, lineWidth: borderWidth))
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
        .modifier(LabelFontModifier(
            hasCustomFont: hasCustomFont,
            customFont: customFont,
            defaultStyle: resolvedFontStyle
        ))
    }

    @ViewBuilder
    private var indicatorView: some View {
        resolvedShape
            .fill(resolvedBgColor)
            .overlay(resolvedShape.stroke(borderColor ?? .clear, lineWidth: borderWidth))
            .frame(width: resolvedSignifierHeight, height: resolvedSignifierHeight)
            .shadow(
                color: (shadowColor ?? .clear).opacity(Double(shadowOpacity)),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }

    @ViewBuilder
    private var skeletonView: some View {
        EDTSSkeleton(cornerRadius: resolvedSignifierHeight / 2)
            .frame(width: resolvedSignifierHeight, height: resolvedSignifierHeight)
    }
}

private struct LabelFontModifier: ViewModifier {
    let hasCustomFont: Bool
    let customFont: Font
    let defaultStyle: EDTSFont.FontStyle

    func body(content: Content) -> some View {
        if hasCustomFont {
            content.font(customFont)
        } else {
            content.edtsFont(defaultStyle)
        }
    }
}

extension View {
    public func edtsSignifier(_ signifier: EDTSSignifier) -> some View {
        self.overlay(alignment: .topTrailing) {
            signifier
                .offset(x: signifier.trailingOffset, y: -signifier.topOffset)
        }
    }
}

// MARK: - Preview
#Preview("Badge") {
    VStack(spacing: 24) {
        EDTSSignifier(label: "0")
        EDTSSignifier(label: "9")
        EDTSSignifier(label: "99+")
        EDTSSignifier(label: "New", labelColor: EDTSColor.white, bgColor: EDTSColor.green30)
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
            .padding(24)
            .edtsSignifier(EDTSSignifier(label: "3", topOffset: -14, trailingOffset: -14))
            .background(Color.pink)
    }
    .padding()
    .background(Color.blue)
}
