//
//  EDTSChipGroup.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 21/10/26.
//

import SwiftUI

// MARK: - Display Mode
public enum ChipGroupDisplayMode: Equatable {
    /// Single-column stacked list.
    case vertical
    /// Single-row, horizontally scrollable list.
    case horizontal
    /// Grid layout.
    /// - `.spanGrid()` (default): column count is calculated automatically from the widest chip.
    /// - `.spanGrid(2)`: fixed number of columns.
    case spanGrid(Int? = nil)
}

// MARK: - Preference Keys
private struct ChipWidestWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct ChipContainerWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Chip Group
public struct EDTSChipGroup: View {
    // MARK: - Properties
    public let data: [String]
    public let dataAttributed: [AttributedString]
    @Binding public var selectedIndices: Set<Int>
    public var displayMode: ChipGroupDisplayMode

    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat

    public var paddingTop: CGFloat
    public var paddingBottom: CGFloat
    public var paddingLeading: CGFloat
    public var paddingTrailing: CGFloat

    // MARK: - Private Variable
    private var chipConfigurator: ((inout EDTSChip) -> Void)?

    @State private var containerWidth: CGFloat = 0
    @State private var widestChipWidth: CGFloat = 0

    private var itemCount: Int {
        dataAttributed.isEmpty ? data.count : dataAttributed.count
    }

    // MARK: - Initializers
    private init(
        data: [String],
        dataAttributed: [AttributedString],
        selectedIndices: Binding<Set<Int>>,
        displayMode: ChipGroupDisplayMode,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        paddingTop: CGFloat,
        paddingBottom: CGFloat,
        paddingLeading: CGFloat,
        paddingTrailing: CGFloat
    ) {
        self.data = data
        self.dataAttributed = dataAttributed
        self._selectedIndices = selectedIndices
        self.displayMode = displayMode
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeading = paddingLeading
        self.paddingTrailing = paddingTrailing
    }

    /// Plain-text chips.
    public init(
        data: [String],
        selectedIndices: Binding<Set<Int>>,
        displayMode: ChipGroupDisplayMode = .vertical,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        paddingTop: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingLeading: CGFloat = 0,
        paddingTrailing: CGFloat = 0
    ) {
        self.init(
            data: data,
            dataAttributed: [],
            selectedIndices: selectedIndices,
            displayMode: displayMode,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeading: paddingLeading,
            paddingTrailing: paddingTrailing
        )
    }

    /// Attributed-text chips (overrides `data`).
    public init(
        dataAttributed: [AttributedString],
        selectedIndices: Binding<Set<Int>>,
        displayMode: ChipGroupDisplayMode = .vertical,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        paddingTop: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingLeading: CGFloat = 0,
        paddingTrailing: CGFloat = 0
    ) {
        self.init(
            data: [],
            dataAttributed: dataAttributed,
            selectedIndices: selectedIndices,
            displayMode: displayMode,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeading: paddingLeading,
            paddingTrailing: paddingTrailing
        )
    }

    // MARK: - Public Function
    /// Customize every chip rendered inside the group (same idea as `configureRadioButton`).
    /// `isActive` and `onTapChip` are managed by the group and are applied after this closure runs.
    public func configureChip(_ configure: @escaping (inout EDTSChip) -> Void) -> EDTSChipGroup {
        var copy = self
        copy.chipConfigurator = configure
        return copy
    }

    // MARK: - Body
    public var body: some View {
        switch displayMode {
        case .vertical:
            VStack(alignment: .leading, spacing: verticalSpacing) {
                chips
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(contentInsets)

        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: horizontalSpacing) {
                    chips
                }
                .padding(contentInsets)
            }

        case .spanGrid(let fixedColumns):
            gridView(fixedColumns: fixedColumns)
        }
    }

    // MARK: - Grid
    private func gridView(fixedColumns: Int?) -> some View {
        let isMeasured = containerWidth > 0 && (fixedColumns != nil || widestChipWidth > 0)
        let columns = resolvedColumns(fixedColumns: fixedColumns)
        let cellWidth = max(0, (containerWidth - horizontalSpacing * CGFloat(columns - 1)) / CGFloat(columns))
        let rows: [[Int]] = stride(from: 0, to: itemCount, by: columns).map {
            Array($0..<min($0 + columns, itemCount))
        }

        return VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: horizontalSpacing) {
                    ForEach(rows[rowIndex], id: \.self) { index in
                        chipView(at: index)
                            .frame(width: isMeasured ? cellWidth : nil, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        // Hide until the first measurement is done to avoid a one-frame flash of a 1-column layout.
        .opacity(isMeasured ? 1 : 0)
        .background(
            GeometryReader { proxy in
                Color.clear.preference(key: ChipContainerWidthKey.self, value: proxy.size.width)
            }
        )
        .background(widthMeasurer)
        .onPreferenceChange(ChipContainerWidthKey.self) { containerWidth = $0 }
        .onPreferenceChange(ChipWidestWidthKey.self) { widestChipWidth = $0 }
        .padding(contentInsets)
    }

    /// Columns that fit based on the widest chip (minimum 1), or the fixed count if provided.
    private func resolvedColumns(fixedColumns: Int?) -> Int {
        if let fixedColumns { return max(1, fixedColumns) }
        guard widestChipWidth > 0 else { return 1 }
        let fit = (containerWidth + horizontalSpacing) / (widestChipWidth + horizontalSpacing)
        return max(1, Int(fit.rounded(.down)))
    }

    /// Invisible copy of every chip at its natural (single-line) width. Only used to find the widest one.
    private var widthMeasurer: some View {
        ZStack {
            ForEach(0..<itemCount, id: \.self) { index in
                chipView(at: index)
                    .fixedSize()
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(key: ChipWidestWidthKey.self, value: proxy.size.width)
                        }
                    )
            }
        }
        .hidden()
        .allowsHitTesting(false)
        .accessibility(hidden: true)
    }

    // MARK: - Setup & Styling
    private var contentInsets: EdgeInsets {
        EdgeInsets(top: paddingTop, leading: paddingLeading, bottom: paddingBottom, trailing: paddingTrailing)
    }

    @ViewBuilder
    private var chips: some View {
        ForEach(0..<itemCount, id: \.self) { index in
            chipView(at: index)
        }
    }

    private func chipView(at index: Int) -> EDTSChip {
        var chip = dataAttributed.isEmpty
            ? EDTSChip(text: data[index])
            : EDTSChip(textAttributed: dataAttributed[index])

        chipConfigurator?(&chip)

        chip.isActive = selectedIndices.contains(index)
        chip.onTapChip = { toggle(index) }
        return chip
    }

    private func toggle(_ index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else {
            selectedIndices.insert(index)
        }
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var vertical: Set<Int> = [0]
        @State private var horizontal: Set<Int> = []
        @State private var autoGrid: Set<Int> = [1, 3]
        @State private var fixedGrid: Set<Int> = []

        private let items = [
            "Fashion", "Electronics", "Groceries", "Home & Living",
            "Beauty", "Sports", "Books", "Automotive", "Toys"
        ]

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Vertical").font(.caption)
                    EDTSChipGroup(data: Array(items.prefix(4)), selectedIndices: $vertical, displayMode: .vertical)

                    Text("Horizontal").font(.caption)
                    EDTSChipGroup(data: items, selectedIndices: $horizontal, displayMode: .horizontal)

                    Text("Span grid (auto)").font(.caption)
                    EDTSChipGroup(data: items, selectedIndices: $autoGrid, displayMode: .spanGrid())

                    Text("Span grid (2 columns)").font(.caption)
                    EDTSChipGroup(data: items, selectedIndices: $fixedGrid, displayMode: .spanGrid(2))
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
