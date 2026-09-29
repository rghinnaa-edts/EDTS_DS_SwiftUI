//
//  EDTSToast.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/09/26.
//

import SwiftUI

// MARK: - Enums
public enum EDTSToastState: String {
    case info = "info"
    case danger = "danger"
}

public struct EDTSToast: View {
    // MARK: - Properties
    public var toastState: EDTSToastState

    public let text: String?
    public let textAttributed: AttributedString?
    public var textColor: Color?
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?

    public var bgColor: Color?

    public let icon: Image?
    public var iconTintColor: Color?
    public var iconSize: CGFloat

    public var spacing: CGFloat
    public var cornerRadius: CGFloat

    public var borderWidth: CGFloat
    public var borderColor: Color?

    public var shadowOpacity: Float
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize?
    public var shadowColor: Color?

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var button: EDTSButton?
    public var buttonIcon: EDTSButtonIcon?

    // MARK: - Private Variable
    private let defaultIconSize: CGFloat = 16
    private let defaultSpacing: CGFloat = 8
    private let defaultCornerRadius: CGFloat = 8
    private let defaultBorderWidth: CGFloat = 0
    private let defaultShadowOpacity: Float = 1.0
    private let defaultShadowRadius: CGFloat = 4
    private let defaultShadowOffset: CGSize = CGSize(width: 0, height: 2)
    private let defaultPadding: CGFloat = 16
    private let defaultValue: CGFloat = -1.0
    private let defaultFontSize: CGFloat = 12
    private let defaultShadowColorOpacity: Double = 0.18

    private var hasCustomFont: Bool {
        !fontName.isEmpty || fontSize != defaultValue || (fontWeight?.isEmpty == false)
    }

    private var resolvedFont: Font {
        if let fontStyle { return fontStyle }
        guard hasCustomFont else {
            return EDTSColor.theme == .poinku ? EDTSFont.Poinku.B3.Light.font : EDTSFont.Klik.B3.Regular.font
        }
        let weight = setupFontWeight(from: fontWeight ?? "")
        if !fontName.isEmpty {
            return .custom(fontName, size: fontSize == defaultValue ? defaultFontSize : fontSize)
        }
        return .system(size: fontSize == defaultValue ? defaultFontSize : fontSize, weight: weight)
    }

    private struct ResolvedValues {
        var tempBgColor: Color?
        var tempLabelColor: Color?
        var tempIconTintColor: Color?
        var tempIconSize: CGFloat = .zero
        var tempSpacing: CGFloat = .zero
        var tempCornerRadius: CGFloat = .zero
        var tempBorderColor: Color?
        var tempBorderWidth: CGFloat = .zero
        var tempShadowOpacity: Float = .zero
        var tempShadowRadius: CGFloat = .zero
        var tempShadowOffset: CGSize = .zero
        var tempShadowColor: Color?
        var tempPaddingTop: CGFloat = .zero
        var tempPaddingBottom: CGFloat = .zero
        var tempPaddingLeading: CGFloat = .zero
        var tempPaddingTrailing: CGFloat = .zero
    }

    // MARK: - Initializer
    public init(
        toastState: EDTSToastState = .info,
        text: String? = nil,
        textAttributed: AttributedString? = nil,
        textColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = -1.0,
        fontWeight: String? = nil,
        bgColor: Color? = nil,
        icon: Image? = nil,
        iconTintColor: Color? = nil,
        iconSize: CGFloat = -1.0,
        spacing: CGFloat = -1.0,
        cornerRadius: CGFloat = -1.0,
        borderWidth: CGFloat = -1.0,
        borderColor: Color? = nil,
        shadowOpacity: Float = -1.0,
        shadowRadius: CGFloat = -1.0,
        shadowOffset: CGSize? = nil,
        shadowColor: Color? = nil,
        paddingTop: CGFloat = -1.0,
        paddingBottom: CGFloat = -1.0,
        paddingLeading: CGFloat = -1.0,
        paddingTrailing: CGFloat = -1.0,
        button: EDTSButton? = nil,
        buttonIcon: EDTSButtonIcon? = nil
    ) {
        self.toastState = toastState
        self.text = textAttributed == nil ? text : nil
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.bgColor = bgColor
        self.icon = icon
        self.iconTintColor = iconTintColor
        self.iconSize = iconSize
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.button = button
        self.buttonIcon = buttonIcon
    }

    // MARK: - Body
    public var body: some View {
        let values = setupToastState()

        HStack(alignment: .center, spacing: values.tempSpacing) {
            if let icon {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: values.tempIconSize, height: values.tempIconSize)
                    .foregroundColor(values.tempIconTintColor)
            }

            Group {
                if let textAttributed {
                    Text(textAttributed)
                } else {
                    Text(text ?? "")
                }
            }
            .font(resolvedFont)
            .foregroundColor(values.tempLabelColor)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)

            if let button {
                button
            }

            if let buttonIcon {
                buttonIcon
            }
        }
        .padding(.top, values.tempPaddingTop)
        .padding(.bottom, values.tempPaddingBottom)
        .padding(.leading, values.tempPaddingLeading)
        .padding(.trailing, values.tempPaddingTrailing)
        .background(values.tempBgColor)
        .clipShape(RoundedRectangle(cornerRadius: values.tempCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: values.tempCornerRadius)
                .stroke(values.tempBorderColor ?? .clear, lineWidth: values.tempBorderWidth)
        )
        .shadow(
            color: (values.tempShadowColor ?? .clear).opacity(Double(values.tempShadowOpacity)),
            radius: values.tempShadowRadius,
            x: values.tempShadowOffset.width,
            y: values.tempShadowOffset.height
        )
    }

    // MARK: - Setup & Styling
    private func setupToastState() -> ResolvedValues {
        var values = ResolvedValues()

        switch toastState {
        case .info:
            values.tempBgColor = bgColor ?? (EDTSColor.theme == .poinku ? EDTSColor.grey70 : EDTSColor.grey60)
        case .danger:
            values.tempBgColor = bgColor ?? EDTSColor.errorStrong
        }

        values.tempLabelColor = textColor ?? EDTSColor.white
        values.tempIconTintColor = iconTintColor ?? EDTSColor.white
        values.tempBorderColor = borderColor ?? .clear
        values.tempShadowColor = shadowColor ?? EDTSColor.grey50.opacity(defaultShadowColorOpacity)

        values.tempIconSize = iconSize == defaultValue ? defaultIconSize : iconSize
        values.tempSpacing = spacing == defaultValue ? defaultSpacing : spacing
        values.tempCornerRadius = cornerRadius == defaultValue ? defaultCornerRadius : cornerRadius
        values.tempBorderWidth = borderWidth == defaultValue ? defaultBorderWidth : borderWidth
        values.tempShadowOpacity = shadowOpacity == Float(defaultValue) ? defaultShadowOpacity : shadowOpacity
        values.tempShadowRadius = shadowRadius == defaultValue ? defaultShadowRadius : shadowRadius
        values.tempShadowOffset = shadowOffset ?? defaultShadowOffset
        values.tempPaddingTop = paddingTop == defaultValue ? defaultPadding : paddingTop
        values.tempPaddingBottom = paddingBottom == defaultValue ? defaultPadding : paddingBottom
        values.tempPaddingLeading = paddingLeading == defaultValue ? defaultPadding : paddingLeading
        values.tempPaddingTrailing = paddingTrailing == defaultValue ? defaultPadding : paddingTrailing

        return values
    }
}

// MARK: - Preview
#Preview("Preview") {
    VStack(spacing: 16) {
        EDTSToast(
            toastState: .info,
            text: "This is an info toast message",
            icon: Image(systemName: "info.circle.fill")
        )

        EDTSToast(
            toastState: .danger,
            text: "Something went wrong",
            icon: Image(systemName: "exclamationmark.triangle.fill"),
            button: EDTSButton(
                btnType: .primary,
                btnSize: .small,
                btnState: .default,
                text: "Retry",
                textColor: EDTSColor.white,
                fontSize: 12,
                fontWeight: "semibold",
                bgColor: .clear,
                rippleColor: .clear,
                paddingTop: 0,
                paddingBottom: 0,
                paddingLeading: 0,
                paddingTrailing: 0
            ) {}
        )

        EDTSToast(
            toastState: .info,
            text: "Item added to cart",
            icon: Image(systemName: "checkmark.circle.fill"),
            buttonIcon: EDTSButtonIcon(
                btnType: .primary,
                btnSize: .small,
                btnState: .default,
                icon: Image(systemName: "xmark"),
                iconTintColor: EDTSColor.white,
                bgColor: .clear,
                rippleColor: .clear,
                paddingTop: 0,
                paddingBottom: 0,
                paddingLeading: 0,
                paddingTrailing: 0
            ) {}
        )
        
        EDTSToast(
            toastState: .info,
            text: "Item added to cart",
            icon: Image(systemName: "checkmark.circle.fill"),
            button: EDTSButton(
                btnType: .primary,
                btnSize: .small,
                btnState: .default,
                text: "Retry",
                textColor: EDTSColor.white,
                fontSize: 12,
                fontWeight: "semibold",
                bgColor: .clear,
                rippleColor: .clear,
                paddingTop: 0,
                paddingBottom: 0,
                paddingLeading: 0,
                paddingTrailing: 0
            ) {},
            buttonIcon: EDTSButtonIcon(
                btnType: .primary,
                btnSize: .small,
                btnState: .default,
                icon: Image(systemName: "xmark"),
                iconTintColor: EDTSColor.white,
                bgColor: .clear,
                rippleColor: .clear,
                paddingTop: 0,
                paddingBottom: 0,
                paddingLeading: 0,
                paddingTrailing: 0
            ) {}
        )
    }
    .padding()
}
