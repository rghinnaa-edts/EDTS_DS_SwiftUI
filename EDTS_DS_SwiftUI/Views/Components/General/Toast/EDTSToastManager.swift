//
//  EDTSToastManager.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/09/26.
//

import SwiftUI
import UIKit
import Combine

// MARK: - Enums
public enum EDTSToastAnimation: String {
    case fade = "fade"
    case slide = "slide"
}

public enum EDTSToastDuration {
    case short
    case long
    case indefinite
    case custom(TimeInterval)

    var timeInterval: TimeInterval? {
        switch self {
        case .short:
            return 1.5
        case .long:
            return 2.75
        case .indefinite:
            return nil
        case .custom(let value):
            return value
        }
    }
}

public enum EDTSToastSwipeDirection: String {
    case horizontal = "horizontal"
    case vertical = "vertical"

    var allowedDirections: (x: Bool, y: Bool) {
        switch self {
        case .horizontal: return (x: true, y: false)
        case .vertical:   return (x: false, y: true)
        }
    }

    func dismissEdge(offsetY: EDTSToastOffsetDirection) -> EDTSToastDismissEdge {
        switch self {
        case .horizontal:
            return .trailing
        case .vertical:
            switch offsetY {
            case .bottom: return .bottom
            case .top:    return .top
            }
        }
    }
}

public enum EDTSToastOffsetDirection {
    case top(Double)
    case bottom(Double)

    var value: Double {
        switch self {
        case .top(let value):    return value
        case .bottom(let value): return value
        }
    }
}

public enum EDTSToastDismissEdge {
    case trailing
    case top
    case bottom
}

// MARK: - Passthrough Window
private final class EDTSToastWindow: UIWindow {
    var toastHeight: CGFloat = 0
    var toastOffset: CGFloat = 0
    var toastHorizontalPadding: CGFloat = 0
    var isTop: Bool = false

    private var interactiveRect: CGRect {
        guard toastHeight > 0 else { return .zero }
        let y = isTop
            ? safeAreaInsets.top + toastOffset
            : bounds.height - safeAreaInsets.bottom - toastOffset - toastHeight
        return CGRect(
            x: toastHorizontalPadding,
            y: y,
            width: bounds.width - toastHorizontalPadding * 2,
            height: toastHeight
        ).insetBy(dx: -8, dy: -8)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard interactiveRect.contains(point) else { return nil }
        return super.hitTest(point, with: event)
    }
}

@MainActor
public class EDTSToastManager: ObservableObject {
    // MARK: - Singleton
    static let shared = EDTSToastManager()
    
    // MARK: - Private Variable
    let fadeInDuration: Double = 0.15
    let fadeOutDuration: Double = 0.075
    let slideDuration: Double = 0.25
    
    private init() {}

    // MARK: - Internal state
    struct ToastItem {
        let id = UUID()
        var toast: EDTSToast
        var horizontalPadding: Double
        var offsetY: EDTSToastOffsetDirection
        var animation: EDTSToastAnimation
        var swipeDirection: EDTSToastSwipeDirection
    }

    @Published var toastItem: ToastItem?
    @Published var isVisible: Bool = false
    @Published var isDismissing: Bool = false

    private var dismissWorkItem: DispatchWorkItem?
    private var toastWindow: EDTSToastWindow?
    
    private func showWindow() {
        if toastWindow == nil {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first else { return }

            let window = EDTSToastWindow(windowScene: scene)
            window.windowLevel = .alert + 1
            window.backgroundColor = .clear

            let host = UIHostingController(rootView: EDTSToastHostView())
            host.view.backgroundColor = .clear
            window.rootViewController = host

            toastWindow = window
        }
        toastWindow?.isHidden = false
    }

    private func hideWindow() {
        toastWindow?.toastHeight = 0
        toastWindow?.isHidden = true
    }

    private func updateToastLayout(for item: ToastItem) {
        guard let window = toastWindow else { return }

        let availableWidth = window.bounds.width - item.horizontalPadding * 2
        let size = UIHostingController(rootView: item.toast)
            .sizeThatFits(in: CGSize(width: availableWidth, height: .greatestFiniteMagnitude))

        window.toastHeight = size.height
        window.toastOffset = item.offsetY.value
        window.toastHorizontalPadding = item.horizontalPadding
        if case .top = item.offsetY {
            window.isTop = true
        } else {
            window.isTop = false
        }
    }

    public static func show(
        _ toast: EDTSToast,
        duration: EDTSToastDuration = .long,
        horizontalPadding: Double = 16.0,
        offsetY: EDTSToastOffsetDirection = .bottom(60.0),
        animation: EDTSToastAnimation = .fade,
        swipeDirection: EDTSToastSwipeDirection = .horizontal
    ) {
        shared.present(toast, duration: duration, horizontalPadding: horizontalPadding,
                       offsetY: offsetY, animation: animation, swipeDirection: swipeDirection)
    }
    
    public static func dismiss(animated: Bool = true) {
        shared.remove(animated: animated)
    }

    
    // MARK: - present
    private func present(
        _ toast: EDTSToast,
        duration: EDTSToastDuration = .long,
        horizontalPadding: Double = 16.0,
        offsetY: EDTSToastOffsetDirection = .bottom(60.0),
        animation: EDTSToastAnimation = .fade,
        swipeDirection: EDTSToastSwipeDirection = .horizontal
    ) {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil

        isDismissing = false
        isVisible = false

        let item = ToastItem(
            toast: toast,
            horizontalPadding: horizontalPadding,
            offsetY: offsetY,
            animation: animation,
            swipeDirection: swipeDirection
        )
        toastItem = item
        showWindow()
        updateToastLayout(for: item)

        let id = item.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self, self.toastItem?.id == id else { return }
            self.isVisible = true
        }

        if let interval = duration.timeInterval {
            let work = DispatchWorkItem { [weak self] in
                self?.remove(animated: true)
            }
            dismissWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
        }
    }

    // MARK: - remove
    private func remove(animated: Bool = true) {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil

        guard let item = toastItem else { return }

        if animated {
            isDismissing = true
            isVisible = false

            let id = item.id
            DispatchQueue.main.asyncAfter(deadline: .now() + outDuration(for: item.animation)) { [weak self] in
                guard let self, self.toastItem?.id == id, self.isVisible == false else { return }
                self.toastItem = nil
                self.isDismissing = false
                self.hideWindow()
            }
        } else {
            isVisible = false
            isDismissing = false
            toastItem = nil
            hideWindow()
        }
    }

    private func outDuration(for animation: EDTSToastAnimation) -> TimeInterval {
        switch animation {
        case .fade:  return fadeOutDuration
        case .slide: return slideDuration
        }
    }
}

// MARK: - Size Preference
private struct EDTSToastSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Host Modifier
private struct EDTSToastHostModifier: ViewModifier {
    @ObservedObject private var manager = EDTSToastManager.shared
    @State private var dragTranslation: CGSize = .zero
    @State private var screenSize: CGSize = .zero
    
    // MARK: - Private Variable
    private let hiddenScale: Double = 0.8
    private let scaleCurveX1: Double = 0.0
    private let scaleCurveY1: Double = 0.0
    private let scaleCurveX2: Double = 0.2
    private let scaleCurveY2: Double = 1.0
    private let toastZIndex: Double = 999

    private let swipeThresholdWidthRatio: Double = 0.4
    private let swipeThresholdHeight: Double = 50
    private let swipeMomentumThreshold: Double = 80
    private let swipeDismissDuration: Double = 0.25
    private let swipeCancelSpringResponse: Double = 0.3
    private let swipeCancelSpringDamping: Double = 0.7

    private let fallbackScreenWidth: CGFloat = 400
    private let fallbackScreenHeight: CGFloat = 800

    private var screenWidth: CGFloat {
        screenSize.width > 0 ? screenSize.width : fallbackScreenWidth
    }

    private var screenHeight: CGFloat {
        screenSize.height > 0 ? screenSize.height : fallbackScreenHeight
    }
    
    private var overlayAlignment: Alignment {
        guard let offsetY = manager.toastItem?.offsetY else { return .bottom }
        switch offsetY {
        case .top:    return .top
        case .bottom: return .bottom
        }
    }


    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: EDTSToastSizeKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(EDTSToastSizeKey.self) { screenSize = $0 }
            .overlay(alignment: overlayAlignment) {
                if let item = manager.toastItem {
                    item.toast
                        .padding(.horizontal, item.horizontalPadding)
                        .padding(edgeInset(item), item.offsetY.value)
                        .scaleEffect(scale(for: item))
                        .animation(.timingCurve(scaleCurveX1, scaleCurveY1, scaleCurveX2, scaleCurveY2, duration: manager.fadeInDuration), value: manager.isVisible)
                        .opacity(opacity(for: item))
                        .animation(.linear(duration: manager.isVisible ? manager.fadeInDuration : manager.fadeOutDuration), value: manager.isVisible)
                        .offset(x: dragTranslation.width,
                                y: dragTranslation.height + slideOffset(for: item))
                        .animation(.easeInOut(duration: manager.slideDuration), value: manager.isVisible)
                        .gesture(dragGesture(for: item))
                        .id(item.id)
                        .zIndex(toastZIndex)
                        .onChange(of: item.id) { _ in dragTranslation = .zero }
                }
            }
    }

    private func scale(for item: EDTSToastManager.ToastItem) -> Double {
        guard item.animation == .fade else { return 1 }
        return (manager.isVisible || manager.isDismissing) ? 1 : hiddenScale
    }

    private func opacity(for item: EDTSToastManager.ToastItem) -> Double {
        guard item.animation == .fade else { return 1 }
        return manager.isVisible ? 1 : 0
    }

    private func slideOffset(for item: EDTSToastManager.ToastItem) -> Double {
        guard item.animation == .slide, !manager.isVisible else { return 0 }
        switch item.offsetY {
        case .top:    return -screenHeight
        case .bottom: return screenHeight
        }
    }

    private func edgeInset(_ item: EDTSToastManager.ToastItem) -> Edge.Set {
        switch item.offsetY {
        case .top:    return .top
        case .bottom: return .bottom
        }
    }

    // MARK: - Swipe to dismiss (mirrors UIKit's handlePan)
    private func dragGesture(for item: EDTSToastManager.ToastItem) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let allowed = item.swipeDirection.allowedDirections
                var translation = value.translation
                if !allowed.x { translation.width = 0 }
                if !allowed.y { translation.height = 0 }

                switch item.swipeDirection.dismissEdge(offsetY: item.offsetY) {
                case .trailing:
                    translation.width = max(0, translation.width)
                    translation.height = 0
                case .bottom:
                    translation.height = max(0, translation.height)
                    translation.width = 0
                case .top:
                    translation.height = min(0, translation.height)
                    translation.width = 0
                }

                dragTranslation = translation
            }
            .onEnded { value in
                let edge = item.swipeDirection.dismissEdge(offsetY: item.offsetY)

                let axialDistance: Double
                let momentum: Double
                let threshold: Double

                switch edge {
                case .trailing:
                    axialDistance = dragTranslation.width
                    momentum = value.predictedEndTranslation.width - value.translation.width
                    threshold = screenWidth * swipeThresholdWidthRatio
                case .bottom:
                    axialDistance = dragTranslation.height
                    momentum = value.predictedEndTranslation.height - value.translation.height
                    threshold = swipeThresholdHeight
                case .top:
                    axialDistance = -dragTranslation.height
                    momentum = -(value.predictedEndTranslation.height - value.translation.height)
                    threshold = swipeThresholdHeight
                }

                let isFastSwipe = momentum > swipeMomentumThreshold
                let isFarEnough = axialDistance > threshold

                if isFastSwipe || isFarEnough {
                    withAnimation(.easeInOut(duration: swipeDismissDuration)) {
                        dragTranslation = offscreenTranslation(for: edge)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + swipeDismissDuration) {
                        EDTSToastManager.dismiss(animated: false)
                        dragTranslation = .zero
                    }
                } else {
                    withAnimation(.spring(response: swipeCancelSpringResponse, dampingFraction: swipeCancelSpringDamping)) {
                        dragTranslation = .zero
                    }
                }
            }
    }

    private func offscreenTranslation(for edge: EDTSToastDismissEdge) -> CGSize {
        switch edge {
        case .trailing: return CGSize(width: screenWidth, height: 0)
        case .bottom:   return CGSize(width: 0, height: screenHeight)
        case .top:      return CGSize(width: 0, height: -screenHeight)
        }
    }
}

// MARK: - Host View
private struct EDTSToastHostView: View {
    var body: some View {
        Color.clear
            .allowsHitTesting(false)
            .modifier(EDTSToastHostModifier())
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        @State private var showSheet = false
        @State private var showFullScreen = false

        var body: some View {
            VStack(spacing: 16) {
                ToastButtons()

                Divider()

                Button("Open sheet") { showSheet = true }
                Button("Open full screen sheet") { showFullScreen = true }
            }
            .padding()
            .sheet(isPresented: $showSheet) {
                if #available(iOS 16.0, *) {
                    SheetContent(title: "Sheet") { showSheet = false }
                        .presentationDetents([.medium, .large])
                } else {
                    SheetContent(title: "Sheet") { showSheet = false }
                }
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                SheetContent(title: "Full screen sheet") { showFullScreen = false }
            }
        }
    }

    struct ToastButtons: View {
        var body: some View {
            VStack(spacing: 16) {
                Button("Show info toast") {
                    EDTSToastManager.show(
                        EDTSToast(
                            toastState: .info,
                            text: "Saved successfully",
                            icon: Image(systemName: "checkmark.circle.fill")
                        )
                    )
                }

                Button("Show danger toast (slide, with action)") {
                    EDTSToastManager.show(
                        EDTSToast(
                            toastState: .danger,
                            text: "Failed to upload file",
                            icon: Image(systemName: "exclamationmark.triangle.fill"),
                            button: EDTSButton(
                                btnType: .primary,
                                btnSize: .small,
                                btnState: .default,
                                text: "Retry",
                                textColor: EDTSColor.white,
                                fontSize: 12,
                                fontWeight: "semibold",
                                bgColor: .clear,
                                rippleColor: .clear,
                                paddingTop: 0,
                                paddingBottom: 0,
                                paddingLeading: 0,
                                paddingTrailing: 0
                            ) {
                                print("Retry tapped")
                            }
                        ),
                        animation: .slide
                    )
                }

                Button("Show toast at top (long)") {
                    EDTSToastManager.show(
                        EDTSToast(
                            toastState: .info,
                            text: "Toast shown from the top",
                            icon: Image(systemName: "info.circle.fill")
                        ),
                        duration: .long,
                        offsetY: .top(60),
                        swipeDirection: .vertical
                    )
                }
            }
        }
    }

    struct SheetContent: View {
        let title: String
        let onClose: () -> Void

        var body: some View {
            VStack(spacing: 16) {
                Text(title)
                    .font(.headline)

                ToastButtons()

                Button("Close", action: onClose)
                    .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }

    return PreviewWrapper()
}
