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

    public let text: String?
    public let textAttributed: AttributedString?
    public var textColor: Color?
    public var textDangerColor: Color?
    public var textDisabledColor: Color?
    
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: Double
    public var fontWeight: String?
    
    public var bgColor: Color?
    public var bgDangerColor: Color?
    public var bgDisabledColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    
    public var rippleColor: Color?
    public var cornerRadius: Double?
    public var maxWidth: Double?
    
    public let iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconDangerTintColorLeading: Color?
    public var iconDisabledTintColorLeading: Color?
    
    public let iconTrailing: Image?
    public var iconTintColorTrailing: Color?
    public var iconDangerTintColorTrailing: Color?
    public var iconDisabledTintColorTrailing: Color?
    
    public var iconSpacing: Double
    public var iconSize: Double
    
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
    
    public var action: () -> Void
    
    // MARK: - State
    @State private var tempResolvedButtonState: BtnState? = nil
    
    // MARK: - Initializers
    public init(
        btnType: BtnType = .primary,
        btnSize: BtnSize = .large,
        btnState: BtnState = .default,
        text: String? = "Button",
        textAttributed: AttributedString? = nil,
        textColor: Color? = nil,
        textDangerColor: Color? = nil,
        textDisabledColor: Color? = nil,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: Double = .zero,
        fontWeight: String? = nil,
        bgColor: Color? = nil,
        bgDangerColor: Color? = nil,
        bgDisabledColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        rippleColor: Color? = nil,
        cornerRadius: Double? = nil,
        maxWidth: Double? = nil,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconDangerTintColorLeading: Color? = nil,
        iconDisabledTintColorLeading: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
        iconDangerTintColorTrailing: Color? = nil,
        iconDisabledTintColorTrailing: Color? = nil,
        iconSpacing: Double = .zero,
        iconSize: Double = .zero,
        borderWidth: Double = .zero,
        borderColor: Color? = nil,
        borderDangerColor: Color? = nil,
        borderDisabledColor: Color? = nil,
        shadowOpacity: Double = .zero,
        shadowRadius: Double = .zero,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        shadowDangerColor: Color? = nil,
        shadowDisabledColor: Color? = nil,
        paddingTop: Double? = nil,
        paddingBottom: Double? = nil,
        paddingLeading: Double? = nil,
        paddingTrailing: Double? = nil,
        action: @escaping () -> Void
    ) {
        self.btnType = btnType
        self.btnSize = btnSize
        self.btnState = btnState
        self.text = textAttributed == nil ? text : nil
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.textDangerColor = textDangerColor
        self.textDisabledColor = textDisabledColor
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
        self.maxWidth = maxWidth
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
    private let defaultFontSize: Double = 16
    private let pressedScale: Double = 0.95
    private let pressAnimationDuration: Double = 0.1
    private let rippleOpacity: Double = 0.12
    
    private let smallIconSize: Double = 16
    private let smallIconSpacing: Double = 8
    private let smallPoinkuPaddingHorizontal: Double = 8
    private let smallPoinkuPaddingVertical: Double = 4
    private let smallPoinkuCornerRadius: Double = 4
    private let smallKlikPaddingHorizontal: Double = 12
    private let smallKlikPaddingVertical: Double = 6
    private let smallKlikCornerRadius: Double = 6
    
    private let mediumIconSize: Double = 16
    private let mediumIconSpacing: Double = 8
    private let mediumPaddingVertical: Double = 8
    private let mediumPaddingHorizontal: Double = 12
    private let mediumPoinkuCornerRadius: Double = 4
    private let mediumKlikCornerRadius: Double = 6
    
    private let largeIconSize: Double = 24
    private let largeIconSpacing: Double = 8
    private let largePaddingVertical: Double = 8
    private let largePaddingHorizontal: Double = 12
    private let largePoinkuCornerRadius: Double = 8
    private let largeKlikCornerRadius: Double = 6
    
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
        var tempTextColor: Color?
        var tempBgColor: Color?
        var tempRippleColor: Color?
        var tempBorderColor: Color?
        var tempBorderWidth: Double = .zero
        var tempIconSize: Double = .zero
        var tempCornerRadius: Double = .zero
        var tempIconSpacing: Double = .zero
        var tempPaddingTop: Double = .zero
        var tempPaddingBottom: Double = .zero
        var tempPaddingLeading: Double = .zero
        var tempPaddingTrailing: Double = .zero
        var tempShadowColor: Color?
    }
    
    private var customFont: Font? {
        if let fontStyle { return fontStyle }
        guard !fontName.isEmpty || fontSize != .zero else { return nil }
        let resolvedSize = fontSize == .zero ? defaultFontSize : fontSize
        var font: Font = fontName.isEmpty
            ? .system(size: resolvedSize)
            : .custom(fontName, size: resolvedSize)
        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }
        return font
    }
    
    private let dragCancelThreshold: Double = 44
    
    // MARK: - Body
    public var body: some View {
        let values = setupBtnType()
        content(values: values)
            .padding(.top, values.tempPaddingTop)
            .padding(.bottom, values.tempPaddingBottom)
            .padding(.leading, values.tempPaddingLeading)
            .padding(.trailing, values.tempPaddingTrailing)
            .frame(maxWidth: maxWidth.map { CGFloat($0) })
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
            .scaleEffect(tempResolvedButtonState != nil ? pressedScale : 1.0)
            .animation(.easeInOut(duration: pressAnimationDuration), value: tempResolvedButtonState)
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
                if let textAttributed {
                    Text(textAttributed)
                } else {
                    Text(text ?? "Button")
                }
            }
            .font(customFont ?? setupFontStyle)
            .foregroundColor(values.tempTextColor)
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
    
    private var setupFontStyle: Font {
        switch EDTSColor.theme {
        case .klikIDM:
            switch resolvedButtonSize {
            case .small: return EDTSFont.Klik.Button.Small.font
            case .medium: return EDTSFont.Klik.Button.Medium.font
            case .large: return EDTSFont.Klik.Button.Large.font
            }
        case .poinku:
            switch resolvedButtonSize {
            case .small: return EDTSFont.Poinku.Button.Small.font
            case .medium: return EDTSFont.Poinku.Button.Medium.font
            case .large: return EDTSFont.Poinku.Button.Large.font
            }
        }
    }
    
    private func setupBtnSize() -> ResolvedValues {
        var values = ResolvedValues()
        
        switch resolvedButtonSize {
        case .small:
            if EDTSColor.theme == .poinku {
                values.tempPaddingLeading = paddingLeading ?? smallPoinkuPaddingHorizontal
                values.tempPaddingTrailing = paddingTrailing ?? smallPoinkuPaddingHorizontal
                values.tempPaddingTop = paddingTop ?? smallPoinkuPaddingVertical
                values.tempPaddingBottom = paddingBottom ?? smallPoinkuPaddingVertical
                values.tempCornerRadius = cornerRadius ?? smallPoinkuCornerRadius
            } else {
                values.tempPaddingLeading = paddingLeading ?? smallKlikPaddingHorizontal
                values.tempPaddingTrailing = paddingTrailing ?? smallKlikPaddingHorizontal
                values.tempPaddingTop = paddingTop ?? smallKlikPaddingVertical
                values.tempPaddingBottom = paddingBottom ?? smallKlikPaddingVertical
                values.tempCornerRadius = cornerRadius ?? smallKlikCornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? smallIconSize : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? smallIconSpacing : iconSpacing
            
        case .medium:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius ?? mediumPoinkuCornerRadius
            } else {
                values.tempCornerRadius = cornerRadius ?? mediumKlikCornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? mediumIconSize : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? mediumIconSpacing : iconSpacing
            values.tempPaddingTop = paddingTop ?? mediumPaddingVertical
            values.tempPaddingBottom = paddingBottom ?? mediumPaddingVertical
            values.tempPaddingLeading = paddingLeading ?? mediumPaddingHorizontal
            values.tempPaddingTrailing = paddingTrailing ?? mediumPaddingHorizontal
            
        case .large:
            if EDTSColor.theme == .poinku {
                values.tempCornerRadius = cornerRadius ?? largePoinkuCornerRadius
            } else {
                values.tempCornerRadius = cornerRadius ?? largeKlikCornerRadius
            }
            
            values.tempIconSize = iconSize == .zero ? largeIconSize : iconSize
            values.tempIconSpacing = iconSpacing == .zero ? largeIconSpacing : iconSpacing
            values.tempPaddingTop = paddingTop ?? largePaddingVertical
            values.tempPaddingBottom = paddingBottom ?? largePaddingVertical
            values.tempPaddingLeading = paddingLeading ?? largePaddingHorizontal
            values.tempPaddingTrailing = paddingTrailing ?? largePaddingHorizontal
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
            if textColor != nil {
                values.tempIconTintColorLeading = iconTintColorLeading == nil ? values.tempTextColor : values.tempIconTintColorLeading
                values.tempIconTintColorTrailing = iconTintColorTrailing == nil ? values.tempTextColor : values.tempIconTintColorTrailing
                values.tempBorderColor = borderColor == nil ? values.tempTextColor : values.tempBorderColor
            }
        }
        
        guard resolvedButtonState != .disabled else {
            values.tempRippleColor = .clear
            return
        }
        
        if rippleColor == nil {
            if values.tempBgColor == EDTSColor.white {
                values.tempRippleColor = values.tempTextColor?.opacity(rippleOpacity)
            } else if values.tempBgColor == .clear {
                values.tempRippleColor = values.tempTextColor?.opacity(rippleOpacity)
            } else if values.tempBgColor != EDTSColor.white {
                values.tempRippleColor = EDTSColor.grey70.opacity(rippleOpacity)
            }
        } else {
            if rippleColor == .clear {
                values.tempRippleColor = rippleColor
            } else {
                values.tempRippleColor = rippleColor?.opacity(rippleOpacity)
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
            values.tempTextColor = textColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.white
            values.tempTextColor = textDangerColor ?? EDTSColor.white
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.white
            values.tempBgColor = bgDangerColor ?? EDTSColor.red30
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempBgColor = bgDisabledColor ?? EDTSColor.grey30
            values.tempBorderColor = borderDisabledColor ?? EDTSColor.grey30
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.white
            values.tempTextColor = textDisabledColor ?? EDTSColor.white
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
                values.tempTextColor = textColor ?? EDTSColor.blue30
                values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blue30
                values.tempBorderColor = borderColor ?? EDTSColor.blue30
            } else {
                values.tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.blue50
                values.tempTextColor = textColor ?? EDTSColor.blue50
                values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blue50
                values.tempBorderColor = borderColor ?? EDTSColor.blue50
            }
            
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.red30
            values.tempTextColor = textDangerColor ?? EDTSColor.red30
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.red30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.grey30
            values.tempTextColor = textDisabledColor ?? EDTSColor.grey30
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
            values.tempTextColor = textColor ?? EDTSColor.grey60
            values.tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.grey60
            values.tempBgColor = bgColor ?? EDTSColor.white
            values.tempBorderColor = borderColor ?? EDTSColor.grey60
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowColor
            
        case .danger:
            values.tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.red30
            values.tempTextColor = textDangerColor ?? EDTSColor.red30
            values.tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.red30
            values.tempBgColor = bgDangerColor ?? EDTSColor.white
            values.tempBorderColor = borderDangerColor ?? EDTSColor.grey30
            values.tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            values.tempShadowColor = shadowDangerColor ?? shadowColor
            
        case .disabled:
            values.tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.grey30
            values.tempTextColor = textDisabledColor ?? EDTSColor.grey30
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
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .default, text: "Primary Default") {}
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .danger, text: "Primary Danger") {}
                EDTSButton(btnType: .primary, btnSize: .large, btnState: .disabled, text: "Primary Disabled") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .default, text: "Secondary Default") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .danger, text: "Secondary Danger") {}
                EDTSButton(btnType: .secondary, btnSize: .medium, btnState: .disabled, text: "Secondary Disabled") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .default, text: "Tertiary Default") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .danger, text: "Tertiary Danger") {}
                EDTSButton(btnType: .tertiary, btnSize: .small, btnState: .disabled, text: "Tertiary Disabled") {}
                EDTSButton(
                    btnType: .primary,
                    btnSize: .small,
                    btnState: .default,
                    text: "Gradient With Icon",
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
