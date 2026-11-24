//
//  EDTSProgressTracker.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/11/26.
//

import SwiftUI
import Combine

public typealias EDTSTrackFill = EDTSRingFill
public typealias EDTSTrackShadow = EDTSRingShadow

// MARK: - View

public struct EDTSProgressTracker: View {
    // MARK: Properties

    public var trackFillTintColor: Color?
    public var trackFillTintColorStart: Color?
    public var trackFillTintColorEnd: Color?
    public var trackFillColorOrientation: EDTSGradientOrientation?

    public var trackFullTintColor: Color?
    public var trackFullTintColorStart: Color?
    public var trackFullTintColorEnd: Color?
    public var trackFullColorOrientation: EDTSGradientOrientation?

    public var trackTintColor: Color?
    public var trackTintColorStart: Color?
    public var trackTintColorEnd: Color?
    public var trackColorOrientation: EDTSGradientOrientation?
    
    public var value: CGFloat
    public var maxValue: CGFloat
    public var limitValue: CGFloat?

    public var indicatorTintColor: Color?
    public var indicatorTintColorStart: Color?
    public var indicatorTintColorEnd: Color?
    public var indicatorColorOrientation: EDTSGradientOrientation?
    public var indicatorSize: CGFloat
    public var indicatorCornerRadius: CGFloat

    public var badgeLabel: String?
    public var badgeLabelAttributed: AttributedString?
    public var badgeLabelColor: Color?
    public var badgeFontStyle: Font?
    public var badgeFontName: String
    public var badgeFontSize: CGFloat
    public var badgeFontWeight: Font.Weight
    public var badgeTintColor: Color?
    public var badgeTintColorStart: Color?
    public var badgeTintColorEnd: Color?
    public var badgeColorOrientation: EDTSGradientOrientation?
    public var badgeSize: CGFloat
    public var badgeCornerRadius: CGFloat
    public var badgePaddingTop: CGFloat
    public var badgePaddingBottom: CGFloat
    public var badgePaddingLeading: CGFloat
    public var badgePaddingTrailing: CGFloat

    public var trackHeight: CGFloat
    public var trackCornerRadius: CGFloat
    
    public var trackPaddingTop: CGFloat
    public var trackPaddingBottom: CGFloat
    public var trackPaddingLeading: CGFloat
    public var trackPaddingTrailing: CGFloat
    
    public var trackInnerShadowOpacity: Float?
    public var trackInnerShadowRadius: CGFloat?
    public var trackInnerShadowOffset: CGSize?
    public var trackInnerShadowColor: Color?

    public var trackShadowOpacity: Float
    public var trackShadowRadius: CGFloat
    public var trackShadowOffset: CGSize
    public var trackShadowColor: Color?

    public var isHasIndicator: Bool?
    public var isHasBadge: Bool?
    public var isLoadingState: Bool
    public var isIntermittentState: Bool
    public var intermittentAnimationType: EDTSIntermittentAnimationType

    // MARK: Private Variable

    private let intermittentAnimationDuration: Double = 0.7
    
    private var isPoinku: Bool { EDTSColor.theme == .poinku }

    private var defaultGradient: EDTSTrackFill {
        .gradient(start: EDTSColor.skyblueLeading, end: EDTSColor.skyblueTrailing, orientation: .horizontal)
    }
    
    @StateObject private var model = EDTSProgressTrackerModel()
    @State private var intermittentStart = Date()

    // MARK: Initializers
    
    public init(
        trackFillTintColor: Color? = nil,
        trackFillTintColorStart: Color? = nil,
        trackFillTintColorEnd: Color? = nil,
        trackFillColorOrientation: EDTSGradientOrientation? = nil,
        trackFullTintColor: Color? = nil,
        trackFullTintColorStart: Color? = nil,
        trackFullTintColorEnd: Color? = nil,
        trackFullColorOrientation: EDTSGradientOrientation? = nil,
        value: CGFloat = 0,
        maxValue: CGFloat = 100,
        limitValue: CGFloat? = nil,
        indicatorTintColor: Color? = nil,
        indicatorTintColorStart: Color? = nil,
        indicatorTintColorEnd: Color? = nil,
        indicatorColorOrientation: EDTSGradientOrientation? = nil,
        indicatorSize: CGFloat = 8,
        indicatorCornerRadius: CGFloat = -1,
        badgeLabel: String? = nil,
        badgeLabelAttributed: AttributedString? = nil,
        badgeLabelColor: Color? = nil,
        badgeFontStyle: Font? = nil,
        badgeFontName: String = "",
        badgeFontSize: CGFloat = 8,
        badgeFontWeight: Font.Weight = .bold,
        badgeTintColor: Color? = nil,
        badgeTintColorStart: Color? = nil,
        badgeTintColorEnd: Color? = nil,
        badgeColorOrientation: EDTSGradientOrientation? = nil,
        badgeSize: CGFloat = 16,
        badgeCornerRadius: CGFloat = -1,
        badgePaddingTop: CGFloat = 2,
        badgePaddingBottom: CGFloat = 2,
        badgePaddingLeading: CGFloat = 4,
        badgePaddingTrailing: CGFloat = 4,
        trackTintColor: Color? = nil,
        trackTintColorStart: Color? = nil,
        trackTintColorEnd: Color? = nil,
        trackColorOrientation: EDTSGradientOrientation? = nil,
        trackHeight: CGFloat = -1,
        trackCornerRadius: CGFloat = -1,
        trackPaddingTop: CGFloat = -1,
        trackPaddingBottom: CGFloat = -1,
        trackPaddingLeading: CGFloat = -1,
        trackPaddingTrailing: CGFloat = -1,
        trackInnerShadowOpacity: Float? = nil,
        trackInnerShadowRadius: CGFloat? = nil,
        trackInnerShadowOffset: CGSize? = nil,
        trackInnerShadowColor: Color? = nil,
        trackShadowOpacity: Float = 0,
        trackShadowRadius: CGFloat = 3,
        trackShadowOffset: CGSize = CGSize(width: 0, height: -3),
        trackShadowColor: Color? = nil,
        isHasIndicator: Bool? = nil,
        isHasBadge: Bool? = nil,
        isLoadingState: Bool = false,
        isIntermittentState: Bool = false,
        intermittentAnimationType: EDTSIntermittentAnimationType = .stretch
    ) {
        self.trackFillTintColor = trackFillTintColor
        self.trackFillTintColorStart = trackFillTintColorStart
        self.trackFillTintColorEnd = trackFillTintColorEnd
        self.trackFillColorOrientation = trackFillColorOrientation
        self.trackFullTintColor = trackFullTintColor
        self.trackFullTintColorStart = trackFullTintColorStart
        self.trackFullTintColorEnd = trackFullTintColorEnd
        self.trackFullColorOrientation = trackFullColorOrientation
        self.value = value
        self.maxValue = maxValue
        self.limitValue = limitValue
        self.indicatorTintColor = indicatorTintColor
        self.indicatorTintColorStart = indicatorTintColorStart
        self.indicatorTintColorEnd = indicatorTintColorEnd
        self.indicatorColorOrientation = indicatorColorOrientation
        self.indicatorSize = indicatorSize
        self.indicatorCornerRadius = indicatorCornerRadius
        self.badgeLabel = badgeLabel
        self.badgeLabelAttributed = badgeLabelAttributed
        self.badgeLabelColor = badgeLabelColor
        self.badgeFontStyle = badgeFontStyle
        self.badgeFontName = badgeFontName
        self.badgeFontSize = badgeFontSize
        self.badgeFontWeight = badgeFontWeight
        self.badgeTintColor = badgeTintColor
        self.badgeTintColorStart = badgeTintColorStart
        self.badgeTintColorEnd = badgeTintColorEnd
        self.badgeColorOrientation = badgeColorOrientation
        self.badgeSize = badgeSize
        self.badgeCornerRadius = badgeCornerRadius
        self.badgePaddingTop = badgePaddingTop
        self.badgePaddingBottom = badgePaddingBottom
        self.badgePaddingLeading = badgePaddingLeading
        self.badgePaddingTrailing = badgePaddingTrailing
        self.trackTintColor = trackTintColor
        self.trackTintColorStart = trackTintColorStart
        self.trackTintColorEnd = trackTintColorEnd
        self.trackColorOrientation = trackColorOrientation
        self.trackHeight = trackHeight
        self.trackCornerRadius = trackCornerRadius
        self.trackPaddingTop = trackPaddingTop
        self.trackPaddingBottom = trackPaddingBottom
        self.trackPaddingLeading = trackPaddingLeading
        self.trackPaddingTrailing = trackPaddingTrailing
        self.trackInnerShadowOpacity = trackInnerShadowOpacity
        self.trackInnerShadowRadius = trackInnerShadowRadius
        self.trackInnerShadowOffset = trackInnerShadowOffset
        self.trackInnerShadowColor = trackInnerShadowColor
        self.trackShadowOpacity = trackShadowOpacity
        self.trackShadowRadius = trackShadowRadius
        self.trackShadowOffset = trackShadowOffset
        self.trackShadowColor = trackShadowColor
        self.isHasIndicator = isHasIndicator
        self.isHasBadge = isHasBadge
        self.isLoadingState = isLoadingState
        self.isIntermittentState = isIntermittentState
        self.intermittentAnimationType = intermittentAnimationType
    }

    // MARK: Body
    
    public var body: some View {
        GeometryReader { geo in
            progressTracker(width: geo.size.width)
                .frame(width: geo.size.width, height: geo.size.height)
                .onAppear { model.setTrackWidth(geo.size.width) }
                .onChange(of: geo.size.width) { model.setTrackWidth($0) }
        }
        .frame(height: contentHeight)
        .onAppear {
            model.configure(config)
            if value != 0 { model.setValue(value) }
            model.setIntermittent(isIntermittentState)
        }
        .onChange(of: config) { model.configure($0) }
        .onChange(of: value) { model.setValue($0) }
        .onChange(of: isIntermittentState) { model.setIntermittent($0) }
        .accessibilityElement(children: .ignore)
        .accessibilityValue(Text("\(Int(((maxValue > 0 ? value / maxValue : 0) * 100).rounded())) percent"))
    }

    // MARK: Resolved values
    
    private var resolvedTrackFill: EDTSTrackFill {
        edtsResolveFill(solid: trackTintColor, start: trackTintColorStart, end: trackTintColorEnd,
                        orientation: trackColorOrientation,
                        fallback: .solid(isPoinku ? EDTSColor.white : EDTSColor.grey20))
    }

    private var resolvedFill: EDTSTrackFill {
        edtsResolveFill(solid: trackFillTintColor, start: trackFillTintColorStart, end: trackFillTintColorEnd,
                        orientation: trackFillColorOrientation, fallback: defaultGradient)
    }

    private var resolvedFullTrackFill: EDTSTrackFill {
        let fallback: EDTSTrackFill = isPoinku
            ? (resolvedLimit > maxValue ? .solid(EDTSColor.blue10) : .solid(.clear))
            : .solid(EDTSColor.blue30)
        return edtsResolveFill(solid: trackFullTintColor, start: trackFullTintColorStart, end: trackFullTintColorEnd,
                               orientation: trackFullColorOrientation, fallback: fallback)
    }

    private var resolvedIndicatorFill: EDTSTrackFill {
        edtsResolveFill(solid: indicatorTintColor, start: indicatorTintColorStart, end: indicatorTintColorEnd,
                        orientation: indicatorColorOrientation, fallback: defaultGradient)
    }

    private var resolvedBadgeFill: EDTSTrackFill {
        edtsResolveFill(solid: badgeTintColor, start: badgeTintColorStart, end: badgeTintColorEnd,
                        orientation: badgeColorOrientation, fallback: defaultGradient)
    }

    private var resolvedTrackHeight: CGFloat { trackHeight >= 0 ? trackHeight : 6 }
    private var resolvedLimit: CGFloat { limitValue ?? maxValue }
    private var resolvedHasIndicator: Bool { isHasIndicator ?? !isPoinku }
    private var resolvedHasBadge: Bool { isHasBadge ?? !isPoinku }

    private var resolvedPadding: EdgeInsets {
        let d: CGFloat = isPoinku ? 0 : 1
        return EdgeInsets(
            top: trackPaddingTop >= 0 ? trackPaddingTop : d,
            leading: trackPaddingLeading >= 0 ? trackPaddingLeading : d,
            bottom: trackPaddingBottom >= 0 ? trackPaddingBottom : d,
            trailing: trackPaddingTrailing >= 0 ? trackPaddingTrailing : d
        )
    }

    private var resolvedBadgePadding: EdgeInsets {
        EdgeInsets(top: badgePaddingTop, leading: badgePaddingLeading,
                   bottom: badgePaddingBottom, trailing: badgePaddingTrailing)
    }

    private var resolvedBadgeFont: Font {
        if let badgeFontStyle { return badgeFontStyle }
        if !badgeFontName.isEmpty { return .custom(badgeFontName, size: badgeFontSize) }
        return .system(size: badgeFontSize, weight: badgeFontWeight)
    }

    private var resolvedTrackShadow: EDTSTrackShadow? {
        guard trackShadowOpacity > 0 else { return nil }
        return EDTSTrackShadow(color: trackShadowColor, opacity: Double(trackShadowOpacity),
                               radius: trackShadowRadius, offset: trackShadowOffset)
    }

    private var resolvedInnerShadows: [EDTSTrackShadow] {
        if trackInnerShadowOpacity != nil || trackInnerShadowRadius != nil
            || trackInnerShadowOffset != nil || trackInnerShadowColor != nil {
            return [.inner(color: trackInnerShadowColor, opacity: trackInnerShadowOpacity,
                           radius: trackInnerShadowRadius, offset: trackInnerShadowOffset)]
        }
        if isPoinku {
            return [
                EDTSTrackShadow(opacity: 0.08, radius: 2, offset: CGSize(width: 0, height: 1)),
                EDTSTrackShadow(opacity: 0.10, radius: 2, offset: CGSize(width: 0, height: -4))
            ]
        }
        return [.defaultInner]
    }

    private var contentHeight: CGFloat {
        max(resolvedTrackHeight,
            resolvedHasIndicator ? indicatorSize : 0,
            resolvedHasBadge ? badgeSize : 0)
    }

    private var config: EDTSProgressTrackerModel.Config {
        let pad = resolvedPadding
        return .init(
            maxValue: maxValue,
            limitValue: resolvedLimit,
            hasIndicator: resolvedHasIndicator,
            indicatorSize: indicatorSize,
            hasBadge: resolvedHasBadge,
            leadingPadding: pad.leading,
            trailingPadding: pad.trailing,
            isLoading: isLoadingState,
            hasCustomBadgeLabel: badgeLabel != nil || badgeLabelAttributed != nil
        )
    }

    private var showsIntermittentBar: Bool {
        isIntermittentState && intermittentAnimationType != .doubleArc
    }

    
    // MARK: Setup and Styling
    
    private func setupBgColor(_ fill: EDTSTrackFill, radius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: radius).fill(fill.shapeStyle)
    }
    
    // MARK: Layers
    
    @ViewBuilder
    private func progressTracker(width: CGFloat) -> some View {
        let pad = resolvedPadding
        let height = resolvedTrackHeight
        let fullHeight = max(height - pad.top - pad.bottom, 0)
        let trackRadius = trackCornerRadius >= 0 ? trackCornerRadius : height / 2
        let fullRadius = trackCornerRadius >= 0 ? trackCornerRadius : fullHeight / 2
        let maxBarWidth = max(width - pad.leading - pad.trailing, 0)

        ZStack(alignment: .topLeading) {
            // trackView
            setupBgColor(resolvedTrackFill, radius: trackRadius)
                .edtsShadow(resolvedTrackShadow)
                .edtsInnerShadow(in: RoundedRectangle(cornerRadius: trackRadius), shadows: resolvedInnerShadows)

            // fullTrackView and fillView
            ZStack(alignment: .topLeading) {
                if model.isFullTrackVisible {
                    setupBgColor(resolvedFullTrackFill, radius: fullRadius)
                        .frame(width: maxBarWidth, height: fullHeight)
                        .padding(.top, pad.top)
                        .padding(.leading, pad.leading)
                }

                if showsIntermittentBar {
                    intermittentFill(maxBarWidth: maxBarWidth, pad: pad, fullHeight: fullHeight, radius: fullRadius)
                } else {
                    regularFill(pad: pad, fullHeight: fullHeight, radius: fullRadius)
                }
            }
            .frame(width: width, height: height, alignment: .topLeading)
            .clipShape(RoundedRectangle(cornerRadius: trackRadius))
        }
        .frame(width: width, height: height)
        // indicator and badge
        .overlay(alignment: .topLeading) {
            if !showsIntermittentBar { indicator(pad: pad, fullHeight: fullHeight) }
        }
        .overlay(alignment: .trailing) { badge }
    }

    private func regularFill(pad: EdgeInsets, fullHeight: CGFloat, radius: CGFloat) -> some View {
        setupBgColor(resolvedFill, radius: radius)
            .frame(width: model.fillWidth, height: fullHeight)
            .animation(model.fillAnimation, value: model.fillWidth)
            .opacity(model.isFillHidden ? 0 : model.fillOpacity)
            .animation(model.fillOpacityAnimation, value: model.fillOpacity)
            .padding(.top, pad.top)
            .padding(.leading, pad.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    // MARK: Indicator
    @ViewBuilder
    private func indicator(pad: EdgeInsets, fullHeight: CGFloat) -> some View {
        if resolvedHasIndicator {
            let edge = pad.leading + model.fillWidth
            let x = model.indicatorAtEnd
                ? edge + pad.trailing - indicatorSize
                : edge - indicatorSize / 2
            let y = pad.top + (fullHeight - indicatorSize) / 2

            setupBgColor(resolvedIndicatorFill, radius: indicatorCornerRadius >= 0 ? indicatorCornerRadius : 10_000)
                .frame(width: indicatorSize, height: indicatorSize)
                .scaleEffect(model.showsIndicator ? 1 : 0.001)
                .animation(model.indicatorAnimation, value: model.showsIndicator)
                .opacity(model.isFillHidden ? 0 : model.fillOpacity)
                .animation(model.fillOpacityAnimation, value: model.fillOpacity)
                .offset(x: x, y: y)
                .animation(model.fillAnimation, value: model.fillWidth)
        }
    }

    // MARK: Intermittent
    
    private func intermittentFill(maxBarWidth: CGFloat, pad: EdgeInsets, fullHeight: CGFloat, radius: CGFloat) -> some View {
        TimelineView(.animation) { context in
            let range = intermittentRange(elapsed: context.date.timeIntervalSince(intermittentStart))
            setupBgColor(resolvedFill, radius: radius)
                .frame(width: max((range.end - range.start) * maxBarWidth, 0), height: fullHeight)
                .padding(.top, pad.top)
                .offset(x: pad.leading + range.start * maxBarWidth)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .id(intermittentAnimationType)
        .onAppear { intermittentStart = Date() }
    }

    private func intermittentRange(elapsed t: Double) -> (start: CGFloat, end: CGFloat) {
        switch intermittentAnimationType {
        case .stretch:
            let phase = intermittentAnimationDuration
            let p = t.truncatingRemainder(dividingBy: phase * 2)
            if p < phase {
                return (0, CGFloat(edtsEaseInOut(p / phase)))
            } else {
                return (CGFloat(edtsEaseInOut((p - phase) / phase)), 1)
            }
        case .fixed:
            let total = intermittentAnimationDuration * 3
            let barFraction = 1.0 / 3.0
            let s = (t.truncatingRemainder(dividingBy: total) / total) * (1 + barFraction)
            return (CGFloat(max(s - barFraction, 0)), CGFloat(min(s, 1)))
        case .doubleArc:
            return (0, 0)
        }
    }

    // MARK: Badge
    
    @ViewBuilder
    private var badge: some View {
        Group {
            if model.isBadgeVisible && resolvedHasBadge {
                badgeContent
                    .padding(resolvedBadgePadding)
                    .frame(minWidth: badgeSize, minHeight: badgeSize)
                    .background(setupBgColor(resolvedBadgeFill, radius: badgeCornerRadius >= 0 ? badgeCornerRadius : 10_000))
                    .scaleEffect(model.badgeScale)
                    .animation(.easeInOut(duration: 0.2), value: model.badgeScale)
                    .transition(.scale)
            }
        }
        .animation(model.badgeAnimation, value: model.isBadgeVisible)
    }

    @ViewBuilder
    private var badgeContent: some View {
        if let badgeLabelAttributed {
            Text(badgeLabelAttributed)
                .font(resolvedBadgeFont)
                .foregroundColor(badgeLabelColor ?? EDTSColor.white)
        } else {
            Text(badgeLabel ?? model.badgeText)
                .font(resolvedBadgeFont)
                .foregroundColor(badgeLabelColor ?? EDTSColor.white)
        }
    }
}

// MARK: - Model

@MainActor
final class EDTSProgressTrackerModel: ObservableObject {

    struct Config: Equatable {
        var maxValue: CGFloat = 100
        var limitValue: CGFloat = 100
        var hasIndicator = false
        var indicatorSize: CGFloat = 8
        var hasBadge = false
        var leadingPadding: CGFloat = 0
        var trailingPadding: CGFloat = 0
        var isLoading = false
        var hasCustomBadgeLabel = false
    }

    // MARK: Render state
    
    @Published private(set) var fillWidth: CGFloat = 0
    @Published private(set) var fillOpacity: Double = 1
    @Published private(set) var isFillHidden = false
    @Published private(set) var isFullTrackVisible = false
    @Published private(set) var showsIndicator = false
    @Published private(set) var indicatorAtEnd = false
    @Published private(set) var isBadgeVisible = false
    @Published private(set) var badgeScale: CGFloat = 1
    @Published private(set) var badgeText = "x1"

    @Published private(set) var fillAnimation: Animation?
    @Published private(set) var fillOpacityAnimation: Animation?
    @Published private(set) var indicatorAnimation: Animation?
    @Published private(set) var badgeAnimation: Animation?

    // MARK: Timing
    
    private let spamDebounceDuration = 0.3
    private let fadeAnimationDuration = 0.4
    private let scaleAnimationDuration = 0.2
    private let fillAnimationDuration = 0.8
    private let settleDelay = 0.03

    // MARK: Logic state
    
    private var config = Config()
    private var hasConfigured = false
    private var trackWidth: CGFloat = 0
    private var value: CGFloat = 0
    private var lapCount = 0
    private var lastProcessedValue: CGFloat = 0
    private var pendingValue: CGFloat?
    private var isUserInputSpam = false
    private var wasAtMaxValue = false
    private var isIndicatorVisible = false
    private var isIntermittentAnimating = false
    private var needsProcessAfterLayout = false

    private var queue: [@MainActor (Int) async -> Void] = []
    private var queueGeneration = 0
    private var isAnimating = false
    private var debounceTask: Task<Void, Never>?
    private var loadingToken = 0

    // MARK: Derived
    
    private var minWidth: CGFloat { config.hasIndicator ? config.indicatorSize / 2 + 1 : 0 }
    private var fillMaxWidth: CGFloat { max(trackWidth - config.leadingPadding - config.trailingPadding, 0) }
    private var effectiveLimit: CGFloat { config.isLoading ? config.maxValue : config.limitValue }

    // MARK: - Inputs from the view
    
    func configure(_ new: Config) {
        let old = config
        config = new

        guard hasConfigured else {
            hasConfigured = true
            setFillWidth(minWidth, animated: false)
            setIndicator(shown: new.hasIndicator, animated: false)
            setupBadge()
            return
        }

        if new.hasIndicator != old.hasIndicator { setIndicator(shown: new.hasIndicator, animated: false) }
        if new.isLoading != old.isLoading { setupLoadingState() }
        if new.hasBadge != old.hasBadge || new.maxValue != old.maxValue { setupBadge() }
    }

    func setTrackWidth(_ width: CGFloat) {
        let old = trackWidth
        trackWidth = width

        if old <= 0, width > 0, needsProcessAfterLayout {
            needsProcessAfterLayout = false
            calculateValue()
        } else if old > 0, abs(width - old) > 0.5 {
            reflow()
        }
    }

    func setValue(_ newValue: CGFloat) {
        value = min(newValue, effectiveLimit)
        calculateValue()
    }

    func setIntermittent(_ on: Bool) {
        if on { startIntermittent() } else { stopIntermittent() }
    }

    // MARK: - State setters
    
    private func setFillWidth(_ width: CGFloat, animated: Bool) {
        fillAnimation = animated ? .easeInOut(duration: fillAnimationDuration) : nil
        fillWidth = width
    }

    private func setFillOpacity(_ opacity: Double, animated: Bool) {
        fillOpacityAnimation = animated ? .easeInOut(duration: fadeAnimationDuration) : nil
        fillOpacity = opacity
    }

    private func setIndicator(shown: Bool, animated: Bool) {
        indicatorAnimation = animated ? .easeInOut(duration: scaleAnimationDuration) : nil
        showsIndicator = shown
    }

    private func setBadge(visible: Bool, animated: Bool) {
        badgeAnimation = animated ? .easeInOut(duration: scaleAnimationDuration) : nil
        isBadgeVisible = visible
    }

    // MARK: - Queue
    
    private func enqueue(_ step: @escaping @MainActor (Int) async -> Void) {
        queue.append(step)
    }

    private func startQueue() {
        guard !isAnimating, !queue.isEmpty else { return }
        isAnimating = true
        let gen = queueGeneration
        Task { [weak self] in
            while let self, self.queueGeneration == gen, !self.queue.isEmpty {
                let step = self.queue.removeFirst()
                await step(gen)
            }
            if let self, self.queueGeneration == gen { self.isAnimating = false }
        }
    }

    private func pause(_ seconds: Double, gen: Int) async -> Bool {
        do { try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000)) } catch { return false }
        return gen == queueGeneration
    }

    private func cancelPendingWork() {
        debounceTask?.cancel()
        debounceTask = nil
        pendingValue = nil
        isUserInputSpam = false
        queue.removeAll()
        queueGeneration += 1
        isAnimating = false
    }

    // MARK: - Setup
    
    private func setupLoadingState() {
        cancelPendingWork()
        if config.isLoading {
            lapCount = 0
            wasAtMaxValue = false
            isFullTrackVisible = false
        }
    }

    private func setupBadge(animateIn: Bool = false) {
        let max = config.maxValue
        let completesLap = value > 0 && max > 0 && value.truncatingRemainder(dividingBy: max) == 0
        let isComplete = lapCount + (completesLap ? 1 : 0) > 0

        isFullTrackVisible = isComplete

        let shouldShowBadge = config.hasBadge && isComplete
        if shouldShowBadge && animateIn && !isBadgeVisible {
            setBadge(visible: true, animated: true)
        } else {
            setBadge(visible: shouldShowBadge, animated: false)
        }
    }

    private func pulseBadge() {
        badgeScale = 1
        Task { [weak self] in
            guard let self else { return }
            self.badgeScale = 1.1
            try? await Task.sleep(nanoseconds: UInt64(self.scaleAnimationDuration * 1_000_000_000))
            self.badgeScale = 1
        }
    }

    private func scaleUpIndicator() {
        isIndicatorVisible = true
        setIndicator(shown: true, animated: true)
    }

    private func animateScaleDownIndicator(gen: Int) async -> Bool {
        isIndicatorVisible = false
        setIndicator(shown: false, animated: true)
        return await pause(scaleAnimationDuration, gen: gen)
    }

    // MARK: - Value handling
    
    private func calculateValue() {
        if config.isLoading {
            debounceTask?.cancel()
            debounceTask = nil
            pendingValue = nil
            isUserInputSpam = false
            processLoadingValue(value)
            return
        }

        if pendingValue != nil { isUserInputSpam = true }
        pendingValue = value

        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(nanoseconds: UInt64(self.spamDebounceDuration * 1_000_000_000))
            } catch { return }
            guard let target = self.pendingValue else { return }
            let isSpam = self.isUserInputSpam
            self.pendingValue = nil
            self.isUserInputSpam = false
            self.processValue(target, compressed: isSpam)
        }
    }

    // MARK: Loading mode (interruptible, single lap)
    
    private func processLoadingValue(_ targetValue: CGFloat) {
        let maxValue = config.maxValue
        guard maxValue > 0 else { return }
        guard trackWidth > 0 else { needsProcessAfterLayout = true; return }

        let capped = min(targetValue, effectiveLimit)
        lastProcessedValue = capped

        let ratio = min(max(capped / maxValue, 0), 1)
        let minW = minWidth, maxW = fillMaxWidth
        let target = min(max(minW + (maxW - minW) * ratio, minW), maxW)

        queue.removeAll()
        isFullTrackVisible = false

        let isAtMax = ratio >= 1
        if !isAtMax { setBadge(visible: false, animated: false) }

        animateFillWidthInterruptible(to: target, isAtMax: isAtMax)
    }

    private func animateFillWidthInterruptible(to target: CGFloat, isAtMax: Bool) {
        loadingToken &+= 1
        let token = loadingToken

        if isFillHidden { setFillWidth(0, animated: false) }
        isFillHidden = false
        setFillOpacity(1, animated: false)

        if config.hasIndicator && !isAtMax {
            indicatorAtEnd = false
            setIndicator(shown: false, animated: false)
            isIndicatorVisible = false
        }

        setFillWidth(target, animated: true)

        Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: UInt64(self.fillAnimationDuration * 1_000_000_000))
            guard token == self.loadingToken else { return }

            if isAtMax {
                if self.config.hasBadge { self.setBadge(visible: true, animated: true) }
                if self.config.hasIndicator {
                    self.indicatorAtEnd = true
                    self.scaleUpIndicator()
                }
            } else if self.config.hasIndicator {
                self.scaleUpIndicator()
            }
        }
    }

    // MARK: Standard mode (laps, queue)
    
    private func processValue(_ targetValue: CGFloat, compressed: Bool) {
        let maxValue = config.maxValue
        guard maxValue > 0 else { return }
        guard trackWidth > 0 else { needsProcessAfterLayout = true; return }

        let capped = min(targetValue, effectiveLimit)
        let previousValue = lastProcessedValue
        let jumpRatio = (capped - previousValue) / maxValue
        let isSpam = compressed || jumpRatio > 2
        lastProcessedValue = capped

        let ratio = capped / maxValue
        let isAtMax = capped > 0 && capped.truncatingRemainder(dividingBy: maxValue) == 0

        let newLapCount = isAtMax ? Int(ratio) - 1 : Int(ratio)
        let newCycleRatio: CGFloat = isAtMax ? 1.0 : ratio - CGFloat(Int(ratio))
        let finalDisplayLaps = isAtMax ? newLapCount + 1 : newLapCount

        let minW = minWidth, maxW = fillMaxWidth

        let wasCompletedLap = wasAtMaxValue
        let previousLapCount = wasAtMaxValue ? lapCount + 1 : lapCount
        let lapsToAnimate = finalDisplayLaps - previousLapCount
        let hasRemainder = !isAtMax && newCycleRatio > 0

        lapCount = newLapCount
        wasAtMaxValue = isAtMax

        if capped < previousValue {
            enqueueDecrease(from: previousValue, to: capped, maxWidth: maxW, minWidth: minW,
                            isSpam: compressed || abs(jumpRatio) > 2)
            startQueue()
            return
        }

        if isSpam && lapsToAnimate > 0 {
            enqueue { [weak self] gen in
                await self?.runFinishedLapAnimation(maxWidth: maxW, displayLaps: finalDisplayLaps,
                                                    isFirstLap: previousLapCount == 0, gen: gen)
            }
        } else if lapsToAnimate > 0 {
            for lap in (previousLapCount + 1)...finalDisplayLaps {
                enqueue { [weak self] gen in
                    await self?.runFinishedLapAnimation(maxWidth: maxW, displayLaps: lap,
                                                        isFirstLap: lap == 1, gen: gen)
                }
            }
        }

        if hasRemainder || (lapsToAnimate == 0 && !isAtMax) {
            let fillW = minW + (maxW - minW) * newCycleRatio
            let target = min(max(fillW, minW), maxW)
            let cameFromCompletedLap = wasCompletedLap || lapsToAnimate > 0

            if hasRemainder && cameFromCompletedLap {
                enqueue { [weak self] gen in
                    guard let self else { return }
                    guard await self.animateFillFadeOut(gen: gen) else { return }
                    guard await self.pause(0.3, gen: gen) else { return }
                    await self.runPartialLapAnimation(targetWidth: target, displayLaps: finalDisplayLaps, gen: gen)
                }
            } else {
                enqueue { [weak self] gen in
                    await self?.runPartialLapAnimation(targetWidth: target, displayLaps: finalDisplayLaps, gen: gen)
                }
            }
        }

        startQueue()
    }

    // MARK: Lap steps
    
    private func runFinishedLapAnimation(maxWidth: CGFloat, displayLaps: Int, isFirstLap: Bool, gen: Int) async {
        if isFillHidden { setFillWidth(0, animated: false) }
        isFillHidden = false
        setFillOpacity(1, animated: false)

        guard await animateFillWidthToMaxValue(maxWidth: maxWidth, gen: gen) else { return }

        setupBadge(animateIn: isFirstLap && config.hasBadge)
        if !config.hasCustomBadgeLabel { badgeText = "x\(displayLaps)" }
        if config.hasBadge && !isFirstLap { pulseBadge() }

        _ = await pause(0.3, gen: gen)
    }

    private func runPartialLapAnimation(targetWidth: CGFloat, displayLaps: Int, gen: Int) async {
        if isFillHidden {
            setFillWidth(0, animated: false)
            isFillHidden = false
        }

        if !config.hasCustomBadgeLabel { badgeText = "x\(displayLaps)" }
        setupBadge()

        _ = await animateFillWidthToTargetValue(targetWidth, showIndicatorAfter: true, gen: gen)
    }

    private func runLapHandoverAnimation(maxWidth: CGFloat, displayLaps: Int, gen: Int) async {
        isFullTrackVisible = true
        setFillWidth(maxWidth, animated: false)
        isFillHidden = false
        setFillOpacity(0, animated: false)

        if !config.hasCustomBadgeLabel { badgeText = "x\(displayLaps)" }

        guard await pause(settleDelay, gen: gen) else { return }
        setFillOpacity(1, animated: true)
        guard await pause(fadeAnimationDuration, gen: gen) else { return }

        setBadge(visible: config.hasBadge, animated: false)
        if config.hasBadge { pulseBadge() }

        if config.hasIndicator {
            indicatorAtEnd = true
            scaleUpIndicator()
        }

        _ = await pause(0.3, gen: gen)
    }

    // MARK: Decrease
    
    private func lapState(for v: CGFloat) -> (lap: Int, ratio: CGFloat) {
        let maxValue = config.maxValue
        guard v > 0, maxValue > 0 else { return (1, 0) }
        let full = Int(v / maxValue)
        let rem = v.truncatingRemainder(dividingBy: maxValue)
        return rem == 0 ? (full, 1) : (full + 1, rem / maxValue)
    }

    private func enqueueDecrease(from oldValue: CGFloat, to newValue: CGFloat,
                                 maxWidth: CGFloat, minWidth: CGFloat, isSpam: Bool) {
        let old = lapState(for: oldValue)
        let new = lapState(for: newValue)
        let finalDisplayLaps = new.ratio == 1 ? new.lap : new.lap - 1

        if new.lap < old.lap {
            let handoverLaps: [Int] = isSpam
                ? [new.lap]
                : Array(stride(from: old.lap - 1, through: new.lap, by: -1))

            for lap in handoverLaps {
                enqueue { [weak self] gen in
                    guard let self else { return }
                    guard await self.animateFillWidthToTargetValue(minWidth, showIndicatorAfter: false, gen: gen) else { return }
                    await self.runLapHandoverAnimation(maxWidth: maxWidth, displayLaps: lap, gen: gen)
                }
            }
        }

        if new.ratio < 1 {
            let fillW = minWidth + (maxWidth - minWidth) * new.ratio
            let target = min(max(fillW, minWidth), maxWidth)
            enqueue { [weak self] gen in
                await self?.runPartialLapAnimation(targetWidth: target, displayLaps: finalDisplayLaps, gen: gen)
            }
        }
    }

    // MARK: Fill animations
    
    @discardableResult
    private func animateFillWidthToMaxValue(maxWidth: CGFloat, gen: Int) async -> Bool {
        if config.hasIndicator && isIndicatorVisible {
            guard await animateScaleDownIndicator(gen: gen) else { return false }
        } else {
            setIndicator(shown: false, animated: false)
            isIndicatorVisible = false
        }

        setFillWidth(maxWidth, animated: true)
        guard await pause(fillAnimationDuration, gen: gen) else { return false }

        if config.hasIndicator {
            indicatorAtEnd = true
            scaleUpIndicator()
        }
        return true
    }

    @discardableResult
    private func animateFillWidthToTargetValue(_ targetWidth: CGFloat, showIndicatorAfter: Bool, gen: Int) async -> Bool {
        if config.hasIndicator && isIndicatorVisible {
            guard await animateScaleDownIndicator(gen: gen) else { return false }
            indicatorAtEnd = false
        } else {
            indicatorAtEnd = false
            setIndicator(shown: false, animated: false)
            isIndicatorVisible = false
        }

        setFillWidth(targetWidth, animated: true)
        guard await pause(fillAnimationDuration, gen: gen) else { return false }

        if config.hasIndicator && !isFillHidden && showIndicatorAfter { scaleUpIndicator() }
        return true
    }

    private func animateFillFadeOut(gen: Int) async -> Bool {
        isFullTrackVisible = true
        setFillOpacity(0, animated: true)
        guard await pause(fadeAnimationDuration, gen: gen) else { return false }

        setFillOpacity(1, animated: false)
        isFillHidden = true
        indicatorAtEnd = false
        setIndicator(shown: false, animated: false)
        isIndicatorVisible = false
        setFillWidth(0, animated: false)
        return true
    }

    // MARK: Intermittent
    
    private func startIntermittent() {
        guard !isIntermittentAnimating else { return }
        isIntermittentAnimating = true
        cancelPendingWork()

        isFullTrackVisible = false
        setBadge(visible: false, animated: false)
        setIndicator(shown: false, animated: false)
        isFillHidden = false
        setFillOpacity(1, animated: false)
    }

    private func stopIntermittent() {
        guard isIntermittentAnimating else { return }
        isIntermittentAnimating = false
        loadingToken &+= 1

        indicatorAtEnd = false
        setFillWidth(0, animated: false)
        isFillHidden = true
        setIndicator(shown: config.hasIndicator, animated: false)
        isIndicatorVisible = false

        lapCount = 0
        wasAtMaxValue = false
        lastProcessedValue = 0
        calculateValue()
    }

    // MARK: Layout changes
    
    private func reflow() {
        let maxValue = config.maxValue
        guard !isAnimating, !isFillHidden, !isIntermittentAnimating, maxValue > 0 else { return }

        let ratio: CGFloat
        if lastProcessedValue <= 0 {
            ratio = 0
        } else if config.isLoading {
            ratio = min(max(lastProcessedValue / maxValue, 0), 1)
        } else if wasAtMaxValue {
            ratio = 1
        } else {
            let r = lastProcessedValue / maxValue
            ratio = r - CGFloat(Int(r))
        }

        let width = minWidth + (fillMaxWidth - minWidth) * ratio
        setFillWidth(min(max(width, minWidth), fillMaxWidth), animated: false)
    }
}

// MARK: - Shapes & helpers

struct EDTSInsetShadowShape: Shape {
    var expansion: CGFloat
    var shapePath: @Sendable (CGRect) -> Path

    init(cornerRadius: CGFloat, expansion: CGFloat) {
        self.expansion = expansion
        self.shapePath = { rect in
            let r = min(cornerRadius, min(rect.width, rect.height) / 2)
            return Path(roundedRect: rect, cornerSize: CGSize(width: r, height: r))
        }
    }

    init(shapePath: @escaping @Sendable (CGRect) -> Path, expansion: CGFloat) {
        self.expansion = expansion
        self.shapePath = shapePath
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect.insetBy(dx: -expansion, dy: -expansion))
        path.addPath(shapePath(rect))
        return path
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var value: CGFloat = 40
        @State private var intermittent = false

        var body: some View {
            VStack(spacing: 28) {
                EDTSProgressTracker(value: value, limitValue: 300, isIntermittentState: intermittent)

                EDTSProgressTracker(
                    trackFillTintColorStart: .purple,
                    trackFillTintColorEnd: .pink,
                    trackFillColorOrientation: .horizontal,
                    trackFullTintColor: .purple,
                    value: value,
                    limitValue: 800,
                    indicatorTintColorStart: .purple,
                    indicatorTintColorEnd: .pink,
                    indicatorColorOrientation: .horizontal,
                    badgeTintColorStart: .purple,
                    badgeTintColorEnd: .pink,
                    badgeColorOrientation: .horizontal,
                    isIntermittentState: intermittent,
                    intermittentAnimationType: .fixed
                )

                EDTSProgressTracker(value: min(value, 100), isLoadingState: true)

                HStack {
                    Button("-25") { value -= 25 }
                    Button("+25") { value += 25 }
                    Button("+100") { value += 100 }
                    Button("Reset") { value = 0 }
                }
                .buttonStyle(.bordered)

                Toggle("Intermittent", isOn: $intermittent)
            }
            .padding()
        }
    }
    return Demo()
}
