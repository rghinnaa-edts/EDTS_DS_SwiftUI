//
//  EDTSTabDefault.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 16/11/26.
//

import SwiftUI

// MARK: - Namespace

private struct EDTSTabNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

private extension EnvironmentValues {
    var edtsTabNamespace: Namespace.ID? {
        get { self[EDTSTabNamespaceKey.self] }
        set { self[EDTSTabNamespaceKey.self] = newValue }
    }
}

// MARK: - Model

public protocol EDTSTabDefaultModelProtocol {
    var id: String { get }
    var title: String { get }
}

// MARK: - Style

public struct EDTSTabDefaultStyle {
    public var indicatorColor: Color = EDTSColor.blue50
    public var textColor: Color = EDTSColor.blue50
    public var textActiveColor: Color = EDTSColor.blue50
    public var cellBackgroundColor: Color = .clear
    public var backgroundColor: Color = EDTSColor.white
    public var paddingTop: CGFloat = 8
    public var paddingBottom: CGFloat = 6
    public var indicatorHeight: CGFloat = 2
    public var indicatorCornerRadius: CGFloat = 2
    public var font: Font = EDTSFont.Klik.B3.Regular.font

    public init() {}
}

// MARK: - Layout

public struct EDTSTabDefaultLayout {
    public var top: CGFloat = 0
    public var leading: CGFloat = 16
    public var bottom: CGFloat = 0
    public var trailing: CGFloat = 16
    public var itemSpacing: CGFloat = 12

    public init(top: CGFloat = 0,
                leading: CGFloat = 16,
                bottom: CGFloat = 0,
                trailing: CGFloat = 16,
                itemSpacing: CGFloat = 12) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
        self.itemSpacing = itemSpacing
    }
}

public struct EDTSTabDefaultSizing {
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    public var useDynamicWidth: Bool = false
    public var minWidth: CGFloat = 60
    public var maxWidth: CGFloat = 200
    public var horizontalPadding: CGFloat = 16

    public init(width: CGFloat = 0,
                height: CGFloat = 0,
                useDynamicWidth: Bool = false,
                minWidth: CGFloat = 60,
                maxWidth: CGFloat = 200,
                horizontalPadding: CGFloat = 16) {
        self.width = width
        self.height = height
        self.useDynamicWidth = useDynamicWidth
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - Default Cell

public struct EDTSTabDefaultCellView: View {
    public let title: String
    public let isSelected: Bool
    public var style: EDTSTabDefaultStyle

    @Environment(\.edtsTabNamespace) private var namespace

    public init(title: String, isSelected: Bool, style: EDTSTabDefaultStyle = .init()) {
        self.title = title
        self.isSelected = isSelected
        self.style = style
    }

    public var body: some View {
        VStack(spacing: style.paddingBottom) {
            Text(title)
                .font(style.font)
                .foregroundColor(isSelected ? style.textActiveColor : style.textColor)
                .lineLimit(1)
                .padding(.top, style.paddingTop)
                .animation(.easeInOut(duration: 0.3), value: isSelected)

            ZStack {
                Color.clear

                if isSelected {
                    indicator
                }
            }
            .frame(height: style.indicatorHeight)
        }
        .background(style.cellBackgroundColor)
    }

    @ViewBuilder
    private var indicator: some View {
        let shape = RoundedRectangle(cornerRadius: style.indicatorCornerRadius)
        if let namespace {
            shape
                .fill(style.indicatorColor)
                .matchedGeometryEffect(id: "edts.tab.indicator", in: namespace)
        } else {
            shape.fill(style.indicatorColor)
        }
    }
}

// MARK: - Tab View

public struct EDTSTabDefaultView<Item: EDTSTabDefaultModelProtocol, Cell: View>: View {

    public var data: [Item]
    @Binding public var selectedId: String?
    public var layout: EDTSTabDefaultLayout
    public var sizing: EDTSTabDefaultSizing
    public var backgroundColor: Color
    public var isScrollable: Bool
    public var isSkeleton: Bool
    public var skeletonItemTotal: Int
    public var onSelect: ((_ index: Int, _ id: String) -> Void)?

    private let cell: (Item, Bool) -> Cell

    @Namespace private var indicatorNamespace

    public init(
        data: [Item],
        selectedId: Binding<String?>,
        layout: EDTSTabDefaultLayout = .init(),
        sizing: EDTSTabDefaultSizing = .init(),
        backgroundColor: Color = EDTSColor.white,
        isScrollable: Bool = true,
        isSkeleton: Bool = false,
        skeletonItemTotal: Int = 0,
        onSelect: ((_ index: Int, _ id: String) -> Void)? = nil,
        @ViewBuilder cell: @escaping (Item, Bool) -> Cell
    ) {
        self.data = data
        self._selectedId = selectedId
        self.layout = layout
        self.sizing = sizing
        self.backgroundColor = backgroundColor
        self.isScrollable = isScrollable
        self.isSkeleton = isSkeleton
        self.skeletonItemTotal = skeletonItemTotal
        self.onSelect = onSelect
        self.cell = cell
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            if isSkeleton {
                skeletonView
                    .transition(.opacity)
            } else {
                tabs
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .animation(.easeOut(duration: 0.2), value: isSkeleton)
        .onAppear(perform: selectDefaultTabIfNeeded)
        .onChange(of: data.map(\.id)) { _ in selectDefaultTabIfNeeded() }
    }

    // MARK: Tabs

    private var tabs: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: layout.itemSpacing) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        let isSelected = item.id == selectedId

                        cell(item, isSelected)
                            .frame(width: fixedWidth,
                                   height: fixedHeight)
                            .frame(minWidth: dynamicMinWidth,
                                   maxWidth: dynamicMaxWidth)
                            .contentShape(Rectangle())
                            .onTapGesture { select(index: index, notify: true) }
                            .id(item.id)
                    }
                }
                .padding(.top, layout.top)
                .padding(.leading, layout.leading)
                .padding(.bottom, layout.bottom)
                .padding(.trailing, layout.trailing)
                .environment(\.edtsTabNamespace, indicatorNamespace)
            }
            .edtsScrollDisabled(!isScrollable)
            .onChange(of: selectedId) { id in
                guard let id else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }
        }
    }

    private var fixedWidth: CGFloat? {
        (!sizing.useDynamicWidth && sizing.width > 0) ? sizing.width : nil
    }

    private var fixedHeight: CGFloat? {
        sizing.height > 0 ? sizing.height : nil
    }

    private var dynamicMinWidth: CGFloat? {
        sizing.useDynamicWidth ? sizing.minWidth : nil
    }

    private var dynamicMaxWidth: CGFloat? {
        sizing.useDynamicWidth ? sizing.maxWidth : nil
    }

    // MARK: Skeleton

    private var skeletonView: some View {
        HStack(spacing: layout.itemSpacing) {
            ForEach(0..<max(skeletonItemTotal, 0), id: \.self) { _ in
                EDTSSkeleton(cornerRadius: 12)
                    .frame(width: sizing.width > 0 ? sizing.width : 57,
                           height: sizing.height > 0 ? sizing.height : 24)
            }
        }
        .padding(.top, layout.top)
        .padding(.leading, layout.leading)
        .padding(.bottom, layout.bottom)
    }

    // MARK: Selection

    private func selectDefaultTabIfNeeded() {
        guard let first = data.first else { return }
        if selectedId == nil || !data.contains(where: { $0.id == selectedId }) {
            selectedId = first.id
        }
    }

    private func select(index: Int, notify: Bool) {
        guard data.indices.contains(index) else { return }
        let id = data[index].id
        guard id != selectedId else { return }

        withAnimation(.easeOut(duration: 0.3)) {
            selectedId = id
        }
        if notify {
            onSelect?(index, id)
        }
    }
}

// MARK: - Convenience init

public extension EDTSTabDefaultView where Cell == EDTSTabDefaultCellView {
    init(
        data: [Item],
        selectedId: Binding<String?>,
        style: EDTSTabDefaultStyle = .init(),
        layout: EDTSTabDefaultLayout = .init(),
        sizing: EDTSTabDefaultSizing = .init(),
        isScrollable: Bool = true,
        isSkeleton: Bool = false,
        skeletonItemTotal: Int = 0,
        onSelect: ((_ index: Int, _ id: String) -> Void)? = nil
    ) {
        self.init(
            data: data,
            selectedId: selectedId,
            layout: layout,
            sizing: sizing,
            backgroundColor: style.backgroundColor,
            isScrollable: isScrollable,
            isSkeleton: isSkeleton,
            skeletonItemTotal: skeletonItemTotal,
            onSelect: onSelect
        ) { item, isSelected in
            EDTSTabDefaultCellView(title: item.title, isSelected: isSelected, style: style)
        }
    }
}

// MARK: - Preview

#if DEBUG
private struct EDTSTabPreviewItem: EDTSTabDefaultModelProtocol {
    let id: String
    let title: String
}

private struct EDTSTabDefaultPreviewHost: View {
    @State private var selectedId: String? = nil
    private let items: [EDTSTabPreviewItem] = [
        EDTSTabPreviewItem(id: "1", title: "Hadiah Produk"),
        EDTSTabPreviewItem(id: "2", title: "Promo"),
        EDTSTabPreviewItem(id: "3", title: "Voucher"),
        EDTSTabPreviewItem(id: "4", title: "Riwayat Transaksi"),
        EDTSTabPreviewItem(id: "5", title: "Lainnya")
    ]

    var body: some View {
        EDTSTabDefaultView(
            data: items,
            selectedId: $selectedId,
            sizing: EDTSTabDefaultSizing(useDynamicWidth: true, minWidth: 60, maxWidth: 200),
            onSelect: { index, id in print("Selected", index, id) }
        )
    }
}

#Preview {
    EDTSTabDefaultPreviewHost()
}
#endif
