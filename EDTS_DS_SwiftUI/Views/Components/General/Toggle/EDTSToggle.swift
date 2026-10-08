//
//  EDTSToggle.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

// MARK: - EDTSToggle

public struct EDTSToggle: View {

    public var title: String?
    public var titleAttributed: AttributedString?
    public var titleColor: Color
    public var titleFontStyle: Font?
    public var titleFontName: String
    public var titleFontSize: Double
    public var titleFontWeight: String
    public var desc: String?
    public var descAttributed: AttributedString?
    public var descColor: Color
    public var descFontStyle: Font?
    public var descFontName: String
    public var descFontSize: Double
    public var descFontWeight: String
    public var trackTintColor: Color
    public var trackActiveTintColor: Color
    public var trackWidth: Double
    public var indicatorTintColor: Color
    public var indicatorActiveTintColor: Color
    public var indicatorPadding: Double
    public var indicatorSize: Double
    public var icon: Image?
    public var iconActive: Image?
    public var iconTintColor: Color
    public var iconActiveTintColor: Color
    public var iconPadding: CGFloat
    public var spacing: Double
    public var textSpacing: Double
    public var shadowColor: Color
    public var shadowOpacity: Double
    public var shadowOffset: CGSize
    public var shadowRadius: Double
    public var indicatorShadowColor: Color
    public var indicatorShadowOpacity: Double
    public var indicatorShadowOffset: CGSize
    public var indicatorShadowRadius: Double
    public var cornerRadius: Double?
    public var toggleAnimation: Animation

    @Binding public var isActive: Bool
    public var onToggle: ((Bool) -> Void)?
    
    private var hasLabel: Bool {
        hasTitle || hasDesc
    }

    private var hasTitle: Bool {
        titleAttributed != nil || (title?.isEmpty == false)
    }

    private var hasDesc: Bool {
        descAttributed != nil || (desc?.isEmpty == false)
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

        guard !titleFontName.isEmpty || titleFontSize > 0 || !titleFontWeight.isEmpty else {
            return EDTSFont.Klik.B2.Medium.font
        }

        let size = titleFontSize > 0 ? CGFloat(titleFontSize) : UIFont.systemFontSize
        var font: Font = titleFontName.isEmpty ? .system(size: size) : .custom(titleFontName, size: size)

        if !titleFontWeight.isEmpty {
            font = font.weight(setupFontWeight(from: titleFontWeight))
        }

        return font
    }

    private var setupDescFont: Font {
        if let descFontStyle {
            return descFontStyle
        }

        guard !descFontName.isEmpty || descFontSize > 0 || !descFontWeight.isEmpty else {
            return EDTSFont.Klik.B3.Regular.font
        }

        let size = descFontSize > 0 ? CGFloat(descFontSize) : UIFont.systemFontSize
        var font: Font = descFontName.isEmpty ? .system(size: size) : .custom(descFontName, size: size)

        if !descFontWeight.isEmpty {
            font = font.weight(setupFontWeight(from: descFontWeight))
        }

        return font
    }

    // MARK: - Init

    public init(
        isActive: Binding<Bool>,
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color = EDTSColor.grey70,
        titleFontStyle: Font? = nil,
        titleFontName: String = "",
        titleFontSize: Double = .zero,
        titleFontWeight: String = "",
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color = EDTSColor.grey60,
        descFontStyle: Font? = nil,
        descFontName: String = "",
        descFontSize: Double = .zero,
        descFontWeight: String = "",
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
        self.titleFontWeight = titleFontWeight
        self.desc = desc
        self.descAttributed = descAttributed
        self.descColor = descColor
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.descFontWeight = descFontWeight
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
            if hasTitle {
                Group {
                    if let titleAttributed {
                        Text(titleAttributed)
                    } else {
                        Text(title ?? "")
                    }
                }
                .font(setupTitleFont)
                .foregroundColor(titleColor)
            }

            if hasDesc {
                Group {
                    if let descAttributed {
                        Text(descAttributed)
                    } else {
                        Text(desc ?? "")
                    }
                }
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

#Preview("Attributed text") {
    struct PreviewWrapper: View {
        @State private var isOn = true

        private var attributedTitle: AttributedString {
            var s = AttributedString("Attributed title")
            if let range = s.range(of: "title") {
                s[range].font = .system(size: 16, weight: .bold)
            }
            return s
        }

        var body: some View {
            EDTSToggle(
                isActive: $isOn,
                titleAttributed: attributedTitle,
                descAttributed: AttributedString("Attributed body inherits font + color")
            )
            .padding()
        }
    }
    return PreviewWrapper()
}

#Preview("Custom font weight") {
    struct PreviewWrapper: View {
        @State private var isOn = true
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                EDTSToggle(
                    isActive: $isOn,
                    title: "Bold title",
                    titleFontName: "Helvetica",
                    titleFontSize: 16,
                    titleFontWeight: "bold",
                    desc: "Light description",
                    descFontName: "Helvetica",
                    descFontSize: 13,
                    descFontWeight: "light"
                )
                EDTSToggle(
                    isActive: $isOn,
                    title: "Semibold, system size",
                    titleFontWeight: "semibold"
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
