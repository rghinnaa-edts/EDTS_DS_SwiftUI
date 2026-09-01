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
    public var btnType: BtnType
    public var btnSize: BtnSize
    public var btnState: BtnState

    public let label: String?
    public let labelAttributed: AttributedString?
    public var labelColor: Color?
    public var labelDangerColor: Color?
    public var labelDisabledColor: Color?
    
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?
    
    public var bgColor: Color?
    public var bgDangerColor: Color?
    public var bgDisabledColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    
    public var rippleColor: Color?
    public var cornerRadius: CGFloat
    
    public let iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconDangerTintColorLeading: Color?
    public var iconDisabledTintColorLeading: Color?
    
    public let iconTrailing: Image?
    public var iconTintColorTrailing: Color?
    public var iconDangerTintColorTrailing: Color?
    public var iconDisabledTintColorTrailing: Color?
    
    public var iconSpacing: CGFloat
    public var iconSize: CGFloat
    
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
    
    public var action: () -> Void
    
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
        labelDangerColor: Color? = nil,
        labelDisabledColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        bgColor: Color? = nil,
        bgDangerColor: Color? = nil,
        bgDisabledColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        rippleColor: Color? = nil,
        cornerRadius: CGFloat = -1.0,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconDangerTintColorLeading: Color? = nil,
        iconDisabledTintColorLeading: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
        iconDangerTintColorTrailing: Color? = nil,
        iconDisabledTintColorTrailing: Color? = nil,
        iconSpacing: CGFloat = .zero,
        iconSize: CGFloat = .zero,
        borderWidth: CGFloat = .zero,
        borderColor: Color? = nil,
        borderDangerColor: Color? = nil,
        borderDisabledColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: CGFloat = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
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
        self.labelDangerColor = labelDangerColor
        self.labelDisabledColor = labelDisabledColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.bgColor = bgColor
        self.bgDangerColor = bgDangerColor
        self.bgDisabledColor = bgDisabledColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
        self.rippleColor = rippleColor
        self.cornerRadius = cornerRadius
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconDangerTintColorLeading = iconDangerTintColorLeading
        self.iconDisabledTintColorLeading = iconDisabledTintColorLeading
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.iconDangerTintColorTrailing = iconDangerTintColorTrailing
        self.iconDisabledTintColorTrailing = iconDisabledTintColorTrailing
        self.iconSpacing = iconSpacing
        self.iconSize = iconSize
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderDangerColor = borderDangerColor
        self.borderDisabledColor = borderDisabledColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
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
    
    private var customFont: Font? {
        if let fontStyle { return fontStyle }
        guard !fontName.isEmpty || fontSize != .zero else { return nil }
        let resolvedSize = fontSize == .zero ? 16 : fontSize
        var font: Font = fontName.isEmpty
            ? .system(size: resolvedSize)
            : .custom(fontName, size: resolvedSize)
        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }
        return font
    }
    
    private let dragCancelThreshold: CGFloat = 44
    
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
        HStack(spacing: values.tempIconSpacing) {
            if let iconLeading {
                iconLeading
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: values.tempIconSize, height: values.tempIconSize)
                    .foregroundColor(values.tempIconTintColorLeading)
            }
            
            Group {
                if let labelAttributed {
                    Text(labelAttributed)
                } else {
                    Text(label ?? "Button")
                }
            }
            .edtsFont(setupFontStyle, custom: customFont)
            .foregroundColor(values.tempLabelColor)
            .multilineTextAlignment(.center)
            
            if let iconTrailing {
                iconTrailing
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: values.tempIconSize, height: values.tempIconSize)
                    .foregroundColor(values.tempIconTintColorTrailing)
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
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            } else {
                values.tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
                values.tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
                values.tempCornerRadius = cornerRadius == defaultValue ? 6 : cornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? 16 : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? 8 : iconSpacing
            values.tempPaddingTop = paddingTop == defaultValue ? 6 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 6 : paddingBottom
            
        case .medium:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 6 : cornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? 16 : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? 8 : iconSpacing
            values.tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            values.tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            values.tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            values.tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .large:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
            } else {
                values.tempCornerRadius = cornerRadius == defaultValue ? 6 : cornerRadius
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
    
    private func setupBtnType() -> ResolvedValues {
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
        
        setupBtnStyle(into: &btnSize)
        
        return btnSize
    }
    
    private func setupBtnStyle(into values: inout ResolvedValues) {
        switch resolvedButtonType {
        case .primary:
            break
            
        case .secondary, .tertiary:
            if labelColor != nil {
                values.tempIconTintColorLeading = iconTintColorLeading == nil ? values.tempLabelColor : values.tempIconTintColorLeading
                values.tempIconTintColorTrailing = iconTintColorTrailing == nil ? values.tempLabelColor : values.tempIconTintColorTrailing
                values.tempBorderColor = borderColor == nil ? values.tempLabelColor : values.tempBorderColor
            }
        }
        
        guard resolvedButtonState != .disabled else {
            values.tempRippleColor = .clear
            return
        }
        
        if rippleColor == nil {
            if values.tempBgColor == EDTSColor.white {
                values.tempRippleColor = values.tempLabelColor?.opacity(0.12)
            } else if values.tempBgColor == .clear {
                values.tempRippleColor = values.tempLabelColor?.opacity(0.12)
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
            
            values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.white
            values.tempLabelColor = labelDangerColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.white
            values.tempBgColor = bgDangerColor ?? EDTSColor.red30
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempBgColor = bgDisabledColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
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
                values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.blue50
                values.tempLabelColor = labelColor ?? EDTSColor.blue50
                values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blue50
                values.tempBorderColor = borderColor ?? EDTSColor.blue50
            }
            
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.red30
            values.tempLabelColor = labelDangerColor ?? EDTSColor.red30
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.grey30
            values.tempLabelColor = labelDisabledColor ?? EDTSColor.grey30
            values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDisabledColor ?? shadowColor
        }
    }
    
    private func setupBtnTertiary(_ state: BtnState, into values: inout ResolvedValues) {
        switch state {
        case .default:
            values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.grey60
            values.tempLabelColor = labelColor ?? EDTSColor.grey60
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.grey60
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderColor = borderColor ?? EDTSColor.grey60
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.errorStrong
            values.tempLabelColor = labelDangerColor ?? EDTSColor.errorStrong
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.errorStrong
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.disabled
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.grey30
            values.tempLabelColor = labelDisabledColor ?? EDTSColor.grey30
            values.tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempBgColor = bgDisabledColor ?? EDTSColor.white
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
                    bgColorOrientation: .vertical,
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
