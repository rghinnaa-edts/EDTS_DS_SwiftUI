//
//  EDTSToggle.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

// MARK: - EDTSToggle

public struct EDTSToggle: View {

    // MARK: - Content

    private let title: String?
    private let titleAttributed: AttributedString?
    private let desc: String?
    private let descAttributed: AttributedString?

    // MARK: - Text Styling

    private var titleColor: Color
    private var titleFont: Font
    private var descColor: Color
    private var descFont: Font

    // MARK: - Track / Indicator

    private var trackTintColor: Color
    private var trackActiveTintColor: Color
    private var trackWidth: CGFloat
    private var indicatorTintColor: Color
    private var indicatorActiveTintColor: Color
    private var indicatorPadding: CGFloat
    private var indicatorSize: CGFloat

    // MARK: - Icon

    private var icon: Image?
    private var iconActive: Image?
    private var iconTintColor: Color
    private var iconActiveTintColor: Color

    // MARK: - Shadow

    private var shadowColor: Color
    private var shadowOpacity: Double
    private var shadowOffset: CGSize
    private var shadowRadius: CGFloat

    // MARK: - Corner Radius

    private var cornerRadius: CGFloat?

    // MARK: - State

    @Binding private var isActive: Bool
    private var onToggle: ((Bool) -> Void)?

    // MARK: - Init

    public init(
        isActive: Binding<Bool>,
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleColor: Color = EDTSColor.grey70,
        titleFont: Font = EDTSFont.Klik.B2.Medium.font,
        desc: String? = nil,
        descAttributed: AttributedString? = nil,
        descColor: Color = EDTSColor.grey60,
        descFont: Font = EDTSFont.Klik.B3.Regular.font,
        trackTintColor: Color = EDTSColor.grey30,
        trackActiveTintColor: Color = EDTSColor.blue50,
        trackWidth: CGFloat = 44,
        indicatorTintColor: Color = EDTSColor.white,
        indicatorActiveTintColor: Color = EDTSColor.white,
        indicatorPadding: CGFloat = 2,
        indicatorSize: CGFloat = 16,
        icon: Image? = nil,
        iconActive: Image? = nil,
        iconTintColor: Color = EDTSColor.white,
        iconActiveTintColor: Color = EDTSColor.white,
        cornerRadius: CGFloat? = nil,
        shadowColor: Color = .black,
        shadowOpacity: Double = 0.0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0.0,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self._isActive = isActive
        self.title = title
        self.titleAttributed = titleAttributed
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.desc = desc
        self.descAttributed = descAttributed
        self.descColor = descColor
        self.descFont = descFont
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
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.onToggle = onToggle
    }

    // MARK: - Derived

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

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .center, spacing: hasLabel ? 8 : 0) {
            trackView
            if hasLabel {
                labelStack
            }
        }
    }

    // MARK: - Track + Indicator

    private var trackView: some View {
        ZStack(alignment: isActive ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: resolvedCornerRadius, style: .continuous)
                .fill(isActive ? trackActiveTintColor : trackTintColor)
                .frame(width: trackWidth, height: containerHeight)
                .shadow(
                    color: shadowColor.opacity(Double(shadowOpacity)),
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
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isActive)
    }

    private var indicatorView: some View {
        Circle()
            .fill(isActive ? indicatorActiveTintColor : indicatorTintColor)
            .frame(width: indicatorSize, height: indicatorSize)
            .shadow(color: EDTSColor.grey50.opacity(0.15), radius: 3, x: 0, y: 1)
            .overlay {
                if let currentImage {
                    currentImage
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(isActive ? iconActiveTintColor : iconTintColor)
                        .frame(width: indicatorSize, height: indicatorSize)
                }
            }
    }

    // MARK: - Labels

    private var labelStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let titleAttributed {
                Text(titleAttributed)
            } else if let title, !title.isEmpty {
                Text(title)
                    .font(titleFont)
                    .foregroundColor(titleColor)
            }

            if let descAttributed {
                Text(descAttributed)
            } else if let desc, !desc.isEmpty {
                Text(desc)
                    .font(descFont)
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
