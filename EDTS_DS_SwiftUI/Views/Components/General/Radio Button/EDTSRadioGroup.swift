//
//  EDTSRadioGroup.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 09/03/26.
//

import SwiftUI

// MARK: - Enum

public enum EDTSSelectionDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int)
}

// MARK: - Preference Keys

private struct RadioContainerWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Radio Group

public struct EDTSRadioGroup: View {
    // MARK: - Properties

    public let data: [[String]]
    public let dataAttributed: [[AttributedString]]

    @Binding public var selectedIndex: Int?
    public var displayMode: EDTSSelectionDisplayMode

    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat

    // MARK: - Private Variable

    private let minimumColumns: Int = 1
    private let visibleOpacity: Double = 1
    private let hiddenOpacity: Double = 0
    private let rippleBleed: CGFloat = 12

    private var itemCount: Int {
        dataAttributed.isEmpty ? data.count : dataAttributed.count
    }

    private var isContainerMeasured: Bool {
        containerWidth > .zero
    }

    @State private var containerWidth: CGFloat = .zero
    private var radioButtonConfigurator: ((inout EDTSRadioButton) -> Void)?

    // MARK: - Initializers

    private init(
        data: [[String]],
        dataAttributed: [[AttributedString]],
        selectedIndex: Binding<Int?>,
        displayMode: EDTSSelectionDisplayMode,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat
    ) {
        self.data = data
        self.dataAttributed = dataAttributed
        self._selectedIndex = selectedIndex
        self.displayMode = displayMode
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public init(
        data: [[String]],
        selectedIndex: Binding<Int?>,
        displayMode: EDTSSelectionDisplayMode = .vertical,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self.init(
            data: data, dataAttributed: [], selectedIndex: selectedIndex, displayMode: displayMode,
            horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing
        )
    }

    public init(
        dataAttributed: [[AttributedString]],
        selectedIndex: Binding<Int?>,
        displayMode: EDTSSelectionDisplayMode = .vertical,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self.init(
            data: [], dataAttributed: dataAttributed, selectedIndex: selectedIndex, displayMode: displayMode,
            horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing
        )
    }

    // MARK: - Public Function

    public func configureRadioButton(_ configure: @escaping (inout EDTSRadioButton) -> Void) -> EDTSRadioGroup {
        var copy = self
        copy.radioButtonConfigurator = configure
        return copy
    }

    // MARK: - Setup & Styling

    @ViewBuilder
    private var radioButtons: some View {
        ForEach(0..<itemCount, id: \.self) { index in
            radioButtonView(at: index)
        }
    }

    private func radioButtonView(at index: Int) -> EDTSRadioButton {
        var radioButton: EDTSRadioButton

        if dataAttributed.isEmpty {
            let row = data[index]
            radioButton = EDTSRadioButton(
                title: row.first,
                desc: row.count > 1 ? row[1] : nil
            )
        } else {
            let row = dataAttributed[index]
            radioButton = EDTSRadioButton(
                titleAttributed: row.first ?? AttributedString(""),
                desc: nil,
                descAttributed: row.count > 1 ? row[1] : nil
            )
        }

        radioButtonConfigurator?(&radioButton)

        radioButton.isActive = selectedIndex == index
        radioButton.onTapRadioButton = { select(index) }
        return radioButton
    }

    private func select(_ index: Int) {
        guard selectedIndex != index else { return }
        selectedIndex = index
    }

    private var containerWidthReader: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: RadioContainerWidthKey.self, value: proxy.size.width)
        }
        .onPreferenceChange(RadioContainerWidthKey.self) { containerWidth = $0 }
    }

    // MARK: - Body

    public var body: some View {
        switch displayMode {
        case .vertical:
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: verticalSpacing) {
                    radioButtons
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(rippleBleed)
            }
            .padding(-rippleBleed)

        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    radioButtons
                }
                .padding(rippleBleed)
            }
            .padding(-rippleBleed)

        case .spanGrid(let columns):
            ScrollView(.vertical, showsIndicators: false) {
                gridView(columns: columns)
                    .padding(rippleBleed)
            }
            .padding(-rippleBleed)
        }
    }

    private func gridView(columns: Int) -> some View {
        let columns = max(minimumColumns, columns)
        let cellWidth = max(.zero, (containerWidth - horizontalSpacing * CGFloat(columns - 1)) / CGFloat(columns))
        let rows: [[Int]] = stride(from: 0, to: itemCount, by: columns).map {
            Array($0..<min($0 + columns, itemCount))
        }

        return VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    ForEach(rows[rowIndex], id: \.self) { index in
                        radioButtonView(at: index)
                            .frame(width: isContainerMeasured ? cellWidth : nil, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(isContainerMeasured ? visibleOpacity : hiddenOpacity)
        .background(containerWidthReader)
    }
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var vertical: Int? = 0
        @State private var horizontal: Int? = nil
        @State private var twoColumns: Int? = 1
        @State private var threeColumns: Int? = nil

        private let items = [
            ["Fashion", ""], ["Electronics", ""], ["Groceries", ""], ["Home & Living", ""],
            ["Beauty", ""], ["Sports", ""], ["Books", ""], ["Automotive", ""], ["Toys", ""]
        ]

        private let itemsWithDesc = [
            ["Regular", "3-5 business days"],
            ["Express", "1-2 business days"],
            ["Same day", "Delivered today"]
        ]

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Vertical (title + description)").font(.caption)
                    EDTSRadioGroup(data: itemsWithDesc, selectedIndex: $vertical, displayMode: .vertical)

                    Text("Horizontal").font(.caption)
                    EDTSRadioGroup(data: items, selectedIndex: $horizontal, displayMode: .horizontal)

                    Text("Span grid (2 columns)").font(.caption)
                    EDTSRadioGroup(data: items, selectedIndex: $twoColumns, displayMode: .spanGrid(2))

                    Text("Span grid (3 columns)").font(.caption)
                    EDTSRadioGroup(data: items, selectedIndex: $threeColumns, displayMode: .spanGrid(3))
                        .configureRadioButton { radioButton in
                            radioButton.titleFontWeight = "light"
                        }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
