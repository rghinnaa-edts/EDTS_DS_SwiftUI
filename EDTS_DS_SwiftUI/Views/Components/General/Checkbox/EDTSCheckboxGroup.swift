//
//  EDTSCheckboxGroup.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 03/11/26.
//

import SwiftUI

// MARK: - Enum
public enum CheckboxGroupDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int)
}

// MARK: - Preference Keys
private struct CheckboxContainerWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Checkbox Group
public struct EDTSCheckboxGroup: View {
    // MARK: - Properties
    public let data: [String]
    public let dataAttributed: [AttributedString]
    @Binding public var selectedIndices: Set<Int>
    public var displayMode: CheckboxGroupDisplayMode

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
    private var checkboxConfigurator: ((inout EDTSCheckbox) -> Void)?

    // MARK: - Initializers
    public init(
        data: [String] = [],
        dataAttributed: [AttributedString] = [],
        selectedIndices: Binding<Set<Int>>,
        displayMode: CheckboxGroupDisplayMode = .vertical,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self.data = data
        self.dataAttributed = dataAttributed
        self._selectedIndices = selectedIndices
        self.displayMode = displayMode
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    // MARK: - Public Function
    public func configureCheckbox(_ configure: @escaping (inout EDTSCheckbox) -> Void) -> EDTSCheckboxGroup {
        var copy = self
        copy.checkboxConfigurator = configure
        return copy
    }

    // MARK: - Setup & Styling
    @ViewBuilder
    private var checkboxes: some View {
        ForEach(0..<itemCount, id: \.self) { index in
            checkboxView(at: index)
        }
    }

    private func checkboxView(at index: Int) -> EDTSCheckbox {
        var checkbox = dataAttributed.isEmpty
        ? EDTSCheckbox(title: data[index], desc: nil)
        : EDTSCheckbox(titleAttributed: dataAttributed[index], desc: nil)

        checkboxConfigurator?(&checkbox)

        checkbox.isActive = selectedIndices.contains(index)
        checkbox.onTapCheckbox = { toggle(index) }
        return checkbox
    }

    private func toggle(_ index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else {
            selectedIndices.insert(index)
        }
    }

    private var containerWidthReader: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: CheckboxContainerWidthKey.self, value: proxy.size.width)
        }
        .onPreferenceChange(CheckboxContainerWidthKey.self) { containerWidth = $0 }
    }

    // MARK: - Body
    public var body: some View {
        switch displayMode {
        case .vertical:
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: verticalSpacing) {
                    checkboxes
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(rippleBleed)
            }
            .padding(-rippleBleed)

        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: horizontalSpacing) {
                    checkboxes
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
                        checkboxView(at: index)
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
        @State private var vertical: Set<Int> = [0]
        @State private var horizontal: Set<Int> = []
        @State private var twoColumns: Set<Int> = [1, 3]
        @State private var threeColumns: Set<Int> = []

        private let items = [
            "Fashion", "Electronics", "Groceries", "Home & Living",
            "Beauty", "Sports", "Books", "Automotive", "Toys"
        ]

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Vertical").font(.caption)
                    EDTSCheckboxGroup(data: Array(items.prefix(4)), selectedIndices: $vertical, displayMode: .vertical)

                    Text("Horizontal").font(.caption)
                    EDTSCheckboxGroup(data: items, selectedIndices: $horizontal, displayMode: .horizontal)

                    Text("Span grid (2 columns)").font(.caption)
                    EDTSCheckboxGroup(data: items, selectedIndices: $twoColumns, displayMode: .spanGrid(2))

                    Text("Span grid (3 columns)").font(.caption)
                    EDTSCheckboxGroup(data: items, selectedIndices: $threeColumns, displayMode: .spanGrid(3))
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
