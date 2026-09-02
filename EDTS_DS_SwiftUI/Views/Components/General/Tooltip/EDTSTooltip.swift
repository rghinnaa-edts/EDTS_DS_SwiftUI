//
//  EDTSTooltip.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 13/08/26.
//

import SwiftUI
import Combine

// MARK: - Direction

public enum EDTSTooltipDirection {
    case top
    case bottom
    case leading
    case trailing
}

// MARK: - Style

public struct EDTSTooltipStyle {
    public var textColor: Color
    public var fontStyle: Font?
    public var fontName: String
    public var fontSize: CGFloat
    public var fontWeight: String?
    public var bgColor: Color
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var padding: EdgeInsets
    public var spacing: CGFloat
    public var maxWidth: CGFloat
    public var arrowSize: CGSize
    public var containerMargin: CGFloat

    public init(
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
        containerMargin: CGFloat = 8
    ) {
        self.textColor = textColor
        self.fontStyle = fontStyle
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.padding = padding
        self.spacing = spacing
        self.maxWidth = maxWidth
        self.arrowSize = arrowSize
        self.containerMargin = containerMargin
    }

    public static let `default` = EDTSTooltipStyle()
}

// MARK: - Bubble shape

private struct EDTSTooltipBubbleShape: Shape {
    var direction: EDTSTooltipDirection
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

struct EDTSTooltipItem: Identifiable, Equatable {
    let id: UUID
    var targetFrame: CGRect
    var direction: EDTSTooltipDirection
    var text: String?
    var attributedText: AttributedString?
    var style: EDTSTooltipStyle
    var onTap: () -> Void

    static func == (lhs: EDTSTooltipItem, rhs: EDTSTooltipItem) -> Bool {
        lhs.id == rhs.id && lhs.targetFrame == rhs.targetFrame && lhs.text == rhs.text
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
        .font(item.style.fontStyle)
        .foregroundColor(item.style.textColor)
        .padding(item.style.padding)
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
        .padding(.top, direction == .bottom ? item.style.arrowSize.height : 0)
        .padding(.bottom, direction == .top ? item.style.arrowSize.height : 0)
        .padding(.leading, direction == .trailing ? item.style.arrowSize.height : 0)
        .padding(.trailing, direction == .leading ? item.style.arrowSize.height : 0)
        .background(
            GeometryReader { g in
                EDTSTooltipBubbleShape(
                    direction: direction,
                    cornerRadius: item.style.cornerRadius,
                    arrowSize: item.style.arrowSize,
                    arrowTip: arrowTip(in: g.size, direction: direction, bubbleFrame: layout)
                )
                .fill(item.style.bgColor)
                .shadow(
                    color: item.style.shadowColor.opacity(item.style.shadowOpacity),
                    radius: item.style.shadowRadius,
                    x: item.style.shadowOffset.width,
                    y: item.style.shadowOffset.height
                )
            }
        )
        .position(x: layout.midX, y: layout.midY)
        .opacity(appeared && hasMeasured ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.98)
        .offset(appeared ? .zero : initialOffset(direction: direction))
        .onTapGesture { item.onTap() }
        .onAppear {
            withAnimation(.easeOut(duration: 0.15)) { appeared = true }
        }
        .onChange(of: item.id) { _ in
            appeared = false
            hasMeasured = false
            needsWrap = false
            withAnimation(.easeOut(duration: 0.15)) { appeared = true }
        }
    }

    private var resolvedContentSize: CGSize {
        hasMeasured ? contentSize : .zero
    }

    private var totalSize: CGSize {
        var size = resolvedContentSize
        switch resolvedDirection {
        case .top, .bottom: size.height += item.style.arrowSize.height
        case .leading, .trailing: size.width += item.style.arrowSize.height
        }
        return size
    }

    private var effectiveMaxWidth: CGFloat {
        let margin = item.style.containerMargin
        let target = item.targetFrame
        let arrow = item.style.arrowSize.height
        let spacing = item.style.spacing

        switch resolvedDirection {
        case .leading:
            let available = target.minX - spacing - arrow - margin
            return max(1, min(item.style.maxWidth, available))
        case .trailing:
            let available = containerSize.width - target.maxX - spacing - arrow - margin
            return max(1, min(item.style.maxWidth, available))
        case .top, .bottom:
            return item.style.maxWidth
        }
    }
    
    private var resolvedDirection: EDTSTooltipDirection {
        let target = item.targetFrame
        let spacing = item.style.spacing
        let arrow = item.style.arrowSize
        let margin = item.style.containerMargin
        let minimumSideSpace: CGFloat = 32

        switch item.direction {
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
        return item.direction
    }

    private func initialOffset(direction: EDTSTooltipDirection) -> CGSize {
        switch direction {
        case .top: return CGSize(width: 0, height: 4)
        case .bottom: return CGSize(width: 0, height: -4)
        case .leading: return CGSize(width: 4, height: 0)
        case .trailing: return CGSize(width: -4, height: 0)
        }
    }

    private func computeLayout(direction: EDTSTooltipDirection, size: CGSize) -> CGRect {
        let target = item.targetFrame
        let spacing = item.style.spacing

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
        let margin = item.style.containerMargin
        return max(margin, min(value, containerLength - length - margin))
    }

    private func arrowTip(in localSize: CGSize, direction: EDTSTooltipDirection, bubbleFrame: CGRect) -> CGPoint {
        let target = item.targetFrame
        let arrow = item.style.arrowSize

        switch direction {
        case .top, .bottom:
            let desiredX = target.midX - bubbleFrame.minX
            let clampedX = max(item.style.cornerRadius + arrow.width, min(desiredX, localSize.width - item.style.cornerRadius - arrow.width))
            let y: CGFloat = direction == .top ? localSize.height : 0
            return CGPoint(x: clampedX, y: y)
        case .leading, .trailing:
            let desiredY = target.midY - bubbleFrame.minY
            let clampedY = max(item.style.cornerRadius + arrow.width, min(desiredY, localSize.height - item.style.cornerRadius - arrow.width))
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

final class EDTSTooltipPresenter: ObservableObject {
    static let shared = EDTSTooltipPresenter()

    @Published fileprivate var items: [EDTSTooltipItem] = []
    private var window: EDTSTooltipPassthroughWindow?

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
        items.removeAll { $0.id == id }
        if items.isEmpty {
            teardownWindow()
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

// MARK: - View modifier

public struct EDTSTooltip: ViewModifier {
    @Binding var isPresented: Bool

    var text: String? = nil
    var attributedText: AttributedString? = nil
    var direction: EDTSTooltipDirection = .top
    var style: EDTSTooltipStyle = .default

    var minimumPressDuration: TimeInterval? = nil
    var dismissOnRelease: Bool = true
    var dismissOnReleaseDelay: TimeInterval = 0.5
    var autoDismissAfter: TimeInterval? = nil

    @State private var id = UUID()
    @State private var dismissWorkItem: DispatchWorkItem?
    @State private var targetFrame: CGRect = .zero

    public func body(content: Content) -> some View {
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
            .modifier(LongPressAttach(
                minimumPressDuration: minimumPressDuration,
                onBegin: { present() },
                onEnd: { scheduleReleaseDismissIfNeeded() }
            ))
            .onChange(of: isPresented) { presented in
                if presented {
                    syncPresenterIfPresented()
                    scheduleAutoDismissIfNeeded()
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
            direction: direction,
            text: text,
            attributedText: attributedText,
            style: style,
            onTap: { withAnimation(.easeIn(duration: 0.15)) { isPresented = false } }
        )
    }

    private func present() {
        id = UUID()
        withAnimation(.easeOut(duration: 0.15)) { isPresented = true }
    }

    private func scheduleAutoDismissIfNeeded() {
        guard let duration = autoDismissAfter else { return }
        dismissWorkItem?.cancel()
        let work = DispatchWorkItem { withAnimation(.easeIn(duration: 0.15)) { isPresented = false } }
        dismissWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }

    private func scheduleReleaseDismissIfNeeded() {
        guard dismissOnRelease else { return }
        dismissWorkItem?.cancel()
        let work = DispatchWorkItem { withAnimation(.easeIn(duration: 0.15)) { isPresented = false } }
        dismissWorkItem = work
        if dismissOnReleaseDelay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissOnReleaseDelay, execute: work)
        } else {
            work.perform()
        }
    }
}

private struct LongPressAttach: ViewModifier {
    let minimumPressDuration: TimeInterval?
    let onBegin: () -> Void
    let onEnd: () -> Void

    func body(content: Content) -> some View {
        if let duration = minimumPressDuration {
            content.onLongPressGesture(
                minimumDuration: duration,
                pressing: { pressing in if !pressing { onEnd() } },
                perform: { onBegin() }
            )
        } else {
            content
        }
    }
}

// MARK: - Extension View

public extension View {
    func edtsTooltip(
        isPresented: Binding<Bool>,
        text: String? = "Text here",
        attributedText: AttributedString? = nil,
        direction: EDTSTooltipDirection = .top,
        style: EDTSTooltipStyle = .default,
        minimumPressDuration: TimeInterval? = nil,
        dismissOnRelease: Bool = true,
        dismissOnReleaseDelay: TimeInterval = 0.5,
        autoDismissAfter: TimeInterval? = nil
    ) -> some View {
        modifier(EDTSTooltip(
            isPresented: isPresented,
            text: text,
            attributedText: attributedText,
            direction: direction,
            style: style,
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
                        direction: .top,
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
                        withAnimation(.easeInOut(duration: 0.15)) {
                            showTapTooltip.toggle()
                        }
                    }
                    .edtsTooltip(
                        isPresented: $showTapTooltip,
                        text: "Tap the button again to close me",
                        direction: .bottom
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
