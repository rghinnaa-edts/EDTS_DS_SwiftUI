//
//  EDTSTray.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 04/11/26.
//

import SwiftUI

// MARK: - Public API
public enum TrayHeightMode {
    case fullScreen
    case wrapContent
    case custom(CGFloat)
}

public struct EDTSTrayConfiguration {
    public var dragHandleColor: Color = EDTSColor.grey30
    public var sheetBgColor: Color = EDTSColor.white
    public var cornerRadius: CGFloat = 16
    public var overlayColor: Color = EDTSColor.black.opacity(0.75)

    public var shadowColor: Color = EDTSColor.black
    public var shadowOpacity: Float = 0.2
    public var shadowRadius: CGFloat = 12
    public var shadowOffset: CGSize = CGSize(width: 0, height: -2)

    public var isHasDragHandle: Bool = true
    public var isHasOverlay: Bool = true

    public var canDismiss: () -> Bool = { true }
    public var onDismissAttempt: (() -> Void)?

    public init() {}
}

// MARK: - Extension
public extension View {
    func edtsTray<Content: View>(
        isPresented: Binding<Bool>,
        heightMode: TrayHeightMode = .wrapContent,
        configuration: EDTSTrayConfiguration = EDTSTrayConfiguration(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(
            EDTSTrayPresenter(isPresented: isPresented,
                              heightMode: heightMode,
                              configuration: configuration,
                              onDismiss: onDismiss,
                              content: content)
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)
        )
    }
}

// MARK: - Presenter
private struct EDTSTrayPresenter<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let heightMode: TrayHeightMode
    let configuration: EDTSTrayConfiguration
    let onDismiss: (() -> Void)?
    let content: () -> Content

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIViewController(context: Context) -> AnchorViewController {
        let vc = AnchorViewController()
        vc.view.isUserInteractionEnabled = false
        vc.onDidAppear = { [weak coordinator = context.coordinator] in coordinator?.sync() }
        return vc
    }

    func updateUIViewController(_ uiViewController: AnchorViewController, context: Context) {
        context.coordinator.parent = self
        context.coordinator.anchor = uiViewController
        context.coordinator.sync()
    }

    final class AnchorViewController: UIViewController {
        var onDidAppear: (() -> Void)?
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear?()
        }
    }

    final class Coordinator {
        var parent: EDTSTrayPresenter<Content>?
        weak var anchor: UIViewController?
        private var hosting: EDTSTrayHostingController<TrayRootView<Content>>?

        func sync() {
            DispatchQueue.main.async { [weak self] in
                guard let self, let parent = self.parent else { return }
                if parent.isPresented {
                    self.present()
                } else {
                    self.dismissIfNeeded()
                }
            }
        }

        private func makeRoot() -> TrayRootView<Content>? {
            guard let parent else { return nil }
            let isWrap: Bool
            if case .wrapContent = parent.heightMode { isWrap = true } else { isWrap = false }
            return TrayRootView(content: parent.content(),
                                isWrapContent: isWrap,
                                onContentHeight: { [weak self] height in
                (self?.hosting?.presentationController as? EDTSTrayPresentationController)?
                    .updateContentHeight(height)
            })
        }

        private func present() {
            guard let parent, let root = makeRoot() else { return }

            if let hosting, hosting.presentingViewController != nil || hosting.isBeingPresented {
                hosting.rootView = root
                return
            }

            guard let rootVC = anchor?.view.window?.rootViewController else { return }
            let top = rootVC.edtsTopMost
            if top.isBeingPresented || top.isBeingDismissed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in self?.sync() }
                return
            }

            let host = EDTSTrayHostingController(rootView: root)
            host.view.backgroundColor = .clear

            let delegate = EDTSTrayTransitioningDelegate(heightMode: parent.heightMode,
                                                         configuration: parent.configuration)
            host.trayDelegate = delegate 
            host.modalPresentationStyle = .custom
            host.transitioningDelegate = delegate
            host.onDidDismiss = { [weak self] in self?.handleDidDismiss() }

            hosting = host
            top.present(host, animated: true)
        }

        private func dismissIfNeeded() {
            guard let hosting, hosting.presentingViewController != nil, !hosting.isBeingDismissed else { return }
            hosting.dismiss(animated: true)
        }

        private func handleDidDismiss() {
            hosting = nil
            if parent?.isPresented == true { parent?.isPresented = false }
            parent?.onDismiss?()
        }
    }
}

// MARK: - Hosting controller
private protocol EDTSTraySizing: AnyObject {
    func fittingHeight(forWidth width: CGFloat) -> CGFloat
}

private final class EDTSTrayHostingController<Content: View>: UIHostingController<Content>, EDTSTraySizing {
    var onDidDismiss: (() -> Void)?
    var trayDelegate: AnyObject?
    private var didNotify = false

    func fittingHeight(forWidth width: CGFloat) -> CGFloat {
        sizeThatFits(in: CGSize(width: width, height: 10_000)).height
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard !didNotify, isBeingDismissed || presentingViewController == nil else { return }
        didNotify = true
        onDidDismiss?()
    }
}

// MARK: - Root view
private struct TrayHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}

private struct TrayRootView<Content: View>: View {
    let content: Content
    let isWrapContent: Bool
    let onContentHeight: (CGFloat) -> Void

    var body: some View {
        if isWrapContent {
            content
                .fixedSize(horizontal: false, vertical: true)
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: TrayHeightKey.self, value: proxy.size.height)
                    }
                )
                .frame(maxWidth: .infinity, alignment: .top)
                .onPreferenceChange(TrayHeightKey.self) { onContentHeight($0) }
        } else {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

// MARK: - Transitioning delegate
private final class EDTSTrayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let heightMode: TrayHeightMode
    private let configuration: EDTSTrayConfiguration

    init(heightMode: TrayHeightMode, configuration: EDTSTrayConfiguration) {
        self.heightMode = heightMode
        self.configuration = configuration
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let tray = EDTSTrayPresentationController(presentedViewController: presented, presenting: presenting)
        tray.heightMode = heightMode
        tray.apply(configuration)
        return tray
    }
}

// MARK: - Presentation controller
private final class EDTSTrayPresentationController: UIPresentationController, UIGestureRecognizerDelegate {

    var heightMode: TrayHeightMode = .wrapContent

    private var dragHandleColor: UIColor = UIColor(EDTSColor.grey30)
    private var sheetBgColor: UIColor = .white
    private var cornerRadius: CGFloat = 16
    private var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.75)
    private var shadowColor: UIColor = .black
    private var shadowOpacity: Float = 0.2
    private var shadowRadius: CGFloat = 12
    private var shadowOffset: CGSize = CGSize(width: 0, height: -2)
    private var isHasDragHandle = true
    private var isHasOverlay = true
    private var canDismiss: () -> Bool = { true }
    private var onDismissAttempt: (() -> Void)?

    private static let dragAreaHeight: CGFloat = 56
    private var contentHeight: CGFloat = 0

    private let dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()

    private let grabberView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 8, width: 36, height: 4))
        view.layer.cornerRadius = 2
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return view
    }()

    private var isOverlayVisible: Bool { isHasOverlay && overlayColor.cgColor.alpha > 0 }
    private var shouldShowShadow: Bool { !isOverlayVisible }

    func apply(_ c: EDTSTrayConfiguration) {
        dragHandleColor = UIColor(c.dragHandleColor)
        sheetBgColor = UIColor(c.sheetBgColor)
        cornerRadius = c.cornerRadius
        overlayColor = UIColor(c.overlayColor)
        shadowColor = UIColor(c.shadowColor)
        shadowOpacity = c.shadowOpacity
        shadowRadius = c.shadowRadius
        shadowOffset = c.shadowOffset
        isHasDragHandle = c.isHasDragHandle
        isHasOverlay = c.isHasOverlay
        canDismiss = c.canDismiss
        onDismissAttempt = c.onDismissAttempt
    }

    func updateContentHeight(_ height: CGFloat) {
        guard case .wrapContent = heightMode,
              abs(height - contentHeight) > 0.5,
              let container = containerView else { return }
        contentHeight = height
        guard presentedView?.transform == .identity else { return }
        container.setNeedsLayout()
        UIView.animate(withDuration: 0.25) { container.layoutIfNeeded() }
    }

    // MARK: Frame
    private func topInset(in container: UIView) -> CGFloat {
        let statusBar = container.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return max(container.safeAreaInsets.top, statusBar)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }

        let maxAllowed = container.bounds.height - topInset(in: container)
        let bottomInset = container.safeAreaInsets.bottom
        let height: CGFloat

        switch heightMode {
        case .fullScreen:
            height = maxAllowed
        case .custom(let value):
            height = min(value, maxAllowed)
        case .wrapContent:
            var content = contentHeight
            if content <= 0, let sizing = presentedViewController as? EDTSTraySizing {
                content = sizing.fittingHeight(forWidth: container.bounds.width)
            }
            if content <= 0 { content = presentedViewController.preferredContentSize.height }
            height = min(content + bottomInset, maxAllowed)
        }

        return CGRect(x: 0,
                      y: container.bounds.height - height,
                      width: container.bounds.width,
                      height: height)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        dimmingView.frame = containerView?.bounds ?? .zero
        if let presented = presentedView, presented.transform == .identity {
            let frame = frameOfPresentedViewInContainerView
            presented.frame = frame
            shadowView.frame = frame
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds,
                                                       cornerRadius: cornerRadius).cgPath
            grabberView.center.x = presented.bounds.midX
        }
    }

    // MARK: Transition
    override func presentationTransitionWillBegin() {
        guard let container = containerView, let presented = presentedView else { return }

        dimmingView.frame = container.bounds
        dimmingView.backgroundColor = isHasOverlay ? overlayColor : .clear
        container.insertSubview(dimmingView, at: 0)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingTapped)))

        if shouldShowShadow {
            shadowView.frame = frameOfPresentedViewInContainerView
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOpacity = shadowOpacity
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds,
                                                       cornerRadius: cornerRadius).cgPath
            container.insertSubview(shadowView, aboveSubview: dimmingView)
        }

        presented.backgroundColor = sheetBgColor
        presented.layer.cornerRadius = cornerRadius
        presented.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presented.layer.masksToBounds = true

        if isHasDragHandle {
            grabberView.backgroundColor = dragHandleColor
            grabberView.center.x = presented.bounds.midX
            presented.addSubview(grabberView)
        }

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        presented.addGestureRecognizer(pan)

        shadowView.transform = CGAffineTransform(translationX: 0, y: frameOfPresentedViewInContainerView.height)
        shadowView.alpha = 1

        let show = {
            self.dimmingView.alpha = 1
            self.shadowView.transform = .identity
        }
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in show() })
        } else {
            show()
        }
    }

    override func dismissalTransitionWillBegin() {
        let hide = {
            self.dimmingView.alpha = 0
            self.shadowView.transform = CGAffineTransform(translationX: 0, y: self.shadowView.bounds.height)
        }
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in hide() })
        } else {
            hide()
        }
    }

    // MARK: Dismiss gestures
    private func dismissOffscreen() {
        guard let presented = presentedView else { return }

        dimmingView.isUserInteractionEnabled = false
        let offscreen = CGAffineTransform(translationX: 0, y: presented.bounds.height)

        UIView.animate(withDuration: 0.2, animations: {
            presented.transform = offscreen
            self.shadowView.transform = offscreen
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.presentedViewController.dismiss(animated: false) {
                presented.transform = .identity
                self.shadowView.transform = .identity
            }
        })
    }

    @objc private func dimmingTapped() {
        guard canDismiss() else {
            onDismissAttempt?()
            return
        }
        dismissOffscreen()
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let presented = presentedView, let container = containerView else { return }

        let translation = max(gesture.translation(in: container).y, 0)

        switch gesture.state {
        case .changed:
            let t = CGAffineTransform(translationX: 0, y: translation)
            presented.transform = t
            shadowView.transform = t

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: container).y
            let shouldDismiss = translation > presented.bounds.height * 0.3 || velocity > 900

            let reset = {
                UIView.animate(withDuration: 0.25) {
                    presented.transform = .identity
                    self.shadowView.transform = .identity
                }
            }

            guard shouldDismiss else {
                reset()
                return
            }

            guard canDismiss() else {
                reset()
                onDismissAttempt?()
                return
            }

            dismissOffscreen()

        default:
            break
        }
    }

    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let presented = presentedView else { return false }
        return touch.location(in: presented).y <= Self.dragAreaHeight
    }
}

//  EDTSTrayPreviewExample.swift
import Combine

// MARK: - Variants
private enum TrayDemoVariant: String {
    case standard = "Default"
    case customized = "Full custom"
    case noOverlay = "No overlay"
}

// MARK: - Demo model
private final class TrayDemoModel: ObservableObject {
    @Published var allowDismiss = false
    @Published var blockedAttempts = 0

    func reset() {
        allowDismiss = false
        blockedAttempts = 0
    }
}

// MARK: - Screen
public struct EDTSTrayDemoScreen: View {
    public init() {}

    public var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        section("Wrap content", mode: .wrapContent)
                        section("Custom height (650)", mode: .custom(650))
                        section("Full screen (below status bar)", mode: .fullScreen)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .navigationTitle("EDTSTray")
            }
            .navigationViewStyle(.stack)
            .tabItem { Label("Home", systemImage: "house") }

            Text("Second tab")
                .tabItem { Label("Other", systemImage: "square.grid.2x2") }
        }
    }

    private func section(_ title: String, mode: TrayHeightMode) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            HStack(spacing: 10) {
                TrayDemoButton(variant: .standard, heightMode: mode)
                TrayDemoButton(variant: .customized, heightMode: mode)
                TrayDemoButton(variant: .noOverlay, heightMode: mode)
            }
        }
    }
}

// MARK: - Button + tray
private struct TrayDemoButton: View {
    let variant: TrayDemoVariant
    let heightMode: TrayHeightMode

    @State private var isPresented = false
    @StateObject private var model = TrayDemoModel()

    var body: some View {
        Button {
            model.reset()
            isPresented = true
        } label: {
            Text(variant.rawValue)
                .font(.footnote.weight(.semibold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .edtsTray(isPresented: $isPresented,
                  heightMode: heightMode,
                  configuration: configuration,
                  onDismiss: { print("Tray dismissed: \(variant.rawValue)") }) {
            TrayDemoContent(variant: variant,
                            heightMode: heightMode,
                            model: model,
                            close: { isPresented = false })
        }
    }

    private var configuration: EDTSTrayConfiguration {
        var config = EDTSTrayConfiguration()

        switch variant {
        case .standard:
            break

        case .customized:
            config.dragHandleColor = Color.white.opacity(0.6)
            config.sheetBgColor = Color(red: 0.10, green: 0.12, blue: 0.30)
            config.cornerRadius = 32
            config.overlayColor = Color.indigo.opacity(0.45)
            config.isHasDragHandle = true
            config.isHasOverlay = true
            config.shadowColor = .black
            config.shadowOpacity = 0.3
            config.shadowRadius = 20
            config.shadowOffset = CGSize(width: 0, height: -4)
            config.canDismiss = { [model] in model.allowDismiss }
            config.onDismissAttempt = { [model] in model.blockedAttempts += 1 }

        case .noOverlay:
            config.isHasOverlay = false
            config.shadowOpacity = 0.3
            config.shadowRadius = 16
        }

        return config
    }
}

// MARK: - Tray content
private struct TrayDemoContent: View {
    let variant: TrayDemoVariant
    let heightMode: TrayHeightMode
    @ObservedObject var model: TrayDemoModel
    let close: () -> Void

    @State private var rows = 2

    private var isDark: Bool { variant == .customized }
    private var primary: Color { isDark ? .white : .primary }
    private var secondary: Color { isDark ? Color.white.opacity(0.7) : .secondary }

    var body: some View {
        switch heightMode {
        case .wrapContent:
            content
        default:
            ScrollView { content }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(variant.rawValue) tray")
                .font(.title3.weight(.bold))
                .foregroundColor(primary)

            Text(description)
                .font(.subheadline)
                .foregroundColor(secondary)

            ForEach(0..<rows, id: \.self) { index in
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.accentColor.opacity(0.9))
                        .frame(width: 32, height: 32)
                        .overlay(Text("\(index + 1)").font(.caption.bold()).foregroundColor(.white))
                    Text("Row \(index + 1)")
                        .foregroundColor(primary)
                    Spacer()
                }
            }

            HStack(spacing: 10) {
                Button("Add row") { withAnimation { rows += 1 } }
                    .buttonStyle(.bordered)
                Button("Remove row") { withAnimation { rows = max(0, rows - 1) } }
                    .buttonStyle(.bordered)
            }

            if variant == .customized {
                Toggle("Allow dismiss", isOn: $model.allowDismiss)
                    .foregroundColor(primary)

                Text("Blocked dismiss attempts: \(model.blockedAttempts)")
                    .font(.footnote.monospacedDigit())
                    .foregroundColor(model.blockedAttempts > 0 ? .orange : secondary)
            }

            Button(action: close) {
                Text("Close")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 16)
    }

    private var description: String {
        switch variant {
        case .standard:
            return "Default configuration. Swipe down from the top area, or tap the dimmed overlay, to dismiss."
        case .customized:
            return "Custom colors, 32pt corners, tinted overlay. Swipe or tap outside is blocked until \"Allow dismiss\" is on; each blocked attempt is counted."
        case .noOverlay:
            return "No overlay, so a shadow is drawn behind the tray instead. Taps outside still dismiss."
        }
    }
}

// MARK: - Preview
struct EDTSTrayDemoScreen_Previews: PreviewProvider {
    static var previews: some View {
        EDTSTrayDemoScreen()
    }
}
