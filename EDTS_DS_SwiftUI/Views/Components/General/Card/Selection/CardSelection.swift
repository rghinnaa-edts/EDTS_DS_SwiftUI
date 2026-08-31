//
//  CardSelection.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI

// MARK: - Model

public struct CardSelectionModel: Identifiable, Equatable {
    public var id: String
    public var title: String
    public var description: String
    public var isEnabled: Bool

    public init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }
}

// MARK: - Style

public struct CardSelectionStyle {
    public var titleColor: Color
    public var titleActiveColor: Color
    public var descColor: Color
    public var descActiveColor: Color

    public var backgroundColor: Color
    public var backgroundActiveColor: Color

    public var borderColor: Color
    public var borderActiveColor: Color
    public var borderWidth: CGFloat

    public var cornerRadius: CGFloat

    public var shadowColor: Color
    public var shadowActiveColor: Color
    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize

    public var disabledColor: Color
    public var disabledBorderColor: Color
    public var disabledBorderWidth: CGFloat

    public init(
        titleColor: Color = EDTSColor.grey70,
        titleActiveColor: Color = EDTSColor.blueDefault,
        descColor: Color = EDTSColor.grey50,
        descActiveColor: Color = EDTSColor.grey50,
        backgroundColor: Color = EDTSColor.white,
        backgroundActiveColor: Color = EDTSColor.white,
        borderColor: Color = EDTSColor.grey20,
        borderActiveColor: Color = EDTSColor.blueDefault,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8,
        shadowColor: Color = EDTSColor.grey50,
        shadowActiveColor: Color = EDTSColor.grey50,
        shadowOpacity: Double = 0,
        shadowRadius: CGFloat = 0,
        shadowOffset: CGSize = .zero,
        disabledColor: Color = EDTSColor.disabled,
        disabledBorderColor: Color = EDTSColor.grey20,
        disabledBorderWidth: CGFloat = 0.5
    ) {
        self.titleColor = titleColor
        self.titleActiveColor = titleActiveColor
        self.descColor = descColor
        self.descActiveColor = descActiveColor
        self.backgroundColor = backgroundColor
        self.backgroundActiveColor = backgroundActiveColor
        self.borderColor = borderColor
        self.borderActiveColor = borderActiveColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowActiveColor = shadowActiveColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.disabledColor = disabledColor
        self.disabledBorderColor = disabledBorderColor
        self.disabledBorderWidth = disabledBorderWidth
    }

    public static let `default` = CardSelectionStyle()
}

// MARK: - Single card

public struct EDTSCardSelectionView: View {
    public let model: CardSelectionModel
    public let isSelected: Bool
    public var style: CardSelectionStyle = .default

    public init(model: CardSelectionModel, isSelected: Bool, style: CardSelectionStyle = .default) {
        self.model = model
        self.isSelected = isSelected
        self.style = style
    }

    private var isEnabled: Bool { model.isEnabled }

    private var titleColor: Color {
        guard isEnabled else { return style.disabledColor }
        return isSelected ? style.titleActiveColor : style.titleColor
    }

    private var descColor: Color {
        guard isEnabled else { return style.disabledColor }
        return isSelected ? style.descActiveColor : style.descColor
    }

    private var backgroundColor: Color {
        isSelected ? style.backgroundActiveColor : style.backgroundColor
    }

    private var borderColor: Color {
        guard isEnabled else { return style.disabledBorderColor }
        return isSelected ? style.borderActiveColor : style.borderColor
    }

    private var borderWidth: CGFloat {
        isEnabled ? style.borderWidth : style.disabledBorderWidth
    }

    private var shadowColor: Color {
        isSelected ? style.shadowActiveColor : style.shadowColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(model.title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(titleColor)
                .lineLimit(1)

            Text(model.description)
                .font(.system(size: 12))
                .foregroundColor(descColor)
                .lineLimit(1)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeOut(duration: 0.3), value: isSelected)
        )
        .shadow(
            color: shadowColor.opacity(style.shadowOpacity),
            radius: style.shadowRadius,
            x: style.shadowOffset.width,
            y: style.shadowOffset.height
        )
    }
}

// MARK: - List

public struct EDTSCardSelectionListView: View {
    public let data: [CardSelectionModel]
    @Binding public var selectedIndex: Int?
    public var style: CardSelectionStyle = .default
    public var onSelect: ((Int) -> Void)? = nil

    public init(
        data: [CardSelectionModel],
        selectedIndex: Binding<Int?>,
        style: CardSelectionStyle = .default,
        onSelect: ((Int) -> Void)? = nil
    ) {
        self.data = data
        self._selectedIndex = selectedIndex
        self.style = style
        self.onSelect = onSelect
    }

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                    EDTSCardSelectionView(
                        model: item,
                        isSelected: index == selectedIndex,
                        style: style
                    )
                    .frame(width: 170, height: 50)
                    .onTapGesture {
                        select(index)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            if selectedIndex == nil {
                selectFirstEnabledItem()
            }
        }
    }

    private func select(_ index: Int) {
        guard data.indices.contains(index), data[index].isEnabled else { return }
        guard selectedIndex != index else { return }

        selectedIndex = index
        onSelect?(index)
    }

    private func selectFirstEnabledItem() {
        if let index = data.firstIndex(where: { $0.isEnabled }) {
            selectedIndex = index
            onSelect?(index)
        } else {
            selectedIndex = nil
        }
    }
}

// MARK: - Preview

#if DEBUG
private struct EDTSCardSelectionListView_PreviewWrapper: View {
    @State private var selectedIndex: Int? = nil

    private let items: [CardSelectionModel] = [
        CardSelectionModel(title: "Debit Card", description: "Instant transfer"),
        CardSelectionModel(title: "Credit Card", description: "Pay later"),
        CardSelectionModel(title: "E-Wallet", description: "Top up balance"),
        CardSelectionModel(title: "Bank Transfer", description: "Not available", isEnabled: false)
    ]

    var body: some View {
        EDTSCardSelectionListView(data: items, selectedIndex: $selectedIndex) { index in
            print("Selected index: \(index)")
        }
        .padding(.vertical, 16)
    }
}

struct EDTSCardSelectionListView_Previews: PreviewProvider {
    static var previews: some View {
        EDTSCardSelectionListView_PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
#endif
