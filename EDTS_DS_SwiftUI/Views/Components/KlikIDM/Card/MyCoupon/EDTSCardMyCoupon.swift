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
    public var cornerRadius: CGFloat

    public let iconLeading: Image?
    public var iconTintColorLeading: Color?
    public var iconBgColorLeading: Color?

    public let iconTrailing: Image?
    public var iconTintColorTrailing: Color?

    public var isLiquidGlassBg: Bool
    public var badge: EDTSSignifier?
    public var onTap: (() -> Void)?

    // MARK: - Private Variable
    @State private var isPressed: Bool = false
    
    private let defaultTitleFontSize: CGFloat = 14
    private let defaultDescFontSize: CGFloat = 12
    private let defaultTitleFontWeight: String = "semibold"
    private let defaultDescFontWeight: String = "regular"

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
        titleColor: Color? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: CGFloat? = nil,
        titleFontWeight: String? = nil,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color? = nil,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: CGFloat? = nil,
        descFontWeight: String? = nil,
        bgColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        iconLeading: Image? = nil,
        iconTintColorLeading: Color? = nil,
        iconBgColorLeading: Color? = nil,
        iconTrailing: Image? = nil,
        iconTintColorTrailing: Color? = nil,
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
        self.cornerRadius = cornerRadius
        self.iconLeading = iconLeading
        self.iconTintColorLeading = iconTintColorLeading
        self.iconBgColorLeading = iconBgColorLeading
        self.iconTrailing = iconTrailing
        self.iconTintColorTrailing = iconTintColorTrailing
        self.isLiquidGlassBg = isLiquidGlassBg
        self.badge = badge
        self.onTap = onTap
    }

    // MARK: - Body
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            leadingIconView
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 4) {
                    titleView
                    if let badge {
                        badge
                    }
                }
                descView
            }

            Spacer(minLength: 0)

            trailingIconView
        }
        .padding(12)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .scaleEffect(isPressed ? 0.97 : 1)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    // Mirrors UIKit's `guard !cvBadge.isSkeleton else { return }`.
                    guard badge?.isSkeleton != true else { return }
                    onTap?()
                }
        )
    }

    private var leadingIconView: some View {
        let color = iconBgColorLeading ?? EDTSColor.white
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.5), color],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 24
                    )
                )
                .opacity(0.3)

            if let iconLeading {
                iconLeading
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(iconTintColorLeading ?? EDTSColor.white)
            }
        }
        .frame(width: 32, height: 32)
    }

    private var trailingIconView: some View {
        Group {
            if let iconTrailing {
                iconTrailing
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 16, height: 16)
        .foregroundColor(iconTintColorTrailing ?? EDTSColor.white)
    }

    private var titleView: some View {
        Group {
            if let titleAttributed {
                Text(titleAttributed)
            } else {
                Text(title ?? "")
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
                Text(desc ?? "")
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
                title: "20% Off Voucher",
                desc: "Valid until end of month",
                iconLeading: Image(systemName: "ticket.fill"),
                badge: EDTSSignifier(text: "3"),
                onTap: {}
            )

            EDTSCardMyCoupon(
                title: "Free Shipping",
                desc: "Min. purchase Rp50.000",
                bgColor: EDTSColor.grey70,
                iconLeading: Image(systemName: "shippingbox.fill"),
                isLiquidGlassBg: false,
                onTap: {}
            )
        }
        .padding()
    }
}
