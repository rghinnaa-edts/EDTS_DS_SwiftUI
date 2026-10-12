//
//  EDTSCoachmark.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 24/09/26.
//

import SwiftUI

// MARK: - Types

public enum EDTSCoachmarkType {
    case single
    case multiple
}

private enum EDTSCoachmarkArrowPosition {
    case top
    case bottom
}

// MARK: - Step Config

public struct EDTSCoachmarkStepConfig {
    public let icon: Image?
    public let title: String?
    public let titleAttributed: AttributedString?
    public let titleFontStyle: Font?
    public let titleFontName: String?
    public let titleFontSize: Double?
    public let titleFontWeight: String?
    public let description: String?
    public let descAttributed: AttributedString?
    public let descFontStyle: Font?
    public let descFontName: String?
    public let descFontSize: Double?
    public let descFontWeight: String?
    public let targetID: String
    public let endTargetID: String?
    public let btnSecondaryText: String?
    public let btnPrimaryText: String?
    public let btnSecondary: EDTSButton?
    public let btnPrimary: EDTSButton?
    public let isBtnPrimaryHide: Bool?
    public let isBtnSecondaryHide: Bool?
    public let contentMargin: CGFloat?
    public let offsetMargin: CGFloat?
    public let spotlightRadius: CGFloat?
    public let spotlightPadding: CGFloat?
    public let spotlightPaddingLeft: CGFloat?
    public let spotlightPaddingRight: CGFloat?
    public let isTargetAList: Bool
    public let isHideSpotlight: Bool

    public init(
        icon: Image? = nil,
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        titleFontStyle: Font? = nil,
        titleFontName: String? = nil,
        titleFontSize: Double? = nil,
        titleFontWeight: String? = nil,
        description: String? = nil,
        descAttributed: AttributedString? = nil,
        descFontStyle: Font? = nil,
        descFontName: String? = nil,
        descFontSize: Double? = nil,
        descFontWeight: String? = nil,
        targetID: String,
        endTargetID: String? = nil,
        btnSecondaryText: String? = nil,
        btnPrimaryText: String? = nil,
        btnSecondary: EDTSButton? = nil,
        btnPrimary: EDTSButton? = nil,
        isBtnPrimaryHide: Bool? = nil,
        isBtnSecondaryHide: Bool? = nil,
        contentMargin: CGFloat? = nil,
        offsetMargin: CGFloat? = nil,
        spotlightRadius: CGFloat? = nil,
        spotlightPadding: CGFloat? = nil,
        spotlightPaddingLeft: CGFloat? = nil,
        spotlightPaddingRight: CGFloat? = nil,
        isTargetAList: Bool = false,
        isHideSpotlight: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.titleAttributed = titleAttributed
        self.titleFontStyle = titleFontStyle
        self.titleFontName = titleFontName
        self.titleFontSize = titleFontSize
        self.titleFontWeight = titleFontWeight
        self.description = description
        self.descAttributed = descAttributed
        self.descFontStyle = descFontStyle
        self.descFontName = descFontName
        self.descFontSize = descFontSize
        self.descFontWeight = descFontWeight
        self.targetID = targetID
        self.endTargetID = endTargetID
        self.btnSecondaryText = btnSecondaryText
        self.btnPrimaryText = btnPrimaryText
        self.btnSecondary = btnSecondary
        self.btnPrimary = btnPrimary
        self.isBtnSecondaryHide = isBtnSecondaryHide
        self.isBtnPrimaryHide = isBtnPrimaryHide
        self.contentMargin = contentMargin
        self.offsetMargin = offsetMargin
        self.spotlightRadius = spotlightRadius
        self.spotlightPadding = spotlightPadding
        self.spotlightPaddingLeft = spotlightPaddingLeft
        self.spotlightPaddingRight = spotlightPaddingRight
        self.isTargetAList = isTargetAList
        self.isHideSpotlight = isHideSpotlight
    }
}

// MARK: - Target Registration

private struct EDTSCoachmarkAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { _, new in new }
    }
}

private struct EDTSCoachmarkCardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View

private struct EDTSCoachmarkView: View {

    // MARK: Variables

    @Binding var isPresented: Bool
    @Binding var currentStep: Int

    let steps: [EDTSCoachmarkStepConfig]
    let type: EDTSCoachmarkType
    let stepConjunction: String?
    let iconTint: Color?
    let iconBgColor: Color?
    let isIconHide: Bool?
    let isDividerHide: Bool?
    let bgColor: Color?
    let onDismiss: (() -> Void)?
    let anchors: [String: Anchor<CGRect>]
    let proxy: GeometryProxy

    private let firstStep = 1
    private let dimColor = Color.black.opacity(0.7)
    private let cardMinWidth: CGFloat = 320
    private let defaultContentMargin: CGFloat = 24
    private let cardCornerRadius: CGFloat = 8
    private let cardPadding: CGFloat = 16
    private let cardContentSpacing: CGFloat = 16
    private let cardTextSpacing: CGFloat = 8
    private let cardFooterSpacing: CGFloat = 8
    private let cardFooterTopPaddingWithoutDivider: CGFloat = 8
    private let cardFooterTopPaddingWithDivider: CGFloat = 16
    private let cardDividerHeight: CGFloat = 1
    private let descriptionLineLimit = 3
    private let cardHeightChangeThreshold: CGFloat = 0.5
    private let cardShadowOpacity: Double = 0.1
    private let cardShadowRadius: CGFloat = 4
    private let cardShadowOffsetY: CGFloat = 2
    private let iconShadowOpacity: Double = 0.2
    private let iconShadowRadius: CGFloat = 2
    private let iconShadowOffsetY: CGFloat = 1
    private let iconContainerSize: CGFloat = 40
    private let iconGlyphSize: CGFloat = 24

    private let buttonFontSize: CGFloat = 12

    private let spotlightDefaultRadius: CGFloat = 4
    private let spotlightDefaultListPadding: CGFloat = 8
    private let spotlightRangePadding: CGFloat = 16
    private let spotlightCollapsedSize: CGFloat = 2

    private let arrowHeight: CGFloat = 8
    private let arrowWidth: CGFloat = 12
    private let arrowCornerInset: CGFloat = 8
    private let arrowSpotlightGap: CGFloat = 8
    private let arrowPlacementExtraClearance: CGFloat = 12
    private let arrowPlacementBottomClearance: CGFloat = 8

    private let cardFadeDuration: Double = 0.2
    private let hideDuration: Double = 0.4
    private let revealAnimation = Animation.timingCurve(0.215, 0.610, 0.355, 1.000, duration: 0.5)
    private let hideAnimation = Animation.timingCurve(0.550, 0.055, 0.675, 0.190, duration: 0.5)
    private let cardFadeInAnimation = Animation.easeInOut(duration: 0.2).delay(0.5)
    private let cardFadeOutAnimation = Animation.easeInOut(duration: 0.2)
    private let stepTransitionAnimation = Animation.easeInOut(duration: 0.3)

    @State private var isRevealed = false
    @State private var cardOpacity: Double = 0
    @State private var cardHeight: CGFloat = 150
    @State private var hasAppeared = false

    private var totalSteps: Int { steps.count }

    private var step: EDTSCoachmarkStepConfig? {
        guard currentStep >= firstStep, currentStep <= steps.count else { return nil }
        return steps[currentStep - firstStep]
    }

    private func frame(for id: String?) -> CGRect {
        guard let id, let anchor = anchors[id] else { return .zero }
        return proxy[anchor]
    }

    private var targetFrame: CGRect { frame(for: step?.targetID) }
    private var endTargetFrame: CGRect { frame(for: step?.endTargetID) }

    private var setupIconHide: Bool {
        if type == .single { return true }
        if let isIconHide { return isIconHide }
        return EDTSColor.theme == .poinku
    }

    private var setupDividerHide: Bool {
        if type == .single { return true }
        if let isDividerHide { return isDividerHide }
        return EDTSColor.theme == .poinku
    }

    private var setupContentMargin: CGFloat {
        step?.contentMargin ?? defaultContentMargin
    }

    private var setupSpotlightRadius: CGFloat {
        step?.spotlightRadius ?? spotlightDefaultRadius
    }

    private var setupStepConjunction: String {
        stepConjunction ?? (EDTSColor.theme == .poinku ? "/" : "dari")
    }

    // MARK: - Fonts

    private var setupTitleFont: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.H3.Medium : EDTSFont.Klik.H1
    }

    private var setupTitleColor: Color {
        EDTSColor.theme == .poinku ? EDTSColor.grey80 : EDTSColor.grey70
    }

    private var setupDescriptionFont: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.P2.Regular : EDTSFont.Klik.P2.Regular
    }

    private var setupDescriptionColor: Color {
        EDTSColor.theme == .poinku ? EDTSColor.grey70 : EDTSColor.grey60
    }

    private var setupStepFont: EDTSFont.FontStyle {
        EDTSColor.theme == .poinku ? EDTSFont.Poinku.B3.Light : EDTSFont.Klik.B4.Bold
    }

    private var setupStepColor: Color {
        EDTSColor.theme == .poinku ? EDTSColor.grey50 : EDTSColor.grey60
    }

    private var setupBgColor: Color {
        bgColor ?? EDTSColor.white
    }

    /// Custom title font from the step config. `nil` means no override, so the theme default is used.
    private func customTitleFont(_ step: EDTSCoachmarkStepConfig) -> Font? {
        resolveCustomFont(
            style: step.titleFontStyle,
            name: step.titleFontName,
            size: step.titleFontSize,
            weight: step.titleFontWeight
        )
    }

    /// Custom description font from the step config. `nil` means no override, so the theme default is used.
    private func customDescriptionFont(_ step: EDTSCoachmarkStepConfig) -> Font? {
        resolveCustomFont(
            style: step.descFontStyle,
            name: step.descFontName,
            size: step.descFontSize,
            weight: step.descFontWeight
        )
    }

    private func resolveCustomFont(style: Font?, name: String?, size: Double?, weight: String?) -> Font? {
        if let style {
            return style
        }

        let fontName = name ?? ""
        let fontSize = size ?? .zero
        let fontWeight = weight ?? ""

        guard !fontName.isEmpty || fontSize > 0 || !fontWeight.isEmpty else {
            return nil
        }

        let resolvedSize = fontSize > 0 ? CGFloat(fontSize) : UIFont.systemFontSize
        var font: Font = fontName.isEmpty ? .system(size: resolvedSize) : .custom(fontName, size: resolvedSize)

        if !fontWeight.isEmpty {
            font = font.weight(setupFontWeight(from: fontWeight))
        }

        return font
    }

    @ViewBuilder
    private func applyFont<Content: View>(_ content: Content, custom: Font?, fallback: EDTSFont.FontStyle) -> some View {
        if let custom {
            content.font(custom)
        } else {
            content.edtsFont(fallback)
        }
    }

    // MARK: - Spotlight Geometry

    private func unifiedRect(padding: CGFloat) -> CGRect {
        let unified = targetFrame.union(endTargetFrame)
        return CGRect(
            x: unified.minX - padding, y: unified.minY - padding,
            width: unified.width + padding * 2, height: unified.height + padding * 2
        )
    }

    private var spotlightTargetRect: CGRect {
        guard let step else { return .zero }
        if step.endTargetID != nil {
            return unifiedRect(padding: spotlightRangePadding)
        }
        if step.isTargetAList {
            let left = step.spotlightPaddingLeft ?? step.spotlightPadding ?? spotlightDefaultListPadding
            let right = step.spotlightPaddingRight ?? step.spotlightPadding ?? spotlightDefaultListPadding
            let vertical = step.spotlightPadding ?? spotlightDefaultListPadding
            return CGRect(
                x: targetFrame.minX + left,
                y: targetFrame.minY - vertical,
                width: targetFrame.width - (left + right),
                height: targetFrame.height + vertical * 2
            )
        }
        return targetFrame.insetBy(dx: -setupSpotlightRadius, dy: -setupSpotlightRadius)
    }

    private var displayedSpotlightRect: CGRect {
        guard isRevealed else {
            let target = spotlightTargetRect
            return CGRect(
                x: target.midX - spotlightCollapsedSize / 2,
                y: target.midY - spotlightCollapsedSize / 2,
                width: spotlightCollapsedSize,
                height: spotlightCollapsedSize
            )
        }
        return spotlightTargetRect
    }

    // MARK: - Tooltip Geometry

    private var cardWidth: CGFloat {
        max(cardMinWidth, proxy.size.width - setupContentMargin * 2)
    }

    private var arrowPosition: EDTSCoachmarkArrowPosition {
        let spot = spotlightTargetRect
        let spaceBelow = proxy.size.height
            - spot.maxY
            - arrowPlacementExtraClearance
            - cardHeight
            - arrowHeight
            - arrowPlacementBottomClearance
        return spaceBelow < 0 ? .bottom : .top
    }

    private var unitOriginX: CGFloat {
        step?.offsetMargin ?? setupContentMargin
    }

    private var unitHeight: CGFloat { cardHeight + arrowHeight }

    private var unitOriginY: CGFloat {
        let spot = spotlightTargetRect
        return arrowPosition == .top
            ? spot.maxY + arrowSpotlightGap
            : spot.minY - arrowSpotlightGap - unitHeight
    }

    private var arrowCenterXLocal: CGFloat {
        let spot = spotlightTargetRect
        let targetCenterXGlobal = step?.endTargetID != nil
            ? unifiedRect(padding: spotlightRangePadding).midX
            : spot.midX
        let targetCenterXLocal = targetCenterXGlobal - unitOriginX

        let cornerClearance = arrowWidth / 2 + arrowCornerInset
        let minX = cornerClearance
        let maxX = cardWidth - cornerClearance
        return min(max(targetCenterXLocal, minX), maxX)
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let step, !step.isHideSpotlight {
                EDTSCoachmarkSpotlightShape(rect: displayedSpotlightRect, cornerRadius: setupSpotlightRadius)
                    .fill(dimColor, style: FillStyle(eoFill: true))
            }

            if let step {
                let arrowAtTop = arrowPosition == .top

                cardView(step)
                    .background(
                        GeometryReader { cardProxy in
                            Color.clear
                                .preference(key: EDTSCoachmarkCardHeightKey.self, value: cardProxy.size.height)
                        }
                    )
                    .frame(width: cardWidth, alignment: .topLeading)
                    .padding(.top, arrowAtTop ? arrowHeight : 0)
                    .padding(.bottom, arrowAtTop ? 0 : arrowHeight)
                    .background(
                        EDTSCoachmarkShape(
                            cornerRadius: cardCornerRadius,
                            arrowX: arrowCenterXLocal,
                            arrowAtTop: arrowAtTop,
                            arrowWidth: arrowWidth,
                            arrowHeight: arrowHeight
                        )
                        .fill(setupBgColor)
                        .shadow(
                            color: .black.opacity(cardShadowOpacity),
                            radius: cardShadowRadius,
                            x: 0,
                            y: cardShadowOffsetY
                        )
                    )
                    .position(x: unitOriginX + cardWidth / 2, y: unitOriginY + unitHeight / 2)
                    .opacity(cardOpacity)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
        .onPreferenceChange(EDTSCoachmarkCardHeightKey.self) { newHeight in
            guard newHeight > 0, abs(newHeight - cardHeight) > cardHeightChangeThreshold else { return }
            cardHeight = newHeight
        }
        .onAppear { presentIfNeeded() }
    }

    // MARK: - Card Content

    @ViewBuilder
    private func cardView(_ step: EDTSCoachmarkStepConfig) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: cardContentSpacing) {
                if !setupIconHide {
                    ZStack {
                        Circle().fill(iconBgColor ?? EDTSColor.grey20)
                        (step.icon ?? Image("ic_placeholder"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconGlyphSize, height: iconGlyphSize)
                            .foregroundColor(iconTint ?? EDTSColor.blue50)
                    }
                    .frame(width: iconContainerSize, height: iconContainerSize)
                    .shadow(
                        color: EDTSColor.grey30.opacity(iconShadowOpacity),
                        radius: iconShadowRadius,
                        x: 0,
                        y: iconShadowOffsetY
                    )
                }

                VStack(alignment: .leading, spacing: cardTextSpacing) {
                    titleView(step)
                    descriptionView(step)
                }
            }
            .padding(.horizontal, cardPadding)
            .padding(.top, cardPadding)

            if !setupDividerHide {
                Rectangle()
                    .fill(EDTSColor.grey30)
                    .frame(height: cardDividerHeight)
                    .padding(.horizontal, cardPadding)
                    .padding(.top, cardPadding)
            }

            HStack(spacing: cardFooterSpacing) {
                if type != .single {
                    Text("\(currentStep) \(setupStepConjunction) \(totalSteps)")
                        .edtsFont(setupStepFont)
                        .foregroundColor(setupStepColor)

                    Spacer()
                }

                if !hideSkipButton(step) {
                    outlinedButton(step)
                }

                if !(step.isBtnPrimaryHide ?? false) {
                    filledButton(step)
                }
            }
            .padding(.horizontal, cardPadding)
            .padding(
                .top,
                setupDividerHide
                    ? cardFooterTopPaddingWithoutDivider
                    : cardFooterTopPaddingWithDivider
            )
            .padding(.bottom, cardPadding)
        }
    }

    private func hideSkipButton(_ step: EDTSCoachmarkStepConfig) -> Bool {
        if type == .single { return true }
        if let explicit = step.isBtnSecondaryHide { return explicit }
        return currentStep == totalSteps
    }

    // MARK: - Buttons

    @ViewBuilder
    private func outlinedButton(_ step: EDTSCoachmarkStepConfig) -> some View {
        if let custom = step.btnSecondary {
            composedButton(custom) { dismiss() }
        } else {
            EDTSButton(
                btnType: .tertiary,
                btnSize: .small,
                text: step.btnSecondaryText ?? "Tutup",
                textColor: EDTSColor.theme == .poinku ? EDTSColor.blue30 : EDTSColor.blue50,
                fontSize: buttonFontSize,
                fontWeight: "semibold",
                borderColor: EDTSColor.theme == .poinku ? EDTSColor.blue30 : EDTSColor.blue50
            ) {
                dismiss()
            }
        }
    }

    @ViewBuilder
    private func filledButton(_ step: EDTSCoachmarkStepConfig) -> some View {
        if let custom = step.btnPrimary {
            composedButton(custom) { advance() }
        } else {
            EDTSButton(
                btnType: .primary,
                btnSize: .small,
                text: step.btnPrimaryText ?? (currentStep == totalSteps ? "Mengerti" : "Berikutnya"),
                fontSize: buttonFontSize,
                fontWeight: "semibold",
                bgColor: EDTSColor.theme == .poinku ? EDTSColor.blue30 : EDTSColor.blue50,
                maxWidth: type == .single ? .infinity : nil
            ) {
                advance()
            }
        }
    }

    private func composedButton(_ button: EDTSButton, then coachmarkAction: @escaping () -> Void) -> EDTSButton {
        var composed = button
        let callerAction = button.action
        composed.action = {
            callerAction()
            coachmarkAction()
        }
        return composed
    }

    // MARK: - Labels

    @ViewBuilder
    private func titleView(_ step: EDTSCoachmarkStepConfig) -> some View {
        let text = Group {
            if let titleAttributed = step.titleAttributed {
                Text(titleAttributed)
            } else {
                Text(step.title ?? "")
            }
        }

        applyFont(text, custom: customTitleFont(step), fallback: setupTitleFont)
            .foregroundColor(setupTitleColor)
    }

    @ViewBuilder
    private func descriptionView(_ step: EDTSCoachmarkStepConfig) -> some View {
        let text = Group {
            if let descAttributed = step.descAttributed {
                Text(descAttributed)
            } else {
                Text(step.description ?? "")
            }
        }

        applyFont(text, custom: customDescriptionFont(step), fallback: setupDescriptionFont)
            .foregroundColor(setupDescriptionColor)
            .lineLimit(descriptionLineLimit)
    }

    // MARK: - Actions

    private func presentIfNeeded() {
        guard !hasAppeared else { return }
        hasAppeared = true

        withAnimation(revealAnimation) {
            isRevealed = true
        }
        withAnimation(cardFadeInAnimation) {
            cardOpacity = 1
        }
    }

    private func advance() {
        if currentStep >= totalSteps {
            dismiss()
        } else {
            withAnimation(stepTransitionAnimation) {
                currentStep += 1
            }
        }
    }

    private func dismiss() {
        withAnimation(cardFadeOutAnimation) {
            cardOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + cardFadeDuration) {
            withAnimation(hideAnimation) {
                isRevealed = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + hideDuration) {
                isPresented = false
                onDismiss?()
            }
        }
    }
}

// MARK: - Overlay Modifier

private struct EDTSCoachmarkOverlay: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var currentStep: Int

    let steps: [EDTSCoachmarkStepConfig]
    let type: EDTSCoachmarkType
    let stepConjunction: String?
    let iconTint: Color?
    let iconBgColor: Color?
    let isIconHide: Bool?
    let isDividerHide: Bool?
    let bgColor: Color?
    let btnSecondaryTint: Color?
    let btnPrimaryTint: Color?
    let onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .overlayPreferenceValue(EDTSCoachmarkAnchorKey.self) { anchors in
                GeometryReader { proxy in
                    if isPresented, !steps.isEmpty {
                        EDTSCoachmarkView(
                            isPresented: $isPresented,
                            currentStep: $currentStep,
                            steps: steps,
                            type: type,
                            stepConjunction: stepConjunction,
                            iconTint: iconTint,
                            iconBgColor: iconBgColor,
                            isIconHide: isIconHide,
                            isDividerHide: isDividerHide,
                            bgColor: bgColor,
                            onDismiss: onDismiss,
                            anchors: anchors,
                            proxy: proxy
                        )
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(isPresented)
            }
    }
}

// MARK: - Spotlight Shape

private struct EDTSCoachmarkSpotlightShape: Shape {
    var rect: CGRect
    var cornerRadius: CGFloat

    var animatableData: AnimatablePair<AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>, CGFloat> {
        get {
            AnimatablePair(
                AnimatablePair(AnimatablePair(rect.origin.x, rect.origin.y), AnimatablePair(rect.size.width, rect.size.height)),
                cornerRadius
            )
        }
        set {
            rect = CGRect(
                x: newValue.first.first.first,
                y: newValue.first.first.second,
                width: newValue.first.second.first,
                height: newValue.first.second.second
            )
            cornerRadius = newValue.second
        }
    }

    func path(in bounds: CGRect) -> Path {
        var path = Path(bounds)
        guard rect.width > 0, rect.height > 0 else { return path }
        path.addPath(Path(roundedRect: rect, cornerRadius: max(cornerRadius, 0)))
        return path
    }
}

// MARK: - Triangle Arrow Shape

private struct EDTSCoachmarkShape: Shape {
    var cornerRadius: CGFloat
    var arrowX: CGFloat
    var arrowAtTop: Bool
    var arrowWidth: CGFloat
    var arrowHeight: CGFloat
    
    private let arrowTipRadius: CGFloat = 1

    var animatableData: CGFloat {
        get { arrowX }
        set { arrowX = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let bodyRect = arrowAtTop
            ? CGRect(x: rect.minX, y: rect.minY + arrowHeight, width: rect.width, height: rect.height - arrowHeight)
            : CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - arrowHeight)

        var path = Path(roundedRect: bodyRect, cornerRadius: cornerRadius)

        let tipRadius = arrowTipRadius
        let halfWidth = arrowWidth / 2
        var tail = Path()

        if arrowAtTop {
            let baseY = bodyRect.minY
            let tipY = rect.minY
            tail.move(to: CGPoint(x: arrowX - halfWidth, y: baseY))
            tail.addLine(to: CGPoint(x: arrowX + halfWidth, y: baseY))
            let rightControl = CGPoint(x: arrowX + tipRadius, y: tipY + tipRadius / 2)
            let leftControl = CGPoint(x: arrowX - tipRadius, y: tipY + tipRadius / 2)
            tail.addLine(to: rightControl)
            tail.addQuadCurve(to: leftControl, control: CGPoint(x: arrowX, y: tipY))
        } else {
            let baseY = bodyRect.maxY
            let tipY = rect.maxY
            tail.move(to: CGPoint(x: arrowX - halfWidth, y: baseY))
            tail.addLine(to: CGPoint(x: arrowX + halfWidth, y: baseY))
            let rightControl = CGPoint(x: arrowX + tipRadius, y: tipY - tipRadius / 2)
            let leftControl = CGPoint(x: arrowX - tipRadius, y: tipY - tipRadius / 2)
            tail.addLine(to: rightControl)
            tail.addQuadCurve(to: leftControl, control: CGPoint(x: arrowX, y: tipY))
        }
        tail.closeSubpath()

        path.addPath(tail)
        return path
    }
}

public extension View {
    func coachmarkTarget(_ id: String) -> some View {
        anchorPreference(key: EDTSCoachmarkAnchorKey.self, value: .bounds) { [id: $0] }
    }

    func edtsCoachmark(
        isPresented: Binding<Bool>,
        currentStep: Binding<Int> = .constant(1),
        steps: [EDTSCoachmarkStepConfig],
        type: EDTSCoachmarkType = .multiple,
        stepConjunction: String? = nil,
        iconTint: Color? = nil,
        iconBgColor: Color? = nil,
        isIconHide: Bool? = nil,
        isDividerHide: Bool? = nil,
        bgColor: Color? = nil,
        btnSecondaryTint: Color? = nil,
        btnPrimaryTint: Color? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(
            EDTSCoachmarkOverlay(
                isPresented: isPresented,
                currentStep: currentStep,
                steps: steps,
                type: type,
                stepConjunction: stepConjunction,
                iconTint: iconTint,
                iconBgColor: iconBgColor,
                isIconHide: isIconHide,
                isDividerHide: isDividerHide,
                bgColor: bgColor,
                btnSecondaryTint: btnSecondaryTint,
                btnPrimaryTint: btnPrimaryTint,
                onDismiss: onDismiss
            )
        )
    }
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewMultitpleWrapper: View {
        @State private var showCoachmark = false
        @State private var coachmarkStep = 1

        var body: some View {
            VStack(spacing: 24) {
                Spacer()

                HStack {
                    Circle()
                        .fill(EDTSColor.blue20)
                        .frame(width: 48, height: 48)
                        .coachmarkTarget("avatar")
                    Spacer()
                }
                .padding(.horizontal, 32)

                Button("Start Tour") { showCoachmark = true }
                    .coachmarkTarget("startButton")

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsCoachmark(
                isPresented: $showCoachmark,
                currentStep: $coachmarkStep,
                steps: [
                    EDTSCoachmarkStepConfig(
                        title: "Your profile",
                        description: "This is your avatar — tap it any time to edit your profile.",
                        targetID: "avatar"
                    ),
                    EDTSCoachmarkStepConfig(
                        title: "Start here",
                        description: "This button kicks off the guided tour whenever you need a refresher.",
                        targetID: "startButton"
                    )
                ],
                onDismiss: { coachmarkStep = 1 }
            )
        }
    }
    return PreviewMultitpleWrapper()
}

// MARK: - Preview (Single Type)

#Preview("Single Coachmark") {
    struct PreviewSingleWrapper: View {
        @State private var showCoachmark = false

        var body: some View {
            VStack(spacing: 24) {
                Spacer()

                Button("Add to cart") {}
                    .padding()
                    .background(EDTSColor.blue50)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .coachmarkTarget("addToCart")

                Button("Show Single Coachmark") { showCoachmark = true }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsCoachmark(
                isPresented: $showCoachmark,
                steps: [
                    EDTSCoachmarkStepConfig(
                        title: "Add items here",
                        description: "Tap this button to add the current item to your cart.",
                        targetID: "addToCart",
                        btnPrimaryText: "Got it"
                    )
                ],
                type: .single
            )
        }
    }
    return PreviewSingleWrapper()
}

// MARK: - Preview (Custom Buttons)

#Preview("Custom Buttons") {
    struct PreviewCustomButtonsWrapper: View {
        @State private var showCoachmark = false
        @State private var coachmarkStep = 1

        var body: some View {
            VStack(spacing: 24) {
                Spacer()

                Button("Add to cart") {}
                    .coachmarkTarget("addToCart")

                Button("Show Coachmark") { showCoachmark = true }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsCoachmark(
                isPresented: $showCoachmark,
                currentStep: $coachmarkStep,
                steps: [
                    EDTSCoachmarkStepConfig(
                        title: "Custom buttons",
                        description: "This step passes its own buttons, so their styles are used.",
                        targetID: "addToCart",
                        btnSecondary: EDTSButton(btnType: .secondary, btnSize: .small, text: "Skip") {},
                        btnPrimary: EDTSButton(btnType: .primary, btnSize: .small, text: "Continue", bgColor: EDTSColor.orange40) {}
                    ),
                    EDTSCoachmarkStepConfig(
                        title: "Default buttons",
                        description: "This step passes no buttons, so the built-in ones are used.",
                        targetID: "addToCart"
                    )
                ],
                onDismiss: { coachmarkStep = 1 }
            )
        }
    }
    return PreviewCustomButtonsWrapper()
}

// MARK: - Preview (Custom Fonts)

#Preview("Custom Fonts") {
    struct PreviewCustomFontsWrapper: View {
        @State private var showCoachmark = false

        var body: some View {
            VStack(spacing: 24) {
                Spacer()

                Button("Add to cart") {}
                    .coachmarkTarget("addToCart")

                Button("Show Coachmark") { showCoachmark = true }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edtsCoachmark(
                isPresented: $showCoachmark,
                steps: [
                    EDTSCoachmarkStepConfig(
                        title: "Bold title",
                        titleFontName: "Helvetica",
                        titleFontSize: 18,
                        titleFontWeight: "bold",
                        description: "Light description",
                        descFontName: "Helvetica",
                        descFontSize: 13,
                        descFontWeight: "light",
                        targetID: "addToCart"
                    )
                ],
                type: .single
            )
        }
    }
    return PreviewCustomFontsWrapper()
}
