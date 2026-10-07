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
    public var iconSize: Double
    
    public var bgColor: Color?
    public var bgDangerColor: Color?
    public var bgDisabledColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?

    public var rippleColor: Color?
    public var cornerRadius: Double?

    public var borderWidth: Double
    public var borderColor: Color?
    public var borderDangerColor: Color?
    public var borderDisabledColor: Color?

    public var shadowOpacity: Double
    public var shadowRadius: Double
    public var shadowOffset: CGSize
    public var shadowColor: Color?
    public var shadowDangerColor: Color?
    public var shadowDisabledColor: Color?

    public var paddingTop: Double?
    public var paddingBottom: Double?
    public var paddingLeading: Double?
    public var paddingTrailing: Double?

    public var badge: EDTSSignifier?

    public var action: () -> Void

    // MARK: - State
    @State private var tempResolvedButtonState: BtnState? = nil

    // MARK: - Initializers
    public init(
        btnType: BtnType = .primary,
        btnSize: BtnSize = .large,
        btnState: BtnState = .default,
        icon: Image? = nil,
        iconTintColor: Color? = nil,
        iconDisabledTintColor: Color? = nil,
        iconDangerTintColor: Color? = nil,
        iconSize: Double = .zero,
        bgColor: Color? = nil,
        bgDisabledColor: Color? = nil,
        bgDangerColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        rippleColor: Color? = nil,
        cornerRadius: Double? = nil,
        borderWidth: Double = .zero,
        borderColor: Color? = nil,
        borderDisabledColor: Color? = nil,
        borderDangerColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: Double = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        shadowDisabledColor: Color? = nil,
        shadowDangerColor: Color? = nil,
        paddingTop: Double? = nil,
        paddingBottom: Double? = nil,
        paddingLeading: Double? = nil,
        paddingTrailing: Double? = nil,
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
    private static let cornerRadiusPoinku: Double = 8
    private static let cornerRadiusKlik: Double = 4
    private static let iconSizeSmall: Double = 16
    private static let iconSizeMedium: Double = 16
    private static let iconSizeLarge: Double = 24
    private static let paddingSmall: Double = 4
    private static let paddingSmallHorizontalKlik: Double = 8
    private static let paddingMediumPoinku: Double = 6
    private static let paddingMediumKlik: Double = 8
    private static let paddingLarge: Double = 8
    private static let rippleOpacity: Double = 0.12
    private static let borderWidthDefault: Double = 1
    private static let pressedScale: Double = 0.95
    private static let restingScale: Double = 1.0
    private static let pressAnimationDuration: Double = 0.1
    private let dragCancelThreshold: Double = 44
    
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
        var tempBorderWidth: Double = .zero
        var tempIconSize: Double = .zero
        var tempCornerRadius: Double = .zero
        var tempPaddingTop: Double = .zero
        var tempPaddingBottom: Double = .zero
        var tempPaddingLeading: Double = .zero
        var tempPaddingTrailing: Double = .zero
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
            .scaleEffect(tempResolvedButtonState != nil ? Self.pressedScale : Self.restingScale)
            .animation(.easeInOut(duration: Self.pressAnimationDuration), value: tempResolvedButtonState)
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
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusPoinku
            } else {
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusKlik
                values.tempPaddingLeading = paddingLeading ?? Self.paddingSmallHorizontalKlik
                values.tempPaddingTrailing = paddingTrailing ?? Self.paddingSmallHorizontalKlik
            }

            values.tempIconSize = iconSize == .zero ? Self.iconSizeSmall : iconSize
            values.tempPaddingTop = paddingTop ?? Self.paddingSmall
            values.tempPaddingBottom = paddingBottom ?? Self.paddingSmall
            values.tempPaddingLeading = paddingLeading ?? Self.paddingSmall
            values.tempPaddingTrailing = paddingTrailing ?? Self.paddingSmall

        case .medium:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusPoinku
                values.tempPaddingTop = paddingTop ?? Self.paddingMediumPoinku
                values.tempPaddingBottom = paddingBottom ?? Self.paddingMediumPoinku
                values.tempPaddingLeading = paddingLeading ?? Self.paddingMediumPoinku
                values.tempPaddingTrailing = paddingTrailing ?? Self.paddingMediumPoinku
            } else {
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusKlik
                values.tempPaddingTop = paddingTop ?? Self.paddingMediumKlik
                values.tempPaddingBottom = paddingBottom ?? Self.paddingMediumKlik
                values.tempPaddingLeading = paddingLeading ?? Self.paddingMediumKlik
                values.tempPaddingTrailing = paddingTrailing ?? Self.paddingMediumKlik
            }

            values.tempIconSize = iconSize == .zero ? Self.iconSizeMedium : iconSize

        case .large:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusPoinku
            } else {
                values.tempCornerRadius = cornerRadius ?? Self.cornerRadiusKlik
            }

            values.tempIconSize = iconSize == .zero ? Self.iconSizeLarge : iconSize
            values.tempPaddingTop = paddingTop ?? Self.paddingLarge
            values.tempPaddingBottom = paddingBottom ?? Self.paddingLarge
            values.tempPaddingLeading = paddingLeading ?? Self.paddingLarge
            values.tempPaddingTrailing = paddingTrailing ?? Self.paddingLarge
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
                values.tempRippleColor = values.tempIconTintColor?.opacity(Self.rippleOpacity)
            } else if values.tempBgColor == .clear {
                values.tempRippleColor = values.tempIconTintColor?.opacity(Self.rippleOpacity)
            } else if values.tempBgColor != EDTSColor.white {
                values.tempRippleColor = EDTSColor.grey70.opacity(Self.rippleOpacity)
            }
        } else {
            if rippleColor == .clear {
                values.tempRippleColor = rippleColor
            } else {
                values.tempRippleColor = rippleColor?.opacity(Self.rippleOpacity)
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
            values.tempBorderWidth = borderWidth == .zero ? .zero : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.white
            values.tempBgColor = bgDangerColor ?? EDTSColor.red30
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? .zero : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempBgColor = bgDisabledColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? .zero : borderWidth
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
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }

    private func setupBtnTertiary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            values.tempIconTintColor = iconTintColor ?? EDTSColor.grey60
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderColor = borderColor ?? EDTSColor.grey60
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
            values.tempShadowColor = shadowColor

        case .danger:
            values.tempIconTintColor = iconDangerTintColor ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.grey30
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor

        case .disabled:
            values.tempIconTintColor = iconDisabledTintColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBorderWidth = borderWidth == .zero ? Self.borderWidthDefault : borderWidth
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
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Primary Button
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Button")
                        .font(.headline)

                    HStack(spacing: 12) {
                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .large,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .large,
                            btnState: .danger,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .large,
                            btnState: .disabled,
                            icon: Image("ic_placeholder")
                        ) {}
                    }
                }

                // MARK: - Secondary Button
                VStack(alignment: .leading, spacing: 8) {
                    Text("Secondary Button")
                        .font(.headline)

                    HStack(spacing: 12) {
                        EDTSButtonIcon(
                            btnType: .secondary,
                            btnSize: .large,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .secondary,
                            btnSize: .large,
                            btnState: .danger,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .secondary,
                            btnSize: .large,
                            btnState: .disabled,
                            icon: Image("ic_placeholder")
                        ) {}
                    }
                }

                // MARK: - Tertiary Button
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tertiary Button")
                        .font(.headline)

                    HStack(spacing: 12) {
                        EDTSButtonIcon(
                            btnType: .tertiary,
                            btnSize: .large,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .tertiary,
                            btnSize: .large,
                            btnState: .danger,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .tertiary,
                            btnSize: .large,
                            btnState: .disabled,
                            icon: Image("ic_placeholder")
                        ) {}
                    }
                }

                // MARK: - Sizes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sizes")
                        .font(.headline)

                    HStack(spacing: 12) {
                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .small,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .medium,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}

                        EDTSButtonIcon(
                            btnType: .primary,
                            btnSize: .large,
                            btnState: .default,
                            icon: Image("ic_placeholder")
                        ) {}
                    }
                }

                // MARK: - Gradient Background + Badge
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gradient Background and With Badge")
                        .font(.headline)

                    EDTSButtonIcon(
                        btnType: .primary,
                        btnSize: .large,
                        icon: Image("ic_placeholder"),
                        bgColorStart: EDTSColor.blue30,
                        bgColorEnd: EDTSColor.red30,
                        bgColorOrientation: .horizontal,
                        badge: EDTSSignifier(text: "3")
                    ) {}
                }

                // MARK: - Icon Only
                VStack(alignment: .leading, spacing: 8) {
                    Text("Icon Only")
                        .font(.headline)

                    EDTSButtonIcon(
                        btnType: .primary,
                        btnSize: .large,
                        btnState: .default,
                        icon: Image("ic_placeholder")
                    ) {}
                }
            }
            .padding()
        }
    }

    return PreviewWrapper()
}
