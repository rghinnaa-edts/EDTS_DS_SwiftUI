//
//  EDTSTabQuadRound.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 16/11/26.
//


import SwiftUI

// MARK: - Model

public struct EDTSTabQuadRoundModel {
    public var id: String
    public var title: String
    public var badge: Int

    public init(id: String, title: String, badge: Int) {
        self.id = id
        self.title = title
        self.badge = badge
    }
}

// MARK: - Style

public struct EDTSTabQuadRoundStyle {
    public var backgroundColor: Color = EDTSColor.blue20
    public var backgroundActiveColor: Color = EDTSColor.white
    public var textColor: Color = EDTSColor.grey50
    public var textActiveColor: Color = EDTSColor.blue50
    public var badgeColor: Color = EDTSColor.grey50
    public var badgeActiveColor: Color = EDTSColor.blue50
    public var badgeTextColor: Color = EDTSColor.white
    public var badgeTextActiveColor: Color = EDTSColor.white
    public var containerBackgroundColor: Color = EDTSColor.blue50
    public var selectedFont: Font = EDTSFont.Klik.B3.Semibold.font
    public var unselectedFont: Font = EDTSFont.Klik.B4.Medium.font
    public var badgeFont: Font = EDTSFont.Klik.B4.Semibold.font

    public var selectedWidth: CGFloat = 150
    public var unselectedWidth: CGFloat = 86
    public var selectedHeight: CGFloat = 32
    public var unselectedHeight: CGFloat = 28
    public var cornerRadius: CGFloat = 12
    public var badgeSize: CGFloat = 14

    public init() {}
}

// MARK: - Corner shape

private nonisolated struct EDTSTabCorners: OptionSet, Sendable {
    let rawValue: Int
    static let topLeft = EDTSTabCorners(rawValue: 1 << 0)
    static let topRight = EDTSTabCorners(rawValue: 1 << 1)
    static let bottomLeft = EDTSTabCorners(rawValue: 1 << 2)
    static let bottomRight = EDTSTabCorners(rawValue: 1 << 3)
}

private struct EDTSTabCornerShape: Shape {
    var corners: EDTSTabCorners
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let r = min(radius, rect.width / 2, rect.height / 2)
        let tl = corners.contains(.topLeft) ? r : 0
        let tr = corners.contains(.topRight) ? r : 0
        let bl = corners.contains(.bottomLeft) ? r : 0
        let br = corners.contains(.bottomRight) ? r : 0

        var path = Path()
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))

        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        if tr > 0 {
            path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                        tangent2End: CGPoint(x: rect.maxX, y: rect.minY + tr),
                        radius: tr)
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        if br > 0 {
            path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                        tangent2End: CGPoint(x: rect.maxX - br, y: rect.maxY),
                        radius: br)
        }

        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        if bl > 0 {
            path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                        tangent2End: CGPoint(x: rect.minX, y: rect.maxY - bl),
                        radius: bl)
        }

        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        if tl > 0 {
            path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                        tangent2End: CGPoint(x: rect.minX + tl, y: rect.minY),
                        radius: tl)
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Cell

private struct EDTSTabQuadRoundCellView: View {
    let item: EDTSTabQuadRoundModel
    let isSelected: Bool
    let isBeforeSelected: Bool
    let isAfterSelected: Bool
    let isFirst: Bool
    let isLast: Bool
    let totalCount: Int
    let style: EDTSTabQuadRoundStyle

    private var tabHeight: CGFloat {
        isSelected ? style.selectedHeight : style.unselectedHeight
    }

    private var tabCorners: EDTSTabCorners {
        if isSelected {
            return [.topLeft, .topRight]
        } else if isBeforeSelected {
            return totalCount == 2 ? [.bottomRight, .topLeft] : [.bottomRight]
        } else if isAfterSelected {
            return totalCount == 2 ? [.bottomLeft, .topRight] : [.bottomLeft]
        }
        return []
    }

    private var backdropCorners: EDTSTabCorners {
        if totalCount == 2 {
            if isFirst { return [.topLeft] }
            if isLast { return [.topRight] }
            return []
        }
        if isFirst && isLast { return [.topLeft, .topRight] }
        if isFirst { return [.topLeft] }
        if isLast { return [.topRight] }
        return []
    }

    private var backdropColor: Color {
        (isBeforeSelected || isAfterSelected) ? style.backgroundActiveColor : style.backgroundColor
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            EDTSTabCornerShape(corners: backdropCorners, radius: style.cornerRadius)
                .fill(backdropColor)
                .frame(height: style.unselectedHeight)

            if isSelected {
                EDTSTabCornerShape(corners: [.topLeft, .topRight], radius: style.cornerRadius)
                    .fill(style.backgroundActiveColor)
                    .shadow(color: EDTSColor.black.opacity(0.15), radius: 2, x: 0, y: 0)
                    .frame(height: max(tabHeight - style.cornerRadius, 0))
                    .frame(height: tabHeight, alignment: .top)
            }

            tab
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var tab: some View {
        let shape = EDTSTabCornerShape(corners: tabCorners, radius: style.cornerRadius)

        return ZStack {
            shape.fill(isSelected ? style.backgroundActiveColor : style.backgroundColor)

            if !isSelected {
                // Inner bottom shadow
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.85),
                        .init(color: EDTSColor.black.opacity(0.05), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(shape)
            }

            content
        }
        .frame(height: tabHeight)
    }

    private var content: some View {
        HStack(spacing: 4) {
            Text(item.title)
                .font(isSelected ? style.selectedFont : style.unselectedFont)
                .foregroundColor(isSelected ? style.textActiveColor : style.textColor)
                .lineLimit(1)

            if item.badge > 0 {
                Text("\(item.badge)")
                    .font(style.badgeFont)
                    .foregroundColor(isSelected ? style.badgeTextActiveColor : style.badgeTextColor)
                    .padding(.horizontal, 3)
                    .frame(minWidth: style.badgeSize, minHeight: style.badgeSize)
                    .background(
                        Capsule().fill(isSelected ? style.badgeActiveColor : style.badgeColor)
                    )
                    .fixedSize()
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Tab View

public struct EDTSTabQuadRoundView: View {

    public var data: [EDTSTabQuadRoundModel]
    @Binding public var selectedId: String?
    public var style: EDTSTabQuadRoundStyle
    public var height: CGFloat
    public var onSelect: ((_ index: Int, _ id: String) -> Void)?

    public init(
        data: [EDTSTabQuadRoundModel],
        selectedId: Binding<String?>,
        style: EDTSTabQuadRoundStyle = .init(),
        height: CGFloat = 40,
        onSelect: ((_ index: Int, _ id: String) -> Void)? = nil
    ) {
        self.data = data
        self._selectedId = selectedId
        self.style = style
        self.height = height
        self.onSelect = onSelect
    }

    public var body: some View {
        GeometryReader { geo in
            content(containerWidth: geo.size.width)
        }
        .frame(height: height)
        .background(style.containerBackgroundColor)
        .onAppear(perform: selectDefaultTabIfNeeded)
        .onChange(of: data.map(\.id)) { _ in selectDefaultTabIfNeeded() }
    }

    // MARK: Layout

    @ViewBuilder
    private func content(containerWidth: CGFloat) -> some View {
        let metrics = WidthMetrics(count: data.count,
                                   containerWidth: containerWidth,
                                   style: style)

        if data.count > 2 {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    tabs(metrics: metrics)
                }
                .onChange(of: selectedId) { id in
                    guard data.count > 3, let id else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
        } else {
            tabs(metrics: metrics)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func tabs(metrics: WidthMetrics) -> some View {
        let selectedIndex = data.firstIndex(where: { $0.id == selectedId }) ?? 0

        return HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                let isSelected = index == selectedIndex

                EDTSTabQuadRoundCellView(
                    item: item,
                    isSelected: isSelected,
                    isBeforeSelected: index == selectedIndex - 1,
                    isAfterSelected: index == selectedIndex + 1,
                    isFirst: index == 0,
                    isLast: index == data.count - 1,
                    totalCount: data.count,
                    style: style
                )
                .frame(width: metrics.width(isSelected: isSelected),
                       height: height,
                       alignment: .bottom)
                .contentShape(Rectangle())
                .onTapGesture { select(index: index) }
                .zIndex(isSelected ? 1 : 0)
                .id(item.id)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedId)
    }

    // MARK: Selection

    private func selectDefaultTabIfNeeded() {
        guard let first = data.first else { return }
        if selectedId == nil || !data.contains(where: { $0.id == selectedId }) {
            selectedId = first.id
        }
    }

    private func select(index: Int) {
        guard data.indices.contains(index) else { return }
        let id = data[index].id
        selectedId = id
        onSelect?(index, id)
    }
}

// MARK: - Width rules (same as the UIKit version)

private struct WidthMetrics {
    let count: Int
    let containerWidth: CGFloat
    let style: EDTSTabQuadRoundStyle

    private let paddingFactor: CGFloat = 1.2

    private var useEqualWidth: Bool {
        switch count {
        case 1, 3, 4: return false
        case 2: return true
        default: return CGFloat(count) * style.unselectedWidth <= containerWidth
        }
    }

    private var equalWidth: CGFloat {
        guard count > 0 else { return 0 }
        let base = containerWidth / CGFloat(count)
        return count <= 2 ? base : base * paddingFactor
    }

    func width(isSelected: Bool) -> CGFloat {
        if count == 1 { return style.selectedWidth }

        if count == 3 {
            return isSelected
                ? style.selectedWidth
                : max((containerWidth - style.selectedWidth) / 2, 0)
        }

        if useEqualWidth { return equalWidth }

        return isSelected ? style.selectedWidth : style.unselectedWidth
    }
}

// MARK: - Preview

#if DEBUG
private struct EDTSTabQuadRoundPreviewHost: View {
    let count: Int
    @State private var selectedId: String? = nil

    private var items: [EDTSTabQuadRoundModel] {
        let titles = ["Promo", "Voucher", "Hadiah", "Riwayat", "Lainnya", "Info"]
        return (0..<count).map { i in
            EDTSTabQuadRoundModel(id: "\(i)", title: titles[i % titles.count], badge: i == 1 ? 3 : 0)
        }
    }

    var body: some View {
        EDTSTabQuadRoundView(
            data: items,
            selectedId: $selectedId,
            onSelect: { index, id in print("Selected", index, id) }
        )
    }
}

#Preview("2 tabs") { EDTSTabQuadRoundPreviewHost(count: 2) }
#Preview("3 tabs") { EDTSTabQuadRoundPreviewHost(count: 3) }
#Preview("6 tabs") { EDTSTabQuadRoundPreviewHost(count: 6) }
#endif
