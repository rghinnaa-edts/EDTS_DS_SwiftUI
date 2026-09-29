//
//  EDTSDialog.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 28/09/26.
//

import SwiftUI

// MARK: - Environment

private struct EDTSDialogDismissKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

private extension EnvironmentValues {
    var edtsDialogDismiss: () -> Void {
        get { self[EDTSDialogDismissKey.self] }
        set { self[EDTSDialogDismissKey.self] = newValue }
    }
}

// MARK: - View

public struct EDTSDialog: View {

    // MARK: - Properties

    // Title
    public let title: String?
    public let titleAttributed: AttributedString?
    public var titleColor: Color?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: CGFloat
    public var titleFontWeight: String?
    public var titleAlignment: TextAlignment?

    // Description
    public let desc: String?
    public let descAttributed: AttributedString?
    public var descColor: Color?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: CGFloat
    public var descFontWeight: String?
    public var descAlignment: TextAlignment?

    // Support
    public let support: String?
    public let supportAttributed: AttributedString?
    public var supportColor: Color?
    public var supportFontStyle: Font?
    public var supportFontName: String
    public var supportFontSize: CGFloat
    public var supportFontWeight: String?
    public var supportAlignment: TextAlignment?

    // Image
    public let image: Image?
    public var imageSize: CGFloat?

    // Close
    public var btnCloseSize: CGFloat
    public var btnCloseTintColor: Color?

    // Buttons
    public var btnOrientation: Orientation
    public var btnPrimaryText: String?
    public var btnPrimaryState: BtnState
    public var btnSecondaryText: String?
    public var btnSecondaryState: BtnState

    // Container
    public var bgColor: Color?
    public var cornerRadius: CGFloat

    // Flags
    public var isHasBtnClose: Bool?
    public var isHasBtnPrimary: Bool
    public var isHasBtnSecondary: Bool
    public var isBtnPositionAtTopLabel: Bool?
    public var isDialogImage: Bool
    public var isDismissOnTapOutside: Bool

    // Callbacks
    public var onClose: (() -> Void)?
    public var onPrimaryTap: (() -> Void)?
    public var onSecondaryTap: (() -> Void)?

    @Environment(\.edtsDialogDismiss) private var dismissDialog

    // MARK: - Init

    public init(
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: CGFloat = .zero,
        titleFontWeight: String? = nil,
        titleAlignment: TextAlignment? = nil,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: CGFloat = .zero,
        descFontWeight: String? = nil,
        descAlignment: TextAlignment? = nil,
        support: String? = nil,
        supportAttributed: AttributedString? = nil,
        supportColor: Color? = nil,
        supportFontStyle: Font? = nil,
        supportFontName: String = "",
        supportFontSize: CGFloat = .zero,
        supportFontWeight: String? = nil,
        supportAlignment: TextAlignment? = nil,
        image: Image? = nil,
        imageSize: CGFloat? = nil,
        btnCloseSize: CGFloat = 16.0,
        btnCloseTintColor: Color? = nil,
        btnOrientation: Orientation = .vertical,
        btnPrimaryText: String? = nil,
        btnPrimaryState: BtnState = .default,
        btnSecondaryText: String? = nil,
        btnSecondaryState: BtnState = .default,
        bgColor: Color? = nil,
        cornerRadius: CGFloat = 12.0,
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

    // MARK: - Setup Values
    
    private var setupHasClose: Bool { isHasBtnClose ?? !isDialogImage }
    private var setupBtnAtTop: Bool { isBtnPositionAtTopLabel ?? isDialogImage }

    private var setupHasImage: Bool { image != nil || isDialogImage }
    private var setupImageSize: CGFloat {
        if let imageSize, imageSize > 0 { return imageSize }
        return 256
    }

    private var hasTitle: Bool { title != nil || titleAttributed != nil }
    private var hasDesc: Bool { desc != nil || descAttributed != nil }
    private var hasSupport: Bool { support != nil || supportAttributed != nil }

    private var setupShowPrimary: Bool { isHasBtnPrimary }
    private var setupShowSecondary: Bool { isHasBtnSecondary }
    private var setupIsHorizontal: Bool { btnOrientation == .horizontal }

    private var setupTitleAlignment: TextAlignment { titleAlignment ?? (isDialogImage ? .center : .leading) }
    private var setupDescAlignment: TextAlignment { descAlignment ?? (isDialogImage ? .center : .leading) }
    private var setupSupportAlignment: TextAlignment { supportAlignment ?? (isDialogImage ? .center : .leading) }

    private var setupTitleStyle: EDTSFont.FontStyle { isDialogImage ? EDTSFont.Klik.D4 : EDTSFont.Klik.H1 }
    private var setupDescStyle: EDTSFont.FontStyle { EDTSFont.Klik.P1.Regular }
    private var setupSupportStyle: EDTSFont.FontStyle { EDTSFont.Klik.P2.Regular }

    private func customFont(style: Font?, name: String, size: CGFloat, weight: String?) -> Font? {
        if let style { return style }
        guard size > 0 else { return nil }
        var font: Font = name.isEmpty ? .system(size: size) : .custom(name, size: size)
        if let weight {
            font = font.weight(setupFontWeight(from: weight))
        }
        return font
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            contentView

            if setupHasClose {
                closeButton
                    .padding(.top, 16)
                    .padding(.trailing, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(bgColor ?? EDTSColor.white)
        )
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: 16)

            if setupHasImage {
                imageView
            }

            if setupBtnAtTop {
                Color.clear.frame(height: 16)
                buttonsView
                Color.clear.frame(height: 24)
                textBlock
            } else {
                Color.clear.frame(height: setupHasImage ? 16 : 0)
                textBlock
                Color.clear.frame(height: hasSupport ? 32 : 36)
                buttonsView
            }

            Color.clear.frame(height: 16)
        }
        .padding(.horizontal, 16)
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
                    style: setupTitleStyle,
                    custom: customFont(style: titleFontStyle, name: titleFontName, size: titleFontSize, weight: titleFontWeight),
                    color: titleColor ?? EDTSColor.grey70,
                    alignment: setupTitleAlignment
                )
                // UIKit ties the title's trailing edge to the close icon's
                // leading edge, so the title stops short of the icon.
                .padding(.trailing, setupHasClose ? btnCloseSize : 0)
            }

            if hasDesc {
                label(
                    text: desc,
                    attributed: descAttributed,
                    style: setupDescStyle,
                    custom: customFont(style: descFontStyle, name: descFontName, size: descFontSize, weight: descFontWeight),
                    color: descColor ?? EDTSColor.grey50,
                    alignment: setupDescAlignment
                )
                .padding(.top, hasTitle ? 16 : 0)
            }

            if hasSupport {
                label(
                    text: support,
                    attributed: supportAttributed,
                    style: setupSupportStyle,
                    custom: customFont(style: supportFontStyle, name: supportFontName, size: supportFontSize, weight: supportFontWeight),
                    color: supportColor ?? EDTSColor.grey40,
                    alignment: setupSupportAlignment
                )
                .padding(.top, (hasTitle || hasDesc) ? 4 : 0)
            }
        }
    }

    @ViewBuilder
    private func label(
        text: String?,
        attributed: AttributedString?,
        style: EDTSFont.FontStyle,
        custom: Font?,
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
        .edtsFont(style, custom: custom)
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
                HStack(spacing: 8) {
                    if setupShowSecondary { secondaryButton }
                    if setupShowPrimary { primaryButton }
                }
            } else {
                VStack(spacing: 8) {
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
        Image("ic_close")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: btnCloseSize, height: btnCloseSize)
            .foregroundColor(btnCloseTintColor ?? EDTSColor.grey50)
            .circularRippleEffect(size: btnCloseSize * 2, color: EDTSColor.grey30.opacity(0.4))
            .onTapGesture {
                handleClose()
            }
    }

    // MARK: - Actions

    private func handleClose() {
        onClose?()
        dismissDialog()
    }
}

// MARK: - Presentation Modifier

private struct EDTSDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let dialog: () -> EDTSDialog

    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if isPresented {
                    let presented = dialog()

                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            guard presented.isDismissOnTapOutside else { return }
                            presented.onClose?()
                            isPresented = false
                        }
                        .transition(.opacity)

                    presented
                        .padding(.horizontal, 24)
                        .onTapGesture { }
                        .environment(\.edtsDialogDismiss, { isPresented = false })
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                }
            }
            .animation(
                isPresented
                    ? .easeOut(duration: 0.25)
                    : .easeIn(duration: 0.2).delay(0.2),
                value: isPresented
            )
        )
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
                    isDismissOnTapOutside: true,
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
