//
//  EDTSChip.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 07/09/26.
//

import SwiftUI

public enum ChipState: String {
    case inactive = "inactive"
    case active = "active"
}

public struct EDTSChip: View {
    // MARK: - Properties
    public let label: String?
    public let labelAttributed: AttributedString?
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String
    
    public var labelColor: Color?
    public var labelColorActive: Color?
    public var bgColor: Color?
    public var bgColorActive: Color?
    
    public var iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconTintColorLeadingActive: Color?
    public var iconBgColorLeading: Color?
    public var iconBgColorLeadingActive: Color?
    
    public var iconTrailing: Image?
    public var iconTintColorTrailing: Color?
    public var iconTintColorTrailingActive: Color?
    public var iconBgColorTrailing: Color?
    public var iconBgColorTrailingActive: Color?
    
    public var iconSize: CGFloat
    public var iconSpacing: CGFloat
    
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var borderWidthActive: CGFloat
    public var borderColor: Color?
    public var borderColorActive: Color?
    
    public var shadowOpacity: Float
    public var shadowOpacityActive: Float
    public var shadowRadius: CGFloat
    public var shadowRadiusActive: CGFloat
    public var shadowOffset: CGSize
    public var shadowOffsetActive: CGSize
    public var shadowColor: Color?
    public var shadowColorActive: Color?
    
    public var paddingTop: CGFloat?
    public var paddingBottom: CGFloat?
    public var paddingLeading: CGFloat?
    public var paddingTrailing: CGFloat?
    
    public var isActive: Bool
    
    // MARK: - Delegate
    public var onTapChip: (() -> Void)?
    public var onTapLeadingIcon: (() -> Void)?
    public var onTapTrailingIcon: (() -> Void)?
    
    // MARK: - Private Variable
    private let iconBadgePadding: CGFloat = 2
    private let iconBadgeRippleBleed: CGFloat = 2

    private var iconBadgeDiameter: CGFloat {
        resolvedIconSize + (iconBadgePadding * 2)
    }

    private var iconBadgeRippleSize: CGFloat {
        iconBadgeDiameter + (iconBadgeRippleBleed * 2)
    }
    
    private var customFont: Font {
        let weight = setupFontWeight(from: fontWeight)
        if !fontName.isEmpty {
            return .custom(fontName, size: fontSize == .zero ? 12 : fontSize)
        }
        return .system(size: fontSize == .zero ? 12 : fontSize, weight: weight)
    }
    
    private var hasCustomFont: Bool {
        !fontName.isEmpty || fontSize != .zero || !fontWeight.isEmpty
    }
    
    private var resolvedIconSize: CGFloat {
        if iconSize != .zero { return iconSize }
        return 16
    }
    
    private var resolvedIconSpacing: CGFloat {
        iconSpacing != .zero ? iconSpacing : 4
    }
    
    private var resolvedPaddingTop: CGFloat { paddingTop ?? 4 }
    private var resolvedPaddingBottom: CGFloat { paddingBottom ?? 4 }
    private var resolvedPaddingLeading: CGFloat { paddingLeading ?? 8 }
    private var resolvedPaddingTrailing: CGFloat { paddingTrailing ?? 8 }

    private var resolvedFontStyle: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.B3.Light : EDTSFont.Klik.B3.Semibold
    }
    
    private var resolvedShape: EDTSShape {
        if cornerRadius != .zero {
            return EDTSShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        return EDTSShape(Capsule())
    }
    
    private var resolvedInactiveBorderWidth: CGFloat {
        borderWidth != .zero ? borderWidth : 0
    }

    private var resolvedActiveBorderWidth: CGFloat {
        if borderWidthActive != .zero { return borderWidthActive }
        if borderWidth != .zero { return borderWidth }
        return EDTSColor.theme == .poinku ? 1 : 0
    }
    
    private struct ResolvedValues {
        var iconTintLeading: Color
        var iconBgLeading: Color
        var labelColor: Color
        var iconTintTrailing: Color
        var iconBgTrailing: Color
        var bgColor: Color
        var borderColor: Color
        var borderWidth: CGFloat
        var shadowOpacity: Float
        var shadowRadius: CGFloat
        var shadowOffset: CGSize
        var shadowColor: Color
    }
    
    private var resolvedStyle: ResolvedValues {
        let state: ChipState = isActive ? .active : .inactive
        switch state {
        case .inactive:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    iconTintLeading: iconTintColorLeading ?? EDTSColor.grey60,
                    iconBgLeading: iconBgColorLeading ?? .clear,
                    labelColor: labelColor ?? EDTSColor.grey80,
                    iconTintTrailing: iconTintColorTrailing ?? EDTSColor.grey60,
                    iconBgTrailing: iconBgColorTrailing ?? .clear,
                    bgColor: bgColor ?? EDTSColor.grey20,
                    borderColor: borderColor ?? .clear,
                    borderWidth: resolvedInactiveBorderWidth,
                    shadowOpacity: shadowOpacity != .zero ? shadowOpacity : .zero,
                    shadowRadius: shadowRadius != .zero ? shadowRadius : .zero,
                    shadowOffset: shadowOffset != .zero ? shadowOffset : .zero,
                    shadowColor: shadowColor ?? .clear
                )
            } else {
                return ResolvedValues(
                    iconTintLeading: iconTintColorLeading ?? EDTSColor.blue50,
                    iconBgLeading: iconBgColorLeading ?? .clear,
                    labelColor: labelColor ?? EDTSColor.blue50,
                    iconTintTrailing: iconTintColorTrailing ?? EDTSColor.blue50,
                    iconBgTrailing: iconBgColorTrailing ?? .clear,
                    bgColor: bgColor ?? EDTSColor.grey20,
                    borderColor: borderColor ?? .clear,
                    borderWidth: resolvedInactiveBorderWidth,
                    shadowOpacity: shadowOpacity != .zero ? shadowOpacity : .zero,
                    shadowRadius: shadowRadius != .zero ? shadowRadius : .zero,
                    shadowOffset: shadowOffset != .zero ? shadowOffset : .zero,
                    shadowColor: shadowColor ?? .clear
                )
            }
            
        case .active:
            if EDTSColor.theme == .poinku {
                return ResolvedValues(
                    iconTintLeading: iconTintColorLeadingActive ?? (iconTintColorLeading ?? EDTSColor.white),
                    iconBgLeading: iconBgColorLeadingActive ?? (iconBgColorLeading ?? .clear),
                    labelColor: labelColorActive ?? (labelColor ?? EDTSColor.white),
                    iconTintTrailing: iconTintColorTrailingActive ?? (iconTintColorTrailing ?? EDTSColor.white),
                    iconBgTrailing: iconBgColorTrailingActive ?? (iconBgColorTrailing ?? .clear),
                    bgColor: bgColorActive ?? (bgColor ?? EDTSColor.blue30),
                    borderColor: borderColorActive ?? (borderColor ?? EDTSColor.blue40),
                    borderWidth: resolvedActiveBorderWidth,
                    shadowOpacity: shadowOpacityActive != .zero ? shadowOpacityActive : (shadowOpacity != .zero ? shadowOpacity : .zero),
                    shadowRadius: shadowRadiusActive != .zero ? shadowRadiusActive : (shadowRadius != .zero ? shadowRadius : .zero),
                    shadowOffset: shadowOffsetActive != .zero ? shadowOffsetActive : (shadowOffset != .zero ? shadowOffset : .zero),
                    shadowColor: shadowColorActive ?? (shadowColor ?? .clear)
                )
            } else {
                return ResolvedValues(
                    iconTintLeading: iconTintColorLeadingActive ?? (iconTintColorLeading ?? EDTSColor.blue50),
                    iconBgLeading: iconBgColorLeadingActive ?? (iconBgColorLeading ?? EDTSColor.grey20),
                    labelColor: labelColorActive ?? (labelColor ?? EDTSColor.white),
                    iconTintTrailing: iconTintColorTrailingActive ?? (iconTintColorTrailing ?? EDTSColor.blue50),
                    iconBgTrailing: iconBgColorTrailingActive ?? (iconBgColorTrailing ?? EDTSColor.grey20),
                    bgColor: bgColorActive ?? (bgColor ?? EDTSColor.blue50),
                    borderColor: borderColorActive ?? (borderColor ?? .clear),
                    borderWidth: resolvedActiveBorderWidth,
                    shadowOpacity: shadowOpacityActive != .zero ? shadowOpacityActive : (shadowOpacity != .zero ? shadowOpacity : .zero),
                    shadowRadius: shadowRadiusActive != .zero ? shadowRadiusActive : (shadowRadius != .zero ? shadowRadius : .zero),
                    shadowOffset: shadowOffsetActive != .zero ? shadowOffsetActive : (shadowOffset != .zero ? shadowOffset : .zero),
                    shadowColor: shadowColorActive ?? (shadowColor ?? .clear)
                )
            }
        }
    }
    
    // MARK: - Initializers
    public init(
        label: String? = "Chip",
        labelAttributed: AttributedString? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String = "",
        labelColor: Color? = nil,
        labelColorActive: Color? = nil,
        bgColor: Color? = nil,
        bgColorActive: Color? = nil,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconTintColorLeadingActive: Color? = nil,
        iconBgColorLeading: Color? = nil,
        iconBgColorLeadingActive: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
        iconTintColorTrailingActive: Color? = nil,
        iconBgColorTrailing: Color? = nil,
        iconBgColorTrailingActive: Color? = nil,
        iconSize: CGFloat = .zero,
        iconSpacing: CGFloat = .zero,
        cornerRadius: CGFloat = .zero,
        borderWidth: CGFloat = .zero,
        borderWidthActive: CGFloat = .zero,
        borderColor: Color? = nil,
        borderColorActive: Color? = nil,
        shadowOpacity: Float = .zero,
        shadowOpacityActive: Float = .zero,
        shadowRadius: CGFloat = .zero,
        shadowRadiusActive: CGFloat = .zero,
        shadowOffset: CGSize = .zero,
        shadowOffsetActive: CGSize = .zero,
        shadowColor: Color? = nil,
        shadowColorActive: Color? = nil,
        paddingTop: CGFloat? = nil,
        paddingBottom: CGFloat? = nil,
        paddingLeading: CGFloat? = nil,
        paddingTrailing: CGFloat? = nil,
        isActive: Bool = false,
        onTapChip: (() -> Void)? = nil,
        onTapLeadingIcon: (() -> Void)? = nil,
        onTapTrailingIcon: (() -> Void)? = nil
    ) {
        self.label = labelAttributed == nil ? (label ?? "Chip") : nil
        self.labelAttributed = labelAttributed
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.labelColor = labelColor
        self.labelColorActive = labelColorActive
        self.bgColor = bgColor
        self.bgColorActive = bgColorActive
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconTintColorLeadingActive = iconTintColorLeadingActive
        self.iconBgColorLeading = iconBgColorLeading
        self.iconBgColorLeadingActive = iconBgColorLeadingActive
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.iconTintColorTrailingActive = iconTintColorTrailingActive
        self.iconBgColorTrailing = iconBgColorTrailing
        self.iconBgColorTrailingActive = iconBgColorTrailingActive
        self.iconSize = iconSize
        self.iconSpacing = iconSpacing
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderWidthActive = borderWidthActive
        self.borderColor = borderColor
        self.borderColorActive = borderColorActive
        self.shadowOpacity = shadowOpacity
        self.shadowOpacityActive = shadowOpacityActive
        self.shadowRadius = shadowRadius
        self.shadowRadiusActive = shadowRadiusActive
        self.shadowOffset = shadowOffset
        self.shadowOffsetActive = shadowOffsetActive
        self.shadowColor = shadowColor
        self.shadowColorActive = shadowColorActive
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.isActive = isActive
        self.onTapChip = onTapChip
        self.onTapLeadingIcon = onTapLeadingIcon
        self.onTapTrailingIcon = onTapTrailingIcon
    }
    
    // MARK: - Body
    public var body: some View {
        let values = resolvedStyle
        
        HStack(spacing: resolvedIconSpacing) {
            if let iconLeading {
                iconBadgeView(
                    icon: iconLeading,
                    tint: values.iconTintLeading,
                    bg: values.iconBgLeading,
                    onTap: onTapLeadingIcon
                )
            }
            
            labelView(color: values.labelColor)
            
            if let iconTrailing {
                iconBadgeView(
                    icon: iconTrailing,
                    tint: values.iconTintTrailing,
                    bg: values.iconBgTrailing,
                    onTap: onTapTrailingIcon
                )
            }
        }
        .padding(.top, resolvedPaddingTop)
        .padding(.bottom, resolvedPaddingBottom)
        .padding(.leading, resolvedPaddingLeading)
        .padding(.trailing, resolvedPaddingTrailing)
        .background(values.bgColor)
        .clipShape(resolvedShape)
        .overlay(resolvedShape.stroke(values.borderColor, lineWidth: values.borderWidth))
        .shadow(
            color: values.shadowColor.opacity(Double(values.shadowOpacity)),
            radius: values.shadowRadius,
            x: values.shadowOffset.width,
            y: values.shadowOffset.height
        )
        
        .rippleEffect(
            color: Color.black.opacity(0.12),
            cornerRadius: cornerRadius != .zero ? cornerRadius : 999,
            onTap: onTapChip
        )
        .animation(.easeInOut(duration: 0.25), value: isActive)
    }
    
    @ViewBuilder
    private func labelView(color: Color) -> some View {
        Group {
            if let labelAttributed {
                Text(labelAttributed)
            } else {
                Text(label ?? "Chip")
            }
        }
        .foregroundColor(color)
        .edtsFont(resolvedFontStyle, custom: fontStyle ?? (hasCustomFont ? customFont : nil))
    }
    
    @ViewBuilder
    private func iconBadgeView(
        icon: Image,
        tint: Color,
        bg: Color,
        onTap: (() -> Void)?
    ) -> some View {
        icon
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: resolvedIconSize, height: resolvedIconSize)
            .foregroundColor(tint)
            .padding(iconBadgePadding)
            .background(bg)
            .clipShape(Circle())
            .circularRippleEffect(size: iconBadgeRippleSize, color: Color.black.opacity(0.22))
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        onTap?()
                    }
            )
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var isActive = false
        
        var body: some View {
            VStack(spacing: 24) {
                EDTSChip(label: "Chip", isActive: isActive, onTapChip: {
                    isActive.toggle()
                })
                
                EDTSChip(
                    label: "With icons",
                    iconLeading: Image(systemName: "star.fill"),
                    iconTrailing: Image(systemName: "xmark"),
                    isActive: isActive,
                    onTapChip: { isActive.toggle() },
                    onTapLeadingIcon: { print("leading icon tapped") },
                    onTapTrailingIcon: { print("trailing icon tapped") }
                )
                
                EDTSChip(label: "Always active", isActive: true, onTapChip: {})
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
