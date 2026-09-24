//
//  EDTSAlertbox.swift
//  EDTS_DS_SwiftUI
//
//  Converted from the UIKit EDTSAlertbox (EDTS_DS) to SwiftUI.
//

import SwiftUI

// MARK: - State

public enum EDTSAlertboxState {
    case `default`
    case success
    case error
    case warning
    case info
}

// MARK: - View

public struct EDTSAlertbox: View {

    // MARK: - Properties

    public var state: EDTSAlertboxState

    public let text: String?
    public let textAttributed: AttributedString?
    public var textColor: Color?

    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?

    public let icon: Image?
    public var iconTintColor: Color?
    public var iconSize: CGFloat

    public var btnCloseTintColor: Color?
    public var btnCloseSize: CGFloat

    public var btnText: String?

    public var bgColor: Color?
    public var borderWidth: CGFloat
    public var borderColor: Color?
    public var cornerRadius: CGFloat

    public var paddingTop: CGFloat?
    public var paddingBottom: CGFloat?
    public var paddingLeading: CGFloat?
    public var paddingTrailing: CGFloat?

    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var shadowColor: Color?

    public var isBtnCloseHide: Bool
    public var isBtnHide: Bool
    public var isRibbonStyle: Bool

    public var onClose: (() -> Void)?
    public var onButtonTap: (() -> Void)?

    private let contentSpacing: CGFloat = 8
    private let poinkuPadding: CGFloat = 8
    private let klikIDMPadding: CGFloat = 12

    private let closeAnimationDuration: Double = 0.3
    private let closeOffsetY: CGFloat = -8
    private let closeRippleOpacity: Double = 0.12
    
    @State private var isVisible: Bool = true
    @State private var opacity: Double = 1
    @State private var offsetY: CGFloat = 0

    private static var isPoinkuTheme: Bool {
        EDTSColor.theme == .poinku
    }

    // MARK: - Init

    public init(
        state: EDTSAlertboxState = .default,
        text: String? = nil,
        textAttributed: AttributedString? = nil,
        textColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        icon: Image? = nil,
        iconTintColor: Color? = nil,
        iconSize: CGFloat = 16.0,
        btnCloseTintColor: Color? = nil,
        btnCloseSize: CGFloat = 16.0,
        btnText: String? = nil,
        bgColor: Color? = nil,
        borderWidth: CGFloat = 1.0,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8.0,
        paddingTop: CGFloat? = nil,
        paddingBottom: CGFloat? = nil,
        paddingLeading: CGFloat? = nil,
        paddingTrailing: CGFloat? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: CGFloat = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        isBtnCloseHide: Bool = false,
        isBtnHide: Bool? = nil,
        isRibbonStyle: Bool = false,
        onClose: (() -> Void)? = nil,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.state = state
        self.text = textAttributed == nil ? text : nil
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.icon = icon
        self.iconTintColor = iconTintColor
        self.iconSize = iconSize
        self.btnCloseTintColor = btnCloseTintColor
        self.btnCloseSize = btnCloseSize
        self.btnText = btnText
        self.bgColor = bgColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.isBtnCloseHide = isBtnCloseHide
        self.isBtnHide = isRibbonStyle ? true : (isBtnHide ?? EDTSAlertbox.isPoinkuTheme)
        self.isRibbonStyle = isRibbonStyle
        self.onClose = onClose
        self.onButtonTap = onButtonTap
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if isVisible {
                if isRibbonStyle {
                    ribbonBody
                } else {
                    defaultBody
                }
            }
        }
        .opacity(opacity)
        .offset(y: offsetY)
    }

    // MARK: - Setup Values

    private struct SetupValues {
        var textColor: Color = EDTSColor.grey60
        var iconName: String = "ic_information"
        var iconColor: Color = EDTSColor.grey50
        var background: Color = EDTSColor.grey10
        var border: Color = EDTSColor.grey30
        var padTop: CGFloat = 12
        var padBottom: CGFloat = 12
        var padLeading: CGFloat = 12
        var padTrailing: CGFloat = 12
    }

    private var setup: SetupValues {
        var values = SetupValues()
        let isPoinku = EDTSAlertbox.isPoinkuTheme

        if isPoinku {
            values.textColor = themed(
                default: EDTSColor.grey50,
                info: EDTSColor.primaryStrong,
                success: EDTSColor.successStrong,
                error: EDTSColor.errorStrong,
                warning: EDTSColor.warningStrong
            )
        } else {
            values.textColor = EDTSColor.grey60
        }

        if isPoinku {
            values.iconName = themed(
                default: "ic_information",
                info: "ic_information",
                success: "ic_success",
                error: "ic_attention",
                warning: "ic_warning"
            )
        } else {
            values.iconName = themed(
                default: "ic_information",
                info: "ic_information",
                success: "ic_success",
                error: "ic_error",
                warning: "ic_attention"
            )
        }

        values.iconColor = themed(
            default: EDTSColor.grey50,
            info: isPoinku ? EDTSColor.primaryStrong : EDTSColor.blue50,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )

        values.background = themed(
            default: EDTSColor.grey10,
            info: EDTSColor.primaryWeak,
            success: EDTSColor.successWeak,
            error: EDTSColor.errorWeak,
            warning: EDTSColor.warningWeak
        )

        values.border = themed(
            default: EDTSColor.grey30,
            info: EDTSColor.primaryStrong,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )

        let hasCustomPadding = paddingTop == nil && paddingBottom == nil
            && paddingLeading == nil && paddingTrailing == nil

        if hasCustomPadding {
            let pad: CGFloat = isPoinku
                ? poinkuPadding
                : klikIDMPadding
            values.padTop = pad
            values.padBottom = pad
            values.padLeading = pad
            values.padTrailing = pad
        } else {
            values.padTop = paddingTop ?? klikIDMPadding
            values.padBottom = paddingBottom ?? klikIDMPadding
            values.padLeading = paddingLeading ?? klikIDMPadding
            values.padTrailing = paddingTrailing ?? klikIDMPadding
        }
        
        if isRibbonStyle {
            values.padTop = paddingTop ?? poinkuPadding
            values.padBottom = paddingBottom ?? poinkuPadding
            values.padLeading = paddingLeading ?? poinkuPadding
            values.padTrailing = paddingTrailing ?? poinkuPadding
        }

        return values
    }

    private var setupFont: Font {
        if let fontStyle { return fontStyle }
        if fontSize > 0 {
            let weight = setupFontWeight(from: fontWeight ?? "regular")
            return fontName.isEmpty
                ? .system(size: fontSize, weight: weight)
                : .custom(fontName, size: fontSize)
        }
        return EDTSAlertbox.isPoinkuTheme
            ? EDTSFont.Poinku.B3.Light.font
            : EDTSFont.Klik.P2.Regular.font
    }

    @ViewBuilder
    private var defaultBody: some View {
        let values = setup

        VStack(alignment: .leading, spacing: contentSpacing) {
            HStack(alignment: .top, spacing: contentSpacing) {
                iconView(name: values.iconName, color: iconTintColor ?? values.iconColor)

                textView(color: textColor ?? values.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !isBtnCloseHide {
                    closeButton
                }
            }

            if !isBtnHide {
                EDTSButton(
                    btnType: .primary,
                    btnSize: .large,
                    text: btnText ?? "Button"
                ) {
                    onButtonTap?()
                }
            }
        }
        .padding(.top, values.padTop)
        .padding(.bottom, values.padBottom)
        .padding(.leading, values.padLeading)
        .padding(.trailing, values.padTrailing)
        .background(bgColor ?? values.background)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor ?? values.border, lineWidth: borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(
            color: (shadowColor ?? .black).opacity(shadowOpacity),
            radius: shadowRadius,
            x: shadowOffset.width,
            y: shadowOffset.height
        )
    }

    @ViewBuilder
    private var ribbonBody: some View {
        let values = setup
        let ribbonBg = themed(
            default: EDTSColor.grey50,
            info: EDTSColor.primaryStrong,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )

        HStack(alignment: .top, spacing: contentSpacing) {
            iconView(name: values.iconName, color: .white)

            textView(color: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, values.padTop)
        .padding(.leading, values.padBottom)
        .padding(.bottom, values.padLeading)
        .padding(.trailing, values.padTrailing)
        .background(bgColor ?? ribbonBg)
    }

    // MARK: - Subviews

    @ViewBuilder
    private func iconView(name: String, color: Color) -> some View {
        (icon ?? Image(name))
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(color)
    }

    @ViewBuilder
    private func textView(color: Color) -> some View {
        Group {
            if let textAttributed {
                Text(textAttributed)
            } else {
                Text(text ?? "")
            }
        }
        .font(setupFont)
        .foregroundColor(color)
        .multilineTextAlignment(.leading)
    }

    private var closeButton: some View {
        Image("ic_close")
            .resizable()
            .scaledToFit()
            .frame(width: btnCloseSize, height: btnCloseSize)
            .foregroundColor(btnCloseTintColor ?? EDTSColor.grey50)
            .rippleEffect(
                color: EDTSColor.grey70.opacity(closeRippleOpacity),
                cornerRadius: btnCloseSize / 2,
                onTap: {
                    handleCloseTap()
                }
            )
    }

    // MARK: - State

    private func themed<T>(default def: T, info: T, success: T, error: T, warning: T) -> T {
        switch state {
        case .default: return def
        case .info: return info
        case .success: return success
        case .error: return error
        case .warning: return warning
        }
    }

    // MARK: - Actions

    private func handleCloseTap() {
        onClose?()

        withAnimation(.easeInOut(duration: closeAnimationDuration)) {
            opacity = 0
            offsetY = closeOffsetY
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + closeAnimationDuration) {
            isVisible = false
        }
    }
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewWrapper: View {
        private let lineText = "This is an example of long text, please make sure that it'll be shown in two lines."

        var body: some View {
            ScrollView {
                VStack(spacing: 12) {
                    EDTSAlertbox(text: lineText)
                    EDTSAlertbox(state: .info, text: lineText)
                    EDTSAlertbox(state: .success, text: lineText, isBtnHide: true)
                    EDTSAlertbox(state: .error, text: lineText, btnText: "Retry")
                    EDTSAlertbox(state: .warning, text: lineText)
                    EDTSAlertbox(state: .error, text: "Ribbon style alert", isRibbonStyle: true)
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
