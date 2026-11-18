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
    // MARK: Configuration (same names and order as the UIKit @IBInspectable properties)

    // Value
    public var value: CGFloat
    public var maxValue: CGFloat

    // Line cap / double arc
    public var lineCapStyle: CGLineCap
    public var doubleArcGap: CGFloat

    // Fill (the progress arc). `nil` colors -> sky-blue leading -> trailing gradient.
    public var trackFillTintColor: Color?
    public var trackFillTintColorStart: Color?
    public var trackFillTintColorEnd: Color?
    public var trackFillColorOrientation: EDTSGradientOrientation?

    // Track (the background ring). `nil` colors -> EDTSColor.grey20.
    public var trackSize: CGFloat
    /// `-1` -> 6.
    public var trackThickness: CGFloat
    public var trackTintColor: Color?
    public var trackTintColorStart: Color?
    public var trackTintColorEnd: Color?
    public var trackColorOrientation: EDTSGradientOrientation?
    public var trackPaddingTop: CGFloat
    public var trackPaddingBottom: CGFloat

    // Inner shadow. Default is 0.10 / radius 2 / zero offset / black.
    // Set `trackInnerShadowOpacity: 0` to hide it.
    public var trackInnerShadowOpacity: Float?
    public var trackInnerShadowRadius: CGFloat?
    public var trackInnerShadowOffset: CGSize?
    public var trackInnerShadowColor: Color?

    // Track shadow (off by default, like UIKit's opacity 0). `nil` color -> EDTSColor.black.
    public var trackShadowOpacity: Float
    public var trackShadowRadius: CGFloat
    public var trackShadowOffset: CGSize
    public var trackShadowColor: Color?

    // States
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
                    content(for: intermittentState(at: context.date))
                }
                .id(intermittentAnimationType) // restart when the type changes
                .onAppear { startDate = Date() }
            } else {
                content(for: RingState(start: 0, end: displayedRatio, capCompensated: true))
                    .accessibilityElement(children: .ignore)
                    .accessibilityValue(Text("\(Int((ratio * 100).rounded())) percent"))
            }
        }
        .frame(width: trackSize, height: trackSize)
        .onAppear { updateDisplayedRatio(to: ratio) }
        .onChange(of: ratio) { newRatio in updateDisplayedRatio(to: newRatio) }
    }

    // MARK: Progress

    private var ratio: CGFloat {
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

    // MARK: Resolved values (UIKit's applyGradient + setupUI defaults)

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

    /// `trackFill*` in UIKit is the progress arc.
    private var resolvedFill: EDTSRingFill {
        resolveFill(
            solid: trackFillTintColor, start: trackFillTintColorStart, end: trackFillTintColorEnd,
            orientation: trackFillColorOrientation,
            fallback: .gradient(start: EDTSColor.skyblueLeading, end: EDTSColor.skyblueTrailing, orientation: .horizontal)
        )
    }

    /// `track*` in UIKit is the background ring.
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
        /// Progress mode only: shrink the arc by the line cap so the visible length equals the ratio.
        var capCompensated = false
    }

    private func intermittentState(at date: Date) -> RingState {
        let t = max(date.timeIntervalSince(startDate), 0)
        func phase(_ duration: Double) -> Double {
            (t / duration).truncatingRemainder(dividingBy: 1)
        }

        switch intermittentAnimationType {
        case .stretch:
            // Same keyframes as animateStretch(), eased like the group's easeInEaseOut.
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
                innerRotation: .degrees(-360 * p), // counter-clockwise
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

        var radius: CGFloat { max(diameter - thickness, 0) / 2 }       // track centerline
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
            // Track + inner shadow (hidden in double-arc mode, like the UIKit version)
            if !state.isDoubleArc {
                track(g)
                if resolvedInnerShadow.opacity > 0 {
                    ringInnerShadow(g, shadow: resolvedInnerShadow)
                }
            }

            // Outer fill arc
            arc(
                fill: resolvedFill,
                radius: g.fillRadius,
                lineWidth: g.fillThickness,
                start: state.start,
                end: state.end,
                rotation: state.outerRotation,
                capCompensated: state.capCompensated
            )

            // Inner counter-rotating arc (double arc only)
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
        // The gradient stays fixed while the masking arc rotates,
        // matching the UIKit gradient-layer + mask setup.
        paint(fill)
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

    /// Soft inner shadow that wraps the ring like a donut: it hugs both the outer and
    /// inner edge of the track and is clipped to the ring band.
    private func ringInnerShadow(_ g: Geometry, shadow: EDTSRingShadow) -> some View {
        let color = (shadow.color ?? EDTSColor.black).opacity(shadow.opacity)
        // CALayer's shadowRadius is a blur diameter; SwiftUI's blur(radius:) is the
        // gaussian sigma, which is roughly half of it.
        let sigma = max(shadow.radius / 2, 0.01)
        // The shadow source must lie entirely *outside* each edge of the ring
        // (a blurred half-plane), otherwise it darkens thin rings uniformly.
        let sourceWidth = max(sigma * 6, 4)

        return ZStack {
            // Outside the outer edge: a band from outerEdge to outerEdge + sourceWidth.
            Circle()
                .stroke(color, lineWidth: sourceWidth)
                .frame(width: (g.outerEdge + sourceWidth / 2) * 2,
                       height: (g.outerEdge + sourceWidth / 2) * 2)
            // Inside the inner edge: the hole itself casts a shadow onto the ring.
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
            // `unitPoints` comes from the EDTSGradientOrientation extension in the tracker section.
            let p = orientation.unitPoints
            Rectangle().fill(
                LinearGradient(colors: [start, end], startPoint: p.start, endPoint: p.end)
            )
        }
    }

    // MARK: Easing helpers

    /// cubic-bezier(0.42, 0, 0.58, 1) — CAMediaTimingFunction(name: .easeInEaseOut)
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

/// A stroked arc, emitted as a filled outline so line caps are part of the path.
/// `start`/`end` are fractions of the circle (like strokeStart/strokeEnd),
/// measured clockwise from 12 o'clock. Both are animatable.
/// A stroked arc, emitted as a filled outline so line caps are part of the path.
/// `start`/`end` are fractions of the circle (like strokeStart/strokeEnd),
/// measured clockwise from 12 o'clock. Both are animatable.
struct EDTSRingArc: Shape {
    var radius: CGFloat
    var lineWidth: CGFloat
    var lineCap: CGLineCap
    var start: CGFloat = 0
    var end: CGFloat = 1
    var rotation: Angle = .zero
    /// When true, the arc is pulled in by the cap size at both ends, so the *visible* length
    /// (caps included) equals `end - start`. Nothing is drawn at 0 and a full ring at 1.
    var capCompensated: Bool = false

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(start, end) }
        set {
            start = newValue.first
            end = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        guard radius > 0, lineWidth > 0 else { return Path() }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        if end - start >= (capCompensated ? 0.995 : 0.9999) {
            // Full ring: a closed ellipse has no caps, so no seam.
            path.addEllipse(in: CGRect(
                x: center.x - radius, y: center.y - radius,
                width: radius * 2, height: radius * 2
            ))
        } else {
            var s = start
            var e = end
            if capCompensated && lineCap != .butt {
                // Each non-butt cap extends lineWidth / 2 past the arc end, as a fraction of the circle.
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
                clockwise: false // false == visually clockwise in SwiftUI's flipped space
            )
        }

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, lineJoin: .round))
    }
}

/// Outer circle (rect-sized) + inner circle; fill with `eoFill: true` for a ring.
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
                    trackFillTintColorStart: .purple,
                    trackFillTintColorEnd: .pink,
                    trackFillColorOrientation: .diagonalUp,
                    trackSize: 80,
                    trackThickness: 10,
                    trackInnerShadowOpacity: 1,
                    trackInnerShadowRadius: 8,
                    trackInnerShadowOffset: CGSize(width: 4, height: 4),
                    trackInnerShadowColor: EDTSColor.red50
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
