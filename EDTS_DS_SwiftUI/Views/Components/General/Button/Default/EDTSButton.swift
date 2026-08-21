//
//  EDTSButton.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 20/08/26.
//

import SwiftUI

// MARK: - Enums
public enum BtnState: String {
    case `default` = "default"
    case focus = "focus"
    case danger = "danger"
    case disabled = "disabled"
}

public enum BtnType: String {
    case primary = "primary"
    case secondary = "secondary"
    case tertiary = "tertiary"
}

public enum BtnSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

public struct EDTSButton: View {
    // MARK: - Properties
    private var btnType: BtnType
    private var btnSize: BtnSize
    private var btnState: BtnState

    private let label: String?
    private let labelAttributed: AttributedString?
    private var labelColor: Color?
    private var labelFocusColor: Color?
    private var labelDangerColor: Color?
    private var labelDisabledColor: Color?
    
    private var fontName: String
    private var fontSize: CGFloat
    private var fontWeight: String?
    
    private var bgColor: Color?
    private var bgFocusColor: Color?
    private var bgDangerColor: Color?
    private var bgDisabledColor: Color?
    private var bgColorStart: Color?
    private var bgColorEnd: Color?
    private var bgColorOrientation: Orientation?
    
    private var rippleColor: Color?
    private var cornerRadius: CGFloat
    
    private let iconLeading: Image?
    private var iconTintColorLeading: Color?
    private var iconFocusTintColorLeading: Color?
    private var iconDangerTintColorLeading: Color?
    private var iconDisabledTintColorLeading: Color?
    
    private let iconTrailing: Image?
    private var iconTintColorTrailing: Color?
    private var iconFocusTintColorTrailing: Color?
    private var iconDangerTintColorTrailing: Color?
    private var iconDisabledTintColorTrailing: Color?
    
    private var iconSpacing: CGFloat
    private var iconSize: CGFloat
    
    private var borderWidth: CGFloat
    private var borderColor: Color?
    private var borderFocusColor: Color?
    private var borderDangerColor: Color?
    private var borderDisabledColor: Color?
    
    private var shadowOpacity: Double
    private var shadowRadius: CGFloat
    private var shadowOffset: CGSize
    private var shadowColor: Color?
    private var shadowFocusColor: Color?
    private var shadowDangerColor: Color?
    private var shadowDisabledColor: Color?
    
    private var paddingTop: CGFloat
    private var paddingBottom: CGFloat
    private var paddingLeading: CGFloat
    private var paddingTrailing: CGFloat
    
    private var action: () -> Void
    
    // MARK: - State
    @State private var tempResolvedButtonState: BtnState? = nil
    private let defaultValue: CGFloat = -1.0
    
    // MARK: - Initializers
    public init(
        btnType: BtnType = .primary,
        btnSize: BtnSize = .large,
        btnState: BtnState = .default,
        label: String? = "Button",
        labelAttributed: AttributedString? = nil,
        labelColor: Color? = nil,
        labelFocusColor: Color? = nil,
        labelDangerColor: Color? = nil,
        labelDisabledColor: Color? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        bgColor: Color? = nil,
        bgFocusColor: Color? = nil,
        bgDangerColor: Color? = nil,
        bgDisabledColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        rippleColor: Color? = nil,
        cornerRadius: CGFloat = -1.0,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconFocusTintColorLeading: Color? = nil,
        iconDangerTintColorLeading: Color? = nil,
        iconDisabledTintColorLeading: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
        iconFocusTintColorTrailing: Color? = nil,
        iconDangerTintColorTrailing: Color? = nil,
        iconDisabledTintColorTrailing: Color? = nil,
        iconSpacing: CGFloat = .zero,
        iconSize: CGFloat = .zero,
        borderWidth: CGFloat = .zero,
        borderColor: Color? = nil,
        borderFocusColor: Color? = nil,
        borderDangerColor: Color? = nil,
        borderDisabledColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: CGFloat = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        shadowFocusColor: Color? = nil,
        shadowDangerColor: Color? = nil,
        shadowDisabledColor: Color? = nil,
        paddingTop: CGFloat = -1.0,
        paddingBottom: CGFloat = -1.0,
        paddingLeading: CGFloat = -1.0,
        paddingTrailing: CGFloat = -1.0,
        action: @escaping () -> Void
    ) {
        self.btnType = btnType
        self.btnSize = btnSize
        self.btnState = btnState
        self.label = labelAttributed == nil ? (label ?? "Button") : nil
        self.labelAttributed = labelAttributed
        self.labelColor = labelColor
        self.labelFocusColor = labelFocusColor
        self.labelDangerColor = labelDangerColor
        self.labelDisabledColor = labelDisabledColor
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.bgColor = bgColor
        self.bgFocusColor = bgFocusColor
        self.bgDangerColor = bgDangerColor
        self.bgDisabledColor = bgDisabledColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
        self.rippleColor = rippleColor
        self.cornerRadius = cornerRadius
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconFocusTintColorLeading = iconFocusTintColorLeading
        self.iconDangerTintColorLeading = iconDangerTintColorLeading
        self.iconDisabledTintColorLeading = iconDisabledTintColorLeading
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.iconFocusTintColorTrailing = iconFocusTintColorTrailing
        self.iconDangerTintColorTrailing = iconDangerTintColorTrailing
        self.iconDisabledTintColorTrailing = iconDisabledTintColorTrailing
        self.iconSpacing = iconSpacing
        self.iconSize = iconSize
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderFocusColor = borderFocusColor
        self.borderDangerColor = borderDangerColor
        self.borderDisabledColor = borderDisabledColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.shadowFocusColor = shadowFocusColor
        self.shadowDangerColor = shadowDangerColor
        self.shadowDisabledColor = shadowDisabledColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
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
        var tempIconTintColorLeading: Color?
        var tempIconTintColorTrailing: Color?
        var tempLabelColor: Color?
        var tempBgColor: Color?
        var tempRippleColor: Color?
        var tempBorderColor: Color?
        var tempBorderWidth: CGFloat = .zero
        var tempIconSize: CGFloat = .zero
        var tempCornerRadius: CGFloat = -1.0
        var tempIconSpacing: CGFloat = .zero
        var tempPaddingTop: CGFloat = -1.0
        var tempPaddingBottom: CGFloat = -1.0
        var tempPaddingLeading: CGFloat = -1.0
        var tempPaddingTrailing: CGFloat = -1.0
        var tempShadowColor: Color?
    }
    
    // MARK: - Setup & Styling
    private var setupFontStyle: EDTSFont.FontStyle {
        switch EDTSColor.theme {
        case .klikIDM:
            switch resolvedButtonSize {
            case .small: return EDTSFont.Klik.Button.Small
            case .medium: return EDTSFont.Klik.Button.Medium
            case .large: return EDTSFont.Klik.Button.Large
            }
        case .poinku:
            switch resolvedButtonSize {
            case .small: return EDTSFont.Poinku.Button.Small
            case .medium: return EDTSFont.Poinku.Button.Medium
            case .large: return EDTSFont.Poinku.Button.Large
            }
        }
    }
    
    private func setupBtnSize() -> ResolvedValues {
        var values = ResolvedValues()
        
        switch resolvedButtonSize {
        case .small:
            if EDTSColor.theme == .poinku {
                values.tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
            } else {
                values.tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            }
            
            values.tempIconSize = iconSize == .zero ? 16 : iconSize
            values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            values.tempIconSpacing = iconSpacing == .zero ? 8 : iconSpacing
            values.tempPaddingTop = paddingTop == defaultValue ? 6 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 6 : paddingBottom
            
        case .medium:
            values.tempIconSize = iconSize == .zero ? 16 : iconSize
            values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            values.tempIconSpacing = iconSpacing == .zero ? 8 : iconSpacing
            values.tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            values.tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            values.tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .large:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? 24 : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? 8 : iconSpacing
            values.tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            values.tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            values.tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
        }
        
        return values
    }
    
    private func setupStyle() -> ResolvedValues {
        var btnSize = setupBtnSize()
        let btnState = tempResolvedButtonState ?? resolvedButtonState
        
        switch resolvedButtonType {
        case .primary:
            setupBtnPrimary(btnState, into: &btnSize)
        case .secondary:
            setupBtnSecondary(btnState, into: &btnSize)
        case .tertiary:
            setupBtnTertiary(btnState, into: &btnSize)
        }
        
        applyButtonStyle(into: &btnSize)
        
        return btnSize
    }
    
    private func setupBtnPrimary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            if EDTSColor.theme == .poinku {
                values.tempBgColor = bgColor ?? EDTSColor.blue30
                values.tempBorderColor = borderColor ?? EDTSColor.blue30
            } else {
                values.tempBgColor = bgColor ?? EDTSColor.blueDefault
                values.tempBorderColor = borderColor ?? EDTSColor.blueDefault
            }
            
            values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .focus:
            values.tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelFocusColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.white
            values.tempBgColor = bgFocusColor ?? EDTSColor.blueDefault
            values.tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            values.tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            values.tempShadowColor = shadowFocusColor ?? shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelDangerColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.white
            values.tempBgColor = bgDangerColor ?? EDTSColor.errorStrong
            values.tempBorderColor = borderDangerColor ?? EDTSColor.errorStrong
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            if EDTSColor.theme == .poinku {
                values.tempBgColor = bgDisabledColor ?? EDTSColor.grey30
                values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            } else {
                values.tempBgColor = bgDisabledColor ?? EDTSColor.disabled
                values.tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            }
            
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelDisabledColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }
    
    private func setupBtnSecondary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            if EDTSColor.theme == .poinku {
                values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.blue30
                values.tempLabelColor = labelColor ?? EDTSColor.blue30
                values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blue30
                values.tempBorderColor = borderColor ?? EDTSColor.blue30
            } else {
                values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.blueDefault
                values.tempLabelColor = labelColor ?? EDTSColor.blueDefault
                values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blueDefault
                values.tempBorderColor = borderColor ?? EDTSColor.blueDefault
            }
            
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .focus:
            values.tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.blueDefault
            values.tempLabelColor = labelFocusColor ?? EDTSColor.blueDefault
            values.tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.blueDefault
            values.tempBgColor = bgFocusColor ?? EDTSColor.white
            values.tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            values.tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            values.tempShadowColor = shadowFocusColor ?? shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.errorStrong
            values.tempLabelColor = labelDangerColor ?? EDTSColor.errorStrong
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.errorStrong
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.errorStrong
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            if EDTSColor.theme == .poinku {
                values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.grey30
                values.tempLabelColor = labelDisabledColor ?? EDTSColor.grey30
                values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.grey30
                values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            } else {
                values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.disabled
                values.tempLabelColor = labelDisabledColor ?? EDTSColor.disabled
                values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.disabled
                values.tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            }
            
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }
    
    private func setupBtnTertiary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.greyText
            values.tempLabelColor = labelColor ?? EDTSColor.greyText
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.greyText
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderColor = borderColor ?? EDTSColor.greyDefault
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .focus:
            values.tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.greyText
            values.tempLabelColor = labelFocusColor ?? EDTSColor.greyText
            values.tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.greyText
            values.tempBgColor = bgFocusColor ?? EDTSColor.grey20
            values.tempBorderColor = borderFocusColor ?? EDTSColor.greyPressed
            values.tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            values.tempShadowColor = shadowFocusColor ?? shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.errorStrong
            values.tempLabelColor = labelDangerColor ?? EDTSColor.errorStrong
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.errorStrong
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.disabled
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.disabled
            values.tempLabelColor = labelDisabledColor ?? EDTSColor.disabled
            values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.disabled
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }
    
    private func applyButtonStyle(into v: inout ResolvedValues) {
        switch resolvedButtonType {
        case .primary:
            break
            
        case .secondary, .tertiary:
            if labelColor != nil {
                v.tempIconTintColorLeading = iconTintColorLeading == nil ? v.tempLabelColor : v.tempIconTintColorLeading
                v.tempIconTintColorTrailing = iconTintColorTrailing == nil ? v.tempLabelColor : v.tempIconTintColorTrailing
                v.tempBorderColor = borderColor == nil ? v.tempLabelColor : v.tempBorderColor
            }
        }
        
        if rippleColor == nil {
            if v.tempBgColor == EDTSColor.white {
                v.tempRippleColor = v.tempLabelColor?.opacity(0.12)
            } else if v.tempBgColor == .clear {
                v.tempRippleColor = v.tempLabelColor?.opacity(0.12)
            } else if v.tempBgColor != EDTSColor.white {
                v.tempRippleColor = EDTSColor.grey70.opacity(0.12)
            }
        } else {
            if rippleColor == .clear {
                v.tempRippleColor = rippleColor
            } else {
                v.tempRippleColor = rippleColor?.opacity(0.12)
            }
        }
    }
    
    // MARK: - Body
    public var body: some View {
        let values = setupStyle()
        
        content(v: values)
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
            .simultaneousGesture(SetupPressGesture())
    }
    
    @ViewBuilder
    private func content(v: ResolvedValues) -> some View {
        HStack(spacing: v.tempIconSpacing) {
            if let iconLeading {
                iconLeading
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: v.tempIconSize, height: v.tempIconSize)
                    .foregroundColor(v.tempIconTintColorLeading)
            }
            
            Group {
                if let labelAttributed {
                    Text(labelAttributed)
                } else {
                    Text(label ?? "Button")
                }
            }
            .edtsFont(setupFontStyle)
            .foregroundColor(v.tempLabelColor)
            .multilineTextAlignment(.center)
            
            if let iconTrailing {
                iconTrailing
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: v.tempIconSize, height: v.tempIconSize)
                    .foregroundColor(v.tempIconTintColorTrailing)
            }
        }
    }
    
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
    
    // MARK: - Press Gesture
    private func SetupPressGesture() -> some Gesture {
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
                
                let withinBounds = abs(value.translation.width) < 44 && abs(value.translation.height) < 44
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
            VStack(spacing: 12) {
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .default, label: "Primary Default") {}
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .danger, label: "Primary Danger") {}
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .disabled, label: "Primary Disabled") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .default, label: "Secondary Default") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .danger, label: "Secondary Danger") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .disabled, label: "Secondary Disabled") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .default, label: "Tertiary Default") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .danger, label: "Tertiary Danger") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .disabled, label: "Tertiary Disabled") {}
                EDTSButton(
                    btnType: .primary,
                    btnSize: .small,
                    btnState: .default,
                    label: "Gradient With Icon",
                    bgColorStart: EDTSColor.skyblueLeading,
                    bgColorEnd: EDTSColor.skyblueTrailing,
                    bgColorOrientation: .horizontal,
                    cornerRadius: 20,
                    iconLeading: Image(systemName: "star.fill"),
                    iconTrailing: Image(systemName: "star.fill"),
                    iconSpacing: 8,
                    iconSize: 8,
                    paddingTop: 8,
                    paddingBottom: 8,
                    paddingLeading: 12,
                    paddingTrailing: 12
                ) {}
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
