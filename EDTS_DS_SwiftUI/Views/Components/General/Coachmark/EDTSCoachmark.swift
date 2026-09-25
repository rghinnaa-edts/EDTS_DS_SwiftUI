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
    public let description: String?
    public let descriptionAttributed: AttributedString?
    public let targetID: String
    public let endTargetID: String?
    public let btnOutlinedText: String?
    public let btnFilledText: String?
    public let isBtnOutlinedHide: Bool?
    public let isBtnFilledHide: Bool?
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
        description: String? = nil,
        descriptionAttributed: AttributedString? = nil,
        targetID: String,
        endTargetID: String? = nil,
        btnOutlinedText: String? = nil,
        btnFilledText: String? = nil,
        isBtnOutlinedHide: Bool? = nil,
        isBtnFilledHide: Bool? = nil,
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
        self.description = description
        self.descriptionAttributed = descriptionAttributed
        self.targetID = targetID
        self.endTargetID = endTargetID
        self.btnOutlinedText = btnOutlinedText
        self.btnFilledText = btnFilledText
        self.isBtnOutlinedHide = isBtnOutlinedHide
        self.isBtnFilledHide = isBtnFilledHide
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
    let btnOutlinedTint: Color?
    let btnFilledTint: Color?
    let onDismiss: (() -> Void)?
    let anchors: [String: Anchor<CGRect>]
    let proxy: GeometryProxy

    private let dimColor = Color.black.opacity(0.7)
    private let contentViewWidth: CGFloat = 320
    private let triangleHeight: CGFloat = 8
    private let triangleWidth: CGFloat = 12
    
    @State private var isRevealed = false
    @State private var cardOpacity: Double = 0
    @State private var cardHeight: CGFloat = 150
    @State private var hasAppeared = false

    // Step
    
    private var totalSteps: Int { steps.count }

    private var step: EDTSCoachmarkStepConfig? {
        guard currentStep > 0, currentStep <= steps.count else { return nil }
        return steps[currentStep - 1]
    }
    
    // Frame

    private func frame(for id: String?) -> CGRect {
        guard let id, let anchor = anchors[id] else { return .zero }
        return proxy[anchor]
    }

    private var targetFrame: CGRect { frame(for: step?.targetID) }
    private var endTargetFrame: CGRect { frame(for: step?.endTargetID) }

    // Setup Value
    
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

    private var setupContentMargin: CGFloat { step?.contentMargin ?? 24 }
    
    private var setupSpotlightRadius: CGFloat { step?.spotlightRadius ?? 4 }

    private var setupStepConjunction: String {
        stepConjunction ?? (EDTSColor.theme == .poinku ? "/" : "dari")
    }

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

    private var setupOutlinedTextColor: Color {
        btnOutlinedTint ?? (EDTSColor.theme == .poinku ? EDTSColor.blue30 : EDTSColor.grey60)
    }

    private var setupOutlinedBorderColor: Color {
        btnOutlinedTint ?? (EDTSColor.theme == .poinku ? .clear : EDTSColor.grey30)
    }

    /// Background of the merged card+tail callout shape. Defaults to
    /// `EDTSColor.white` when the caller doesn't pass `bgColor`.
    private var setupBgColor: Color {
        bgColor ?? EDTSColor.white
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
            return unifiedRect(padding: 16)
        }
        if step.isTargetAList {
            let left = step.spotlightPaddingLeft ?? step.spotlightPadding ?? 8
            let right = step.spotlightPaddingRight ?? step.spotlightPadding ?? 8
            let vertical = step.spotlightPadding ?? 8
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
            return CGRect(x: target.midX - 1, y: target.midY - 1, width: 2, height: 2)
        }
        return spotlightTargetRect
    }

    // MARK: - Tooltip Geometry

    private var cardWidth: CGFloat {
        max(contentViewWidth, proxy.size.width - setupContentMargin * 2)
    }
    
    private var arrowPosition: EDTSCoachmarkArrowPosition {
        let spot = spotlightTargetRect
        let spaceBelow = proxy.size.height - spot.maxY - 12 - cardHeight - triangleHeight - 8
        return spaceBelow < 0 ? .bottom : .top
    }

    private var unitOriginX: CGFloat {
        step?.offsetMargin ?? setupContentMargin
    }

    private var unitHeight: CGFloat { cardHeight + triangleHeight }

    private var unitOriginY: CGFloat {
        let spot = spotlightTargetRect
        return arrowPosition == .top
            ? spot.maxY + 8
            : spot.minY - 8 - unitHeight
    }

    private var arrowCenterXLocal: CGFloat {
        let spot = spotlightTargetRect
        let targetCenterXGlobal = step?.endTargetID != nil ? unifiedRect(padding: 16).midX : spot.midX
        let targetCenterXLocal = targetCenterXGlobal - unitOriginX

        let cornerClearance = triangleWidth / 2 + 8
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
                    .padding(.top, arrowAtTop ? triangleHeight : 0)
                    .padding(.bottom, arrowAtTop ? 0 : triangleHeight)
                    .background(
                        EDTSCoachmarkCalloutShape(
                            cornerRadius: 8,
                            arrowX: arrowCenterXLocal,
                            arrowAtTop: arrowAtTop,
                            arrowWidth: triangleWidth,
                            arrowHeight: triangleHeight
                        )
                        .fill(setupBgColor)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .position(x: unitOriginX + cardWidth / 2, y: unitOriginY + unitHeight / 2)
                    .opacity(cardOpacity)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
        .onPreferenceChange(EDTSCoachmarkCardHeightKey.self) { newHeight in
            guard newHeight > 0, abs(newHeight - cardHeight) > 0.5 else { return }
            cardHeight = newHeight
        }
        .onAppear { presentIfNeeded() }
    }

    // MARK: - Card Content

    @ViewBuilder
    private func cardView(_ step: EDTSCoachmarkStepConfig) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                if !setupIconHide {
                    ZStack {
                        Circle().fill(iconBgColor ?? EDTSColor.grey20)
                        (step.icon ?? Image("ic_placeholder"))
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(iconTint ?? EDTSColor.blue50)
                    }
                    .frame(width: 40, height: 40)
                    .shadow(color: EDTSColor.grey30.opacity(0.2), radius: 2, x: 0, y: 1)
                }

                VStack(alignment: .leading, spacing: 8) {
                    titleView(step)
                    descriptionView(step)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            if !setupDividerHide {
                Rectangle()
                    .fill(EDTSColor.grey30)
                    .frame(height: 1)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            }

            HStack(spacing: 8) {
                if type != .single {
                    Text("\(currentStep) \(setupStepConjunction) \(totalSteps)")
                        .edtsFont(setupStepFont)
                        .foregroundColor(setupStepColor)
                }

                Spacer()

                if !hideSkipButton(step) {
                    EDTSButton(
                        btnType: .tertiary,
                        btnSize: .small,
                        text: step.btnOutlinedText ?? "Tutup",
                        textColor: setupOutlinedTextColor,
                        fontSize: 12,
                        fontWeight: "semibold",
                        borderColor: setupOutlinedBorderColor
                    ) {
                        dismiss()
                    }
                }

                if !(step.isBtnFilledHide ?? false) {
                    EDTSButton(
                        btnType: .primary,
                        btnSize: .small,
                        text: step.btnFilledText ?? (currentStep == totalSteps ? "Mengerti" : "Berikutnya"),
                        fontSize: 12,
                        fontWeight: "semibold",
                        bgColor: btnFilledTint
                    ) {
                        advance()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, setupDividerHide ? 8 : 16)
            .padding(.bottom, 16)
        }
    }

    private func hideSkipButton(_ step: EDTSCoachmarkStepConfig) -> Bool {
        if type == .single { return true }
        if let explicit = step.isBtnOutlinedHide { return explicit }
        return currentStep == totalSteps
    }

    @ViewBuilder
    private func titleView(_ step: EDTSCoachmarkStepConfig) -> some View {
        Group {
            if let titleAttributed = step.titleAttributed {
                Text(titleAttributed)
            } else {
                Text(step.title ?? "")
            }
        }
        .edtsFont(setupTitleFont)
        .foregroundColor(setupTitleColor)
    }

    @ViewBuilder
    private func descriptionView(_ step: EDTSCoachmarkStepConfig) -> some View {
        Group {
            if let descriptionAttributed = step.descriptionAttributed {
                Text(descriptionAttributed)
            } else {
                Text(step.description ?? "")
            }
        }
        .edtsFont(setupDescriptionFont)
        .foregroundColor(setupDescriptionColor)
        .lineLimit(3)
    }

    // MARK: - Actions

    private func presentIfNeeded() {
        guard !hasAppeared else { return }
        hasAppeared = true

        withAnimation(.timingCurve(0.215, 0.610, 0.355, 1.000, duration: 0.5)) {
            isRevealed = true
        }
        withAnimation(.easeInOut(duration: 0.2).delay(0.5)) {
            cardOpacity = 1
        }
    }

    private func advance() {
        if currentStep >= totalSteps {
            dismiss()
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) {
            cardOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.timingCurve(0.550, 0.055, 0.675, 0.190, duration: 0.4)) {
                isRevealed = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
    let btnOutlinedTint: Color?
    let btnFilledTint: Color?
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
                            btnOutlinedTint: btnOutlinedTint,
                            btnFilledTint: btnFilledTint,
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

private struct EDTSCoachmarkCalloutShape: Shape {
    var cornerRadius: CGFloat
    var arrowX: CGFloat
    var arrowAtTop: Bool
    var arrowWidth: CGFloat
    var arrowHeight: CGFloat

    var animatableData: CGFloat {
        get { arrowX }
        set { arrowX = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let bodyRect = arrowAtTop
            ? CGRect(x: rect.minX, y: rect.minY + arrowHeight, width: rect.width, height: rect.height - arrowHeight)
            : CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - arrowHeight)

        var path = Path(roundedRect: bodyRect, cornerRadius: cornerRadius)

        let topRadius: CGFloat = 1
        let halfWidth = arrowWidth / 2
        var tail = Path()

        if arrowAtTop {
            let baseY = bodyRect.minY
            let tipY = rect.minY
            tail.move(to: CGPoint(x: arrowX - halfWidth, y: baseY))
            tail.addLine(to: CGPoint(x: arrowX + halfWidth, y: baseY))
            let rightControl = CGPoint(x: arrowX + topRadius, y: tipY + topRadius / 2)
            let leftControl = CGPoint(x: arrowX - topRadius, y: tipY + topRadius / 2)
            tail.addLine(to: rightControl)
            tail.addQuadCurve(to: leftControl, control: CGPoint(x: arrowX, y: tipY))
        } else {
            let baseY = bodyRect.maxY
            let tipY = rect.maxY
            tail.move(to: CGPoint(x: arrowX - halfWidth, y: baseY))
            tail.addLine(to: CGPoint(x: arrowX + halfWidth, y: baseY))
            let rightControl = CGPoint(x: arrowX + topRadius, y: tipY - topRadius / 2)
            let leftControl = CGPoint(x: arrowX - topRadius, y: tipY - topRadius / 2)
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
        btnOutlinedTint: Color? = nil,
        btnFilledTint: Color? = nil,
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
                btnOutlinedTint: btnOutlinedTint,
                btnFilledTint: btnFilledTint,
                onDismiss: onDismiss
            )
        )
    }
}

// MARK: - Preview

#Preview("Preview") {
    struct PreviewWrapper: View {
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
    return PreviewWrapper()
}
