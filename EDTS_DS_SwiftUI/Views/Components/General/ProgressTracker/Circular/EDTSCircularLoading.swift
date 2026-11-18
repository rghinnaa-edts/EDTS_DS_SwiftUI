//
//  EDTSCircularLoading.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/11/26.
//

import SwiftUI

// MARK: - Public Types

public enum EDTSGradientOrientation {
    case horizontal
    case vertical
    case diagonalUp
    case diagonalDown
}

public enum EDTSIntermittentAnimationType {
    case stretch
    case fixed
    case doubleArc
}

public enum EDTSRingFill {
    case solid(Color)
    case gradient(start: Color, end: Color, orientation: EDTSGradientOrientation = .horizontal)
}

public struct EDTSRingShadow {

    public var color: Color?
    public var opacity: Double
    public var radius: CGFloat
    public var offset: CGSize

    public init(color: Color? = nil, opacity: Double, radius: CGFloat, offset: CGSize = .zero) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

    public static let defaultInner = EDTSRingShadow(opacity: 0.10, radius: 2)
}

// MARK: - View

public struct EDTSCircularLoadingView: View {
    // MARK: Configuration (mirrors the old @IBInspectable properties)
    
    public var value: CGFloat
    public var maxValue: CGFloat
    public var lineCap: CGLineCap
    public var doubleArcGap: CGFloat
    public var trackSize: CGFloat
    public var trackThickness: CGFloat?
    public var trackPaddingTop: CGFloat
    public var trackPaddingBottom: CGFloat
    public var trackFill: EDTSRingFill?
    public var fill: EDTSRingFill?
    public var trackShadow: EDTSRingShadow?
    public var trackInnerShadow: EDTSRingShadow?
    public var isIntermittentState: Bool
    public var intermittentAnimationType: EDTSIntermittentAnimationType

    // MARK: Timing constants
    
    private let fillAnimationDuration: Double = 1.0
    private let stretchRotationDuration: Double = 2.4
    private let stretchSweepDuration: Double = 1.33
    private let fixedRotationDuration: Double = 1.0
    private let fixedSweepFraction: CGFloat = 0.25
    private let doubleArcRotationDuration: Double = 1.4
    private let doubleArcSweepFraction: CGFloat = 0.75

    // MARK: State
    
    @State private var displayedRatio: CGFloat = 0
    @State private var startDate = Date()

    public init(
        value: CGFloat = 0,
        maxValue: CGFloat = 100,
        lineCap: CGLineCap = .round,
        doubleArcGap: CGFloat = 4,
        trackSize: CGFloat = 50,
        trackThickness: CGFloat? = nil,
        trackPaddingTop: CGFloat = 0,
        trackPaddingBottom: CGFloat = 0,
        trackFill: EDTSRingFill? = nil,
        fill: EDTSRingFill? = nil,
        trackShadow: EDTSRingShadow? = nil,
        trackInnerShadow: EDTSRingShadow? = .defaultInner,
        isIntermittentState: Bool = false,
        intermittentAnimationType: EDTSIntermittentAnimationType = .stretch
    ) {
        self.value = value
        self.maxValue = maxValue
        self.lineCap = lineCap
        self.doubleArcGap = doubleArcGap
        self.trackSize = trackSize
        self.trackThickness = trackThickness
        self.trackPaddingTop = trackPaddingTop
        self.trackPaddingBottom = trackPaddingBottom
        self.trackFill = trackFill
        self.fill = fill
        self.trackShadow = trackShadow
        self.trackInnerShadow = trackInnerShadow
        self.isIntermittentState = isIntermittentState
        self.intermittentAnimationType = intermittentAnimationType
    }

    // MARK: Body
    
    public var body: some View {
        Group {
            if isIntermittentState {
                TimelineView(.animation) { context in
                    content(for: intermittentState(at: context.date))
                }
                .id(intermittentAnimationType)
                .onAppear { startDate = Date() }
            } else {
                content(for: RingState(start: 0, end: displayedRatio))
                    .accessibilityElement(children: .ignore)
                    .accessibilityValue(Text("\(Int((ratio * 100).rounded())) percent"))
            }
        }
        .frame(width: trackSize, height: trackSize)
        .onAppear { updateDisplayedRatio() }
        .onChange(of: ratio) { _ in updateDisplayedRatio() }
    }

    // MARK: Progress
    
    private var ratio: CGFloat {
        guard maxValue > 0 else { return 0 }
        let clamped = min(max(value, 0), maxValue)
        return min(max(clamped / maxValue, 0), 1)
    }

    private func updateDisplayedRatio() {
        if isIntermittentState {
            displayedRatio = ratio
        } else {
            withAnimation(.easeInOut(duration: fillAnimationDuration)) {
                displayedRatio = ratio
            }
        }
    }

    // MARK: Ring state
    
    private struct RingState {
        var start: CGFloat = 0
        var end: CGFloat = 0
        var outerRotation: Angle = .zero
        var innerRotation: Angle = .zero
        var isDoubleArc = false
    }

    private func intermittentState(at date: Date) -> RingState {
        let t = max(date.timeIntervalSince(startDate), 0)
        func phase(_ duration: Double) -> Double {
            (t / duration).truncatingRemainder(dividingBy: 1)
        }

        switch intermittentAnimationType {
        case .stretch:

            let u = Self.easeInOut(phase(stretchSweepDuration))
            let keyTimes: [Double] = [0, 0.25, 0.75, 1]
            let head = Self.interpolate(u, keyTimes: keyTimes, values: [0, 0, 0.75, 1])
            let tail = Self.interpolate(u, keyTimes: keyTimes, values: [0, 0.75, 1, 1])
            return RingState(
                start: head,
                end: tail,
                outerRotation: .degrees(360 * phase(stretchRotationDuration))
            )
        case .fixed:
            return RingState(
                start: 0,
                end: fixedSweepFraction,
                outerRotation: .degrees(360 * phase(fixedRotationDuration))
            )
        case .doubleArc:
            let p = phase(doubleArcRotationDuration)
            return RingState(
                start: 0,
                end: doubleArcSweepFraction,
                outerRotation: .degrees(360 * p),
                innerRotation: .degrees(-360 * p),
                isDoubleArc: true
            )
        }
    }

    // MARK: Geometry
    
    private struct Geometry {
        let diameter: CGFloat
        let thickness: CGFloat
        let paddingTop: CGFloat
        let paddingBottom: CGFloat
        let gap: CGFloat

        var radius: CGFloat { max(diameter - thickness, 0) / 2 }
        var outerEdge: CGFloat { radius + thickness / 2 }
        var innerEdge: CGFloat { radius - thickness / 2 }
        private var fillOuterEdge: CGFloat { outerEdge - paddingTop }
        private var fillInnerEdge: CGFloat { innerEdge + paddingBottom }
        var fillThickness: CGFloat { max(fillOuterEdge - fillInnerEdge, 0) }
        var fillRadius: CGFloat { (fillOuterEdge + fillInnerEdge) / 2 }
        var doubleArcInnerRadius: CGFloat { radius - thickness - gap }
    }

    private var geometry: Geometry {
        Geometry(
            diameter: trackSize,
            thickness: trackThickness ?? 6,
            paddingTop: trackPaddingTop,
            paddingBottom: trackPaddingBottom,
            gap: doubleArcGap
        )
    }

    // MARK: Layers
    
    @ViewBuilder
    private func content(for state: RingState) -> some View {
        let g = geometry
        ZStack {
            if !state.isDoubleArc {
                track(g)
                if let inner = trackInnerShadow, inner.opacity > 0 {
                    ringInnerShadow(g, shadow: inner)
                }
            }

            arc(
                fill: resolvedFill,
                radius: g.fillRadius,
                lineWidth: g.fillThickness,
                start: state.start,
                end: state.end,
                rotation: state.outerRotation
            )

            if state.isDoubleArc, g.doubleArcInnerRadius > 0 {
                arc(
                    fill: resolvedFill,
                    radius: g.doubleArcInnerRadius,
                    lineWidth: g.fillThickness,
                    start: state.start,
                    end: state.end,
                    rotation: state.innerRotation
                )
            }
        }
        .frame(width: g.diameter, height: g.diameter)
    }

    private func track(_ g: Geometry) -> some View {
        paint(resolvedTrackFill)
            .mask(
                EDTSRingArc(radius: g.radius, lineWidth: g.thickness, lineCap: lineCap, start: 0, end: 1)
            )
            .edtsShadow(trackShadow)
    }

    private func arc(
        fill: EDTSRingFill,
        radius: CGFloat,
        lineWidth: CGFloat,
        start: CGFloat,
        end: CGFloat,
        rotation: Angle
    ) -> some View {
        paint(fill)
            .mask(
                EDTSRingArc(
                    radius: radius,
                    lineWidth: lineWidth,
                    lineCap: lineCap,
                    start: start,
                    end: end,
                    rotation: rotation
                )
            )
    }

    private func ringInnerShadow(_ g: Geometry, shadow: EDTSRingShadow) -> some View {
        let color = (shadow.color ?? Self.defaultShadowColor).opacity(shadow.opacity)
        let sigma = max(shadow.radius / 2, 0.01)
        let sourceWidth = max(sigma * 6, 4)

        return ZStack {
            Circle()
                .stroke(color, lineWidth: sourceWidth)
                .frame(width: (g.outerEdge + sourceWidth / 2) * 2,
                       height: (g.outerEdge + sourceWidth / 2) * 2)

            if g.innerEdge > 0 {
                Circle()
                    .fill(color)
                    .frame(width: g.innerEdge * 2, height: g.innerEdge * 2)
            }
        }
        .frame(width: g.diameter, height: g.diameter)
        .blur(radius: sigma)
        .offset(shadow.offset)
        .mask(
            EDTSRingBand(innerRadius: max(g.innerEdge, 0))
                .fill(Color.black, style: FillStyle(eoFill: true))
        )
        .allowsHitTesting(false)
    }

    // MARK: Paint (solid / gradient)
    
    @ViewBuilder
    private func paint(_ fill: EDTSRingFill) -> some View {
        switch fill {
        case .solid(let color):
            Rectangle().fill(color)
        case .gradient(let start, let end, let orientation):
            let points = Self.gradientPoints(for: orientation)
            Rectangle().fill(
                LinearGradient(colors: [start, end], startPoint: points.start, endPoint: points.end)
            )
        }
    }

    private static func gradientPoints(for orientation: EDTSGradientOrientation) -> (start: UnitPoint, end: UnitPoint) {
        switch orientation {
        case .horizontal:
            return (UnitPoint(x: 0, y: 0.5), UnitPoint(x: 1, y: 0.5))
        case .vertical:
            return (UnitPoint(x: 0.5, y: 0), UnitPoint(x: 0.5, y: 1))
        case .diagonalUp:
            return diagonalPoints(angleDegrees: 10)
        case .diagonalDown:
            let p = diagonalPoints(angleDegrees: 170)
            return (p.end, p.start)
        }
    }

    private static func diagonalPoints(angleDegrees: CGFloat) -> (start: UnitPoint, end: UnitPoint) {
        let radians = angleDegrees * .pi / 180
        let dx = cos(radians)
        let dy = -sin(radians)
        let half: CGFloat = 0.5

        let scale: CGFloat
        if dx == 0 {
            scale = half / abs(dy)
        } else if dy == 0 {
            scale = half / abs(dx)
        } else {
            scale = min(half / abs(dx), half / abs(dy))
        }

        return (
            UnitPoint(x: half - dx * scale, y: half - dy * scale),
            UnitPoint(x: half + dx * scale, y: half + dy * scale)
        )
    }

    // MARK: Resolved defaults
    
    private static var defaultShadowColor: Color { EDTSColor.black }

    private var resolvedTrackFill: EDTSRingFill {
        trackFill ?? .solid(EDTSColor.grey20)
    }

    private var resolvedFill: EDTSRingFill {
        fill ?? .gradient(
            start: EDTSColor.skyblueLeading,
            end: EDTSColor.skyblueTrailing,
            orientation: .horizontal
        )
    }

    // MARK: Easing helpers

    private static func easeInOut(_ x: Double) -> Double {
        let (x1, y1, x2, y2) = (0.42, 0.0, 0.58, 1.0)
        func bezier(_ t: Double, _ a: Double, _ b: Double) -> Double {
            let mt = 1 - t
            return 3 * mt * mt * t * a + 3 * mt * t * t * b + t * t * t
        }
        var lo = 0.0, hi = 1.0
        for _ in 0..<24 {
            let mid = (lo + hi) / 2
            if bezier(mid, x1, x2) < x { lo = mid } else { hi = mid }
        }
        return bezier((lo + hi) / 2, y1, y2)
    }

    private static func interpolate(_ x: Double, keyTimes: [Double], values: [Double]) -> Double {
        for i in 1..<keyTimes.count where x <= keyTimes[i] {
            let span = keyTimes[i] - keyTimes[i - 1]
            let f = span > 0 ? (x - keyTimes[i - 1]) / span : 1
            return values[i - 1] + (values[i] - values[i - 1]) * f
        }
        return values.last ?? 0
    }
}

// MARK: - Shapes

struct EDTSRingArc: Shape {
    var radius: CGFloat
    var lineWidth: CGFloat
    var lineCap: CGLineCap
    var start: CGFloat = 0
    var end: CGFloat = 1
    var rotation: Angle = .zero

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(start, end) }
        set {
            start = newValue.first
            end = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let sweep = end - start
        guard sweep > 0.0001, radius > 0, lineWidth > 0 else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        if sweep >= 0.9999 {
            path.addEllipse(in: CGRect(
                x: center.x - radius, y: center.y - radius,
                width: radius * 2, height: radius * 2
            ))
        } else {
            let base = Angle.degrees(-90) + rotation
            path.addArc(
                center: center,
                radius: radius,
                startAngle: base + .degrees(Double(360 * start)),
                endAngle: base + .degrees(Double(360 * end)),
                clockwise: false
            )
        }

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, lineJoin: .round))
    }
}

struct EDTSRingBand: Shape {
    var innerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        let c = CGPoint(x: rect.midX, y: rect.midY)
        path.addEllipse(in: CGRect(
            x: c.x - innerRadius, y: c.y - innerRadius,
            width: innerRadius * 2, height: innerRadius * 2
        ))
        return path
    }
}

// MARK: - Helpers

private extension View {
    @ViewBuilder
    func edtsShadow(_ shadow: EDTSRingShadow?) -> some View {
        if let shadow, shadow.opacity > 0 {
            self.shadow(
                color: (shadow.color ?? EDTSColor.black).opacity(shadow.opacity),
                radius: shadow.radius,
                x: shadow.offset.width,
                y: shadow.offset.height
            )
        } else {
            self
        }
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var value: CGFloat = 65
        var body: some View {
            VStack(spacing: 24) {
                EDTSCircularLoadingView(value: value)

                EDTSCircularLoadingView(
                    value: value,
                    trackSize: 80,
                    trackThickness: 10,
                    fill: .gradient(start: .purple, end: .pink, orientation: .diagonalUp),
                    trackInnerShadow: EDTSRingShadow(color: EDTSColor.red50, opacity: 100.0, radius: 8, offset: CGSize(width: 4, height: 4))
                )

                HStack(spacing: 24) {
                    EDTSCircularLoadingView(isIntermittentState: true, intermittentAnimationType: .stretch)
                    EDTSCircularLoadingView(isIntermittentState: true, intermittentAnimationType: .fixed)
                    EDTSCircularLoadingView(trackSize: 64, isIntermittentState: true, intermittentAnimationType: .doubleArc)
                }

                Slider(value: $value, in: 0...100).padding(.horizontal)
            }
            .padding()
        }
    }
    return Demo()
}
