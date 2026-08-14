//
//  EDTSTooltip.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 13/08/26.
//

import SwiftUI

// MARK: - Direction

public enum EDTSTooltipDirection {
    case top
    case bottom
    case leading
    case trailing
}

// MARK: - Style

public struct EDTSTooltipStyle {
    public var labelColor: Color
    public var font: Font
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var shadowOpacity: Double
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var padding: EdgeInsets
    public var spacing: CGFloat
    public var maxWidth: CGFloat
    public var arrowSize: CGSize

    public init(
        labelColor: Color = .white,
        font: Font = .system(size: 12),
        backgroundColor: Color = .black,
        cornerRadius: CGFloat = 4,
        shadowColor: Color = Color(.sRGB, white: 0.5, opacity: 1),
        shadowOpacity: Double = 0.18,
        shadowRadius: CGFloat = 5,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        padding: EdgeInsets = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
        spacing: CGFloat = 8,
        maxWidth: CGFloat = UIScreen.main.bounds.width - 32,
        arrowSize: CGSize = CGSize(width: 12, height: 8)
    ) {
        self.labelColor = labelColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.padding = padding
        self.spacing = spacing
        self.maxWidth = maxWidth
        self.arrowSize = arrowSize
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

// MARK: - Coordinate space

public struct EDTSTooltipContainerSpace: ViewModifier {
    public static let name = "EDTSTooltipContainer"
    public func body(content: Content) -> some View {
        content.coordinateSpace(name: Self.name)
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

struct EDTSTooltipPreferenceKey: PreferenceKey {
    static var defaultValue: [EDTSTooltipItem] = []
    static func reduce(value: inout [EDTSTooltipItem], nextValue: () -> [EDTSTooltipItem]) {
        value.append(contentsOf: nextValue())
    }
}

public struct EDTSTooltipRenderer: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .modifier(EDTSTooltipContainerSpace())
            .overlayPreferenceValue(EDTSTooltipPreferenceKey.self) { items in
                GeometryReader { proxy in
                    ForEach(items) { item in
                        EDTSTooltipBubble(item: item, containerSize: proxy.size)
                    }
                }
            }
    }
}

// MARK: - Bubble

private struct EDTSTooltipBubble: View {
    let item: EDTSTooltipItem
    let containerSize: CGSize

    @State private var measuredSize: CGSize = .zero
    @State private var hasMeasured = false
    @State private var appeared = false

    var body: some View {
        let layout = computeLayout()

        Group {
            if let attributed = item.attributedText {
                Text(attributed)
            } else {
                Text(item.text ?? "")
            }
        }
        .font(item.style.font)
        .foregroundColor(item.style.labelColor)
        .padding(item.style.padding)
        .frame(maxWidth: item.style.maxWidth, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        // Reserve room for the arrow on the side facing the target.
        .padding(.top, item.direction == .bottom ? item.style.arrowSize.height : 0)
        .padding(.bottom, item.direction == .top ? item.style.arrowSize.height : 0)
        .padding(.leading, item.direction == .trailing ? item.style.arrowSize.height : 0)
        .padding(.trailing, item.direction == .leading ? item.style.arrowSize.height : 0)
        .background(
            GeometryReader { g in
                EDTSTooltipBubbleShape(
                    direction: item.direction,
                    cornerRadius: item.style.cornerRadius,
                    arrowSize: item.style.arrowSize,
                    arrowTip: arrowTip(in: g.size)
                )
                .fill(item.style.backgroundColor)
                .shadow(
                    color: item.style.shadowColor.opacity(item.style.shadowOpacity),
                    radius: item.style.shadowRadius,
                    x: item.style.shadowOffset.width,
                    y: item.style.shadowOffset.height
                )
                .preference(key: EDTSTooltipSizeKey.self, value: g.size)
            }
        )
        .onPreferenceChange(EDTSTooltipSizeKey.self) { size in
            guard size != .zero else { return }
            measuredSize = size
            hasMeasured = true
        }
        .position(x: layout.midX, y: layout.midY)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.98)
        .offset(appeared ? .zero : initialOffset())
        .onTapGesture { item.onTap() }
        .onAppear {
            withAnimation(.easeOut(duration: 0.15)) { appeared = true }
        }
        .onChange(of: item.id) { _ in
            appeared = false
            withAnimation(.easeOut(duration: 0.15)) { appeared = true }
        }
    }

    private var estimatedSize: CGSize {
        hasMeasured ? measuredSize : CGSize(width: 120, height: 40)
    }

    private func initialOffset() -> CGSize {
        switch item.direction {
        case .top: return CGSize(width: 0, height: 4)
        case .bottom: return CGSize(width: 0, height: -4)
        case .leading: return CGSize(width: 4, height: 0)
        case .trailing: return CGSize(width: -4, height: 0)
        }
    }

    private func computeLayout() -> CGRect {
        let size = estimatedSize
        let target = item.targetFrame
        let spacing = item.style.spacing
        let arrow = item.style.arrowSize

        var origin: CGPoint
        switch item.direction {
        case .top:
            origin = CGPoint(x: target.midX - size.width / 2, y: target.minY - spacing - arrow.height - size.height)
        case .bottom:
            origin = CGPoint(x: target.midX - size.width / 2, y: target.maxY + spacing)
        case .leading:
            origin = CGPoint(x: target.minX - spacing - arrow.height - size.width, y: target.midY - size.height / 2)
        case .trailing:
            origin = CGPoint(x: target.maxX + spacing, y: target.midY - size.height / 2)
        }

        origin.x = max(8, min(origin.x, containerSize.width - size.width - 8))
        origin.y = max(8, min(origin.y, containerSize.height - size.height - 8))

        return CGRect(origin: origin, size: size)
    }

    private func arrowTip(in localSize: CGSize) -> CGPoint {
        let target = item.targetFrame
        let bubbleFrame = computeLayout()
        let arrow = item.style.arrowSize

        switch item.direction {
        case .top, .bottom:
            let desiredX = target.midX - bubbleFrame.minX
            let clampedX = max(item.style.cornerRadius + arrow.width, min(desiredX, localSize.width - item.style.cornerRadius - arrow.width))
            let y: CGFloat = item.direction == .top ? localSize.height : 0
            return CGPoint(x: clampedX, y: y)
        case .leading, .trailing:
            let desiredY = target.midY - bubbleFrame.minY
            let clampedY = max(item.style.cornerRadius + arrow.width, min(desiredY, localSize.height - item.style.cornerRadius - arrow.width))
            let x: CGFloat = item.direction == .leading ? localSize.width : 0
            return CGPoint(x: x, y: clampedY)
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

// MARK: - Attach modifier

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

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: EDTSTooltipPreferenceKey.self,
                            value: isPresented ? [makeItem(frame: proxy.frame(in: .named(EDTSTooltipContainerSpace.name)))] : []
                        )
                }
            )
            .modifier(LongPressAttach(
                minimumPressDuration: minimumPressDuration,
                onBegin: { present() },
                onEnd: { scheduleReleaseDismissIfNeeded() }
            ))
            .onChange(of: isPresented) { presented in
                if presented { scheduleAutoDismissIfNeeded() }
                else { dismissWorkItem?.cancel() }
            }
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

// MARK: - Public API

public extension View {
    func edtsTooltipContainer() -> some View {
        modifier(EDTSTooltipRenderer())
    }

    func edtsTooltip(
        isPresented: Binding<Bool>,
        text: String? = nil,
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

private struct EDTSTooltipView: View {
    @State private var showLongPressTooltip = false
    @State private var showTapTooltip = false

    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 8) {
                Text("Long press")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(EDTSColor.grey60, in: RoundedRectangle(cornerRadius: 8))
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
                    .background(EDTSColor.grey60, in: RoundedRectangle(cornerRadius: 8))
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
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edtsTooltipContainer()
    }
}

#Preview {
    EDTSTooltipView()
}
