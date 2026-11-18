//
//  EDTSCircularLoading.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/11/26.
//

import SwiftUI

// MARK: - Enum

public enum EDTSGradientOrientation {
    case horizontal
    case vertical
    case diagonalUp
    case diagonalDown
    
    var unitPoints: (start: UnitPoint, end: UnitPoint) {
        switch self {
        case .horizontal: return (UnitPoint(x: 0, y: 0.5), UnitPoint(x: 1, y: 0.5))
        case .vertical:   return (UnitPoint(x: 0.5, y: 0), UnitPoint(x: 0.5, y: 1))
        case .diagonalUp: return Self.diagonal(angleDegrees: 10)
        case .diagonalDown:
            let p = Self.diagonal(angleDegrees: 170)
            return (p.end, p.start)
        }
    }

    private static func diagonal(angleDegrees: CGFloat) -> (start: UnitPoint, end: UnitPoint) {
        let r = angleDegrees * .pi / 180
        let dx = cos(r), dy = -sin(r)
        let scale = min(0.5 / max(abs(dx), 0.0001), 0.5 / max(abs(dy), 0.0001))
        return (UnitPoint(x: 0.5 - dx * scale, y: 0.5 - dy * scale),
                UnitPoint(x: 0.5 + dx * scale, y: 0.5 + dy * scale))
    }
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

public struct EDTSCircularLoading: View {
    // MARK: Properties

    public var value: CGFloat
    public var maxValue: CGFloat
    public var lineCapStyle: CGLineCap
    public var doubleArcGap: CGFloat
    public var trackFillTintColor: Color?
    public var trackFillTintColorStart: Color?
    public var trackFillTintColorEnd: Color?
    public var trackFillColorOrientation: EDTSGradientOrientation?
    public var trackSize: CGFloat
    public var trackThickness: CGFloat
    public var trackTintColor: Color?
    public var trackTintColorStart: Color?
    public var trackTintColorEnd: Color?
    public var trackColorOrientation: EDTSGradientOrientation?
    public var trackPaddingTop: CGFloat
    public var trackPaddingBottom: CGFloat
    public var trackInnerShadowOpacity: Float?
    public var trackInnerShadowRadius: CGFloat?
    public var trackInnerShadowOffset: CGSize?
    public var trackInnerShadowColor: Color?
    public var trackShadowOpacity: Float
    public var trackShadowRadius: CGFloat
    public var trackShadowOffset: CGSize
    public var trackShadowColor: Color?

    public var isIntermittentState: Bool
    public var intermittentAnimationType: EDTSIntermittentAnimationType

    // MARK: Private Variable
    
    private let fillAnimationDuration: Double = 1.0
    private let stretchRotationDuration: Double = 2.4
    private let stretchSweepDuration: Double = 1.33
    private let fixedRotationDuration: Double = 1.0
    private let fixedSweepFraction: CGFloat = 0.25
    private let doubleArcRotationDuration: Double = 1.4
    private let doubleArcSweepFraction: CGFloat = 0.75

    @State private var displayedRatio: CGFloat = 0
    @State private var startDate = Date()

    public init(
        value: CGFloat = 0,
        maxValue: CGFloat = 100,
        lineCapStyle: CGLineCap = .round,
        doubleArcGap: CGFloat = 4,
        trackFillTintColor: Color? = nil,
        trackFillTintColorStart: Color? = nil,
        trackFillTintColorEnd: Color? = nil,
        trackFillColorOrientation: EDTSGradientOrientation? = nil,
        trackSize: CGFloat = 50,
        trackThickness: CGFloat = -1,
        trackTintColor: Color? = nil,
        trackTintColorStart: Color? = nil,
        trackTintColorEnd: Color? = nil,
        trackColorOrientation: EDTSGradientOrientation? = nil,
        trackPaddingTop: CGFloat = 0,
        trackPaddingBottom: CGFloat = 0,
        trackInnerShadowOpacity: Float? = nil,
        trackInnerShadowRadius: CGFloat? = nil,
        trackInnerShadowOffset: CGSize? = nil,
        trackInnerShadowColor: Color? = nil,
        trackShadowOpacity: Float = 0,
        trackShadowRadius: CGFloat = 0,
        trackShadowOffset: CGSize = .zero,
        trackShadowColor: Color? = nil,
        isIntermittentState: Bool = false,
        intermittentAnimationType: EDTSIntermittentAnimationType = .stretch
    ) {
        self.value = value
        self.maxValue = maxValue
        self.lineCapStyle = lineCapStyle
        self.doubleArcGap = doubleArcGap
        self.trackFillTintColor = trackFillTintColor
        self.trackFillTintColorStart = trackFillTintColorStart
        self.trackFillTintColorEnd = trackFillTintColorEnd
        self.trackFillColorOrientation = trackFillColorOrientation
        self.trackSize = trackSize
        self.trackThickness = trackThickness
        self.trackTintColor = trackTintColor
        self.trackTintColorStart = trackTintColorStart
        self.trackTintColorEnd = trackTintColorEnd
        self.trackColorOrientation = trackColorOrientation
        self.trackPaddingTop = trackPaddingTop
        self.trackPaddingBottom = trackPaddingBottom
        self.trackInnerShadowOpacity = trackInnerShadowOpacity
        self.trackInnerShadowRadius = trackInnerShadowRadius
        self.trackInnerShadowOffset = trackInnerShadowOffset
        self.trackInnerShadowColor = trackInnerShadowColor
        self.trackShadowOpacity = trackShadowOpacity
        self.trackShadowRadius = trackShadowRadius
        self.trackShadowOffset = trackShadowOffset
        self.trackShadowColor = trackShadowColor
        self.isIntermittentState = isIntermittentState
        self.intermittentAnimationType = intermittentAnimationType
    }

    // MARK: Body

    public var body: some View {
        Group {
            if isIntermittentState {
                TimelineView(.animation) { context in
                    content(for: setupIntermittentAnimation(at: context.date))
                }
                .id(intermittentAnimationType)
                .onAppear { startDate = Date() }
            } else {
                content(for: RingState(start: 0, end: displayedRatio, capCompensated: true))
                    .accessibilityElement(children: .ignore)
                    .accessibilityValue(Text("\(Int((calculateRatio * 100).rounded())) percent"))
            }
        }
        .frame(width: trackSize, height: trackSize)
        .onAppear { updateDisplayedRatio(to: calculateRatio) }
        .onChange(of: calculateRatio) { newRatio in updateDisplayedRatio(to: newRatio) }
    }

    // MARK: Progress

    private var calculateRatio: CGFloat {
        guard maxValue > 0 else { return 0 }
        let clamped = min(max(value, 0), maxValue)
        return min(max(clamped / maxValue, 0), 1)
    }

    private func updateDisplayedRatio(to target: CGFloat) {
        if isIntermittentState {
            displayedRatio = target
        } else {
            withAnimation(.easeInOut(duration: fillAnimationDuration)) {
                displayedRatio = target
            }
        }
    }

    // MARK: Resolved values

    private func resolveFill(
        solid: Color?, start: Color?, end: Color?,
        orientation: EDTSGradientOrientation?, fallback: EDTSRingFill
    ) -> EDTSRingFill {
        if start != nil || end != nil {
            return .gradient(start: start ?? .clear, end: end ?? .clear, orientation: orientation ?? .horizontal)
        }
        if let solid { return .solid(solid) }
        return fallback
    }

    private var resolvedFill: EDTSRingFill {
        resolveFill(
            solid: trackFillTintColor, start: trackFillTintColorStart, end: trackFillTintColorEnd,
            orientation: trackFillColorOrientation,
            fallback: .gradient(start: EDTSColor.skyblueLeading, end: EDTSColor.skyblueTrailing, orientation: .horizontal)
        )
    }

    private var resolvedTrackFill: EDTSRingFill {
        resolveFill(
            solid: trackTintColor, start: trackTintColorStart, end: trackTintColorEnd,
            orientation: trackColorOrientation,
            fallback: .solid(EDTSColor.grey20)
        )
    }

    private var resolvedInnerShadow: EDTSRingShadow {
        EDTSRingShadow(
            color: trackInnerShadowColor,
            opacity: Double(trackInnerShadowOpacity ?? 0.10),
            radius: trackInnerShadowRadius ?? 2,
            offset: trackInnerShadowOffset ?? .zero
        )
    }

    private var resolvedTrackShadow: EDTSRingShadow? {
        guard trackShadowOpacity > 0 else { return nil }
        return EDTSRingShadow(
            color: trackShadowColor,
            opacity: Double(trackShadowOpacity),
            radius: trackShadowRadius,
            offset: trackShadowOffset
        )
    }

    // MARK: Ring state

    private struct RingState {
        var start: CGFloat = 0
        var end: CGFloat = 0
        var outerRotation: Angle = .zero
        var innerRotation: Angle = .zero
        var isDoubleArc = false
        var capCompensated = false
    }

    private func setupIntermittentAnimation(at date: Date) -> RingState {
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
            thickness: trackThickness >= 0 ? trackThickness : 6,
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
                if resolvedInnerShadow.opacity > 0 {
                    setupInnerShadow(g, shadow: resolvedInnerShadow)
                }
            }

            arc(
                fill: resolvedFill,
                radius: g.fillRadius,
                lineWidth: g.fillThickness,
                start: state.start,
                end: state.end,
                rotation: state.outerRotation,
                capCompensated: state.capCompensated
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
        setupBgColor(resolvedTrackFill)
            .mask(
                EDTSRingArc(radius: g.radius, lineWidth: g.thickness, lineCap: lineCapStyle, start: 0, end: 1)
            )
            .edtsShadow(resolvedTrackShadow)
    }

    private func arc(
        fill: EDTSRingFill,
        radius: CGFloat,
        lineWidth: CGFloat,
        start: CGFloat,
        end: CGFloat,
        rotation: Angle,
        capCompensated: Bool = false
    ) -> some View {
        setupBgColor(fill)
            .mask(
                EDTSRingArc(
                    radius: radius,
                    lineWidth: lineWidth,
                    lineCap: lineCapStyle,
                    start: start,
                    end: end,
                    rotation: rotation,
                    capCompensated: capCompensated
                )
            )
    }

    private func setupInnerShadow(_ g: Geometry, shadow: EDTSRingShadow) -> some View {
        let color = (shadow.color ?? EDTSColor.black).opacity(shadow.opacity)
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

    // MARK: Paint

    @ViewBuilder
    private func setupBgColor(_ fill: EDTSRingFill) -> some View {
        switch fill {
        case .solid(let color):
            Rectangle().fill(color)
        case .gradient(let start, let end, let orientation):
            let p = orientation.unitPoints
            Rectangle().fill(
                LinearGradient(colors: [start, end], startPoint: p.start, endPoint: p.end)
            )
        }
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

public struct EDTSRingArc: Shape {
    public var radius: CGFloat
    public var lineWidth: CGFloat
    public var lineCap: CGLineCap
    public var start: CGFloat = 0
    public var end: CGFloat = 1
    public var rotation: Angle = .zero
    public var capCompensated: Bool = false

    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(start, end) }
        set {
            start = newValue.first
            end = newValue.second
        }
    }

    public func path(in rect: CGRect) -> Path {
        guard radius > 0, lineWidth > 0 else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        if end - start >= (capCompensated ? 0.995 : 0.9999) {
            path.addEllipse(in: CGRect(
                x: center.x - radius, y: center.y - radius,
                width: radius * 2, height: radius * 2
            ))
        } else {
            var s = start
            var e = end
            if capCompensated && lineCap != .butt {
                let capFraction = (lineWidth / 2) / (2 * .pi * radius)
                s += capFraction
                e -= capFraction
            }
            guard e - s > 0.0001 else { return Path() }

            let base = Angle.degrees(-90) + rotation
            path.addArc(
                center: center,
                radius: radius,
                startAngle: base + .degrees(Double(360 * s)),
                endAngle: base + .degrees(Double(360 * e)),
                clockwise: false
            )
        }

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, lineJoin: .round))
    }
}

// MARK: - Helpers

public struct EDTSRingBand: Shape {
    var innerRadius: CGFloat

    public func path(in rect: CGRect) -> Path {
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

public extension View {
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
                EDTSCircularLoading(value: value)

                EDTSCircularLoading(
                    value: value,
                    trackFillTintColorStart: .purple,
                    trackFillTintColorEnd: .pink,
                    trackFillColorOrientation: .diagonalUp,
                    trackSize: 80,
                    trackThickness: 10
                )

                HStack(spacing: 24) {
                    EDTSCircularLoading(isIntermittentState: true, intermittentAnimationType: .stretch)
                    EDTSCircularLoading(isIntermittentState: true, intermittentAnimationType: .fixed)
                    EDTSCircularLoading(trackSize: 64, isIntermittentState: true, intermittentAnimationType: .doubleArc)
                }

                Slider(value: $value, in: 0...100).padding(.horizontal)
            }
            .padding()
        }
    }
    return Demo()
}
