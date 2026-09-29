//
//  EDTSToastManager.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 18/09/26.
//

import SwiftUI
import Combine
import UIKit

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

@MainActor
public class EDTSToastManager: ObservableObject {
    // MARK: - Singleton
    public static let toast = EDTSToastManager()
    
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

    // MARK: - Show
    public func show(
        _ toast: EDTSToast,
        duration: EDTSToastDuration = .long,
        horizontalPadding: Double = 16.0,
        offsetY: EDTSToastOffsetDirection = .bottom(60.0),
        animation: EDTSToastAnimation = .fade,
        swipeDirection: EDTSToastSwipeDirection = .horizontal
    ) {
        dismiss(animated: false)

        isDismissing = false
        isVisible = false
        toastItem = ToastItem(
            toast: toast,
            horizontalPadding: horizontalPadding,
            offsetY: offsetY,
            animation: animation,
            swipeDirection: swipeDirection
        )

        if let interval = duration.timeInterval {
            let work = DispatchWorkItem { [weak self] in
                self?.dismiss(animated: true)
            }
            dismissWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
        }
    }

    // MARK: - Dismiss
    public func dismiss(animated: Bool = true) {
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
            }
        } else {
            isVisible = false
            isDismissing = false
            toastItem = nil
        }
    }

    private func outDuration(for animation: EDTSToastAnimation) -> TimeInterval {
        switch animation {
        case .fade:  return fadeOutDuration
        case .slide: return slideDuration
        }
    }
}

// MARK: - Host Modifier
private struct EDTSToastHostModifier: ViewModifier {
    @ObservedObject private var manager = EDTSToastManager.toast
    @State private var dragTranslation: CGSize = .zero
    
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

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        .onAppear { manager.isVisible = true }
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

    private var overlayAlignment: Alignment {
        guard let offsetY = manager.toastItem?.offsetY else { return .bottom }
        switch offsetY {
        case .top:    return .top
        case .bottom: return .bottom
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
                        EDTSToastManager.toast.dismiss(animated: false)
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

    private var screenWidth: CGFloat {
        #if canImport(UIKit)
        return (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.width) ?? fallbackScreenWidth
        #else
        return fallbackScreenWidth
        #endif
    }

    private var screenHeight: CGFloat {
        #if canImport(UIKit)
        return (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.height) ?? fallbackScreenHeight
        #else
        return fallbackScreenHeight
        #endif
    }
}

public extension View {
    func edtsToastHost() -> some View {
        modifier(EDTSToastHostModifier())
    }
}

// MARK: - Preview
#Preview("Preview") {
    struct PreviewWrapper: View {
        var body: some View {
            VStack(spacing: 16) {
                Button("Show info toast") {
                    EDTSToastManager.toast.show(
                        EDTSToast(
                            toastState: .info,
                            text: "Saved successfully",
                            icon: Image(systemName: "checkmark.circle.fill")
                        )
                    )
                }

                Button("Show danger toast (slide, with action)") {
                    EDTSToastManager.toast.show(
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
            }
            .padding()
            .edtsToastHost()
        }
    }
    return PreviewWrapper()
}
