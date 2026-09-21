//
//  CardSelection.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI

// MARK: - Model

public struct EDTSCardSelectionModel: Identifiable, Equatable {
    public var id: String
    public var title: String
    public var titleAttributed: AttributedString?
    public var description: String
    public var descriptionAttributed: AttributedString?
    public var isEnabled: Bool

    public init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        isEnabled: Bool = true,
        titleAttributed: AttributedString? = nil,
        descriptionAttributed: AttributedString? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
        self.titleAttributed = titleAttributed
        self.descriptionAttributed = descriptionAttributed
    }
}

// MARK: - Style

public struct EDTSCardSelectionConfig {
    public var titleColor: Color
    public var titleActiveColor: Color
    public var descColor: Color
    public var descActiveColor: Color
    public var bgColor: Color
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var bgColorOrientation: Orientation?
    public var bgActiveColor: Color
    public var bgActiveColorStart: Color
    public var bgActiveColorEnd: Color
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
    public var disabledBgColor: Color
    public var disabledBorderColor: Color
    public var disabledBorderWidth: CGFloat

    public init(
        titleColor: Color = EDTSColor.grey70,
        titleActiveColor: Color = EDTSColor.blueDefault,
        descColor: Color = EDTSColor.grey50,
        descActiveColor: Color = EDTSColor.grey50,
        bgColor: Color = EDTSColor.white,
        bgColorStart: Color = EDTSColor.white,
        bgColorEnd: Color = EDTSColor.white,
        bgColorOrientation: Orientation? = .vertical,
        bgActiveColor: Color = EDTSColor.white,
        bgActiveColorStart: Color = EDTSColor.white,
        bgActiveColorEnd: Color = EDTSColor.white,
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
        disabledBgColor: Color = EDTSColor.white,
        disabledBorderColor: Color = EDTSColor.grey20,
        disabledBorderWidth: CGFloat = 0.5
    ) {
        self.titleColor = titleColor
        self.titleActiveColor = titleActiveColor
        self.descColor = descColor
        self.descActiveColor = descActiveColor
        self.bgColor = bgColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.bgColorOrientation = bgColorOrientation
        self.bgActiveColor = bgActiveColor
        self.bgActiveColorStart = bgActiveColorStart
        self.bgActiveColorEnd = bgActiveColorEnd
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
        self.disabledBgColor = disabledBgColor
        self.disabledBorderColor = disabledBorderColor
        self.disabledBorderWidth = disabledBorderWidth
    }

    public static let `default` = EDTSCardSelectionConfig()
}

// MARK: - Single card

public struct EDTSCardSelectionView: View {
    private static let fontSize: CGFloat = 12
    private static let titleDescriptionSpacing: CGFloat = 2
    private static let contentPadding: CGFloat = 8
    private static let selectionAnimationDuration: Double = 0.3

    public let model: EDTSCardSelectionModel
    public let isSelected: Bool
    public var style: EDTSCardSelectionConfig = .default

    public init(model: EDTSCardSelectionModel, isSelected: Bool, style: EDTSCardSelectionConfig = .default) {
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
        guard isEnabled else { return style.disabledBgColor }
        return isSelected ? style.bgActiveColor : style.bgColor
    }
    
    private var backgroundColorStart: Color? {
        guard isEnabled else { return style.disabledBgColor }
        return isSelected ? style.bgActiveColorStart : style.bgColorStart
    }
    
    private var backgroundColorEnd: Color? {
        guard isEnabled else { return style.disabledBgColor }
        return isSelected ? style.bgActiveColorEnd : style.bgColorEnd
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

    private var titleText: Text {
        if let titleAttributed = model.titleAttributed {
            return Text(titleAttributed)
        }
        return Text(model.title).foregroundColor(titleColor)
    }

    private var descriptionText: Text {
        if let descriptionAttributed = model.descriptionAttributed {
            return Text(descriptionAttributed)
        }
        return Text(model.description).foregroundColor(descColor)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Self.titleDescriptionSpacing) {
            titleText
                .font(.system(size: Self.fontSize, weight: .medium))
                .lineLimit(1)

            descriptionText
                .font(.system(size: Self.fontSize))
                .lineLimit(1)
        }
        .padding(Self.contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(containerBackgroundStyle)
                .animation(.easeOut(duration: Self.selectionAnimationDuration), value: isSelected)
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeOut(duration: Self.selectionAnimationDuration), value: isSelected)
        )
        .shadow(
            color: shadowColor.opacity(style.shadowOpacity),
            radius: style.shadowRadius,
            x: style.shadowOffset.width,
            y: style.shadowOffset.height
        )
    }
    
    private var containerBackgroundStyle: AnyShapeStyle {
        if style.bgColorStart != nil || style.bgColorEnd != nil {
            let orientation = style.bgColorOrientation ?? .horizontal
            return AnyShapeStyle(
                LinearGradient(
                    colors: [backgroundColorStart ?? .clear, backgroundColorEnd ?? .clear],
                    startPoint: orientation == .horizontal ? .leading : .top,
                    endPoint: orientation == .horizontal ? .trailing : .bottom
                )
            )
        } else {
            return AnyShapeStyle(backgroundColor)
        }
    }
}

// MARK: - List

public struct EDTSCardSelectionListView: View {
    private static let cardWidth: CGFloat = 170
    private static let cardHeight: CGFloat = 50
    private static let itemSpacing: CGFloat = 8
    private static let horizontalPadding: CGFloat = 16

    public let data: [EDTSCardSelectionModel]
    @Binding public var selectedIndex: Int?
    public var style: EDTSCardSelectionConfig = .default
    public var onSelect: ((Int) -> Void)? = nil

    public init(
        data: [EDTSCardSelectionModel],
        selectedIndex: Binding<Int?>,
        style: EDTSCardSelectionConfig = .default,
        onSelect: ((Int) -> Void)? = nil
    ) {
        self.data = data
        self._selectedIndex = selectedIndex
        self.style = style
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(Self.cardHeight))], spacing: Self.itemSpacing) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                    EDTSCardSelectionView(
                        model: item,
                        isSelected: index == selectedIndex,
                        style: style
                    )
                    .frame(width: Self.cardWidth, height: Self.cardHeight)
                    .onTapGesture {
                        select(index)
                    }
                }
            }
            .padding(.horizontal, Self.horizontalPadding)
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

    private let items: [EDTSCardSelectionModel] = [
        EDTSCardSelectionModel(title: "Debit Card", description: "Instant transfer"),
        EDTSCardSelectionModel(title: "Credit Card", description: "Pay later"),
        EDTSCardSelectionModel(title: "E-Wallet", description: "Top up balance"),
        EDTSCardSelectionModel(title: "Bank Transfer", description: "Not available", isEnabled: false)
    ]

    var body: some View {
        EDTSCardSelectionListView(data: items, selectedIndex: $selectedIndex, style: EDTSCardSelectionConfig(bgColorStart: EDTSColor.white, bgColorEnd: EDTSColor.grey20)) { index in
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
