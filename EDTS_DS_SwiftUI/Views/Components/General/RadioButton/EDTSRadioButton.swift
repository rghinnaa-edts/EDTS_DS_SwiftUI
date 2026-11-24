//
//  EDTSRadioButton.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 16/11/26.
//

import SwiftUI

// MARK: - Enums

public enum EDTSSelectionState: String {
    case `default` = "default"
    case disabled = "disabled"
}

public struct EDTSRadioButton: View {
    // MARK: - Properties
    
    public var radioButtonState: EDTSSelectionState

    public let title: String?
    public let titleAttributed: AttributedString?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: Double
    public var titleFontWeight: String?
    public var titleColorActive: Color?
    public var titleColorInactive: Color?

    public let desc: String?
    public let descAttributed: AttributedString?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: Double
    public var descFontWeight: String?
    public var descColorActive: Color?
    public var descColorInactive: Color?

    public let iconActive: Image?
    public let iconInactive: Image?
    public var iconTintColorActive: Color?
    public var iconTintColorInactive: Color?
    public let iconPadding: Double

    public var iconBgColorActive: Color?
    public var iconBgColorInactive: Color?
    public var boxSize: Double?

    public var spacing: Double?
    public var textSpacing: Double?

    public var borderWidth: Double?
    public var borderColorActive: Color?
    public var borderColorInactive: Color?

    public var paddingTop: Double
    public var paddingBottom: Double
    public var paddingLeading: Double
    public var paddingTrailing: Double

    public var isActive: Bool

    public var onTapRadioButton: (() -> Void)?

    // MARK: - Private Variable
    
    private let defaultTitleFontSize: Double = 14
    private let defaultDescFontSize: Double = 12
    private let defaultBoxSize: Double = 20
    private let bulletSize: Double = 10
    private let defaultSpacing: Double = 8
    private let defaultTextSpacing: Double = 4
    private let defaultBorderWidth: Double = 1
    private let rippleBleedMultiplier: Double = 1.8
    private let rippleOpacity: Double = 0.12
    private let activeStateAnimationDuration: Double = 0.25
    private let bulletInactiveScale: Double = 0.5
    private let bulletInactiveOpacity: Double = 0.5

    private var resolvedBoxSize: Double {
        boxSize ?? defaultBoxSize
    }

    private var resolvedSpacing: Double {
        spacing ?? defaultSpacing
    }

    private var resolvedTextSpacing: Double {
        textSpacing ?? defaultTextSpacing
    }

    private var resolvedBorderWidth: Double {
        borderWidth ?? defaultBorderWidth
    }

    private var hasCustomIcon: Bool {
        iconActive != nil || iconInactive != nil
    }

    private var currentIcon: Image? {
        isActive ? iconActive : iconInactive
    }

    private struct ResolvedValues {
        var titleColor: Color
        var descColor: Color
        var boxBgColor: Color
        var bulletColor: Color
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
        let size = titleFontSize == .zero ? defaultTitleFontSize : titleFontSize
        let weight = setupFontWeight(from: titleFontWeight ?? "")
        if !titleFontName.isEmpty {
            let font = Font.custom(titleFontName, size: size)
            return (titleFontWeight?.isEmpty ?? true) ? font : font.weight(weight)
        }
        return .system(size: size, weight: weight)
    }

    private var customDescFont: Font? {
        if let descFontStyle { return descFontStyle }
        guard hasCustomDescFont else { return nil }
        let size = descFontSize == .zero ? defaultDescFontSize : descFontSize
        let weight = setupFontWeight(from: descFontWeight ?? "")
        if !descFontName.isEmpty {
            let font = Font.custom(descFontName, size: size)
            return (descFontWeight?.isEmpty ?? true) ? font : font.weight(weight)
        }
        return .system(size: size, weight: weight)
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

    // MARK: - Initializers
    
    public init(
        radioButtonState: EDTSSelectionState = .default,
        title: String? = "Title radio button",
        titleAttributed: AttributedString? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: Double = .zero,
        titleFontWeight: String? = nil,
        titleColorActive: Color? = nil,
        titleColorInactive: Color? = nil,
        desc: String? = "Body text goes here",
        descAttributed: AttributedString? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: Double = .zero,
        descFontWeight: String? = nil,
        descColorActive: Color? = nil,
        descColorInactive: Color? = nil,
        iconActive: Image? = nil,
        iconInactive: Image? = nil,
        iconTintColorActive: Color? = nil,
        iconTintColorInactive: Color? = nil,
        iconPadding: Double = .zero,
        iconBgColorActive: Color? = nil,
        iconBgColorInactive: Color? = nil,
        boxSize: Double? = nil,
        spacing: Double? = nil,
        textSpacing: Double? = nil,
        borderWidth: Double? = nil,
        borderColorActive: Color? = nil,
        borderColorInactive: Color? = nil,
        paddingTop: Double = .zero,
        paddingBottom: Double = .zero,
        paddingLeading: Double = .zero,
        paddingTrailing: Double = .zero,
        isActive: Bool = false,
        onTapRadioButton: (() -> Void)? = nil
    ) {
        self.radioButtonState = radioButtonState
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
        self.iconActive = iconActive
        self.iconInactive = iconInactive
        self.iconTintColorActive = iconTintColorActive
        self.iconTintColorInactive = iconTintColorInactive
        self.iconPadding = iconPadding
        self.iconBgColorActive = iconBgColorActive
        self.iconBgColorInactive = iconBgColorInactive
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
        self.onTapRadioButton = onTapRadioButton
    }

    // MARK: - Setup & Styling

    private func resolveStyle() -> ResolvedValues {
        let isPoinku = EDTSColor.theme == .poinku
        let titleFont = customTitleFont ?? (isPoinku ? EDTSFont.Poinku.B2.Medium.font : EDTSFont.Klik.B2.Medium.font)
        let descFont = customDescFont ?? (isPoinku ? EDTSFont.Poinku.B3.Light.font : EDTSFont.Klik.B3.Regular.font)

        switch (radioButtonState, isActive) {
        case (.default, false):
            return ResolvedValues(
                titleColor: titleColorInactive ?? (isPoinku ? EDTSColor.grey70 : EDTSColor.grey60),
                descColor: descColorInactive ?? (isPoinku ? EDTSColor.grey60 : EDTSColor.grey50),
                boxBgColor: iconBgColorInactive ?? EDTSColor.white,
                bulletColor: iconTintColorInactive ?? EDTSColor.white,
                iconTintColor: iconTintColorInactive ?? (iconInactive == nil ? EDTSColor.white : EDTSColor.blue50),
                borderColor: borderColorInactive ?? EDTSColor.grey30,
                titleFont: titleFont,
                descFont: descFont
            )

        case (.default, true):
            return ResolvedValues(
                titleColor: titleColorActive ?? (isPoinku ? EDTSColor.grey70 : EDTSColor.grey60),
                descColor: descColorActive ?? (isPoinku ? EDTSColor.grey60 : EDTSColor.grey50),
                boxBgColor: iconBgColorActive ?? (isPoinku ? EDTSColor.blue30 : EDTSColor.blue50),
                bulletColor: iconTintColorActive ?? EDTSColor.white,
                iconTintColor: iconTintColorActive ?? EDTSColor.white,
                borderColor: borderColorActive ?? (isPoinku ? EDTSColor.blue30 : Color.clear),
                titleFont: titleFont,
                descFont: descFont
            )

        case (.disabled, false):
            return ResolvedValues(
                titleColor: isPoinku ? EDTSColor.grey50 : EDTSColor.grey40,
                descColor: EDTSColor.grey30,
                boxBgColor: EDTSColor.grey20,
                bulletColor: EDTSColor.grey20,
                iconTintColor: EDTSColor.grey20,
                borderColor: EDTSColor.grey30,
                titleFont: titleFont,
                descFont: descFont
            )

        case (.disabled, true):
            let disabledMark = isPoinku ? EDTSColor.grey30 : EDTSColor.grey40
            return ResolvedValues(
                titleColor: isPoinku ? EDTSColor.grey50 : EDTSColor.grey40,
                descColor: EDTSColor.grey30,
                boxBgColor: EDTSColor.grey20,
                bulletColor: disabledMark,
                iconTintColor: disabledMark,
                borderColor: disabledMark,
                titleFont: titleFont,
                descFont: descFont
            )
        }
    }

    // MARK: - Body
    
    public var body: some View {
        let values = resolvedStyle

        HStack(alignment: .center, spacing: resolvedSpacing) {
            bulletBox(values: values)

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
        .padding(.leading, paddingLeading)
        .padding(.trailing, paddingTrailing)
        .contentShape(Rectangle())
        .circularRippleEffect(
            size: resolvedBoxSize * rippleBleedMultiplier,
            color: EDTSColor.black.opacity(rippleOpacity),
            centerX: paddingLeading + resolvedBoxSize / 2,
            isEnabled: radioButtonState != .disabled,
            onTap: onTapRadioButton
        )
    }

    @ViewBuilder
    private func bulletBox(values: ResolvedValues) -> some View {
        ZStack {
            if hasCustomIcon {
                if let currentIcon {
                    currentIcon
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .padding(iconPadding)
                        .foregroundColor(values.iconTintColor)
                }
            } else {
                Circle()
                    .fill(values.bulletColor)
                    .frame(width: bulletSize, height: bulletSize)
                    .scaleEffect(isActive ? 1 : bulletInactiveScale)
                    .opacity(isActive ? 1 : bulletInactiveOpacity)
            }
        }
        .frame(width: resolvedBoxSize, height: resolvedBoxSize)
        .background(Circle().fill(values.boxBgColor))
        .overlay(
            Circle().strokeBorder(values.borderColor, lineWidth: resolvedBorderWidth)
        )
        .clipShape(Circle())
        .contentShape(Circle())
        .allowsHitTesting(radioButtonState != .disabled)
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
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var isSelected = false
        @State private var isSelected2 = false

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                EDTSRadioButton(
                    title: "Tap me",
                    desc: "Body text goes here",
                    isActive: isSelected,
                    onTapRadioButton: { isSelected.toggle() }
                )
                
                EDTSRadioButton(
                    title: "Custom icon",
                    desc: "Body text goes here",
                    iconActive: Image(systemName: "star.fill"),
                    iconInactive: Image(systemName: "star"),
                    iconPadding: 3,
                    isActive: isSelected2,
                    onTapRadioButton: { isSelected2.toggle() }
                )

                EDTSRadioButton(
                    title: "Selected",
                    desc: "Body text goes here",
                    isActive: true
                )

                EDTSRadioButton(
                    title: "Unselected, no description",
                    desc: nil,
                    isActive: false
                )

                EDTSRadioButton(
                    radioButtonState: .disabled,
                    title: "Disabled unselected",
                    desc: "Body text goes here",
                    isActive: false
                )

                EDTSRadioButton(
                    radioButtonState: .disabled,
                    title: "Disabled selected",
                    desc: "Body text goes here",
                    isActive: true
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
