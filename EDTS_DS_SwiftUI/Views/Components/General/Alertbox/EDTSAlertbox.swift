//
//  EDTSAlertbox.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
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
    public var fontSize: Double
    public var fontWeight: String?

    public let icon: Image?
    public var iconTintColor: Color?
    public var iconSize: Double

    public var btnCloseTintColor: Color?
    public var btnCloseSize: Double

    public var buttonText: String?
    public var button: EDTSButton?

    public var bgColor: Color?
    public var borderWidth: Double
    public var borderColor: Color?
    public var cornerRadius: Double

    public var paddingTop: Double?
    public var paddingBottom: Double?
    public var paddingLeading: Double?
    public var paddingTrailing: Double?

    public var shadowOpacity: Double
    public var shadowRadius: Double
    public var shadowOffset: CGSize
    public var shadowColor: Color?

    public var isBtnCloseHide: Bool
    public var isBtnHide: Bool
    public var isBtnAtRightSide: Bool
    public var isRibbonStyle: Bool

    public var onClose: (() -> Void)?
    public var onButtonTap: (() -> Void)?

    private let contentSpacing: Double = 8
    private static let poinkuPaddingValue: Double = 8
    private static let klikIDMPaddingValue: Double = 12
    private let poinkuPadding: Double = EDTSAlertbox.poinkuPaddingValue
    private let klikIDMPadding: Double = EDTSAlertbox.klikIDMPaddingValue

    public static var defaultPadding: Double {
        isPoinkuTheme ? poinkuPaddingValue : klikIDMPaddingValue
    }

    private let rightButtonLeadingGap: Double = 4
    private let rightButtonIconSpacing: Double = 4
    private let rightButtonChevronSize: Double = 16

    private let closeAnimationDuration: Double = 0.3
    private let closeOffsetY: Double = -8
    private let closeRippleOpacity: Double = 0.12
    
    @State private var isVisible: Bool = true
    @State private var opacity: Double = 1
    @State private var offsetY: Double = 0

    private static var isPoinkuTheme: Bool {
        EDTSColor.theme == .poinku
    }
    
    private var hasCustomFont: Bool {
        !fontName.isEmpty || fontSize > 0 || !(fontWeight ?? "").isEmpty
    }

    private var setupFont: Font {
        if let fontStyle { return fontStyle }

        guard hasCustomFont else {
            return EDTSAlertbox.isPoinkuTheme
                ? EDTSFont.Poinku.B3.Light.font
                : EDTSFont.Klik.P2.Regular.font
        }

        let size = fontSize > 0 ? fontSize : 12

        if !fontName.isEmpty {
            return .custom(fontName, size: size)
        }

        return .system(size: size, weight: setupFontWeight(from: fontWeight ?? "regular"))
    }

    private var isRightLayout: Bool {
        isBtnAtRightSide && !isBtnHide && !isRibbonStyle
    }

    // MARK: - Init

    public init(
        state: EDTSAlertboxState = .default,
        text: String? = nil,
        textAttributed: AttributedString? = nil,
        textColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: Double = .zero,
        fontWeight: String? = nil,
        icon: Image? = nil,
        iconTintColor: Color? = nil,
        iconSize: Double = 16.0,
        btnCloseTintColor: Color? = nil,
        btnCloseSize: Double = 16.0,
        buttonText: String? = nil,
        button: EDTSButton? = nil,
        bgColor: Color? = nil,
        borderWidth: Double = 1.0,
        borderColor: Color? = nil,
        cornerRadius: Double = 8.0,
        paddingTop: Double? = nil,
        paddingBottom: Double? = nil,
        paddingLeading: Double? = nil,
        paddingTrailing: Double? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: Double = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        isBtnCloseHide: Bool = false,
        isBtnHide: Bool? = nil,
        isBtnAtRightSide: Bool = false,
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
        self.buttonText = buttonText
        self.button = button
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
        self.isBtnHide = isRibbonStyle
            ? true
            : (isBtnHide ?? (EDTSAlertbox.isPoinkuTheme && button == nil))
        self.isBtnAtRightSide = isBtnAtRightSide
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
                } else if isRightLayout {
                    rightSideBody
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
        var padTop: Double = 12
        var padBottom: Double = 12
        var padLeading: Double = 12
        var padTrailing: Double = 12
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
            let pad: Double = isPoinku
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

        if isRightLayout {
            values.padBottom = paddingBottom ?? values.padTop
        }
        
        if isRibbonStyle {
            values.padTop = paddingTop ?? poinkuPadding
            values.padBottom = paddingBottom ?? poinkuPadding
            values.padLeading = paddingLeading ?? poinkuPadding
            values.padTrailing = paddingTrailing ?? poinkuPadding
        }

        return values
    }

    // MARK: - Bodies

    @ViewBuilder
    private var defaultBody: some View {
        let values = setup

        decorated(values: values) {
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
                    if let button {
                        button
                    } else {
                        EDTSButton(
                            btnType: .primary,
                            btnSize: .large,
                            text: buttonText ?? "Button",
                            maxWidth: .infinity
                        ) { onButtonTap?() }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var rightSideBody: some View {
        let values = setup
        let resolvedIconColor = iconTintColor ?? values.iconColor

        decorated(values: values) {
            HStack(alignment: .center, spacing: contentSpacing) {
                iconView(name: values.iconName, color: resolvedIconColor)

                textView(color: textColor ?? values.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                rightSideButton(color: rightButtonColor(iconColor: resolvedIconColor))
                    .padding(.leading, rightButtonLeadingGap)
            }
        }
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
        .padding(.leading, values.padLeading)
        .padding(.bottom, values.padBottom)
        .padding(.trailing, values.padTrailing)
        .background(bgColor ?? ribbonBg)
    }

    // MARK: - Shared Decoration

    private func decorated<Content: View>(
        values: SetupValues,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
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

    // MARK: - Subviews

    @ViewBuilder
    private func iconView(name: String, color: Color) -> some View {
        (icon ?? Image(name, bundle: .edtsDS))
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

    @ViewBuilder
    private func rightSideButton(color: Color) -> some View {
        if let button {
            button
                .fixedSize(horizontal: true, vertical: false)
        } else {
            Button {
                onButtonTap?()
            } label: {
                HStack(spacing: rightButtonIconSpacing) {
                    Text(buttonText ?? "Button")
                        .font(setupFont.weight(.semibold))
                        .lineLimit(1)

                    Image("ic_chevron_right", bundle: .edtsDS)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: rightButtonChevronSize, height: rightButtonChevronSize)
                }
                .foregroundColor(color)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    private func rightButtonColor(iconColor: Color) -> Color {
        state == .default ? EDTSColor.blue50 : iconColor
    }

    private var closeButton: some View {
        Image("ic_close", bundle: .edtsDS)
            .renderingMode(.template)
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
                    EDTSAlertbox(state: .error, text: lineText, buttonText: "Retry")
                    EDTSAlertbox(state: .warning, text: lineText)
                    EDTSAlertbox(state: .error, text: "Ribbon style alert", isRibbonStyle: true)

                    // Button at right side
                    EDTSAlertbox(text: lineText, buttonText: "Detail", isBtnAtRightSide: true)
                    EDTSAlertbox(state: .info, text: lineText, buttonText: "Detail", isBtnAtRightSide: true)
                    EDTSAlertbox(state: .success, text: lineText, buttonText: "Lihat", isBtnAtRightSide: true)
                    EDTSAlertbox(state: .error, text: "Short text", buttonText: "Retry", isBtnAtRightSide: true)
                    EDTSAlertbox(state: .warning, text: lineText, buttonText: "Detail", isBtnAtRightSide: true)
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
