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

    public var boxBgColorActive: Color?
    public var boxBgColorInactive: Color?

    public var spacing: CGFloat
    public var labelSpacing: CGFloat

    public var borderWidth: CGFloat
    public var borderColorActive: Color?
    public var borderColorInactive: Color?

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var isActive: Bool

    public var onTapCheckbox: (() -> Void)?

    // MARK: - State
    @State private var isPressed = false

    // MARK: - Initializers
    public init(
        checkboxState: EDTSCheckboxState = .default,
        checkboxType: EDTSCheckboxType = .checked,
        title: String? = "Title Here",
        titleAttributed: AttributedString? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: CGFloat = .zero,
        titleFontWeight: String? = nil,
        titleColorActive: Color? = nil,
        titleColorInactive: Color? = nil,
        desc: String? = "Body text",
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
        boxBgColorActive: Color? = nil,
        boxBgColorInactive: Color? = nil,
        spacing: CGFloat = .zero,
        labelSpacing: CGFloat = .zero,
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
        self.boxBgColorActive = boxBgColorActive
        self.boxBgColorInactive = boxBgColorInactive
        self.spacing = spacing
        self.labelSpacing = labelSpacing
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

    // MARK: - Private Variable
    private var resolvedSpacing: CGFloat { spacing == .zero ? 8 : spacing }
    private var resolvedLabelSpacing: CGFloat { labelSpacing == .zero ? 4 : labelSpacing }
    private var resolvedBorderWidth: CGFloat { borderWidth == .zero ? 1 : borderWidth }
    private var resolvedCornerRadius: CGFloat { 4 }
    private var resolvedIconContainerSize: CGFloat { 20 }

    private var hasTitle: Bool {
        if let titleAttributed { return !titleAttributed.characters.isEmpty }
        return !(title ?? "").isEmpty
    }

    private var hasDesc: Bool {
        if let descAttributed { return !descAttributed.characters.isEmpty }
        return !(desc ?? "").isEmpty
    }

    private var resolvedTitleFontStyle: EDTSFont.FontStyle {
        EDTSFont.Klik.B2.Medium
    }

    private var hasCustomTitleFont: Bool {
        !titleFontName.isEmpty || titleFontSize != .zero || (titleFontWeight?.isEmpty == false)
    }

    private var customTitleFont: Font? {
        if let titleFontStyle { return titleFontStyle }
        guard hasCustomTitleFont else { return nil }
        let weight = setupFontWeight(from: titleFontWeight ?? "")
        if !titleFontName.isEmpty {
            return .custom(titleFontName, size: titleFontSize == .zero ? 14 : titleFontSize)
        }
        return .system(size: titleFontSize == .zero ? 14 : titleFontSize, weight: weight)
    }

    private var resolvedDescFontStyle: EDTSFont.FontStyle {
        EDTSFont.Klik.B3.Regular
    }

    private var hasCustomDescFont: Bool {
        !descFontName.isEmpty || descFontSize != .zero || (descFontWeight?.isEmpty == false)
    }

    private var customDescFont: Font? {
        if let descFontStyle { return descFontStyle }
        guard hasCustomDescFont else { return nil }
        let weight = setupFontWeight(from: descFontWeight ?? "")
        if !descFontName.isEmpty {
            return .custom(descFontName, size: descFontSize == .zero ? 12 : descFontSize)
        }
        return .system(size: descFontSize == .zero ? 12 : descFontSize, weight: weight)
    }

    private struct ResolvedValues {
        var titleColor: Color
        var descColor: Color
        var boxBgColor: Color
        var iconTintColor: Color
        var borderColor: Color
    }

    private var resolvedStyle: ResolvedValues {
        switch checkboxState {
        case .default:
            return resolveDefault()
        case .disabled:
            return resolveDisabled()
        }
    }

    private func resolveDefault() -> ResolvedValues {
        switch isActive {
        case false:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    titleColor: titleColorInactive ?? EDTSColor.grey70,
                    descColor: descColorInactive ?? EDTSColor.grey60,
                    boxBgColor: boxBgColorInactive ?? EDTSColor.white,
                    iconTintColor: iconTintColorInactive ?? EDTSColor.white,
                    borderColor: borderColorInactive ?? EDTSColor.grey30
                )
            } else {
                return ResolvedValues(
                    titleColor: titleColorInactive ?? EDTSColor.grey60,
                    descColor: descColorInactive ?? EDTSColor.grey50,
                    boxBgColor: boxBgColorInactive ?? EDTSColor.white,
                    iconTintColor: iconTintColorInactive ?? EDTSColor.white,
                    borderColor: borderColorInactive ?? EDTSColor.grey30
                )
            }

        case true:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    titleColor: titleColorInactive ?? EDTSColor.grey70,
                    descColor: descColorInactive ?? EDTSColor.grey60,
                    boxBgColor: boxBgColorInactive ?? EDTSColor.blue30,
                    iconTintColor: iconTintColorInactive ?? EDTSColor.white,
                    borderColor: borderColorInactive ?? EDTSColor.blue30
                )
            } else {
                return ResolvedValues(
                    titleColor: titleColorActive ?? EDTSColor.grey60,
                    descColor: descColorActive ?? EDTSColor.grey50,
                    boxBgColor: boxBgColorActive ?? EDTSColor.blue50,
                    iconTintColor: iconTintColorActive ?? EDTSColor.white,
                    borderColor: borderColorActive ?? .clear
                )
            }
        }
    }

    private func resolveDisabled() -> ResolvedValues {
        switch isActive {
        case false:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    titleColor: EDTSColor.grey50,
                    descColor: EDTSColor.grey30,
                    boxBgColor: EDTSColor.grey20,
                    iconTintColor: EDTSColor.grey20,
                    borderColor: EDTSColor.grey30
                )
            } else {
                return ResolvedValues(
                    titleColor: EDTSColor.grey40,
                    descColor: EDTSColor.grey30,
                    boxBgColor: EDTSColor.grey20,
                    iconTintColor: EDTSColor.grey20,
                    borderColor: EDTSColor.grey30
                )
            }

        case true:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    titleColor: EDTSColor.grey50,
                    descColor: EDTSColor.grey30,
                    boxBgColor: EDTSColor.grey20,
                    iconTintColor: EDTSColor.grey30,
                    borderColor: EDTSColor.grey30
                )
            } else {
                return ResolvedValues(
                    titleColor: EDTSColor.grey40,
                    descColor: EDTSColor.grey30,
                    boxBgColor: EDTSColor.grey20,
                    iconTintColor: EDTSColor.grey40,
                    borderColor: EDTSColor.grey40
                )
            }
        }
    }

    private var resolvedIcon: Image? {
        if let icon { return icon }
        switch checkboxType {
        case .checked:
            return Image("ic_check")
        case .indeterminated:
            return Image("ic_minus")
        }
    }

    // MARK: - Body
    public var body: some View {
        let values = resolvedStyle

        HStack(alignment: .center, spacing: resolvedSpacing) {
            iconBox(values: values)

            if hasTitle || hasDesc {
                VStack(alignment: .leading, spacing: resolvedLabelSpacing) {
                    if hasTitle {
                        titleView(color: values.titleColor)
                    }
                    if hasDesc {
                        descView(color: values.descColor)
                    }
                }
            }
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.leading, paddingLeading)
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
                    .frame(width: 16, height: 16)
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
        .overlay(
            Circle()
                .fill(EDTSColor.black.opacity(isPressed ? 0.12 : 0))
                .frame(width: resolvedIconContainerSize + 16, height: resolvedIconContainerSize + 16)
                .animation(.easeOut(duration: isPressed ? 0.10 : 0.22), value: isPressed)
                .allowsHitTesting(false)
        )
        .animation(.easeInOut(duration: 0.25), value: isActive)
    }

    @ViewBuilder
    private func titleView(color: Color) -> some View {
        Group {
            if let titleAttributed {
                Text(titleAttributed)
            } else {
                Text(title ?? "")
            }
        }
        .foregroundColor(color)
        .edtsFont(resolvedTitleFontStyle, custom: customTitleFont)
    }

    @ViewBuilder
    private func descView(color: Color) -> some View {
        Group {
            if let descAttributed {
                Text(descAttributed)
            } else {
                Text(desc ?? "")
            }
        }
        .foregroundColor(color)
        .edtsFont(resolvedDescFontStyle, custom: customDescFont)
    }

    // MARK: - Gesture
    private func setupPressGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard checkboxState != .disabled else { return }
                if !isPressed {
                    isPressed = true
                }
            }
            .onEnded { value in
                guard checkboxState != .disabled else { return }
                isPressed = false

                let withinBounds = abs(value.translation.width) < 44 && abs(value.translation.height) < 44
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
        @State private var isChecked2 = true
        @State private var isChecked3 = true

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
                    isActive: isChecked3,
                    onTapCheckbox: { isChecked3.toggle() }
                )
                
                EDTSCheckbox(
                    checkboxType: .indeterminated,
                    title: "Indeterminate",
                    desc: "Body text goes here",
                    isActive: isChecked2,
                    onTapCheckbox: { isChecked2.toggle() }
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
