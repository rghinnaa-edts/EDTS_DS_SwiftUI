//
//  EDTSRibbon.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI

// MARK: - Public types

public nonisolated enum EDTSRibbonGravity: Equatable, Sendable {
    case start
    case end
}

public nonisolated enum EDTSRibbonVerticalAlignment: Equatable, Sendable {
    case top
    case center
    case bottom
    case defaultV
}

// MARK: - Shapes

private nonisolated struct RibbonBodyShape: Shape {
    let gravity: EDTSRibbonGravity
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let corners: UIRectCorner = gravity == .start
            ? [.topLeft, .topRight, .bottomRight]
            : [.topLeft, .topRight, .bottomLeft]
        let bezierPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(bezierPath.cgPath)
    }
}

private nonisolated struct RibbonTriangleShape: Shape {
    let gravity: EDTSRibbonGravity

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if gravity == .start {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        } else {
            path.move(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - EDTSRibbon view

public struct EDTSRibbon: View {

    let text: String
    var gravity: EDTSRibbonGravity
    var triangleColor: Color
    var containerColor: Color
    var containerStartColor: Color?
    var containerEndColor: Color?
    var textColor: Color
    var cornerRadius: CGFloat
    var textVerticalPadding: CGFloat
    var textHorizontalPadding: CGFloat
    var font: Font

    static let triangleWidth: CGFloat = 6
    static let triangleHeight: CGFloat = 6

    public init(
        text: String,
        gravity: EDTSRibbonGravity = .start,
        triangleColor: Color = EDTSColor.blue50,
        containerColor: Color = EDTSColor.blue30,
        containerStartColor: Color? = nil,
        containerEndColor: Color? = nil,
        textColor: Color = EDTSColor.white,
        cornerRadius: CGFloat = 4,
        textVerticalPadding: CGFloat = 2,
        textHorizontalPadding: CGFloat = 4,
        font: Font = EDTSFont.Klik.B3.Medium.font
    ) {
        self.text = text
        self.gravity = gravity
        self.triangleColor = triangleColor
        self.containerColor = containerColor
        self.containerStartColor = containerStartColor
        self.containerEndColor = containerEndColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.textVerticalPadding = textVerticalPadding
        self.textHorizontalPadding = textHorizontalPadding
        self.font = font
    }

    public var body: some View {
        VStack(alignment: gravity == .start ? .leading : .trailing, spacing: 0) {
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .padding(.horizontal, textHorizontalPadding)
                .padding(.vertical, textVerticalPadding)
                .background(containerBackground)
                .clipShape(RibbonBodyShape(gravity: gravity, cornerRadius: cornerRadius))
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 2)

            RibbonTriangleShape(gravity: gravity)
                .fill(triangleColor)
                .frame(width: Self.triangleWidth, height: Self.triangleHeight)
        }
        .fixedSize()
    }

    @ViewBuilder
    private var containerBackground: some View {
        if let start = containerStartColor, let end = containerEndColor {
            LinearGradient(colors: [start, end], startPoint: .leading, endPoint: .trailing)
        } else {
            containerColor
        }
    }
}

// MARK: - Anchoring helper

private struct RibbonAnchorModifier: ViewModifier {
    let ribbon: EDTSRibbon
    let verticalAlignment: EDTSRibbonVerticalAlignment
    let offsetX: CGFloat
    let offsetY: CGFloat

    private var triangleWidth: CGFloat { EDTSRibbon.triangleWidth }
    private var triangleHeight: CGFloat { EDTSRibbon.triangleHeight }

    func body(content: Content) -> some View {
        content.overlay(alignment: overlayAlignment) {
            horizontallyGuidedRibbon
                .offset(x: offsetX, y: offsetY)
        }
    }

    private var overlayAlignment: Alignment {
        let horizontal: HorizontalAlignment = ribbon.gravity == .start ? .leading : .trailing
        let vertical: VerticalAlignment
        switch verticalAlignment {
        case .top, .defaultV: vertical = .top
        case .bottom: vertical = .bottom
        case .center: vertical = .center
        }
        return Alignment(horizontal: horizontal, vertical: vertical)
    }

    @ViewBuilder
    private var horizontallyGuidedRibbon: some View {
        switch ribbon.gravity {
        case .start:
            verticallyGuidedRibbon
                .alignmentGuide(.leading) { _ in triangleWidth }
        case .end:
            verticallyGuidedRibbon
                .alignmentGuide(.trailing) { d in d.width - triangleWidth }
        }
    }

    @ViewBuilder
    private var verticallyGuidedRibbon: some View {
        switch verticalAlignment {
        case .top:
            ribbon.alignmentGuide(.top) { d in d.height - triangleHeight }
        case .bottom:
            ribbon.alignmentGuide(.bottom) { _ in 0 }
        case .center:
            ribbon.alignmentGuide(VerticalAlignment.center) { d in (d.height - triangleHeight) / 2 }
        case .defaultV:
            ribbon.alignmentGuide(.top) { _ in -8 }
        }
    }
}

public extension View {
    func ribbon(
        _ ribbon: EDTSRibbon,
        verticalAlignment: EDTSRibbonVerticalAlignment = .defaultV,
        offsetX: CGFloat? = nil,
        offsetY: CGFloat? = nil
    ) -> some View {
        let resolvedOffsetX = offsetX ?? (
            ribbon.gravity == .start ? -EDTSRibbon.triangleWidth : EDTSRibbon.triangleWidth
        )
        let resolvedOffsetY: CGFloat
        if let offsetY {
            resolvedOffsetY = offsetY
        } else {
            switch verticalAlignment {
            case .top: resolvedOffsetY = 8
            case .bottom: resolvedOffsetY = -8
            case .center, .defaultV: resolvedOffsetY = 0
            }
        }

        return modifier(
            RibbonAnchorModifier(
                ribbon: ribbon,
                verticalAlignment: verticalAlignment,
                offsetX: resolvedOffsetX,
                offsetY: resolvedOffsetY
            )
        )
    }
}

// MARK: - Preview

#Preview("EDTSRibbon") {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            Color(uiColor: .systemGray5)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .ribbon(
                    EDTSRibbon(
                        text: "New",
                        gravity: .start,
                        triangleColor: EDTSColor.blue50,
                        containerColor: EDTSColor.blue30
                    ),
                    verticalAlignment: .top
                )

            Color(uiColor: .systemGray5)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .ribbon(
                    EDTSRibbon(
                        text: "Sale",
                        gravity: .start,
                        triangleColor: EDTSColor.red50,
                        containerColor: EDTSColor.red30
                    ),
                    verticalAlignment: .bottom
                )
            
            Color(uiColor: .systemGray5)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .ribbon(
                    EDTSRibbon(
                        text: "Promo",
                        gravity: .start,
                        triangleColor: EDTSColor.orange50,
                        containerColor: EDTSColor.orange30
                    ),
                    verticalAlignment: .center
                )
        }

        EDTSRibbon(
            text: "Standalone",
            gravity: .start,
            triangleColor: EDTSColor.green50,
            containerColor: EDTSColor.green30
        )
    }
    .padding(40)
}
