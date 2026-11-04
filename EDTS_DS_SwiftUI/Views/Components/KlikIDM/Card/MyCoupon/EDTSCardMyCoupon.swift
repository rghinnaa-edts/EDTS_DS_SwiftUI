//
//  EDTSCardMyCoupon.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 05/10/26.
//

import SwiftUI

public struct EDTSCardMyCoupon: View {
    // MARK: - Properties
    public let title: String?
    public let titleAttributed: AttributedString?
    public var titleColor: Color?
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: CGFloat?
    public var titleFontWeight: String?

    public let desc: String?
    public let descAttributed: AttributedString?
    public var descColor: Color?
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: CGFloat?
    public var descFontWeight: String?
    public var bgColor: Color?
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    public var iconSpacing: CGFloat
    public var textSpacing: CGFloat
    public var cornerRadius: CGFloat

    public let iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconBgColorLeading: Color?
    public var iconLeadingSize: CGFloat
    public var iconLeadingPadding: CGFloat

    public let iconTrailing: Image?
    public var iconTintColorTrailing: Color?
    public var iconBgColorTrailing: Color?
    public var iconTrailingSize: CGFloat
    public var iconTrailingPadding: CGFloat
    
    public var borderWidth: CGFloat
    public var borderColor: Color?

    public var shadowOpacity: Double
    public var shadowRadius: Double
    public var shadowOffset: CGSize
    public var shadowColor: Color?
    
    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    public var isLiquidGlassBg: Bool
    public var badge: EDTSSignifier?
    public var onTap: (() -> Void)?

    // MARK: - Private Variable
    @State private var isPressed: Bool = false
    
    private let defaultTitleFontSize: CGFloat = 14
    private let defaultDescFontSize: CGFloat = 12
    private let defaultTitleFontWeight: String = "semibold"
    private let defaultDescFontWeight: String = "regular"
    private let fallbackTitle: String = "Title Text"
    private let fallbackDesc: String = "Description Text"

    private let titleBadgeSpacing: CGFloat = 4

    private let pressedScale: CGFloat = 0.97
    private let restingScale: CGFloat = 1
    private let pressAnimationDuration: Double = 0.1

    private var defaultIconBgStartColor: Color { EDTSColor.white.opacity(0.15) }
    private var defaultIconBgEndColor: Color { EDTSColor.white.opacity(0.3) }

    private var resolvedTitle: String {
        if let title, !title.isEmpty { return title }
        return fallbackTitle
    }

    private var resolvedDesc: String {
        if let desc, !desc.isEmpty { return desc }
        return fallbackDesc
    }

    private var leadingContainerSize: CGFloat { iconLeadingSize + iconLeadingPadding * 2 }
    private var trailingContainerSize: CGFloat { iconTrailingSize + iconTrailingPadding * 2 }

    private var resolvedTitleFont: Font {
        if let titleFontStyle { return titleFontStyle }
        let size = titleFontSize ?? defaultTitleFontSize
        if !titleFontName.isEmpty {
            return .custom(titleFontName, size: size)
        }
        let weight = (titleFontWeight ?? "").isEmpty ? defaultTitleFontWeight : (titleFontWeight ?? "")
        return .system(size: size, weight: setupFontWeight(from: weight))
    }

    private var resolvedDescFont: Font {
        if let descFontStyle { return descFontStyle }
        let size = descFontSize ?? defaultDescFontSize
        if !descFontName.isEmpty {
            return .custom(descFontName, size: size)
        }
        let weight = (descFontWeight ?? "").isEmpty ? defaultDescFontWeight : (descFontWeight ?? "")
        return .system(size: size, weight: setupFontWeight(from: weight))
    }


    // MARK: - Initializer
    public init(
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color? = EDTSColor.white,
        titleFontStyle: Font? = EDTSFont.Klik.B2.Semibold.font,
        titleFontName: String = "",
        titleFontSize: CGFloat? = nil,
        titleFontWeight: String? = nil,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color? = EDTSColor.grey30,
        descFontStyle: Font? = EDTSFont.Klik.B3.Regular.font,
        descFontName: String = "",
        descFontSize: CGFloat? = nil,
        descFontWeight: String? = nil,
        bgColor: Color? = nil,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        bgColorOrientation: Orientation? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        shadowOpacity: Double = 0,
        shadowRadius: Double = 0,
        shadowOffset: CGSize = .zero,
        shadowColor: Color? = nil,
        paddingTop: CGFloat = 12,
        paddingBottom: CGFloat = 12,
        paddingLeading: CGFloat = 12,
        paddingTrailing: CGFloat = 12,
        iconSpacing: CGFloat = 8,
        textSpacing: CGFloat = 4,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconBgColorLeading: Color? = nil,
        iconLeadingSize: CGFloat = 24,
        iconLeadingPadding: CGFloat = 4,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = EDTSColor.white,
        iconBgColorTrailing: Color? = nil,
        iconTrailingSize: CGFloat = 16,
        iconTrailingPadding: CGFloat = 4,
        isLiquidGlassBg: Bool = true,
        badge: EDTSSignifier? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = titleAttributed == nil ? title : nil
        self.titleAttributed = titleAttributed
        self.titleColor = titleColor
        self.titleFontStyle = titleFontStyle
        self.titleFontName = titleFontName
        self.titleFontSize = titleFontSize
        self.titleFontWeight = titleFontWeight
        self.desc = descAttributed == nil ? desc : nil
        self.descAttributed = descAttributed
        self.descColor = descColor
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.descFontWeight = descFontWeight
        self.bgColor = bgColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
        self.iconSpacing = iconSpacing
        self.textSpacing = textSpacing
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconBgColorLeading = iconBgColorLeading
        self.iconLeadingSize = iconLeadingSize
        self.iconLeadingPadding = iconLeadingPadding
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.iconBgColorTrailing = iconBgColorTrailing
        self.iconTrailingSize = iconTrailingSize
        self.iconTrailingPadding = iconTrailingPadding
        self.isLiquidGlassBg = isLiquidGlassBg
        self.badge = badge
        self.onTap = onTap
    }

    // MARK: - Body
    public var body: some View {
        HStack(alignment: .center, spacing: iconSpacing) {
            leadingIconView

            VStack(alignment: .leading, spacing: textSpacing) {
                HStack(alignment: .center, spacing: titleBadgeSpacing) {
                    titleView
                    if let badge {
                        badge
                    }
                }
                descView
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            trailingIconView
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.leading, paddingLeading)
        .padding(.trailing, paddingTrailing)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            if !isLiquidGlassBg && borderWidth > 0 {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(borderColor ?? .clear, lineWidth: borderWidth)
            }
        }
        .shadow(
            color: (shadowColor ?? .clear).opacity(shadowOpacity),
            radius: shadowRadius,
            x: shadowOffset.width,
            y: shadowOffset.height
        )
        .scaleEffect(isPressed ? pressedScale : restingScale)
        .animation(.easeInOut(duration: pressAnimationDuration), value: isPressed)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    onTap?()
                }
        )
    }

    @ViewBuilder
    private var leadingIconBackground: some View {
        if let iconBgColorLeading {
            Circle().fill(iconBgColorLeading)
        } else {
            Circle().fill(
                RadialGradient(
                    colors: [defaultIconBgStartColor, defaultIconBgEndColor],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: leadingContainerSize
                )
            )
        }
    }

    @ViewBuilder
    private var leadingIconView: some View {
        if let iconLeading {
            ZStack {
                leadingIconBackground

                iconLeading
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconLeadingSize, height: iconLeadingSize)
                    .foregroundColor(iconTintColorLeading)
            }
            .frame(width: leadingContainerSize, height: leadingContainerSize)
        }
    }

    @ViewBuilder
    private var trailingIconView: some View {
        if let iconTrailing {
            ZStack {
                if let iconBgColorTrailing {
                    Circle().fill(iconBgColorTrailing)
                } else {
                    Circle().fill(
                        RadialGradient(
                            colors: [defaultIconBgStartColor, defaultIconBgEndColor],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: trailingContainerSize
                        )
                    )
                }

                iconTrailing
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconTrailingSize, height: iconTrailingSize)
                    .foregroundColor(iconTintColorTrailing ?? EDTSColor.white)
            }
            .frame(width: trailingContainerSize, height: trailingContainerSize)
        }
    }

    private var titleView: some View {
        Group {
            if let titleAttributed {
                Text(titleAttributed)
            } else {
                Text(resolvedTitle)
            }
        }
        .font(resolvedTitleFont)
        .foregroundColor(titleColor ?? EDTSColor.white)
        .lineLimit(1)
    }

    private var descView: some View {
        Group {
            if let descAttributed {
                Text(descAttributed)
            } else {
                Text(resolvedDesc)
            }
        }
        .font(resolvedDescFont)
        .foregroundColor(descColor ?? EDTSColor.grey30)
        .lineLimit(1)
    }

    @ViewBuilder
    private var backgroundView: some View {
        if isLiquidGlassBg {
            if #available(iOS 26.0, *) {
                Color.clear
                    .glassEffect(.clear, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            } else {
                EDTSLiquidGlassBackground(cornerRadius: cornerRadius)
            }
        } else if bgColorStart != nil || bgColorEnd != nil {
            let orientation = bgColorOrientation ?? .horizontal
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [bgColorStart ?? .clear, bgColorEnd ?? .clear],
                        startPoint: orientation == .horizontal ? .leading : .top,
                        endPoint: orientation == .horizontal ? .trailing : .bottom
                    )
                )
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(bgColor ?? .clear)
        }
    }
}

// MARK: - Preview
#Preview("Preview") {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

        VStack(spacing: 16) {
            EDTSCardMyCoupon(
                title: "Kupon Saya",
                desc: "Kumpulan kupon yang kamu punya",
                iconLeading: Image("img_coupon"),
                iconTrailing: Image("ic_chevron_right"),
                iconBgColorTrailing: .clear,
                badge: EDTSSignifier(text: "9"),
                onTap: {}
            )

            EDTSCardMyCoupon(
                title: "Free Shipping",
                desc: "Min. purchase Rp50.000",
                bgColor: EDTSColor.grey70,
                iconLeading: Image(systemName: "shippingbox.fill"),
                iconTintColorLeading: .white,
                iconTrailing: Image("ic_chevron_right"),
                isLiquidGlassBg: false,
                onTap: {}
            )
            EDTSCardMyCoupon()
        }
        .padding()
    }
}
