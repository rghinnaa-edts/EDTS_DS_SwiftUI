//
//  EDTSToggle.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

// MARK: - EDTSToggle

public struct EDTSToggle: View {

    private var title: String?
    private var titleAttributed: AttributedString?
    private var titleColor: Color
    private var titleFontStyle: Font?
    private var titleFontName: String
    private var titleFontSize: Double
    private var desc: String?
    private var descAttributed: AttributedString?
    private var descColor: Color
    private var descFontStyle: Font?
    private var descFontName: String
    private var descFontSize: Double
    private var trackTintColor: Color
    private var trackActiveTintColor: Color
    private var trackWidth: Double
    private var indicatorTintColor: Color
    private var indicatorActiveTintColor: Color
    private var indicatorPadding: Double
    private var indicatorSize: Double
    private var icon: Image?
    private var iconActive: Image?
    private var iconTintColor: Color
    private var iconActiveTintColor: Color
    private var iconPadding: CGFloat
    private var spacing: Double
    private var textSpacing: Double
    private var shadowColor: Color
    private var shadowOpacity: Double
    private var shadowOffset: CGSize
    private var shadowRadius: Double
    private var indicatorShadowColor: Color
    private var indicatorShadowOpacity: Double
    private var indicatorShadowOffset: CGSize
    private var indicatorShadowRadius: Double
    private var cornerRadius: Double?
    private var toggleAnimation: Animation

    @Binding private var isActive: Bool
    private var onToggle: ((Bool) -> Void)?

    // MARK: - Init

    public init(
        isActive: Binding<Bool>,
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color = EDTSColor.grey70,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: Double = .zero,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color = EDTSColor.grey60,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: Double = .zero,
        trackTintColor: Color = EDTSColor.grey30,
        trackActiveTintColor: Color = EDTSColor.blue50,
        trackWidth: Double = 44,
        indicatorTintColor: Color = EDTSColor.white,
        indicatorActiveTintColor: Color = EDTSColor.white,
        indicatorPadding: Double = 2,
        indicatorSize: Double = 16,
        icon: Image? = nil,
        iconActive: Image? = nil,
        iconTintColor: Color = EDTSColor.white,
        iconActiveTintColor: Color = EDTSColor.white,
        iconPadding: CGFloat = 0,
        spacing: Double = 8,
        textSpacing: Double = 4,
        cornerRadius: Double? = nil,
        shadowColor: Color = .black,
        shadowOpacity: Double = 0.0,
        shadowOffset: CGSize = .zero,
        shadowRadius: Double = 0.0,
        indicatorShadowColor: Color = EDTSColor.grey50,
        indicatorShadowOpacity: Double = 0.15,
        indicatorShadowOffset: CGSize = CGSize(width: 0, height: 1),
        indicatorShadowRadius: Double = 3,
        toggleAnimation: Animation = .spring(response: 0.25, dampingFraction: 0.75),
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self._isActive = isActive
        self.title = title
        self.titleAttributed = titleAttributed
        self.titleColor = titleColor
        self.titleFontStyle = titleFontStyle
        self.titleFontName = titleFontName
        self.titleFontSize = titleFontSize
        self.desc = desc
        self.descAttributed = descAttributed
        self.descColor = descColor
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.trackTintColor = trackTintColor
        self.trackActiveTintColor = trackActiveTintColor
        self.trackWidth = trackWidth
        self.indicatorTintColor = indicatorTintColor
        self.indicatorActiveTintColor = indicatorActiveTintColor
        self.indicatorPadding = indicatorPadding
        self.indicatorSize = indicatorSize
        self.icon = icon
        self.iconActive = iconActive
        self.iconTintColor = iconTintColor
        self.iconActiveTintColor = iconActiveTintColor
        self.iconPadding = iconPadding
        self.spacing = spacing
        self.textSpacing = textSpacing
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.indicatorShadowColor = indicatorShadowColor
        self.indicatorShadowOpacity = indicatorShadowOpacity
        self.indicatorShadowOffset = indicatorShadowOffset
        self.indicatorShadowRadius = indicatorShadowRadius
        self.toggleAnimation = toggleAnimation
        self.onToggle = onToggle
    }

    private var hasLabel: Bool {
        (title?.isEmpty == false) || (desc?.isEmpty == false) ||
        titleAttributed != nil || descAttributed != nil
    }

    private var resolvedCornerRadius: CGFloat {
        cornerRadius ?? ((indicatorSize + (indicatorPadding * 2)) / 2)
    }

    private var containerHeight: CGFloat {
        indicatorSize + (indicatorPadding * 2)
    }

    private var currentImage: Image? {
        isActive ? (iconActive ?? icon) : icon
    }

    // MARK: - Fonts

    private var setupTitleFont: Font {
        if let titleFontStyle {
            return titleFontStyle
        }

        if titleFontName.isEmpty && titleFontSize <= 0 {
            return EDTSFont.Klik.B2.Medium.font
        }

        let size = titleFontSize > 0 ? CGFloat(titleFontSize) : UIFont.systemFontSize
        return titleFontName.isEmpty ? .system(size: size) : .custom(titleFontName, size: size)
    }

    private var setupDescFont: Font {
        if let descFontStyle {
            return descFontStyle
        }

        if descFontName.isEmpty && descFontSize <= 0 {
            return EDTSFont.Klik.B3.Regular.font
        }

        let size = descFontSize > 0 ? CGFloat(descFontSize) : UIFont.systemFontSize
        return descFontName.isEmpty ? .system(size: size) : .custom(descFontName, size: size)
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .center, spacing: hasLabel ? spacing : 0) {
            trackView
            if hasLabel {
                labelStack
            }
        }
    }

    // MARK: - Track and Indicator

    private var trackView: some View {
        ZStack(alignment: isActive ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: resolvedCornerRadius, style: .continuous)
                .fill(isActive ? trackActiveTintColor : trackTintColor)
                .frame(width: trackWidth, height: containerHeight)
                .shadow(
                    color: shadowColor.opacity(shadowOpacity),
                    radius: shadowRadius,
                    x: shadowOffset.width,
                    y: shadowOffset.height
                )

            indicatorView
                .padding(isActive ? .trailing : .leading, indicatorPadding)
        }
        .frame(width: trackWidth, height: containerHeight)
        .contentShape(Rectangle())
        .onTapGesture {
            handleToggleTap()
        }
        .animation(toggleAnimation, value: isActive)
    }

    private var indicatorView: some View {
        RoundedRectangle(cornerRadius: resolvedCornerRadius, style: .continuous)
            .fill(isActive ? indicatorActiveTintColor : indicatorTintColor)
            .frame(width: indicatorSize, height: indicatorSize)
            .shadow(
                color: indicatorShadowColor.opacity(indicatorShadowOpacity),
                radius: indicatorShadowRadius,
                x: indicatorShadowOffset.width,
                y: indicatorShadowOffset.height
            )
            .overlay {
                if let currentImage {
                    currentImage
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(isActive ? iconActiveTintColor : iconTintColor)
                        .padding(iconPadding)
                        .frame(width: indicatorSize, height: indicatorSize)
                }
            }
    }

    // MARK: - Labels

    private var labelStack: some View {
        VStack(alignment: .leading, spacing: textSpacing) {
            if let titleAttributed {
                Text(titleAttributed)
            } else if let title, !title.isEmpty {
                Text(title)
                    .font(setupTitleFont)
                    .foregroundColor(titleColor)
            }

            if let descAttributed {
                Text(descAttributed)
            } else if let desc, !desc.isEmpty {
                Text(desc)
                    .font(setupDescFont)
                    .foregroundColor(descColor)
            }
        }
    }

    // MARK: - Toggle Logic

    private func handleToggleTap() {
        isActive.toggle()
        onToggle?(isActive)
    }
}

// MARK: - Preview

#Preview("Track only") {
    struct PreviewWrapper: View {
        @State private var isOn = true
        var body: some View {
            EDTSToggle(isActive: $isOn)
                .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("With label") {
    struct PreviewWrapper: View {
        @State private var isOn = false
        var body: some View {
            EDTSToggle(
                isActive: $isOn,
                title: "Title Here",
                desc: "Body text"
            )
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("With system image icon") {
    struct PreviewWrapper: View {
        @State private var isOn = false
        var body: some View {
            EDTSToggle(
                isActive: $isOn,
                title: "Title Here",
                desc: "Body text",
                icon: Image(systemName: "bell"),
                iconActive: Image(systemName: "bell.fill"),
                iconTintColor: EDTSColor.grey50,
                iconActiveTintColor: EDTSColor.blue50,
                iconPadding: 2
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
