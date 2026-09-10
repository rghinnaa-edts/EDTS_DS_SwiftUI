//
//  EDTSTooltip.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 13/08/26.
//

import SwiftUI
import Combine

// MARK: - Layout constants

private enum EDTSTooltipLayout {
    static let animationDuration: TimeInterval = 0.15
    static let appearOffset: CGFloat = 4
    static let minimumSideSpace: CGFloat = 32
}

// MARK: - Config

struct EDTSTooltipConfig {
    var textColor: Color = .white
    var fontStyle: Font? = nil
    var fontName: String = ""
    var fontSize: CGFloat = .zero
    var fontWeight: String? = nil
    var bgColor: Color = .black
    var cornerRadius: CGFloat = 4
    var shadowColor: Color = Color(.sRGB, white: 0.5, opacity: 1)
    var shadowOpacity: Double = 0.18
    var shadowRadius: CGFloat = 5
    var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    var padding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    var spacing: CGFloat = 8
    var maxWidth: CGFloat = UIScreen.main.bounds.width - 32
    var arrowSize: CGSize = CGSize(width: 12, height: 8)
    var containerMargin: CGFloat = 8
    var position: Position = .top

    func resolvedFont() -> Font {
        if let fontStyle {
            return fontStyle
        }

        if fontName.isEmpty && fontSize <= 0 && fontWeight == nil {
            return EDTSFont.Klik.P2.Regular.font
        }

        let size = fontSize > 0 ? fontSize : UIFont.systemFontSize
        var font: Font = fontName.isEmpty ? .system(size: size) : .custom(fontName, size: size)

        if let fontWeight {
            font = font.weight(setupFontWeight(from: fontWeight))
        }

        return font
    }
}

struct EDTSTooltipItem: Identifiable {
    let id: UUID
    var targetFrame: CGRect
    var text: String?
    var attributedText: AttributedString?
    var config: EDTSTooltipConfig
    var onTap: () -> Void
    var isDismissing: Bool = false
}

// MARK: - View modifier

struct EDTSTooltip: ViewModifier {
    @Binding var isPresented: Bool
    var text: String? = nil
    var attributedText: AttributedString? = nil
    var config: EDTSTooltipConfig = EDTSTooltipConfig()
    var minimumPressDuration: TimeInterval? = nil
    var dismissOnRelease: Bool = true
    var dismissOnReleaseDelay: TimeInterval = 0.5
    var autoDismissAfter: TimeInterval? = nil

    @State private var id = UUID()
    @State private var dismissWorkItem: DispatchWorkItem?
    @State private var targetFrame: CGRect = .zero

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            targetFrame = proxy.frame(in: .global)
                            syncPresenterIfPresented()
                        }
                        .onChange(of: proxy.frame(in: .global)) { newFrame in
                            targetFrame = newFrame
                            syncPresenterIfPresented()
                        }
                }
            )
            .modifier(ActionHelper.LongPressAttach(
                minimumPressDuration: minimumPressDuration,
                onBegin: { present() },
                onEnd: { scheduleDismiss(after: dismissOnRelease ? dismissOnReleaseDelay : nil) }
            ))
            .onChange(of: isPresented) { presented in
                if presented {
                    syncPresenterIfPresented()
                    scheduleDismiss(after: autoDismissAfter)
                } else {
                    EDTSTooltipPresenter.shared.dismiss(id: id)
                    dismissWorkItem?.cancel()
                }
            }
            .onChange(of: text) { _ in syncPresenterIfPresented() }
            .onDisappear {
                EDTSTooltipPresenter.shared.dismiss(id: id)
            }
    }

    private func syncPresenterIfPresented() {
        guard isPresented else { return }
        EDTSTooltipPresenter.shared.present(makeItem(frame: targetFrame))
    }

    private func makeItem(frame: CGRect) -> EDTSTooltipItem {
        EDTSTooltipItem(
            id: id,
            targetFrame: frame,
            text: text,
            attributedText: attributedText,
            config: config,
            onTap: { isPresented = false }
        )
    }
    
    private func present() {
        id = UUID()
        isPresented = true
    }

    private func scheduleDismiss(after delay: TimeInterval?) {
        guard let delay else { return }
        dismissWorkItem?.cancel()
        let work = DispatchWorkItem { isPresented = false }
        dismissWorkItem = work
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
        } else {
            work.perform()
        }
    }
}

// MARK: - Bubble shape

private struct EDTSTooltipBubbleShape: Shape {
    var direction: Position
    var cornerRadius: CGFloat
    var arrowSize: CGSize
    var arrowTip: CGPoint

    func path(in rect: CGRect) -> Path {
        var bodyRect = rect
        switch direction {
        case .top:    bodyRect.size.height -= arrowSize.height
        case .bottom:
            bodyRect.origin.y += arrowSize.height
            bodyRect.size.height -= arrowSize.height
        case .leading: bodyRect.size.width -= arrowSize.height
        case .trailing:
            bodyRect.origin.x += arrowSize.height
            bodyRect.size.width -= arrowSize.height
        }

        var path = Path(roundedRect: bodyRect, cornerRadius: cornerRadius)

        var arrow = Path()
        switch direction {
        case .top:
            arrow.move(to: CGPoint(x: arrowTip.x - arrowSize.width / 2, y: bodyRect.maxY))
            arrow.addLine(to: arrowTip)
            arrow.addLine(to: CGPoint(x: arrowTip.x + arrowSize.width / 2, y: bodyRect.maxY))
        case .bottom:
            arrow.move(to: CGPoint(x: arrowTip.x - arrowSize.width / 2, y: bodyRect.minY))
            arrow.addLine(to: arrowTip)
            arrow.addLine(to: CGPoint(x: arrowTip.x + arrowSize.width / 2, y: bodyRect.minY))
        case .leading:
            arrow.move(to: CGPoint(x: bodyRect.maxX, y: arrowTip.y - arrowSize.width / 2))
            arrow.addLine(to: arrowTip)
            arrow.addLine(to: CGPoint(x: bodyRect.maxX, y: arrowTip.y + arrowSize.width / 2))
        case .trailing:
            arrow.move(to: CGPoint(x: bodyRect.minX, y: arrowTip.y - arrowSize.width / 2))
            arrow.addLine(to: arrowTip)
            arrow.addLine(to: CGPoint(x: bodyRect.minX, y: arrowTip.y + arrowSize.width / 2))
        }
        arrow.closeSubpath()
        path.addPath(arrow)
        return path
    }
}

// MARK: - Bubble

private struct EDTSTooltipBubble: View {
    let item: EDTSTooltipItem
    let containerSize: CGSize

    @State private var contentSize: CGSize = .zero
    @State private var hasMeasured = false
    @State private var appeared = false
    @State private var needsWrap = false

    var body: some View {
        let direction = resolvedDirection
        let size = totalSize
        let layout = computeLayout(direction: direction, size: size)

        Group {
            if let attributed = item.attributedText {
                Text(attributed)
            } else {
                Text(item.text ?? "")
            }
        }
        .font(item.config.resolvedFont())
        .foregroundColor(item.config.textColor)
        .padding(item.config.padding)
        .modifier(EDTSTooltipTextSizing(maxWidth: effectiveMaxWidth, needsWrap: needsWrap))
        .background(
            GeometryReader { g in
                Color.clear.preference(key: EDTSTooltipSizeKey.self, value: g.size)
            }
        )
        .onPreferenceChange(EDTSTooltipSizeKey.self) { measured in
            guard measured != .zero else { return }
            if !needsWrap && measured.width > effectiveMaxWidth {
                needsWrap = true
                return
            }
            contentSize = measured
            hasMeasured = true
        }
        .padding(.top, direction == .bottom ? item.config.arrowSize.height : 0)
        .padding(.bottom, direction == .top ? item.config.arrowSize.height : 0)
        .padding(.leading, direction == .trailing ? item.config.arrowSize.height : 0)
        .padding(.trailing, direction == .leading ? item.config.arrowSize.height : 0)
        .background(
            GeometryReader { g in
                EDTSTooltipBubbleShape(
                    direction: direction,
                    cornerRadius: item.config.cornerRadius,
                    arrowSize: item.config.arrowSize,
                    arrowTip: arrowTip(in: g.size, direction: direction, bubbleFrame: layout)
                )
                .fill(item.config.bgColor)
                .shadow(
                    color: item.config.shadowColor.opacity(item.config.shadowOpacity),
                    radius: item.config.shadowRadius,
                    x: item.config.shadowOffset.width,
                    y: item.config.shadowOffset.height
                )
            }
        )
        .position(x: layout.midX, y: layout.midY)
        .opacity(appeared && hasMeasured ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.98)
        .offset(appeared ? .zero : initialOffset(direction: direction))
        .onTapGesture { item.onTap() }
        .onAppear {
            guard !item.isDismissing else { return }
            withAnimation(.easeOut(duration: EDTSTooltipLayout.animationDuration)) { appeared = true }
        }
        .onChange(of: item.id) { _ in
            appeared = false
            hasMeasured = false
            needsWrap = false
            withAnimation(.easeOut(duration: EDTSTooltipLayout.animationDuration)) { appeared = true }
        }
        .onChange(of: item.isDismissing) { isDismissing in
            guard isDismissing else { return }
            withAnimation(.easeIn(duration: EDTSTooltipLayout.animationDuration)) { appeared = false }
        }
    }

    private var resolvedContentSize: CGSize {
        hasMeasured ? contentSize : .zero
    }

    private var totalSize: CGSize {
        var size = resolvedContentSize
        switch resolvedDirection {
        case .top, .bottom: size.height += item.config.arrowSize.height
        case .leading, .trailing: size.width += item.config.arrowSize.height
        }
        return size
    }

    private var effectiveMaxWidth: CGFloat {
        let margin = item.config.containerMargin
        let target = item.targetFrame
        let arrow = item.config.arrowSize.height
        let spacing = item.config.spacing

        switch resolvedDirection {
        case .leading:
            let available = target.minX - spacing - arrow - margin
            return max(1, min(item.config.maxWidth, available))
        case .trailing:
            let available = containerSize.width - target.maxX - spacing - arrow - margin
            return max(1, min(item.config.maxWidth, available))
        case .top, .bottom:
            return item.config.maxWidth
        }
    }

    private var resolvedDirection: Position {
        let target = item.targetFrame
        let spacing = item.config.spacing
        let arrow = item.config.arrowSize
        let margin = item.config.containerMargin
        let minimumSideSpace = EDTSTooltipLayout.minimumSideSpace

        switch item.config.position {
        case .top:
            let size = resolvedContentSize
            let required = size.height + spacing + arrow.height
            let fitsTop = target.minY - required >= margin
            let fitsBottom = target.maxY + required <= containerSize.height - margin
            if !fitsTop && fitsBottom { return .bottom }
        case .bottom:
            let size = resolvedContentSize
            let required = size.height + spacing + arrow.height
            let fitsBottom = target.maxY + required <= containerSize.height - margin
            let fitsTop = target.minY - required >= margin
            if !fitsBottom && fitsTop { return .top }
        case .leading:
            let availableLeading = target.minX - spacing - arrow.height - margin
            if availableLeading < minimumSideSpace { return .trailing }
        case .trailing:
            let availableTrailing = containerSize.width - target.maxX - spacing - arrow.height - margin
            if availableTrailing < minimumSideSpace { return .leading }
        }
        return item.config.position
    }

    private func initialOffset(direction: Position) -> CGSize {
        let offset = EDTSTooltipLayout.appearOffset
        switch direction {
        case .top: return CGSize(width: 0, height: offset)
        case .bottom: return CGSize(width: 0, height: -offset)
        case .leading: return CGSize(width: offset, height: 0)
        case .trailing: return CGSize(width: -offset, height: 0)
        }
    }

    private func computeLayout(direction: Position, size: CGSize) -> CGRect {
        let target = item.targetFrame
        let spacing = item.config.spacing

        var origin: CGPoint
        switch direction {
        case .top:
            let idealY = target.minY - spacing - size.height
            origin = CGPoint(x: target.midX - size.width / 2, y: idealY)
            origin.x = clampCrossAxis(origin.x, length: size.width, containerLength: containerSize.width)
        case .bottom:
            let idealY = target.maxY + spacing
            origin = CGPoint(x: target.midX - size.width / 2, y: idealY)
            origin.x = clampCrossAxis(origin.x, length: size.width, containerLength: containerSize.width)
        case .leading:
            let idealX = target.minX - spacing - size.width
            origin = CGPoint(x: idealX, y: target.midY - size.height / 2)
            origin.y = clampCrossAxis(origin.y, length: size.height, containerLength: containerSize.height)
        case .trailing:
            let idealX = target.maxX + spacing
            origin = CGPoint(x: idealX, y: target.midY - size.height / 2)
            origin.y = clampCrossAxis(origin.y, length: size.height, containerLength: containerSize.height)
        }

        return CGRect(origin: origin, size: size)
    }

    private func clampCrossAxis(_ value: CGFloat, length: CGFloat, containerLength: CGFloat) -> CGFloat {
        let margin = item.config.containerMargin
        return max(margin, min(value, containerLength - length - margin))
    }

    private func arrowTip(in localSize: CGSize, direction: Position, bubbleFrame: CGRect) -> CGPoint {
        let target = item.targetFrame
        let arrow = item.config.arrowSize

        switch direction {
        case .top, .bottom:
            let desiredX = target.midX - bubbleFrame.minX
            let clampedX = max(item.config.cornerRadius + arrow.width, min(desiredX, localSize.width - item.config.cornerRadius - arrow.width))
            let y: CGFloat = direction == .top ? localSize.height : 0
            return CGPoint(x: clampedX, y: y)
        case .leading, .trailing:
            let desiredY = target.midY - bubbleFrame.minY
            let clampedY = max(item.config.cornerRadius + arrow.width, min(desiredY, localSize.height - item.config.cornerRadius - arrow.width))
            let x: CGFloat = direction == .leading ? localSize.width : 0
            return CGPoint(x: x, y: clampedY)
        }
    }
}

private struct EDTSTooltipTextSizing: ViewModifier {
    let maxWidth: CGFloat
    let needsWrap: Bool

    func body(content: Content) -> some View {
        if needsWrap {
            content
                .frame(maxWidth: maxWidth, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            content
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}

private struct EDTSTooltipSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        if next != .zero { value = next }
    }
}

// MARK: - Overlay window presentation

@MainActor
final class EDTSTooltipPresenter: ObservableObject {
    static let shared = EDTSTooltipPresenter()

    @Published fileprivate var items: [EDTSTooltipItem] = []
    private var window: EDTSTooltipPassthroughWindow?
    private let dismissAnimationDuration: TimeInterval = EDTSTooltipLayout.animationDuration

    private init() {}

    func present(_ item: EDTSTooltipItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        ensureWindow()
    }
    
    func dismiss(id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        guard !items[index].isDismissing else { return }
        items[index].isDismissing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAnimationDuration) { [weak self] in
            guard let self else { return }
            guard let index = self.items.firstIndex(where: { $0.id == id }), self.items[index].isDismissing else { return }
            self.items.remove(at: index)
            if self.items.isEmpty {
                self.teardownWindow()
            }
        }
    }

    private func ensureWindow() {
        guard window == nil else { return }
        guard let scene = Self.activeWindowScene() else { return }

        let overlayWindow = EDTSTooltipPassthroughWindow(windowScene: scene)
        overlayWindow.backgroundColor = .clear
        overlayWindow.windowLevel = .alert + 1
        overlayWindow.isUserInteractionEnabled = true

        let hosting = UIHostingController(rootView: EDTSTooltipOverlayRoot(presenter: self))
        hosting.view.backgroundColor = .clear
        overlayWindow.rootViewController = hosting
        overlayWindow.isHidden = false

        window = overlayWindow
    }

    private func teardownWindow() {
        window?.isHidden = true
        window = nil
    }

    private static func activeWindowScene() -> UIWindowScene? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
    }
}

private final class EDTSTooltipPassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return hitView == rootViewController?.view ? nil : hitView
    }
}

private struct EDTSTooltipOverlayRoot: View {
    @ObservedObject var presenter: EDTSTooltipPresenter

    var body: some View {
        GeometryReader { proxy in
            ForEach(presenter.items) { item in
                EDTSTooltipBubble(item: item, containerSize: proxy.size)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Extension View

public extension View {
    func edtsTooltip(
        isPresented: Binding<Bool>,
        text: String? = "Text here",
        attributedText: AttributedString? = nil,
        textColor: Color = .white,
        fontStyle: Font? = nil,
        fontName: String = "",
        fontSize: CGFloat = .zero,
        fontWeight: String? = nil,
        bgColor: Color = .black,
        cornerRadius: CGFloat = 4,
        shadowColor: Color = Color(.sRGB, white: 0.5, opacity: 1),
        shadowOpacity: Double = 0.18,
        shadowRadius: CGFloat = 5,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        padding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        spacing: CGFloat = 8,
        maxWidth: CGFloat = UIScreen.main.bounds.width - 32,
        arrowSize: CGSize = CGSize(width: 12, height: 8),
        containerMargin: CGFloat = 8,
        position: Position = .top,
        minimumPressDuration: TimeInterval? = nil,
        dismissOnRelease: Bool = true,
        dismissOnReleaseDelay: TimeInterval = 0.5,
        autoDismissAfter: TimeInterval? = nil
    ) -> some View {
        let config = EDTSTooltipConfig(
            textColor: textColor,
            fontStyle: fontStyle,
            fontName: fontName,
            fontSize: fontSize,
            fontWeight: fontWeight,
            bgColor: bgColor,
            cornerRadius: cornerRadius,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            padding: padding,
            spacing: spacing,
            maxWidth: maxWidth,
            arrowSize: arrowSize,
            containerMargin: containerMargin,
            position: position
        )

        return modifier(EDTSTooltip(
            isPresented: isPresented,
            text: text,
            attributedText: attributedText,
            config: config,
            minimumPressDuration: minimumPressDuration,
            dismissOnRelease: dismissOnRelease,
            dismissOnReleaseDelay: dismissOnReleaseDelay,
            autoDismissAfter: autoDismissAfter
        ))
    }
}

// MARK: - Example usage

struct EDTSTooltipView: View {
    @State private var showLongPressTooltip = false
    @State private var showTapTooltip = false
    @State private var showEdgeTooltip = false

    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 8) {
                Text("Long press")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.gray, in: RoundedRectangle(cornerRadius: 8))
                    .edtsTooltip(
                        isPresented: $showLongPressTooltip,
                        text: "Hold and release to dismiss",
                        position: .top,
                        minimumPressDuration: 0.35
                    )

                Text("Press and hold this button")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                Text("Tap to toggle")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.gray, in: RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        showTapTooltip.toggle()
                    }
                    .edtsTooltip(
                        isPresented: $showTapTooltip,
                        text: "Tap the button again to close me",
                        position: .bottom
                    )

                Text("Tap once to open, tap again to close")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EDTSTooltipView()
}
