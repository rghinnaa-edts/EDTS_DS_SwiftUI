//
//  EDTSDialog.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 28/09/26.
//

import SwiftUI

// MARK: - View

public struct EDTSDialog: View {

    // MARK: - Properties

    public var title: String?
    public var titleAttributed: AttributedString?
    public var titleColor: Color?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: Double
    public var titleFontWeight: String?
    public var titleAlignment: TextAlignment?

    public var desc: String?
    public var descAttributed: AttributedString?
    public var descColor: Color?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: Double
    public var descFontWeight: String?
    public var descAlignment: TextAlignment?

    public var support: String?
    public var supportAttributed: AttributedString?
    public var supportColor: Color?
    public var supportFontStyle: Font?
    public var supportFontName: String
    public var supportFontSize: Double
    public var supportFontWeight: String?
    public var supportAlignment: TextAlignment?

    public var image: Image?
    public var imageSize: Double?

    public var btnCloseSize: Double
    public var btnCloseTintColor: Color?

    public var btnOrientation: Orientation
    public var btnPrimaryText: String?
    public var btnPrimaryState: BtnState
    public var btnSecondaryText: String?
    public var btnSecondaryState: BtnState

    public var bgColor: Color?
    public var cornerRadius: Double
    public var shadowColor: Color?
    public var shadowOpacity: Double
    public var shadowRadius: Double
    public var shadowOffset: CGSize

    public var isHasBtnClose: Bool?
    public var isHasBtnPrimary: Bool
    public var isHasBtnSecondary: Bool
    public var isBtnPositionAtTopLabel: Bool?
    public var isDialogImage: Bool
    public var isDismissOnTapOutside: Bool

    public var onClose: (() -> Void)?
    public var onPrimaryTap: (() -> Void)?
    public var onSecondaryTap: (() -> Void)?

    // MARK: - Setup Values
    
    private var contentPadding: Double = 16
    private var closeInset: Double = 16
    private var closeHitAreaMultiplier: Double = 2
    private var defaultImageSize: Double = 256
    private var imageToContentSpacing: Double = 16
    private var buttonsToTextSpacing: Double = 16
    private var buttonsAboveTextSpacing: Double = 24
    private var textToButtonsSpacing: Double = 36
    private var textWithSupportToButtonsSpacing: Double = 32
    private var titleToDescSpacing: Double = 16
    private var descToSupportSpacing: Double = 4
    private var buttonSpacing: Double = 8
    private var closeRippleOpacity: Double = 0.4
    
    @State private var isCloseRippling = false
    
    var internalDismiss: (() -> Void)?

    private var setupHasClose: Bool {
        isHasBtnClose ?? !isDialogImage
    }

    private var setupBtnAtTop: Bool {
        isBtnPositionAtTopLabel ?? isDialogImage
    }

    private var setupHasImage: Bool {
        image != nil || isDialogImage
    }

    private var setupImageSize: Double {
        if let imageSize, imageSize > 0 { return imageSize }
        return defaultImageSize
    }

    private var closeHitSize: Double {
        btnCloseSize * closeHitAreaMultiplier
    }

    private var closeOuterPadding: Double {
        closeInset - (closeHitSize - btnCloseSize) / 2
    }

    private var hasTitle: Bool {
        title != nil || titleAttributed != nil
    }

    private var hasDesc: Bool {
        desc != nil || descAttributed != nil
    }

    private var hasSupport: Bool {
        support != nil || supportAttributed != nil
    }

    private var setupShowPrimary: Bool {
        isHasBtnPrimary
    }

    private var setupShowSecondary: Bool {
        isHasBtnSecondary
    }

    private var setupIsHorizontal: Bool {
        btnOrientation == .horizontal
    }

    private var setupTitleAlignment: TextAlignment {
        titleAlignment ?? (isDialogImage ? .center : .leading)
    }

    private var setupDescAlignment: TextAlignment {
        descAlignment ?? (isDialogImage ? .center : .leading)
    }

    private var setupSupportAlignment: TextAlignment {
        supportAlignment ?? (isDialogImage ? .center : .leading)
    }

    private var setupTitleStyle: EDTSFont.FontStyle {
        isDialogImage ? EDTSFont.Klik.D4 : EDTSFont.Klik.H1
    }

    private var setupDescStyle: EDTSFont.FontStyle {
        EDTSFont.Klik.P1.Regular
    }

    private var setupSupportStyle: EDTSFont.FontStyle {
        EDTSFont.Klik.P2.Regular
    }

    private func resolvedFont(style: Font?, name: String, size: Double, weight: String?, token: EDTSFont.FontStyle) -> Font {
        if let style { return style }

        if name.isEmpty && size <= 0 && weight == nil {
            return token.font
        }

        let resolvedSize = size > 0 ? size : UIFont.systemFontSize
        var font: Font = name.isEmpty ? .system(size: resolvedSize) : .custom(name, size: resolvedSize)
        if let weight {
            font = font.weight(setupFontWeight(from: weight))
        }
        return font
    }
    
    // MARK: - Init

    public init(
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: Double = .zero,
        titleFontWeight: String? = nil,
        titleAlignment: TextAlignment? = nil,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: Double = .zero,
        descFontWeight: String? = nil,
        descAlignment: TextAlignment? = nil,
        support: String? = nil,
        supportAttributed: AttributedString? = nil,
        supportColor: Color? = nil,
        supportFontStyle: Font? = nil,
        supportFontName: String = "",
        supportFontSize: Double = .zero,
        supportFontWeight: String? = nil,
        supportAlignment: TextAlignment? = nil,
        image: Image? = nil,
        imageSize: Double? = nil,
        btnCloseSize: Double = 16,
        btnCloseTintColor: Color? = nil,
        btnOrientation: Orientation = .vertical,
        btnPrimaryText: String? = nil,
        btnPrimaryState: BtnState = .default,
        btnSecondaryText: String? = nil,
        btnSecondaryState: BtnState = .default,
        bgColor: Color? = nil,
        cornerRadius: Double = 12,
        shadowColor: Color? = nil,
        shadowOpacity: Double = 0.15,
        shadowRadius: Double = 12,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        isHasBtnClose: Bool? = nil,
        isHasBtnPrimary: Bool = true,
        isHasBtnSecondary: Bool = true,
        isBtnPositionAtTopLabel: Bool? = nil,
        isDialogImage: Bool = false,
        isDismissOnTapOutside: Bool = false,
        onClose: (() -> Void)? = nil,
        onPrimaryTap: (() -> Void)? = nil,
        onSecondaryTap: (() -> Void)? = nil
    ) {
        self.title = titleAttributed == nil ? title : nil
        self.titleAttributed = titleAttributed
        self.titleColor = titleColor
        self.titleFontStyle = titleFontStyle
        self.titleFontName = titleFontName
        self.titleFontSize = titleFontSize
        self.titleFontWeight = titleFontWeight
        self.titleAlignment = titleAlignment
        self.desc = descAttributed == nil ? desc : nil
        self.descAttributed = descAttributed
        self.descColor = descColor
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.descFontWeight = descFontWeight
        self.descAlignment = descAlignment
        self.support = supportAttributed == nil ? support : nil
        self.supportAttributed = supportAttributed
        self.supportColor = supportColor
        self.supportFontStyle = supportFontStyle
        self.supportFontName = supportFontName
        self.supportFontSize = supportFontSize
        self.supportFontWeight = supportFontWeight
        self.supportAlignment = supportAlignment
        self.image = image
        self.imageSize = imageSize
        self.btnCloseSize = btnCloseSize
        self.btnCloseTintColor = btnCloseTintColor
        self.btnOrientation = btnOrientation
        self.btnPrimaryText = btnPrimaryText
        self.btnPrimaryState = btnPrimaryState
        self.btnSecondaryText = btnSecondaryText
        self.btnSecondaryState = btnSecondaryState
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.isHasBtnClose = isHasBtnClose
        self.isHasBtnPrimary = isHasBtnPrimary
        self.isHasBtnSecondary = isHasBtnSecondary
        self.isBtnPositionAtTopLabel = isBtnPositionAtTopLabel
        self.isDialogImage = isDialogImage
        self.isDismissOnTapOutside = isDismissOnTapOutside
        self.onClose = onClose
        self.onPrimaryTap = onPrimaryTap
        self.onSecondaryTap = onSecondaryTap
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            contentView

            if setupHasClose {
                closeButton
                    .padding(.top, closeOuterPadding)
                    .padding(.trailing, closeOuterPadding)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(bgColor ?? EDTSColor.white)
                .shadow(
                    color: (shadowColor ?? .black).opacity(shadowOpacity),
                    radius: shadowRadius,
                    x: shadowOffset.width,
                    y: shadowOffset.height
                )
        )
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: contentPadding)

            if setupHasImage {
                imageView
            }

            if setupBtnAtTop {
                Color.clear.frame(height: buttonsToTextSpacing)
                buttonsView
                Color.clear.frame(height: buttonsAboveTextSpacing)
                textBlock
            } else {
                Color.clear.frame(height: setupHasImage ? imageToContentSpacing : .zero)
                textBlock
                Color.clear.frame(
                    height: hasSupport
                        ? textWithSupportToButtonsSpacing
                        : textToButtonsSpacing
                )
                buttonsView
            }

            Color.clear.frame(height: contentPadding)
        }
        .padding(.horizontal, contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Subviews

    private var imageView: some View {
        (image ?? Image("ic_placeholder"))
            .resizable()
            .scaledToFit()
            .frame(width: setupImageSize, height: setupImageSize)
            .frame(maxWidth: .infinity)
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            if hasTitle {
                label(
                    text: title,
                    attributed: titleAttributed,
                    font: resolvedFont(style: titleFontStyle, name: titleFontName, size: titleFontSize, weight: titleFontWeight, token: setupTitleStyle),
                    color: titleColor ?? EDTSColor.grey70,
                    alignment: setupTitleAlignment
                )
                .padding(.trailing, setupHasClose ? btnCloseSize : .zero)
            }

            if hasDesc {
                label(
                    text: desc,
                    attributed: descAttributed,
                    font: resolvedFont(style: descFontStyle, name: descFontName, size: descFontSize, weight: descFontWeight, token: setupDescStyle),
                    color: descColor ?? EDTSColor.grey50,
                    alignment: setupDescAlignment
                )
                .padding(.top, hasTitle ? titleToDescSpacing : .zero)
            }

            if hasSupport {
                label(
                    text: support,
                    attributed: supportAttributed,
                    font: resolvedFont(style: supportFontStyle, name: supportFontName, size: supportFontSize, weight: supportFontWeight, token: setupSupportStyle),
                    color: supportColor ?? EDTSColor.grey40,
                    alignment: setupSupportAlignment
                )
                .padding(.top, (hasTitle || hasDesc) ? descToSupportSpacing : .zero)
            }
        }
    }

    @ViewBuilder
    private func label(
        text: String?,
        attributed: AttributedString?,
        font: Font,
        color: Color,
        alignment: TextAlignment
    ) -> some View {
        Group {
            if let attributed {
                Text(attributed)
            } else {
                Text(text ?? "")
            }
        }
        .font(font)
        .foregroundColor(color)
        .multilineTextAlignment(alignment)
        .frame(maxWidth: .infinity, alignment: frameAlignment(for: alignment))
    }

    private func frameAlignment(for alignment: TextAlignment) -> Alignment {
        switch alignment {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    @ViewBuilder
    private var buttonsView: some View {
        if setupShowPrimary || setupShowSecondary {
            if setupIsHorizontal {
                HStack(spacing: buttonSpacing) {
                    if setupShowSecondary { secondaryButton }
                    if setupShowPrimary { primaryButton }
                }
            } else {
                VStack(spacing: buttonSpacing) {
                    if setupShowPrimary { primaryButton }
                    if setupShowSecondary { secondaryButton }
                }
            }
        }
    }

    private var primaryButton: some View {
        EDTSButton(
            btnType: .primary,
            btnSize: .large,
            btnState: btnPrimaryState,
            text: btnPrimaryText ?? "Button"
        ) {
            onPrimaryTap?()
        }
    }

    private var secondaryButton: some View {
        EDTSButton(
            btnType: .secondary,
            btnSize: .large,
            btnState: btnSecondaryState,
            text: btnSecondaryText ?? "Button"
        ) {
            onSecondaryTap?()
        }
    }

    private var closeButton: some View {
        Button(action: handleClose) {
            Image("ic_close")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: btnCloseSize, height: btnCloseSize)
                .foregroundColor(btnCloseTintColor ?? EDTSColor.grey50)
                .circularRippleEffect(size: closeHitSize, color: EDTSColor.grey30.opacity(closeRippleOpacity), trigger: $isCloseRippling)
                .frame(width: closeHitSize, height: closeHitSize)
                .contentShape(Rectangle())
        }
        .buttonStyle(EDTSCloseButtonStyle(isPressed: $isCloseRippling))
        .accessibilityLabel("Close")
    }

    private func handleClose() {
        onClose?()
        internalDismiss?()
    }
}

// MARK: - Presentation Modifier

private struct EDTSDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let dialog: () -> EDTSDialog

    var dimOpacity: Double = 0.5
    var presentDuration: Double = 0.25
    var dismissDuration: Double = 0.2
    var dismissDelay: Double = 0.25
    var presentScale: Double = 0.8
    var dialogHorizontalMargin: Double = 24

    private func makeDialog() -> EDTSDialog {
        var d = dialog()
        d.internalDismiss = { isPresented = false }
        return d
    }

    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if isPresented {
                    let presented = makeDialog()

                    Color.black.opacity(dimOpacity)
                        .ignoresSafeArea()
                        .onTapGesture {
                            guard presented.isDismissOnTapOutside else { return }
                            presented.onClose?()
                            isPresented = false
                        }
                        .zIndex(0)
                        .transition(.opacity)

                    presented
                        .padding(.horizontal, dialogHorizontalMargin)
                        .zIndex(1)
                        .transition(.scale(scale: presentScale).combined(with: .opacity))
                }
            }
            .animation(
                isPresented
                    ? .easeOut(duration: presentDuration)
                    : .easeIn(duration: dismissDuration).delay(dismissDelay),
                value: isPresented
            )
        )
    }
}

private struct EDTSCloseButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(EDTSOnChangeModifier(value: configuration.isPressed) { newValue in
                isPressed = newValue
            })
    }
}

private struct EDTSOnChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (Value) -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: value) { _, newValue in
                action(newValue)
            }
        } else {
            content.onChange(of: value) { newValue in
                action(newValue)
            }
        }
    }
}

public extension View {
    func edtsDialog(
        isPresented: Binding<Bool>,
        dialog: @escaping () -> EDTSDialog
    ) -> some View {
        modifier(EDTSDialogModifier(isPresented: isPresented, dialog: dialog))
    }
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var showBasic = false
        @State private var showHorizontal = false
        @State private var showImage = false

        var body: some View {
            VStack(spacing: 16) {
                Button("Basic dialog") { showBasic = true }
                Button("Horizontal buttons") { showHorizontal = true }
                Button("Image dialog") { showImage = true }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsDialog(isPresented: $showBasic) {
                EDTSDialog(
                    title: "Basic dialog title",
                    desc: "A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made.",
                    onPrimaryTap: { showBasic = false },
                    onSecondaryTap: { showBasic = false }
                )
            }
            .edtsDialog(isPresented: $showHorizontal) {
                EDTSDialog(
                    title: "Delete this item?",
                    desc: "This action can't be undone.",
                    btnOrientation: .horizontal,
                    btnPrimaryText: "Delete",
                    btnPrimaryState: .danger,
                    btnSecondaryText: "Cancel",
                    onPrimaryTap: { showHorizontal = false },
                    onSecondaryTap: { showHorizontal = false }
                )
            }
            .edtsDialog(isPresented: $showImage) {
                EDTSDialog(
                    title: "Dialog with image",
                    desc: "Centered layout with the image on top and buttons above the text.",
                    support: "Supporting text sits below the description.",
                    isDialogImage: true,
                    onPrimaryTap: { showImage = false },
                    onSecondaryTap: { showImage = false }
                )
            }
        }
    }
    return PreviewWrapper()
}
