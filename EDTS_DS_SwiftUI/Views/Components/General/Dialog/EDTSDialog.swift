//
//  EDTSDialog.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 28/09/26.
//

import SwiftUI
import Combine

// MARK: - View

public struct EDTSDialog: View {

    // MARK: - Properties

    public var title: String?
    public var titleAttributed: NSAttributedString?
    public var titleColor: Color?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: Double
    public var titleFontWeight: String?
    public var titleAlignment: TextAlignment?

    public var desc: String?
    public var descAttributed: NSAttributedString?
    public var descColor: Color?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: Double
    public var descFontWeight: String?
    public var descAlignment: TextAlignment?

    public var support: String?
    public var supportAttributed: NSAttributedString?
    public var supportColor: Color?
    public var supportFontStyle: Font?
    public var supportFontName: String
    public var supportFontSize: Double
    public var supportFontWeight: String?
    public var supportAlignment: TextAlignment?

    public var image: Image?
    public var imageSize: Double?
    public var imageTintColor: Color?

    public var btnCloseSize: Double
    public var btnCloseTintColor: Color?

    public var btnOrientation: Orientation
    public var btnPrimary: EDTSButton?
    public var btnSecondary: EDTSButton?

    public var bgColor: Color?
    public var cornerRadius: Double
    public var shadowColor: Color?
    public var shadowOpacity: Double
    public var shadowRadius: Double
    public var shadowOffset: CGSize

    public var isHasBtnClose: Bool?
    public var isHasBtnPrimary: Bool
    public var isHasBtnSecondary: Bool
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
    private var imageToContentSpacing: Double = 8
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
        titleAttributed: NSAttributedString? = nil,
        titleColor: Color? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: Double = .zero,
        titleFontWeight: String? = nil,
        titleAlignment: TextAlignment? = nil,
        desc: String? = nil,
        descAttributed: NSAttributedString? = nil,
        descColor: Color? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: Double = .zero,
        descFontWeight: String? = nil,
        descAlignment: TextAlignment? = nil,
        support: String? = nil,
        supportAttributed: NSAttributedString? = nil,
        supportColor: Color? = nil,
        supportFontStyle: Font? = nil,
        supportFontName: String = "",
        supportFontSize: Double = .zero,
        supportFontWeight: String? = nil,
        supportAlignment: TextAlignment? = nil,
        image: Image? = nil,
        imageSize: Double? = nil,
        imageTintColor: Color? = nil,
        btnCloseSize: Double = 16,
        btnCloseTintColor: Color? = nil,
        btnOrientation: Orientation = .vertical,
        btnPrimary: EDTSButton? = nil,
        btnSecondary: EDTSButton? = nil,
        bgColor: Color? = nil,
        cornerRadius: Double = 12,
        shadowColor: Color? = nil,
        shadowOpacity: Double = 0.15,
        shadowRadius: Double = 12,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        isHasBtnClose: Bool? = nil,
        isHasBtnPrimary: Bool = true,
        isHasBtnSecondary: Bool = true,
        isDialogImage: Bool = false,
        isDismissOnTapOutside: Bool = false,
        onClose: (() -> Void)? = nil
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
        self.imageTintColor = imageTintColor
        self.btnCloseSize = btnCloseSize
        self.btnCloseTintColor = btnCloseTintColor
        self.btnOrientation = btnOrientation
        self.btnPrimary = btnPrimary
        self.btnSecondary = btnSecondary
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.isHasBtnClose = isHasBtnClose
        self.isHasBtnPrimary = isHasBtnPrimary
        self.isHasBtnSecondary = isHasBtnSecondary
        self.isDialogImage = isDialogImage
        self.isDismissOnTapOutside = isDismissOnTapOutside
        self.onClose = onClose
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            contentView

            if setupHasClose {
                closeButton
                    .padding(.top, CGFloat(closeOuterPadding))
                    .padding(.trailing, CGFloat(closeOuterPadding))
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                .fill(bgColor ?? EDTSColor.white)
                .shadow(
                    color: (shadowColor ?? .black).opacity(shadowOpacity),
                    radius: CGFloat(shadowRadius),
                    x: shadowOffset.width,
                    y: shadowOffset.height
                )
        )
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: CGFloat(contentPadding))

            if setupHasImage {
                imageView
            }
            
            Color.clear.frame(height: setupHasImage ? CGFloat(imageToContentSpacing) : .zero)

            if hasTitle {
                label(
                    text: title,
                    attributed: titleAttributed,
                    font: resolvedFont(style: titleFontStyle, name: titleFontName, size: titleFontSize, weight: titleFontWeight, token: setupTitleStyle),
                    color: titleColor ?? EDTSColor.grey70,
                    alignment: setupTitleAlignment
                )
                .padding(.trailing, setupHasClose ? CGFloat(btnCloseSize) : .zero)
            }
            
            scrollableTextBlock
            Color.clear.frame(
                height: hasSupport
                    ? CGFloat(textWithSupportToButtonsSpacing)
                    : CGFloat(textToButtonsSpacing)
            )
            buttonsView

            if isHasBtnPrimary || isHasBtnSecondary {
                Color.clear.frame(height: CGFloat(contentPadding))
            }
        }
        .padding(.horizontal, CGFloat(contentPadding))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var imageView: some View {
        let base = image ?? Image("ic_placeholder")

        Group {
            if let imageTintColor {
                base
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(imageTintColor)
            } else {
                base
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: CGFloat(setupImageSize), height: CGFloat(setupImageSize))
        .frame(maxWidth: .infinity)
    }

    private var scrollableTextBlock: some View {
        textBlock
            .hidden()
            .overlay(
                ScrollView(.vertical, showsIndicators: true) {
                    textBlock
                }
                .modifier(EDTSScrollBounceModifier())
            )
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            if hasDesc {
                label(
                    text: desc,
                    attributed: descAttributed,
                    font: resolvedFont(style: descFontStyle, name: descFontName, size: descFontSize, weight: descFontWeight, token: setupDescStyle),
                    color: descColor ?? EDTSColor.grey50,
                    alignment: setupDescAlignment
                )
                .padding(.top, hasTitle ? CGFloat(titleToDescSpacing) : .zero)
            }

            if hasSupport {
                label(
                    text: support,
                    attributed: supportAttributed,
                    font: resolvedFont(style: supportFontStyle, name: supportFontName, size: supportFontSize, weight: supportFontWeight, token: setupSupportStyle),
                    color: supportColor ?? EDTSColor.grey40,
                    alignment: setupSupportAlignment
                )
                .padding(.top, (hasTitle || hasDesc) ? CGFloat(descToSupportSpacing) : .zero)
            }
        }
    }

    @ViewBuilder
    private func label(
        text: String?,
        attributed: NSAttributedString?,
        font: Font,
        color: Color,
        alignment: TextAlignment
    ) -> some View {
        Group {
            if let attributed {
                makeText(from: attributed)
            } else {
                Text(text ?? "")
            }
        }
        .font(font)
        .foregroundColor(color)
        .multilineTextAlignment(alignment)
        .frame(maxWidth: .infinity, alignment: frameAlignment(for: alignment))
    }

    private func makeText(from attributed: NSAttributedString) -> Text {
        var result = Text("")
        let fullRange = NSRange(location: 0, length: attributed.length)

        attributed.enumerateAttributes(in: fullRange, options: []) { attributes, range, _ in
            var piece = Text(attributed.attributedSubstring(from: range).string)

            if let uiFont = attributes[.font] as? UIFont {
                piece = piece.font(Font(uiFont as CTFont))
            }
            if let uiColor = attributes[.foregroundColor] as? UIColor {
                piece = piece.foregroundColor(Color(uiColor))
            }
            if let underline = attributes[.underlineStyle] as? Int, underline != 0 {
                piece = piece.underline()
            }
            if let strikethrough = attributes[.strikethroughStyle] as? Int, strikethrough != 0 {
                piece = piece.strikethrough()
            }

            result = result + piece
        }

        return result
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
        if isHasBtnPrimary || isHasBtnSecondary {
            if setupIsHorizontal {
                HStack(spacing: CGFloat(buttonSpacing)) {
                    if isHasBtnSecondary { btnSecondary }
                    if isHasBtnPrimary { btnPrimary }
                }
            } else {
                VStack(spacing: CGFloat(buttonSpacing)) {
                    if isHasBtnPrimary { btnPrimary }
                    if isHasBtnSecondary { btnSecondary }
                }
            }
        }
    }

    private var closeButton: some View {
        Button(action: handleClose) {
            Image("ic_close")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(btnCloseSize), height: CGFloat(btnCloseSize))
                .foregroundColor(btnCloseTintColor ?? EDTSColor.grey50)
                .circularRippleEffect(size: closeHitSize, color: EDTSColor.grey30.opacity(closeRippleOpacity), trigger: $isCloseRippling)
                .frame(width: CGFloat(closeHitSize), height: CGFloat(closeHitSize))
                .contentShape(Rectangle())
        }
        .buttonStyle(EDTSCloseButtonStyle(isPressed: $isCloseRippling))
        .accessibility(label: Text("Close"))
    }

    private func handleClose() {
        onClose?()
        internalDismiss?()
    }
}

// MARK: - Scroll Bounce Modifier

private struct EDTSScrollBounceModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.scrollBounceBehavior(.basedOnSize)
        } else {
            content
        }
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
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            guard presented.isDismissOnTapOutside else { return }
                            presented.onClose?()
                            isPresented = false
                        }
                        .zIndex(0)
                        .transition(.opacity)

                    presented
                        .padding(.horizontal, CGFloat(dialogHorizontalMargin))
                        .zIndex(1)
                        .transition(.scale(scale: CGFloat(presentScale)).combined(with: .opacity))
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
                if isPressed != newValue {
                    isPressed = newValue
                }
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
        } else if #available(iOS 14.0, *) {
            content.onChange(of: value) { newValue in
                action(newValue)
            }
        } else {
            content.onReceive(Just(value)) { newValue in
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
        @State private var showLongText = false
        @State private var showHorizontal = false
        @State private var showImage = false

        private let longText = Array(
            repeating: "A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made.",
            count: 15
        ).joined(separator: " ")

        var body: some View {
            VStack(spacing: 16) {
                Button("Basic dialog") { showBasic = true }
                Button("Long text (scrollable)") { showLongText = true }
                Button("Horizontal buttons") { showHorizontal = true }
                Button("Image dialog") { showImage = true }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsDialog(isPresented: $showBasic) {
                EDTSDialog(
                    title: "Basic dialog title",
                    desc: "A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made.",
                    btnPrimary: EDTSButton(
                        btnType: .primary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showBasic = false }
                    ),
                    btnSecondary: EDTSButton(
                        btnType: .secondary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showBasic = false }
                    )
                )
            }
            .edtsDialog(isPresented: $showLongText) {
                EDTSDialog(
                    title: "Long text dialog",
                    desc: longText,
                    btnPrimary: EDTSButton(
                        btnType: .primary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showLongText = false }
                    ),
                    btnSecondary: EDTSButton(
                        btnType: .secondary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showLongText = false }
                    )
                )
            }
            .edtsDialog(isPresented: $showHorizontal) {
                EDTSDialog(
                    title: "Delete this item?",
                    desc: "This action can't be undone.",
                    btnOrientation: .horizontal,
                    btnPrimary: EDTSButton(
                        btnType: .primary,
                        btnState: .danger,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showHorizontal = false }
                    ),
                    btnSecondary: EDTSButton(
                        btnType: .secondary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showHorizontal = false }
                    )
                )
            }
            .edtsDialog(isPresented: $showImage) {
                EDTSDialog(
                    title: "Dialog with image",
                    desc: "Centered layout with the image on top and buttons above the text.",
                    support: "Supporting text sits below the description.",
                    btnPrimary: EDTSButton(
                        btnType: .primary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showImage = false }
                    ),
                    btnSecondary: EDTSButton(
                        btnType: .secondary,
                        btnState: .default,
                        text: "Button",
                        maxWidth: .infinity,
                        action: { showImage = false }
                    ),
                    isDialogImage: true
                )
            }
        }
    }
    return PreviewWrapper()
}
