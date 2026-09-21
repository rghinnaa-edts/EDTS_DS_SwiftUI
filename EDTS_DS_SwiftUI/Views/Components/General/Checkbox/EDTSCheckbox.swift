//
//  EDTSCheckbox.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 16/09/26.
//

import SwiftUI

// MARK: - Enums
public enum EDTSCheckboxState: String {
    case `default` = "default"
    case disabled = "disabled"
}

public enum EDTSCheckboxType: String {
    case checked = "checked"
    case indeterminated = "indeterminated"
}

public struct EDTSCheckbox: View {
    // MARK: - Properties
    public var checkboxState: EDTSCheckboxState
    public var checkboxType: EDTSCheckboxType

    public let title: String?
    public let titleAttributed: AttributedString?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: CGFloat
    public var titleFontWeight: String?
    public var titleColorActive: Color?
    public var titleColorInactive: Color?

    public let desc: String?
    public let descAttributed: AttributedString?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: CGFloat
    public var descFontWeight: String?
    public var descColorActive: Color?
    public var descColorInactive: Color?

    public let icon: Image?
    public var iconTintColorActive: Color?
    public var iconTintColorInactive: Color?
    public let iconSize: CGFloat
    public let iconPadding: CGFloat

    public var boxBgColorActive: Color?
    public var boxBgColorInactive: Color?
    public var boxCornerRadius: CGFloat
    public var boxSize: CGFloat
    
    public var spacing: CGFloat
    public var textSpacing: CGFloat

    public var borderWidth: CGFloat
    public var borderColorActive: Color?
    public var borderColorInactive: Color?

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var isActive: Bool

    public var onTapCheckbox: (() -> Void)?

    // MARK: - Private Variable
    private let defaultTitleFontSize: CGFloat = 14
    private let defaultDescFontSize: CGFloat = 12
    private let defaultSpacing: CGFloat = 8
    private let defaultTextSpacing: CGFloat = 4
    private let defaultCornerRadius: CGFloat = 4
    private let defaultBorderWidth: CGFloat = 1
    private let defaultPaddingLeading: CGFloat = 2
    private let rippleBleedMultiplier: CGFloat = 1.8
    private let rippleOpacity: Double = 0.12
    private let rippleGrowDuration: Double = 0.10
    private let rippleFadeDuration: Double = 0.22
    private let activeStateAnimationDuration: Double = 0.25
    private let dragCancelThreshold: CGFloat = 44

    private var resolvedIcon: Image? {
        if let icon { return icon }
        switch checkboxType {
        case .checked:
            return Image("ic_check")
        case .indeterminated:
            return Image("ic_minus")
        }
    }

    private var resolvedIconContainerSize: CGFloat {
        boxSize != .zero ? boxSize : (iconSize + (iconPadding * 2))
    }
    
    private var resolvedSpacing: CGFloat {
        spacing == .zero ? defaultSpacing : spacing
    }
    
    private var resolvedTextSpacing: CGFloat {
        textSpacing == .zero ? defaultTextSpacing : textSpacing
    }
    
    private var resolvedPaddingLeading: CGFloat {
        paddingLeading == .zero ? defaultPaddingLeading : paddingLeading
    }
    
    private var resolvedCornerRadius: CGFloat {
        boxCornerRadius != .zero ? boxCornerRadius : defaultCornerRadius
    }
    
    private var resolvedBorderWidth: CGFloat {
        borderWidth == .zero ? defaultBorderWidth : borderWidth
    }
    
    private struct ResolvedValues {
        var titleColor: Color
        var descColor: Color
        var boxBgColor: Color
        var iconTintColor: Color
        var borderColor: Color
        var titleFont: Font
        var descFont: Font
    }

    private var resolvedStyle: ResolvedValues {
        resolveStyle()
    }
    
    private var customTitleFont: Font? {
        if let titleFontStyle { return titleFontStyle }
        guard hasCustomTitleFont else { return nil }
        let weight = setupFontWeight(from: titleFontWeight ?? "")
        if !titleFontName.isEmpty {
            return .custom(titleFontName, size: titleFontSize == .zero ? defaultTitleFontSize : titleFontSize)
        }
        return .system(size: titleFontSize == .zero ? defaultTitleFontSize : titleFontSize, weight: weight)
    }

    private var customDescFont: Font? {
        if let descFontStyle { return descFontStyle }
        guard hasCustomDescFont else { return nil }
        let weight = setupFontWeight(from: descFontWeight ?? "")
        if !descFontName.isEmpty {
            return .custom(descFontName, size: descFontSize == .zero ? defaultDescFontSize : descFontSize)
        }
        return .system(size: descFontSize == .zero ? defaultDescFontSize : descFontSize, weight: weight)
    }
    
    private var hasTitle: Bool {
        if let titleAttributed { return !titleAttributed.characters.isEmpty }
        return !(title ?? "").isEmpty
    }

    private var hasCustomTitleFont: Bool {
        !titleFontName.isEmpty || titleFontSize != .zero || (titleFontWeight?.isEmpty == false)
    }

    private var hasDesc: Bool {
        if let descAttributed { return !descAttributed.characters.isEmpty }
        return !(desc ?? "").isEmpty
    }
    
    private var hasCustomDescFont: Bool {
        !descFontName.isEmpty || descFontSize != .zero || (descFontWeight?.isEmpty == false)
    }
    
    // MARK: - State
    @State private var isPressed = false
    @State private var isRipplePressed = false

    // MARK: - Initializers
    public init(
        checkboxState: EDTSCheckboxState = .default,
        checkboxType: EDTSCheckboxType = .checked,
        title: String? = "Title checkbox",
        titleAttributed: AttributedString? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: CGFloat = .zero,
        titleFontWeight: String? = nil,
        titleColorActive: Color? = nil,
        titleColorInactive: Color? = nil,
        desc: String? = "Body text goes here",
        descAttributed: AttributedString? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: CGFloat = .zero,
        descFontWeight: String? = nil,
        descColorActive: Color? = nil,
        descColorInactive: Color? = nil,
        icon: Image? = nil,
        iconTintColorActive: Color? = nil,
        iconTintColorInactive: Color? = nil,
        iconSize: CGFloat = 16,
        iconPadding: CGFloat = 2,
        boxBgColorActive: Color? = nil,
        boxBgColorInactive: Color? = nil,
        boxCornerRadius: CGFloat = .zero,
        boxSize: CGFloat = .zero,
        spacing: CGFloat = .zero,
        textSpacing: CGFloat = .zero,
        borderWidth: CGFloat = .zero,
        borderColorActive: Color? = nil,
        borderColorInactive: Color? = nil,
        paddingTop: CGFloat = .zero,
        paddingBottom: CGFloat = .zero,
        paddingLeading: CGFloat = .zero,
        paddingTrailing: CGFloat = .zero,
        isActive: Bool = false,
        onTapCheckbox: (() -> Void)? = nil
    ) {
        self.checkboxState = checkboxState
        self.checkboxType = checkboxType
        self.title = titleAttributed == nil ? title : nil
        self.titleAttributed = titleAttributed
        self.titleFontStyle = titleFontStyle
        self.titleFontName = titleFontName
        self.titleFontSize = titleFontSize
        self.titleFontWeight = titleFontWeight
        self.titleColorActive = titleColorActive
        self.titleColorInactive = titleColorInactive
        self.desc = descAttributed == nil ? desc : nil
        self.descAttributed = descAttributed
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.descFontWeight = descFontWeight
        self.descColorActive = descColorActive
        self.descColorInactive = descColorInactive
        self.icon = icon
        self.iconTintColorActive = iconTintColorActive
        self.iconTintColorInactive = iconTintColorInactive
        self.iconSize = iconSize
        self.iconPadding = iconPadding
        self.boxBgColorActive = boxBgColorActive
        self.boxBgColorInactive = boxBgColorInactive
        self.boxCornerRadius = boxCornerRadius
        self.boxSize = boxSize
        self.spacing = spacing
        self.textSpacing = textSpacing
        self.borderWidth = borderWidth
        self.borderColorActive = borderColorActive
        self.borderColorInactive = borderColorInactive
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.isActive = isActive
        self.onTapCheckbox = onTapCheckbox
    }

    // MARK: - Setup & Styling
    private func resolveStyle() -> ResolvedValues {
        let isPoinku = EDTSColor.theme == .poinku
        let titleFont = customTitleFont ?? (isPoinku ? EDTSFont.Poinku.B2.Medium.font : EDTSFont.Klik.B2.Medium.font)
        let descFont = customDescFont ?? (isPoinku ? EDTSFont.Poinku.B3.Light.font : EDTSFont.Klik.B3.Regular.font)

        switch (checkboxState, isActive) {
        case (.default, false):
            return ResolvedValues(
                titleColor: titleColorInactive ?? (isPoinku ? EDTSColor.grey70 : EDTSColor.grey60),
                descColor: descColorInactive ?? (isPoinku ? EDTSColor.grey60 : EDTSColor.grey50),
                boxBgColor: boxBgColorInactive ?? EDTSColor.white,
                iconTintColor: iconTintColorInactive ?? EDTSColor.white,
                borderColor: borderColorInactive ?? EDTSColor.grey30,
                titleFont: titleFont,
                descFont: descFont
            )

        case (.default, true):
            return ResolvedValues(
                titleColor: titleColorActive ?? (isPoinku ? EDTSColor.grey70 : EDTSColor.grey60),
                descColor: descColorActive ?? (isPoinku ? EDTSColor.grey60 : EDTSColor.grey50),
                boxBgColor: boxBgColorActive ?? (isPoinku ? EDTSColor.blue30 : EDTSColor.blue50),
                iconTintColor: iconTintColorActive ?? EDTSColor.white,
                borderColor: borderColorActive ?? (isPoinku ? EDTSColor.blue30 : EDTSColor.blue50),
                titleFont: titleFont,
                descFont: descFont
            )

        case (.disabled, false):
            return ResolvedValues(
                titleColor: isPoinku ? EDTSColor.grey50 : EDTSColor.grey40,
                descColor: EDTSColor.grey30,
                boxBgColor: EDTSColor.grey20,
                iconTintColor: EDTSColor.grey20,
                borderColor: EDTSColor.grey30,
                titleFont: titleFont,
                descFont: descFont
            )

        case (.disabled, true):
            return ResolvedValues(
                titleColor: isPoinku ? EDTSColor.grey50 : EDTSColor.grey40,
                descColor: EDTSColor.grey30,
                boxBgColor: EDTSColor.grey20,
                iconTintColor: isPoinku ? EDTSColor.grey30 : EDTSColor.grey40,
                borderColor: EDTSColor.grey30,
                titleFont: titleFont,
                descFont: descFont
            )
        }
    }

    // MARK: - Body
    public var body: some View {
        let values = resolvedStyle

        HStack(alignment: .center, spacing: resolvedSpacing) {
            iconBox(values: values)

            if hasTitle || hasDesc {
                VStack(alignment: .leading, spacing: resolvedTextSpacing) {
                    if hasTitle {
                        titleView(color: values.titleColor, font: values.titleFont)
                    }
                    if hasDesc {
                        descView(color: values.descColor, font: values.descFont)
                    }
                }
            }
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.leading, resolvedPaddingLeading)
        .padding(.trailing, paddingTrailing)
        .contentShape(Rectangle())
        .simultaneousGesture(setupPressGesture())
    }

    @ViewBuilder
    private func iconBox(values: ResolvedValues) -> some View {
        Group {
            if let resolvedIcon {
                resolvedIcon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(values.iconTintColor)
            }
        }
        .frame(width: resolvedIconContainerSize, height: resolvedIconContainerSize)
        .background(values.boxBgColor)
        .overlay(
            RoundedRectangle(cornerRadius: resolvedCornerRadius)
                .stroke(values.borderColor, lineWidth: resolvedBorderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: resolvedCornerRadius))
        .contentShape(Rectangle())
        .circularRippleEffect(size: resolvedIconContainerSize * rippleBleedMultiplier, color: EDTSColor.black.opacity(rippleOpacity), trigger: $isRipplePressed)
        .allowsHitTesting(checkboxState != .disabled)
        .animation(.easeInOut(duration: activeStateAnimationDuration), value: isActive)
    }

    @ViewBuilder
    private func titleView(color: Color, font: Font) -> some View {
        Group {
            if let titleAttributed {
                Text(titleAttributed)
            } else {
                Text(title ?? "")
            }
        }
        .foregroundColor(color)
        .font(font)
    }

    @ViewBuilder
    private func descView(color: Color, font: Font) -> some View {
        Group {
            if let descAttributed {
                Text(descAttributed)
            } else {
                Text(desc ?? "")
            }
        }
        .foregroundColor(color)
        .font(font)
    }

    // MARK: - Gesture
    private func setupPressGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard checkboxState != .disabled else { return }
                if !isPressed {
                    isPressed = true
                    isRipplePressed = true
                }
            }
            .onEnded { value in
                guard checkboxState != .disabled else { return }
                isPressed = false
                isRipplePressed = false

                let withinBounds = abs(value.translation.width) < dragCancelThreshold && abs(value.translation.height) < dragCancelThreshold
                if withinBounds {
                    onTapCheckbox?()
                }
            }
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var isChecked1 = false

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                EDTSCheckbox(
                    title: "Title checkboxes",
                    desc: "Body text goes here",
                    isActive: isChecked1,
                    onTapCheckbox: { isChecked1.toggle() }
                )

                EDTSCheckbox(
                    title: "Checked",
                    desc: "Body text goes here",
                    isActive: true
                )
                
                EDTSCheckbox(
                    checkboxType: .indeterminated,
                    title: "Indeterminate",
                    desc: "Body text goes here",
                    isActive: true
                )

                EDTSCheckbox(
                    checkboxState: .disabled,
                    title: "Disabled unchecked",
                    desc: "Body text goes here",
                    isActive: false
                )

                EDTSCheckbox(
                    checkboxState: .disabled,
                    title: "Disabled checked",
                    desc: "Body text goes here",
                    isActive: true
                )
                
                EDTSCheckbox(
                    checkboxState: .disabled,
                    checkboxType: .indeterminated,
                    title: "Disabled Indeterminate",
                    desc: "Body text goes here",
                    isActive: true
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
