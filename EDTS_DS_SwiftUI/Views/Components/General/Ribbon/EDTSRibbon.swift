//
//  EDTSRibbon.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 19/08/26.
//

import SwiftUI

// MARK: - Public types

public nonisolated enum EDTSRibbonGravity: Equatable, Sendable {
    case leading
    case trailing
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
        let corners: UIRectCorner = gravity == .leading
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
        if gravity == .leading {
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
    public var text: String
    public var textAttributed: AttributedString?
    public var textColor: Color
    public var fontStyle: Font?
    public var fontName: String = ""
    public var fontSize: CGFloat = .zero
    public var fontWeight: String? = nil
    public var gravity: EDTSRibbonGravity
    public var triangleColor: Color
    public var bgColor: Color
    public var bgColorStart: Color?
    public var bgColorEnd: Color?
    public var shadowColor: Color
    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var cornerRadius: CGFloat
    public var paddingTop: CGFloat
    public var paddingLeading: CGFloat
    public var paddingBottom: CGFloat
    public var paddingTrailing: CGFloat
    public var offsetX: CGFloat
    public var offsetY: CGFloat

    static let triangleWidth: CGFloat = 6
    static let triangleHeight: CGFloat = 6
    static let defaultVerticalNudge: CGFloat = 8

    public init(
        text: String,
        textAttributed: AttributedString? = nil,
        textColor: Color = EDTSColor.white,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        gravity: EDTSRibbonGravity = .leading,
        triangleColor: Color = EDTSColor.blue50,
        bgColor: Color = EDTSColor.blue30,
        bgColorStart: Color? = nil,
        bgColorEnd: Color? = nil,
        shadowColor: Color = .black,
        shadowOpacity: Double = 0.15,
        shadowRadius: CGFloat = 6,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        cornerRadius: CGFloat = 4,
        paddingTop: CGFloat = 2,
        paddingLeading: CGFloat = 4,
        paddingBottom: CGFloat = 2,
        paddingTrailing: CGFloat = 4,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0
    ) {
        self.text = text
        self.textAttributed = textAttributed
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.gravity = gravity
        self.triangleColor = triangleColor
        self.bgColor = bgColor
        self.bgColorStart = bgColorStart
        self.bgColorEnd = bgColorEnd
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.cornerRadius = cornerRadius
        self.paddingTop = paddingTop
        self.paddingLeading = paddingLeading
        self.paddingBottom = paddingBottom
        self.paddingTrailing = paddingTrailing
        self.offsetX = offsetX
        self.offsetY = offsetY
    }

    public var body: some View {
        VStack(alignment: gravity == .leading ? .leading : .trailing, spacing: 0) {
            Group {
                if let textAttributed {
                    Text(textAttributed)
                } else {
                    Text(text)
                }
            }
            .font(resolvedFont())
            .foregroundColor(textColor)
            .padding(EdgeInsets(
                top: paddingTop,
                leading: paddingLeading,
                bottom: paddingBottom,
                trailing: paddingTrailing
            ))
            .background(containerBackground)
            .clipShape(RibbonBodyShape(gravity: gravity, cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor.opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )

            RibbonTriangleShape(gravity: gravity)
                .fill(triangleColor)
                .frame(width: Self.triangleWidth, height: Self.triangleHeight)
        }
        .fixedSize()
        .offset(x: offsetX, y: offsetY)
    }

    @ViewBuilder
    private var containerBackground: some View {
        if bgColorStart != nil || bgColorEnd != nil {
            LinearGradient(
                colors: [bgColorStart ?? .white, bgColorEnd ?? .white],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            bgColor
        }
    }
    
    private func resolvedFont() -> Font {
        if let fontStyle {
            return fontStyle
        }

        if fontName.isEmpty && fontSize <= 0 && fontWeight == nil {
            return EDTSFont.Klik.B3.Medium.font
        }

        let size = fontSize > 0 ? fontSize : UIFont.systemFontSize
        var font: Font = fontName.isEmpty ? .system(size: size) : .custom(fontName, size: size)

        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }

        return font
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
    private var defaultVerticalNudge: CGFloat { EDTSRibbon.defaultVerticalNudge }

    func body(content: Content) -> some View {
        content.overlay(alignment: overlayAlignment) {
            horizontallyGuidedRibbon
                .offset(x: offsetX, y: offsetY)
        }
    }

    private var overlayAlignment: Alignment {
        let horizontal: HorizontalAlignment = ribbon.gravity == .leading ? .leading : .trailing
        let vertical: VerticalAlignment
        switch verticalAlignment {
        case .top, .defaultV:
            vertical = .top
        case .bottom:
            vertical = .bottom
        case .center:
            vertical = .center
        }
        return Alignment(horizontal: horizontal, vertical: vertical)
    }

    @ViewBuilder
    private var horizontallyGuidedRibbon: some View {
        switch ribbon.gravity {
        case .leading:
            verticallyGuidedRibbon
                .alignmentGuide(.leading) { _ in
                    triangleWidth
                }
        case .trailing:
            verticallyGuidedRibbon
                .alignmentGuide(.trailing) { d in
                    d.width - triangleWidth
                }
        }
    }

    @ViewBuilder
    private var verticallyGuidedRibbon: some View {
        switch verticalAlignment {
        case .top:
            ribbon.alignmentGuide(.top) { d in
                d.height - triangleHeight
            }
        case .bottom:
            ribbon.alignmentGuide(.bottom) { _ in
                0
            }
        case .center:
            ribbon.alignmentGuide(VerticalAlignment.center) { d in
                (d.height - triangleHeight) / 2
            }
        case .defaultV:
            ribbon.alignmentGuide(.top) { _ in
                -defaultVerticalNudge
            }
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
            ribbon.gravity == .leading ? -EDTSRibbon.triangleWidth : EDTSRibbon.triangleWidth
        )
        let resolvedOffsetY: CGFloat
        if let offsetY {
            resolvedOffsetY = offsetY
        } else {
            switch verticalAlignment {
            case .top:
                resolvedOffsetY = EDTSRibbon.defaultVerticalNudge
            case .bottom:
                resolvedOffsetY = -EDTSRibbon.defaultVerticalNudge
            case .center, .defaultV:
                resolvedOffsetY = 0
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
                        gravity: .leading,
                        triangleColor: EDTSColor.blue50,
                        bgColor: EDTSColor.blue30
                    ),
                    verticalAlignment: .top
                )

            Color(uiColor: .systemGray5)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .ribbon(
                    EDTSRibbon(
                        text: "Sale",
                        gravity: .leading,
                        triangleColor: EDTSColor.red50,
                        bgColor: EDTSColor.red30
                    ),
                    verticalAlignment: .bottom
                )
            
            Color(uiColor: .systemGray5)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .ribbon(
                    EDTSRibbon(
                        text: "Promo",
                        gravity: .leading,
                        triangleColor: EDTSColor.orange50,
                        bgColor: EDTSColor.orange30
                    ),
                    verticalAlignment: .center
                )
        }

        EDTSRibbon(
            text: "Standalone",
            gravity: .leading,
            triangleColor: EDTSColor.green50,
            bgColor: EDTSColor.green30
        )
    }
    .padding(40)
}
