//
//  ExtensionView+SwiftUI.swift
//  EDTS_DS_SwiftUI
//
//  Original created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

// MARK: - Orientation

public enum Orientation: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case diagonalUp = "diagonalup"
    case diagonalDown = "diagonaldown"
}

// MARK: - Rounded Corner Shape (per-corner radius, mirrors UIRectCorner)

public struct RoundedCorner: Shape {
    public var radius: CGFloat = 0
    public var corners: UIRectCorner = .allCorners

    public init(radius: CGFloat = 0, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(bezierPath.cgPath)
    }
}

// MARK: - Gradient Background

public struct GradientBackgroundModifier: ViewModifier {
    let gradient: [Color]
    var orientation: Orientation = .horizontal
    var cornerRadius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    var borderWidth: CGFloat = 0
    var borderColor: Color? = nil

    private var startPoint: UnitPoint {
        orientation == .horizontal ? .leading : .top
    }
    private var endPoint: UnitPoint {
        orientation == .horizontal ? .trailing : .bottom
    }

    public func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(colors: gradient, startPoint: startPoint, endPoint: endPoint)
                    .clipShape(RoundedCorner(radius: cornerRadius, corners: corners))
            )
            .overlay(
                Group {
                    if borderWidth > 0, let borderColor {
                        RoundedCorner(radius: cornerRadius, corners: corners)
                            .stroke(borderColor, lineWidth: borderWidth)
                    }
                }
            )
    }
}

extension View {

    public func gradientBackground(
        _ gradient: [Color],
        orientation: Orientation = .horizontal,
        cornerRadius: CGFloat = 0,
        corners: UIRectCorner = .allCorners,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil
    ) -> some View {
        modifier(
            GradientBackgroundModifier(
                gradient: gradient,
                orientation: orientation,
                cornerRadius: cornerRadius,
                corners: corners,
                borderWidth: borderWidth,
                borderColor: borderColor
            )
        )
    }

    // MARK: - Circular clip

    public func applyCircular() -> some View {
        clipShape(Circle())
    }

    // MARK: - Grayscale

    public func applyGrayscale(_ isGrayscale: Bool) -> some View {
        grayscale(isGrayscale ? 1.0 : 0.0)
    }
    
    public func rippleEffect(
        color: Color = Color.black.opacity(0.12),
        cornerRadius: CGFloat = 0
    ) -> some View {
        modifier(RippleModifier(color: color, cornerRadius: cornerRadius))
    }
    
    public func circularRippleEffect(
        isActive: Binding<Bool>,
        size: CGFloat = 32,
        color: Color = Color.black.opacity(0.22)
    ) -> some View {
        modifier(CircularRippleModifier(isActive: isActive, size: size, color: color))
    }
}

// MARK: - Ripple Animation
private struct RippleInstance: Identifiable {
    let id = UUID()
    let point: CGPoint
    let maxRadius: CGFloat
}

public struct RippleModifier: ViewModifier {
    var color: Color = Color.black.opacity(0.12)
    var cornerRadius: CGFloat = 0

    @State private var ripples: [RippleInstance] = []
    @State private var containerSize: CGSize = .zero

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    ZStack {
                        ForEach(ripples) { ripple in
                            RippleShapeView(color: color, maxRadius: ripple.maxRadius)
                                .position(ripple.point)
                        }
                    }
                    .onAppear { containerSize = geo.size }
                    .onChange(of: geo.size) { containerSize = $0 }
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .allowsHitTesting(false)
            )
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        addRipple(at: value.location)
                    }
            )
    }

    private func addRipple(at point: CGPoint) {
        let radius = maxCornerDistance(from: point, in: containerSize)
        let ripple = RippleInstance(point: point, maxRadius: radius)
        ripples.append(ripple)
        let lifetime = 0.62
        DispatchQueue.main.asyncAfter(deadline: .now() + lifetime) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }

    private func maxCornerDistance(from point: CGPoint, in size: CGSize) -> CGFloat {
        let corners = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: size.width, y: 0),
            CGPoint(x: 0, y: size.height),
            CGPoint(x: size.width, y: size.height)
        ]
        return corners.map { hypot(point.x - $0.x, point.y - $0.y) }.max()
            ?? max(size.width, size.height)
    }
}

private struct RippleShapeView: View {
    let color: Color
    let maxRadius: CGFloat

    @State private var scale: CGFloat = 0.01
    @State private var opacity: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 2, height: 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.easeOut(duration: 0.10)) {
                    opacity = 1
                }
                withAnimation(.easeOut(duration: 0.40)) {
                    scale = max(maxRadius, 0.02)
                }
                withAnimation(.easeOut(duration: 0.22).delay(0.40)) {
                    opacity = 0
                }
            }
    }
}

// MARK: - Circular Ripple
public struct CircularRippleModifier: ViewModifier {
    @Binding var isActive: Bool
    var size: CGFloat = 32
    var color: Color = Color.black.opacity(0.22)

    @State private var scale: CGFloat = 0.01
    @State private var opacity: Double = 0

    public func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .allowsHitTesting(false)
            )
            .onChange(of: isActive) { active in
                if active {
                    scale = 0.01
                    withAnimation(.easeOut(duration: 0.10)) { opacity = 1 }
                    withAnimation(.easeOut(duration: 0.40)) { scale = 1 }
                } else {
                    withAnimation(.easeOut(duration: 0.22)) { opacity = 0 }
                }
            }
    }
}

// MARK: - Coupon Shape (replaces createCouponPath / applyCouponBackground)

public struct CouponShape: Shape {
    public var notchRadius: CGFloat
    public var notchPosition: CGFloat
    public var cornerRadius: CGFloat

    public init(notchRadius: CGFloat = 8, notchPosition: CGFloat, cornerRadius: CGFloat = 12) {
        self.notchRadius = notchRadius
        self.notchPosition = notchPosition
        self.cornerRadius = cornerRadius
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: cornerRadius))

        path.addArc(
            center: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))

        path.addArc(
            center: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: width, y: notchPosition - notchRadius))

        path.addArc(
            center: CGPoint(x: width, y: notchPosition),
            radius: notchRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(90),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))

        path.addArc(
            center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: cornerRadius, y: height))

        path.addArc(
            center: CGPoint(x: cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: 0, y: notchPosition + notchRadius))

        path.addArc(
            center: CGPoint(x: 0, y: notchPosition),
            radius: notchRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(270),
            clockwise: true
        )

        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        path.closeSubpath()
        return path
    }
}

extension View {
    public func couponBackground(
        notchRadius: CGFloat = 8,
        notchPosition: CGFloat,
        cornerRadius: CGFloat = 12,
        fill: Color = Color(.systemBackground)
    ) -> some View {
        let shape = CouponShape(notchRadius: notchRadius, notchPosition: notchPosition, cornerRadius: cornerRadius)
        return self
            .background(shape.fill(fill))
            .clipShape(shape)
    }
}
