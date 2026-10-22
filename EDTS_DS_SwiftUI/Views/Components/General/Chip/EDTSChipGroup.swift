//
//  EDTSChipGroup.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 21/10/26.
//

import SwiftUI

// MARK: - Enum
public enum ChipGroupDisplayMode: Equatable {
    case vertical
    case horizontal
    case spanGrid(Int? = nil)
}

// MARK: - Preference Keys
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
    
    // MARK: - Private Variable
    private var itemCount: Int {
        dataAttributed.isEmpty ? data.count : dataAttributed.count
    }
    
    @State private var containerWidth: CGFloat = 0
    private var chipConfigurator: ((inout EDTSChip) -> Void)?
    
    // MARK: - Initializers
    public init(
        data: [String] = [],
        dataAttributed: [AttributedString] = [],
        selectedIndices: Binding<Set<Int>>,
        displayMode: ChipGroupDisplayMode = .spanGrid(),
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
    public func configureChip(_ configure: @escaping (inout EDTSChip) -> Void) -> EDTSChipGroup {
        var copy = self
        copy.chipConfigurator = configure
        return copy
    }
    
    // MARK: - Setup & Styling
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
    
    private var containerWidthReader: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ChipContainerWidthKey.self, value: proxy.size.width)
        }
        .onPreferenceChange(ChipContainerWidthKey.self) { containerWidth = $0 }
    }
    
    // MARK: - Body
    public var body: some View {
        switch displayMode {
        case .vertical:
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: verticalSpacing) {
                    chips
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        case .horizontal:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: horizontalSpacing) {
                    chips
                }
            }
            
        case .spanGrid(let fixedColumns):
            ScrollView(.vertical, showsIndicators: false) {
                if let fixedColumns {
                    gridView(columns: fixedColumns)
                } else {
                    wrapGridView
                }
            }
        }
    }
    
    private func gridView(columns: Int) -> some View {
        let columns = max(1, columns)
        let isMeasured = containerWidth > 0
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
        .opacity(isMeasured ? 1 : 0)
        .background(containerWidthReader)
    }
    
    private var wrapGridView: some View {
        var x: CGFloat = 0
        var y: CGFloat = 0
        let lastIndex = itemCount - 1
        
        return ZStack(alignment: .topLeading) {
            ForEach(0..<itemCount, id: \.self) { index in
                chipView(at: index)
                    .alignmentGuide(.leading) { d in
                        if abs(x - d.width) > containerWidth {
                            x = 0
                            y -= d.height + verticalSpacing
                        }
                        let result = x
                        x = (index == lastIndex) ? 0 : x - (d.width + horizontalSpacing)
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = y
                        if index == lastIndex { y = 0 }
                        return result
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .opacity(containerWidth > 0 ? 1 : 0)
        .background(containerWidthReader)
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
