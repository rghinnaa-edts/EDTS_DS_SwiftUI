//
//  EDTSSearchField.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 17/11/26.
//

import SwiftUI

// MARK: - Placeholder animation

public nonisolated enum EDTSPlaceholderAnimationType: Equatable, Sendable {
    case append
    case appendPrefix
    case slideTopBottom
    case slideTopBottomPrefix
}

public nonisolated struct EDTSSearchFieldAnimation: Equatable, Sendable {
    public var type: EDTSPlaceholderAnimationType
    public var speed: TimeInterval
    public var cursorSymbol: String
    public var prefix: String

    public init(type: EDTSPlaceholderAnimationType,
                speed: TimeInterval = 0.1,
                cursorSymbol: String = "|",
                prefix: String = "") {
        self.type = type
        self.speed = speed
        self.cursorSymbol = cursorSymbol
        self.prefix = prefix
    }
}

// MARK: - Style

public struct EDTSSearchFieldStyle {
    public var textColor: Color = .primary
    public var placeholderColor: Color = Color(uiColor: .placeholderText)
    public var fontStyle: Font = EDTSFont.Klik.B3.Regular.font
    public var bgColor: Color = EDTSColor.white
    public var bgActiveColor: Color = Color.clear
    public var borderWidth: CGFloat = 1
    public var borderColor: Color = EDTSColor.grey30
    public var borderActiveColor: Color = EDTSColor.blue10
    public var iconSize: CGFloat = 24
    public var iconTintColor: Color = EDTSColor.grey60
    public var btnClearColor: Color = EDTSColor.grey60
    public var btnClearSize: CGFloat = 20
    public var height: CGFloat = 36
    public var cornerRadius: CGFloat = 8
    public var verticalPadding: CGFloat = 8
    public var horizontalPadding: CGFloat = 8

    public init() {}
}

// MARK: - Search Field

public struct EDTSSearchField: View {

    @Binding public var text: String
    public var placeholder: String
    public var placeholderAnimation: EDTSSearchFieldAnimation?
    public var style: EDTSSearchFieldStyle
    public var onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool
    @State private var revealedCount: Int = 0

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        placeholderAnimation: EDTSSearchFieldAnimation? = nil,
        style: EDTSSearchFieldStyle = .init(),
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderAnimation = placeholderAnimation
        self.style = style
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image("ic_search", bundle: .edtsDS)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: style.iconSize, height: style.iconSize)
                .foregroundColor(style.iconTintColor)

            ZStack(alignment: .leading) {
                placeholderView
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)

                TextField("", text: $text)
                    .font(style.fontStyle)
                    .foregroundColor(style.textColor)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }
                    .accessibilityLabel(accessibilityPlaceholder)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if isFocused && !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: style.btnClearSize, height: style.btnClearSize)
                        .foregroundColor(style.btnClearColor)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear text")
            }
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .frame(minHeight: style.height)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(isFocused ? style.bgActiveColor : style.bgColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(isFocused ? style.borderActiveColor : style.borderColor,
                        lineWidth: style.borderWidth)
        )
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .task(id: AnimationKey(placeholder: placeholder,
                               animation: placeholderAnimation,
                               isActive: text.isEmpty)) {
            await runPlaceholderAnimation()
        }
    }

    // MARK: Placeholder

    private var accessibilityPlaceholder: String {
        guard let animation = placeholderAnimation,
              animation.type == .appendPrefix || animation.type == .slideTopBottomPrefix,
              !animation.prefix.isEmpty else { return placeholder }
        return animation.prefix + " " + placeholder
    }

    @ViewBuilder
    private var placeholderView: some View {
        if text.isEmpty {
            if let animation = placeholderAnimation {
                animatedPlaceholder(animation)
            } else {
                Text(placeholder)
                    .font(style.fontStyle)
                    .foregroundColor(style.placeholderColor)
                    .lineLimit(1)
            }
        }
    }

    @ViewBuilder
    private func animatedPlaceholder(_ animation: EDTSSearchFieldAnimation) -> some View {
        switch animation.type {
        case .append:
            Text(String(placeholder.prefix(revealedCount)))
                .font(style.fontStyle)
                .foregroundColor(style.placeholderColor)
                .lineLimit(1)

        case .appendPrefix:
            let lead = animation.prefix.isEmpty ? "" : animation.prefix + " "
            Text(lead + String(placeholder.prefix(revealedCount)) + animation.cursorSymbol)
                .font(style.fontStyle)
                .foregroundColor(style.placeholderColor)
                .lineLimit(1)

        case .slideTopBottom:
            HStack(spacing: 0) {
                ForEach(Array(placeholder.enumerated()), id: \.offset) { index, character in
                    let isRevealed = index < revealedCount
                    Text(String(character))
                        .font(style.fontStyle)
                        .foregroundColor(style.placeholderColor)
                        .offset(y: isRevealed ? 0 : -8)
                        .opacity(isRevealed ? 1 : 0)
                }
            }
            .lineLimit(1)
            .animation(.easeOut(duration: 0.2), value: revealedCount)

        case .slideTopBottomPrefix:
            HStack(spacing: 0) {
                if !animation.prefix.isEmpty {
                    Text(animation.prefix + " ")
                        .font(style.fontStyle)
                        .foregroundColor(style.placeholderColor)
                }

                ForEach(Array(placeholder.enumerated()), id: \.offset) { index, character in
                    let isRevealed = index < revealedCount
                    Text(String(character))
                        .font(style.fontStyle)
                        .foregroundColor(style.placeholderColor)
                        .offset(y: isRevealed ? 0 : -8)
                        .opacity(isRevealed ? 1 : 0)
                }
            }
            .lineLimit(1)
            .animation(.easeOut(duration: 0.2), value: revealedCount)
        }
    }

    // MARK: Animation

    @MainActor
    private func runPlaceholderAnimation() async {
        guard let animation = placeholderAnimation, text.isEmpty else {
            revealedCount = placeholder.count
            return
        }

        let total = placeholder.count
        let stepNanoseconds = UInt64(max(animation.speed, 0.01) * 1_000_000_000)

        while !Task.isCancelled {
            for index in 0...total {
                revealedCount = index
                try? await Task.sleep(nanoseconds: stepNanoseconds)
                if Task.isCancelled { return }
            }

            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }

    private nonisolated struct AnimationKey: Equatable, Sendable {
        let placeholder: String
        let animation: EDTSSearchFieldAnimation?
        let isActive: Bool
    }
}

// MARK: - Preview

#if DEBUG
private struct EDTSSearchFieldPreviewHost: View {
    @State private var plain = ""
    @State private var append = ""
    @State private var prefix = ""
    @State private var slide = ""
    @State private var slidePrefix = ""

    var body: some View {
        VStack(spacing: 16) {
            EDTSSearchField(text: $plain, placeholder: "Cari produk")

            EDTSSearchField(
                text: $append,
                placeholder: "Cari produk",
                placeholderAnimation: .init(type: .append)
            )

            EDTSSearchField(
                text: $prefix,
                placeholder: "promo",
                placeholderAnimation: .init(type: .appendPrefix, prefix: "Cari")
            )

            EDTSSearchField(
                text: $slide,
                placeholder: "Cari voucher",
                placeholderAnimation: .init(type: .slideTopBottom, speed: 0.08),
                onSubmit: { print("Submit", slide) }
            )

            EDTSSearchField(
                text: $slidePrefix,
                placeholder: "voucher",
                placeholderAnimation: .init(type: .slideTopBottomPrefix, speed: 0.08, prefix: "Cari")
            )
        }
        .padding()
    }
}

#Preview {
    EDTSSearchFieldPreviewHost()
}
#endif
