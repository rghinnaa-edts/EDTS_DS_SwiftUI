//
//  EDTSButtonIcon.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 09/09/26.
//

import SwiftUI

public struct EDTSButtonIcon: View {
    // MARK: - Properties
    public var btnType: BtnType
    public var btnSize: BtnSize
    public var btnState: BtnState

    public let icon: Image?
    public var iconTintColor: Color?
    public var iconDangerTintColor: Color?
    public var iconDisabledTintColor: Color?
    public var iconSize: CGFloat
    
    public var bgColor: Color?
    public var bgDangerColor: Color?
    public var bgDisabledColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?

    public var rippleColor: Color?
    public var cornerRadius: CGFloat

    public var borderWidth: CGFloat
    public var borderColor: Color?
    public var borderDangerColor: Color?
    public var borderDisabledColor: Color?

    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var shadowColor: Color?
    public var shadowDangerColor: Color?
    public var shadowDisabledColor: Color?

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var badge: EDTSSignifier?

    public var action: () -> Void

    // MARK: - State
    @State private var tempResolvedButtonState: BtnState? = nil
    private let defaultValue: CGFloat = -1.0
    private let dragCancelThreshold: CGFloat = 44

    // MARK: - Initializers
    public init(
        btnType: BtnType = .primary,
        btnSize: BtnSize = .large,
        btnState: BtnState = .default,
        icon: Image? = nil,
        iconTintColor: Color? = nil,
        iconDisabledTintColor: Color? = nil,
        iconDangerTintColor: Color? = nil,
        iconSize: CGFloat = .zero,
        bgColor: Color? = nil,
        bgDisabledColor: Color? = nil,
        bgDangerColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        rippleColor: Color? = nil,
        cornerRadius: CGFloat = -1.0,
        borderWidth: CGFloat = .zero,
        borderColor: Color? = nil,
        borderDisabledColor: Color? = nil,
        borderDangerColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: CGFloat = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        shadowDisabledColor: Color? = nil,
        shadowDangerColor: Color? = nil,
        paddingTop: CGFloat = -1.0,
        paddingBottom: CGFloat = -1.0,
        paddingLeading: CGFloat = -1.0,
        paddingTrailing: CGFloat = -1.0,
        badge: EDTSSignifier? = nil,
        action: @escaping () -> Void
    ) {
        self.btnType = btnType
        self.btnSize = btnSize
        self.btnState = btnState
        self.icon = icon
        self.iconTintColor = iconTintColor
        self.iconDisabledTintColor = iconDisabledTintColor
        self.iconDangerTintColor = iconDangerTintColor
        self.iconSize = iconSize
        self.bgColor = bgColor
        self.bgDisabledColor = bgDisabledColor
        self.bgDangerColor = bgDangerColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
        self.rippleColor = rippleColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderDisabledColor = borderDisabledColor
        self.borderDangerColor = borderDangerColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.shadowDisabledColor = shadowDisabledColor
        self.shadowDangerColor = shadowDangerColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.badge = badge
        self.action = action
    }

    // MARK: - Private Variable
    private var resolvedButtonSize: BtnSize {
        btnSize
    }

    private var resolvedButtonType: BtnType {
        btnType
    }

    private var resolvedButtonState: BtnState {
        btnState
    }

    private struct ResolvedValues {
        var tempIconTintColor: Color?
        var tempBgColor: Color?
        var tempRippleColor: Color?
        var tempBorderColor: Color?
        var tempBorderWidth: CGFloat = .zero
        var tempIconSize: CGFloat = .zero
        var tempCornerRadius: CGFloat = -1.0
        var tempPaddingTop: CGFloat = -1.0
        var tempPaddingBottom: CGFloat = -1.0
        var tempPaddingLeading: CGFloat = -1.0
        var tempPaddingTrailing: CGFloat = -1.0
        var tempShadowColor: Color?
    }

    // MARK: - Body
    public var body: some View {
        let values = setupBtnType()

        content(values: values)
            .padding(.top, values.tempPaddingTop)
            .padding(.bottom, values.tempPaddingBottom)
            .padding(.leading, values.tempPaddingLeading)
            .padding(.trailing, values.tempPaddingTrailing)
            .background(setupBackground(values: values))
            .overlay(
                RoundedRectangle(cornerRadius: values.tempCornerRadius)
                    .stroke(values.tempBorderColor ?? .clear, lineWidth: values.tempBorderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: values.tempCornerRadius))
            .shadow(
                color: (values.tempShadowColor ?? .clear).opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
            .rippleEffect(
                color: (bgColorStart == nil && bgColorEnd == nil) ? (values.tempRippleColor ?? .clear) : .clear,
                cornerRadius: values.tempCornerRadius
            )
            .scaleEffect(tempResolvedButtonState != nil ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: tempResolvedButtonState)
            .contentShape(Rectangle())
            .simultaneousGesture(setupPressGesture())
    }

    @ViewBuilder
    private func content(values: ResolvedValues) -> some View {
        Group {
            if let icon {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("ic_placeholder")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: values.tempIconSize, height: values.tempIconSize)
        .foregroundColor(values.tempIconTintColor)
        .overlay(alignment: .topTrailing) {
            if let badge {
                badge
                    .offset(x: badge.offsetX, y: -badge.offsetY)
            }
        }
    }

    // MARK: - Setup & Styling
    @ViewBuilder
    private func setupBackground(values: ResolvedValues) -> some View {
        if bgColorStart != nil || bgColorEnd != nil {
            let orientation = bgColorOrientation ?? .vertical
            LinearGradient(
                colors: [bgColorStart ?? .clear, bgColorEnd ?? .clear],
                startPoint: orientation == .horizontal ? .leading : .top,
                endPoint: orientation == .horizontal ? .trailing : .bottom
            )
        } else {
            values.tempBgColor ?? .clear
        }
    }

    private func setupBtnSize() -> ResolvedValues {
        var values = ResolvedValues()

        switch resolvedButtonSize {
        case .small:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
                values.tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
            }

            values.tempIconSize = iconSize == .zero ? 16 : iconSize
            values.tempPaddingTop = paddingTop == defaultValue ? 4 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 4 : paddingBottom
            values.tempPaddingLeading = paddingLeading == defaultValue ? 4 : paddingLeading
            values.tempPaddingTrailing = paddingTrailing == defaultValue ? 4 : paddingTrailing

        case .medium:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
                values.tempPaddingTop = paddingTop == defaultValue ? 6 : paddingTop
                values.tempPaddingBottom = paddingBottom == defaultValue ? 6 : paddingBottom
                values.tempPaddingLeading = paddingLeading == defaultValue ? 6 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 6 : paddingTrailing
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
                values.tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
                values.tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
                values.tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
            }

            values.tempIconSize = iconSize == .zero ? 16 : iconSize

        case .large:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            }

            values.tempIconSize = iconSize == .zero ? 24 : iconSize
            values.tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            values.tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
            values.tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
        }

        return values
    }

    private func setupBtnType() -> ResolvedValues {
        var values = setupBtnSize()
        let state = tempResolvedButtonState ?? resolvedButtonState

        switch resolvedButtonType {
        case .primary:
            setupBtnPrimary(state, into: &values)
        case .secondary:
            setupBtnSecondary(state, into: &values)
        case .tertiary:
            setupBtnTertiary(state, into: &values)
        }

        setupBtnStyle(into: &values)

        return values
    }

    private func setupBtnStyle(into values: inout ResolvedValues) {
        switch resolvedButtonType {
        case .primary:
            break

        case .secondary, .tertiary:
            if iconTintColor != nil {
                values.tempBorderColor = borderColor == nil ? values.tempIconTintColor : values.tempBorderColor
            }
        }

        guard resolvedButtonState != .disabled else {
            values.tempRippleColor = .clear
            return
        }

        if rippleColor == nil {
            if values.tempBgColor == EDTSColor.white {
                values.tempRippleColor = values.tempIconTintColor?.opacity(0.12)
            } else if values.tempBgColor == .clear {
                values.tempRippleColor = values.tempIconTintColor?.opacity(0.12)
            } else if values.tempBgColor != EDTSColor.white {
                values.tempRippleColor = EDTSColor.grey70.opacity(0.12)
            }
        } else {
            if rippleColor == .clear {
                values.tempRippleColor = rippleColor
            } else {
                values.tempRippleColor = rippleColor?.opacity(0.12)
            }
        }
    }

    private func setupBtnPrimary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            if EDTSColor.theme == .poinku {
                values.tempBgColor = bgColor ?? EDTSColor.blue30
                values.tempBorderColor = borderColor ?? EDTSColor.blue30
            } else {
                values.tempBgColor = bgColor ?? EDTSColor.blue50
                values.tempBorderColor = borderColor ?? EDTSColor.blue50
            }

            values.tempIconTintColor = iconTintColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.white
            values.tempBgColor = bgDangerColor ?? EDTSColor.red30
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempBgColor = bgDisabledColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }

    private func setupBtnSecondary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            if EDTSColor.theme == .poinku {
                values.tempIconTintColor = iconTintColor ?? EDTSColor.blue30
                values.tempBorderColor = borderColor ?? EDTSColor.blue30
            } else {
                values.tempIconTintColor = iconTintColor ?? EDTSColor.blue50
                values.tempBorderColor = borderColor ?? EDTSColor.blue50
            }

            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }

    private func setupBtnTertiary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            values.tempIconTintColor = iconTintColor ?? EDTSColor.grey60
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderColor = borderColor ?? EDTSColor.grey60
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.grey30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }

    // MARK: - Gesture
    private func setupPressGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard resolvedButtonState != .disabled else { return }
                if tempResolvedButtonState == nil {
                    tempResolvedButtonState = resolvedButtonState
                }
            }
            .onEnded { value in
                guard resolvedButtonState != .disabled else { return }
                tempResolvedButtonState = nil

                let withinBounds = abs(value.translation.width) < dragCancelThreshold && abs(value.translation.height) < dragCancelThreshold
                if withinBounds {
                    action()
                }
            }
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        var body: some View {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    EDTSButtonIcon(btnType: .primary, btnSize: .large, btnState: .default, icon: Image(systemName: "heart.fill")) {}
                    EDTSButtonIcon(btnType: .primary, btnSize: .medium, btnState: .default, icon: Image(systemName: "heart.fill")) {}
                    EDTSButtonIcon(btnType: .primary, btnSize: .small, btnState: .default, icon: Image(systemName: "heart.fill")) {}
                    EDTSButtonIcon(btnType: .primary, btnSize: .large, btnState: .disabled, icon: Image(systemName: "heart.fill")) {}
                }

                HStack(spacing: 12) {
                    EDTSButtonIcon(btnType: .secondary, btnSize: .large, btnState: .default, icon: Image(systemName: "square.and.arrow.up")) {}
                    EDTSButtonIcon(btnType: .secondary, btnSize: .large, btnState: .disabled, icon: Image(systemName: "square.and.arrow.up")) {}
                }

                HStack(spacing: 12) {
                    EDTSButtonIcon(btnType: .tertiary, btnSize: .large, btnState: .default, icon: Image(systemName: "trash")) {}
                    EDTSButtonIcon(btnType: .tertiary, btnSize: .large, btnState: .disabled, icon: Image(systemName: "trash")) {}
                }

                EDTSButtonIcon(
                    btnType: .primary,
                    btnSize: .large,
                    icon: Image(systemName: "bell.fill"),
                    badge: EDTSSignifier(label: "3")
                ) {}
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
