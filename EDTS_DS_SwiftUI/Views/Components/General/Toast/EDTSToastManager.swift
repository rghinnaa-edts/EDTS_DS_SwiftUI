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
    case top(CGFloat)
    case bottom(CGFloat)

    var value: CGFloat {
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

public class EDTSToastManager: ObservableObject {
    // MARK: - Singleton
    public static let toast = EDTSToastManager()
    private init() {}

    // MARK: - Internal state
    struct ToastItem {
        var toast: EDTSToast
        var horizontalPadding: CGFloat
        var offsetY: EDTSToastOffsetDirection
        var animation: EDTSToastAnimation
        var swipeDirection: EDTSToastSwipeDirection
    }

    @Published var toastItem: ToastItem?
    @Published var isVisible: Bool = false

    private var dismissWorkItem: DispatchWorkItem?

    // MARK: - Show
    public func show(
        _ toast: EDTSToast,
        duration: EDTSToastDuration = .long,
        horizontalPadding: CGFloat = 16.0,
        offsetY: EDTSToastOffsetDirection = .bottom(60.0),
        animation: EDTSToastAnimation = .fade,
        swipeDirection: EDTSToastSwipeDirection = .horizontal
    ) {
        dismiss(animated: false)

        let item = ToastItem(
            toast: toast,
            horizontalPadding: horizontalPadding,
            offsetY: offsetY,
            animation: animation,
            swipeDirection: swipeDirection
        )

        toastItem = item
        withAnimation(animationCurve(for: animation)) {
            isVisible = true
        }

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

        guard toastItem != nil else { return }
        let animation = toastItem?.animation ?? .fade

        if animated {
            withAnimation(animationCurve(for: animation)) {
                isVisible = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration(for: animation)) { [weak self] in
                guard let self, self.isVisible == false else { return }
                self.toastItem = nil
            }
        } else {
            isVisible = false
            toastItem = nil
        }
    }

    private func animationCurve(for animation: EDTSToastAnimation) -> Animation {
        switch animation {
        case .fade:  return .easeInOut(duration: 0.15)
        case .slide: return .easeInOut(duration: 0.25)
        }
    }

    private func animationDuration(for animation: EDTSToastAnimation) -> TimeInterval {
        switch animation {
        case .fade:  return 0.15
        case .slide: return 0.25
        }
    }
}

// MARK: - Host Modifier
private struct EDTSToastHostModifier: ViewModifier {
    @ObservedObject private var manager = EDTSToastManager.toast
    @State private var dragTranslation: CGSize = .zero

    func body(content: Content) -> some View {
        content.overlay(alignment: overlayAlignment) {
            if manager.isVisible, let item = manager.toastItem {
                item.toast
                    .padding(.horizontal, item.horizontalPadding)
                    .padding(edgeInset(item), item.offsetY.value)
                    .offset(dragTranslation)
                    .transition(transition(for: item))
                    .gesture(dragGesture(for: item))
                    .zIndex(999)
            }
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

    private func transition(for item: EDTSToastManager.ToastItem) -> AnyTransition {
        switch item.animation {
        case .fade:
            return .opacity.combined(with: .scale(scale: 0.8))
        case .slide:
            switch item.offsetY {
            case .top:    return .move(edge: .top)
            case .bottom: return .move(edge: .bottom)
            }
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

                let axialDistance: CGFloat
                let momentum: CGFloat
                let threshold: CGFloat

                switch edge {
                case .trailing:
                    axialDistance = dragTranslation.width
                    momentum = value.predictedEndTranslation.width - value.translation.width
                    threshold = screenWidth * 0.4
                case .bottom:
                    axialDistance = dragTranslation.height
                    momentum = value.predictedEndTranslation.height - value.translation.height
                    threshold = 50
                case .top:
                    axialDistance = -dragTranslation.height
                    momentum = -(value.predictedEndTranslation.height - value.translation.height)
                    threshold = 50
                }

                let isFastSwipe = momentum > 80
                let isFarEnough = axialDistance > threshold

                if isFastSwipe || isFarEnough {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        dragTranslation = offscreenTranslation(for: edge)
                    }
                    EDTSToastManager.toast.dismiss(animated: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        dragTranslation = .zero
                    }
                } else {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
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
        return UIScreen.main.bounds.width
        #else
        return 400
        #endif
    }

    private var screenHeight: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.height
        #else
        return 800
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
                            iconLeading: Image(systemName: "checkmark.circle.fill")
                        )
                    )
                }

                Button("Show danger toast (slide, with action)") {
                    EDTSToastManager.toast.show(
                        EDTSToast(
                            toastState: .danger,
                            text: "Failed to upload file",
                            iconLeading: Image(systemName: "exclamationmark.triangle.fill"),
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
