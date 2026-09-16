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
    public var textColor: Color = .white
    public var fontStyle: Font? = nil
    public var fontName: String = ""
    public var fontSize: CGFloat = .zero
    public var fontWeight: String? = nil
    public var bgColor: Color = .black
    public var cornerRadius: CGFloat = 4
    public var shadowColor: Color = Color(.sRGB, white: 0.5, opacity: 1)
    public var shadowOpacity: Double = 0.18
    public var shadowRadius: CGFloat = 5
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    public var paddingTop: CGFloat = 8
    public var paddingBottom: CGFloat = 8
    public var paddingLeading: CGFloat = 8
    public var paddingTrailing: CGFloat = 8
    public var distance: CGFloat = 8
    public var maxWidth: CGFloat = UIScreen.main.bounds.width - 32
    public var arrowSize: CGSize = CGSize(width: 12, height: 8)
    public var containerMargin: CGFloat = 8
    public var position: Position = .top

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
    public let id: UUID
    public var targetFrame: CGRect
    public var text: String?
    public var textAttributed: AttributedString?
    public var config: EDTSTooltipConfig
    public var onTap: () -> Void
    public var isDismissing: Bool = false
}

// MARK: - View modifier

struct EDTSTooltip: ViewModifier {
    @Binding var isPresented: Bool
    public var text: String? = nil
    public var textAttributed: AttributedString? = nil
    public var config: EDTSTooltipConfig = EDTSTooltipConfig()
    public var minimumPressDuration: TimeInterval? = nil
    public var dismissOnRelease: Bool = true
    public var dismissOnReleaseDelay: TimeInterval = 0.5
    public var autoDismissAfter: TimeInterval? = nil

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
                            guard isAnchorOnScreen(newFrame) else {
                                EDTSTooltipPresenter.shared.dismiss(id: id, animated: false)
                                return
                            }
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
                EDTSTooltipPresenter.shared.dismiss(id: id, animated: false)
            }
    }

    private func syncPresenterIfPresented() {
        guard isPresented else { return }
        EDTSTooltipPresenter.shared.present(makeItem(frame: targetFrame))
    }

    private func isAnchorOnScreen(_ frame: CGRect) -> Bool {
        guard frame.width > 0, frame.height > 0 else { return false }
        return UIScreen.main.bounds.intersects(frame)
    }

    private func makeItem(frame: CGRect) -> EDTSTooltipItem {
        EDTSTooltipItem(
            id: id,
            targetFrame: frame,
            text: text,
            textAttributed: textAttributed,
            config: config,
            onTap: { isPresented = false }
        )
    }
    
    private func present() {
        guard !isPresented else { return }
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
        case .top:
            bodyRect.size.height -= arrowSize.height
        case .bottom:
            bodyRect.origin.y += arrowSize.height
            bodyRect.size.height -= arrowSize.height
        case .leading:
            bodyRect.size.width -= arrowSize.height
        case .trailing:
            bodyRect.origin.x += arrowSize.height
            bodyRect.size.width -= arrowSize.height
        }

        let r = min(cornerRadius, min(bodyRect.width, bodyRect.height) / 2)
        let halfArrow = arrowSize.width / 2
        var path = Path()

        switch direction {
        case .top:
            path.move(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY))
            path.addLine(to: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY - r))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: arrowTip.x + halfArrow, y: bodyRect.maxY))
            path.addLine(to: arrowTip)
            path.addLine(to: CGPoint(x: arrowTip.x - halfArrow, y: bodyRect.maxY))
            path.addLine(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX, y: bodyRect.minY + r))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        case .bottom:
            path.move(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY))
            path.addLine(to: CGPoint(x: arrowTip.x - halfArrow, y: bodyRect.minY))
            path.addLine(to: arrowTip)
            path.addLine(to: CGPoint(x: arrowTip.x + halfArrow, y: bodyRect.minY))
            path.addLine(to: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY - r))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX, y: bodyRect.minY + r))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        case .leading:
            path.move(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY))
            path.addLine(to: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: arrowTip.y - halfArrow))
            path.addLine(to: arrowTip)
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: arrowTip.y + halfArrow))
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY - r))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX, y: bodyRect.minY + r))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        case .trailing:
            path.move(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY))
            path.addLine(to: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY - r))
            path.addArc(center: CGPoint(x: bodyRect.maxX - r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            path.addLine(to: CGPoint(x: bodyRect.minX, y: arrowTip.y + halfArrow))
            path.addLine(to: arrowTip)
            path.addLine(to: CGPoint(x: bodyRect.minX, y: arrowTip.y - halfArrow))
            path.addLine(to: CGPoint(x: bodyRect.minX, y: bodyRect.minY + r))
            path.addArc(center: CGPoint(x: bodyRect.minX + r, y: bodyRect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Bubble

private struct EDTSTooltipBubble: View {
    let item: EDTSTooltipItem
    let containerSize: CGSize
    let topSafeAreaInset: CGFloat

    @State private var contentSize: CGSize = .zero
    @State private var hasMeasured = false
    @State private var appeared = false
    @State private var needsWrap = false

    var body: some View {
        let direction = resolvedDirection
        let size = totalSize
        let layout = computeLayout(direction: direction, size: size)

        Group {
            if let attributed = item.textAttributed {
                Text(attributed)
            } else {
                Text(item.text ?? "Text Here")
            }
        }
        .font(item.config.resolvedFont())
        .foregroundColor(item.config.textColor)
        .padding(EdgeInsets(top: item.config.paddingTop, leading: item.config.paddingLeading, bottom: item.config.paddingBottom, trailing: item.config.paddingTrailing))
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
            
            guard !hasMeasured else { return }
            hasMeasured = true
            guard !item.isDismissing else { return }
            withAnimation(.easeOut(duration: EDTSTooltipLayout.animationDuration)) {
                appeared = true
            }
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
        .onChange(of: item.id) { _ in
            appeared = false
            hasMeasured = false
            needsWrap = false
        }
        .onChange(of: item.isDismissing) { isDismissing in
            guard isDismissing else { return }
            withAnimation(.easeIn(duration: EDTSTooltipLayout.animationDuration)) { appeared = false }
        }
        .preference(key: EDTSTooltipFrameKey.self, value: [item.id: layout])
    }

    private var resolvedContentSize: CGSize {
        hasMeasured ? contentSize : .zero
    }

    private var totalSize: CGSize {
        var size = resolvedContentSize
        
        switch resolvedDirection {
        case .top, .bottom:
            size.height += item.config.arrowSize.height
        case .leading, .trailing:
            size.width += item.config.arrowSize.height
        }
        
        return size
    }

    private var effectiveMaxWidth: CGFloat {
        let margin = item.config.containerMargin
        let target = item.targetFrame
        let arrow = item.config.arrowSize.height
        let distance = item.config.distance

        switch resolvedDirection {
        case .leading:
            let available = target.minX - distance - arrow - margin
            return max(1, min(item.config.maxWidth, available))
        case .trailing:
            let available = containerSize.width - target.maxX - distance - arrow - margin
            return max(1, min(item.config.maxWidth, available))
        case .top, .bottom:
            return item.config.maxWidth
        }
    }

    private var topLimit: CGFloat {
        topSafeAreaInset
    }

    private var bottomLimit: CGFloat {
        containerSize.height - (item.config.distance + item.config.arrowSize.height + item.config.containerMargin)
    }

    private var resolvedDirection: Position {
        let target = item.targetFrame
        let spacing = item.config.distance
        let arrow = item.config.arrowSize
        let minimumSideSpace = EDTSTooltipLayout.minimumSideSpace

        switch item.config.position {
        case .top:
            let size = resolvedContentSize
            let required = size.height + spacing + arrow.height
            let fitsTop = target.minY - required >= topLimit
            let fitsBottom = target.maxY + required <= bottomLimit
            if !fitsTop && fitsBottom { return .bottom }
        case .bottom:
            let size = resolvedContentSize
            let required = size.height + spacing + arrow.height
            let fitsBottom = target.maxY + required <= bottomLimit
            let fitsTop = target.minY - required >= topLimit
            if !fitsBottom && fitsTop { return .top }
        case .leading:
            let availableLeading = target.minX - spacing - arrow.height - item.config.containerMargin
            if availableLeading < minimumSideSpace { return .trailing }
        case .trailing:
            let availableTrailing = containerSize.width - target.maxX - spacing - arrow.height - item.config.containerMargin
            if availableTrailing < minimumSideSpace { return .leading }
        }
        return item.config.position
    }

    private func initialOffset(direction: Position) -> CGSize {
        let offset = EDTSTooltipLayout.appearOffset
        
        switch direction {
        case .top:
            return CGSize(width: 0, height: offset)
        case .bottom:
            return CGSize(width: 0, height: -offset)
        case .leading:
            return CGSize(width: offset, height: 0)
        case .trailing:
            return CGSize(width: -offset, height: 0)
        }
    }

    private func computeLayout(direction: Position, size: CGSize) -> CGRect {
        let target = item.targetFrame
        let spacing = item.config.distance
        var origin: CGPoint
        
        switch direction {
        case .top:
            let idealY = target.minY - spacing - size.height
            origin = CGPoint(x: target.midX - size.width / 2, y: max(idealY, topLimit))
            origin.x = clampCrossAxis(origin.x, length: size.width, containerLength: containerSize.width)
        case .bottom:
            let idealY = target.maxY + spacing
            origin = CGPoint(x: target.midX - size.width / 2, y: min(idealY, bottomLimit - size.height))
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

private struct EDTSTooltipFrameKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
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

    func dismiss(id: UUID, animated: Bool = true) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        guard !items[index].isDismissing else { return }

        guard animated else {
            items.remove(at: index)
            if items.isEmpty {
                teardownWindow()
            }
            return
        }

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

    func updateBubbleFrames(_ frames: [CGRect]) {
        window?.bubbleFrames = frames
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
    var bubbleFrames: [CGRect] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        let tappedBubble = bubbleFrames.contains { $0.insetBy(dx: -4, dy: -4).contains(point) }
        return tappedBubble ? hitView : nil
    }
}

private struct EDTSTooltipOverlayRoot: View {
    @ObservedObject var presenter: EDTSTooltipPresenter

    private var topSafeAreaInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let keyWindow = scenes.flatMap { $0.windows }.first(where: { $0.isKeyWindow })
        return keyWindow?.safeAreaInsets.top ?? 0
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(presenter.items) { item in
                EDTSTooltipBubble(
                    item: item,
                    containerSize: proxy.size,
                    topSafeAreaInset: topSafeAreaInset
                )
            }
        }
        .ignoresSafeArea()
        .onPreferenceChange(EDTSTooltipFrameKey.self) { frames in
            presenter.updateBubbleFrames(Array(frames.values))
        }
    }
}

// MARK: - Extension View

public extension View {
    func edtsTooltip(
        isPresented: Binding<Bool>,
        text: String? = "Text here",
        textAttributed: AttributedString? = nil,
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
        paddingTop: CGFloat = 8,
        paddingBottom: CGFloat = 8,
        paddingLeading: CGFloat = 8,
        paddingTrailing: CGFloat = 8,
        distance: CGFloat = 8,
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
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            paddingLeading: paddingLeading,
            paddingTrailing: paddingTrailing,
            distance: distance,
            maxWidth: maxWidth,
            arrowSize: arrowSize,
            containerMargin: containerMargin,
            position: position
        )

        return modifier(EDTSTooltip(
            isPresented: isPresented,
            text: text,
            textAttributed: textAttributed,
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
        VStack(spacing: 24) {
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
