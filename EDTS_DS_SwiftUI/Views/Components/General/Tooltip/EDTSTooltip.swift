//
//  EDTSTooltip.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 18/06/26.
//

import UIKit

// MARK: - Direction

public enum EDTSTooltipDirection {
    case top
    case bottom
    case leading
    case trailing
}

@IBDesignable
public class EDTSTooltip: UIView {

    // MARK: - Public Properties

    @IBInspectable public var label: String? {
        didSet {
            lblText.attributedText = nil
            lblText.text = label
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var labelAttributed: NSAttributedString? {
        didSet {
            lblText.text = nil
            lblText.attributedText = labelAttributed
            setNeedsLayout()
        }
    }

    @IBInspectable public var labelColor: UIColor = .white {
        didSet {
            lblText.textColor = labelColor
        }
    }
    
    @IBInspectable public var fontName: String = "" {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = 12 {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var fontWeight: String? {
        didSet {
            setupLabelFont()
        }
    }

    @IBInspectable public var bgColor: UIColor = .black {
        didSet {
            updateBackgroundColor()
            setNeedsDisplay()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 4 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.18 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 4){
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 5.0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = EDTSColor.grey30 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var spacing: CGFloat = 8

    @IBInspectable public var maxWidth: CGFloat = UIScreen.main.bounds.width - 32

    public var onDismiss: (() -> Void)?

    // MARK: - Private Properties

    private let lblText = UILabel()
    private let backgroundLayer = CAShapeLayer()
    private let arrowSize = CGSize(width: 12, height: 8)
    
    private static var associatedTooltipKey: UInt8 = 0
    
    private weak var targetView: UIView?
    private weak var longPressParentView: UIView?
    private weak var longPressGesture: UILongPressGestureRecognizer?
    
    private var direction: EDTSTooltipDirection = .bottom
    private var autoDismissWorkItem: DispatchWorkItem?
    private var longPressAnimated: Bool = true
    private var longPressAutoDismissAfter: TimeInterval?
    private var dismissOnRelease: Bool = true
    private var dismissOnReleaseDelay: TimeInterval = 0.5
    private var animationGeneration: Int = 0

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Public Functions

    public func attach(
        to target: UIView,
        direction: EDTSTooltipDirection = .top,
        in parentView: UIView? = nil,
        minimumPressDuration: TimeInterval = 0.35,
        animated: Bool = true,
        dismissOnRelease: Bool = true,
        dismissOnReleaseDelay: TimeInterval = 0.5,
        autoDismissAfter: TimeInterval? = nil
    ) {
        target.isUserInteractionEnabled = true
        self.targetView = target
        self.direction = direction
        self.longPressParentView = parentView
        self.longPressAnimated = animated
        self.longPressAutoDismissAfter = autoDismissAfter
        self.dismissOnRelease = dismissOnRelease
        self.dismissOnReleaseDelay = dismissOnReleaseDelay

        objc_setAssociatedObject(target, &EDTSTooltip.associatedTooltipKey, self, .OBJC_ASSOCIATION_RETAIN)

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        gesture.minimumPressDuration = minimumPressDuration
        target.addGestureRecognizer(gesture)
        longPressGesture = gesture
    }

    public func detach(from target: UIView) {
        if let gesture = longPressGesture {
            target.removeGestureRecognizer(gesture)
        }
        objc_setAssociatedObject(target, &EDTSTooltip.associatedTooltipKey, nil, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let target = gesture.view else { return }
        switch gesture.state {
        case .began:
            show(on: target, direction: direction, in: longPressParentView, animated: longPressAnimated, autoDismissAfter: longPressAutoDismissAfter)
        case .ended, .cancelled, .failed:
            guard dismissOnRelease else { return }
            autoDismissWorkItem?.cancel()
            if dismissOnReleaseDelay > 0 {
                let workItem = DispatchWorkItem { [weak self] in self?.dismiss() }
                autoDismissWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + dismissOnReleaseDelay, execute: workItem)
            } else {
                dismiss()
            }
        default:
            break
        }
    }

    public func show(
        on target: UIView,
        direction: EDTSTooltipDirection = .bottom,
        in parentView: UIView? = nil,
        animated: Bool = true,
        autoDismissAfter: TimeInterval? = nil
    ) {
        guard parentView != nil || target.window != nil else {
            DispatchQueue.main.async { [weak target] in
                guard let target = target else { return }
                self.show(on: target, direction: direction, in: parentView, animated: animated, autoDismissAfter: autoDismissAfter)
            }
            return
        }

        guard let container = parentView ?? target.enclosingViewController()?.view ?? target.window else { return }

        autoDismissWorkItem?.cancel()
        animationGeneration += 1
        let currentGeneration = animationGeneration

        layer.removeAllAnimations()
        transform = .identity

        self.targetView = target
        self.direction = direction
        lblText.text = label

        container.layoutIfNeeded()

        let isAlreadyVisible = self.superview === container

        frame = container.bounds
        if !isAlreadyVisible {
            alpha = animated ? 0 : 1
        }
        container.addSubview(self)

        layoutTooltip()

        if animated {
            transform = initialTransform(for: direction)
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
                self.alpha = 1
                self.transform = .identity
            }
        } else {
            alpha = 1
            transform = .identity
        }

        if let duration = autoDismissAfter {
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self, self.animationGeneration == currentGeneration else { return }
                self.dismiss()
            }
            autoDismissWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
        }
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        autoDismissWorkItem?.cancel()
        animationGeneration += 1
        let currentGeneration = animationGeneration

        guard animated else {
            removeFromSuperview()
            onDismiss?()
            completion?()
            return
        }

        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.alpha = 0
            self.transform = self.initialTransform(for: self.direction)
        }, completion: { [weak self] _ in
            guard let self = self, self.animationGeneration == currentGeneration else { return }
            self.removeFromSuperview()
            self.transform = .identity
            self.onDismiss?()
            completion?()
        })
    }
    
    public func updatePosition() {
        layoutTooltip()
    }
    
    // MARK: Private Functions

    private func setupUI() {
        backgroundColor = .clear

        layer.insertSublayer(backgroundLayer, at: 0)
        updateBackgroundColor()
        updateShadow()

        lblText.numberOfLines = 0
        lblText.textColor = labelColor
        lblText.textAlignment = .left
        setupLabelFont()
        
        addSubview(lblText)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setupLabelFont() {
        guard fontSize > 0 else { return }
        let weight = setupFontWeight(from: fontWeight ?? "regular")
        
        if !fontName.isEmpty {
            lblText.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: weight)
        } else {
            lblText.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }

    private func updateBackgroundColor() {
        backgroundLayer.fillColor = bgColor.cgColor
    }
    
    private func updateShadow() {
        backgroundLayer.shadowColor = shadowColor?.cgColor
        backgroundLayer.shadowOpacity = shadowOpacity
        backgroundLayer.shadowOffset = shadowOffset
        backgroundLayer.shadowRadius = shadowRadius
        backgroundLayer.masksToBounds = false
    }

    // MARK: - Layout

    private func initialTransform(for direction: EDTSTooltipDirection) -> CGAffineTransform {
        switch direction {
        case .top: return CGAffineTransform(translationX: 0, y: 4)
        case .bottom: return CGAffineTransform(translationX: 0, y: -4)
        case .leading: return CGAffineTransform(translationX: 4, y: 0)
        case .trailing: return CGAffineTransform(translationX: -4, y: 0)
        }
    }

    private func layoutTooltip() {
        guard let target = targetView, let superview = self.superview else { return }

        let targetFrame = target.convert(target.bounds, to: superview)

        let labelMaxWidth = maxWidth - paddingLeading - paddingTrailing
        let textSize = lblText.sizeThatFits(CGSize(width: labelMaxWidth, height: .greatestFiniteMagnitude))

        var backgroundSize = CGSize(
            width: textSize.width + paddingLeading + paddingTrailing,
            height: textSize.height + paddingTop + paddingBottom
        )
        backgroundSize.width = min(backgroundSize.width, maxWidth)

        var backgroundOrigin: CGPoint = .zero

        switch direction {
        case .top:
            backgroundOrigin = CGPoint(
                x: targetFrame.midX - backgroundSize.width / 2,
                y: targetFrame.minY - spacing - arrowSize.height - backgroundSize.height
            )
        case .bottom:
            backgroundOrigin = CGPoint(
                x: targetFrame.midX - backgroundSize.width / 2,
                y: targetFrame.maxY + spacing + arrowSize.height
            )
        case .leading:
            backgroundOrigin = CGPoint(
                x: targetFrame.minX - spacing - arrowSize.height - backgroundSize.width,
                y: targetFrame.midY - backgroundSize.height / 2
            )
        case .trailing:
            backgroundOrigin = CGPoint(
                x: targetFrame.maxX + spacing + arrowSize.height,
                y: targetFrame.midY - backgroundSize.height / 2
            )
        }

        backgroundOrigin.x = max(8, min(backgroundOrigin.x, superview.bounds.width - backgroundSize.width - 8))
        backgroundOrigin.y = max(8, min(backgroundOrigin.y, superview.bounds.height - backgroundSize.height - 8))

        let backgroundRect = CGRect(origin: backgroundOrigin, size: backgroundSize)

        var viewFrame = backgroundRect
        switch direction {
        case .top: viewFrame.size.height += arrowSize.height
        case .bottom:
            viewFrame.origin.y -= arrowSize.height
            viewFrame.size.height += arrowSize.height
        case .leading: viewFrame.size.width += arrowSize.height
        case .trailing:
            viewFrame.origin.x -= arrowSize.height
            viewFrame.size.width += arrowSize.height
        }
        self.frame = viewFrame

        let localbackgroundRect = backgroundRect.offsetBy(dx: -viewFrame.origin.x, dy: -viewFrame.origin.y)

        let arrowTipPoint: CGPoint
        switch direction {
        case .top, .bottom:
            let clampedX = max(localbackgroundRect.minX + arrowSize.width, min(targetFrame.midX - viewFrame.origin.x, localbackgroundRect.maxX - arrowSize.width))
            arrowTipPoint = CGPoint(x: clampedX, y: direction == .top ? localbackgroundRect.maxY + arrowSize.height : localbackgroundRect.minY - arrowSize.height)
        case .leading, .trailing:
            let clampedY = max(localbackgroundRect.minY + arrowSize.width, min(targetFrame.midY - viewFrame.origin.y, localbackgroundRect.maxY - arrowSize.width))
            arrowTipPoint = CGPoint(x: direction == .leading ? localbackgroundRect.maxX + arrowSize.height : localbackgroundRect.minX - arrowSize.height, y: clampedY)
        }
        let tooltipPath = backgroundPath(backgroundRect: localbackgroundRect, arrowTip: arrowTipPoint, direction: direction).cgPath
        backgroundLayer.path = tooltipPath
        backgroundLayer.shadowPath = tooltipPath
        backgroundLayer.frame = self.bounds

        lblText.frame = CGRect(
            x: localbackgroundRect.minX + paddingLeading,
            y: localbackgroundRect.minY + paddingTop,
            width: localbackgroundRect.width - paddingLeading - paddingTrailing,
            height: localbackgroundRect.height - paddingTop - paddingBottom
        )
    }

    private func backgroundPath(backgroundRect: CGRect, arrowTip: CGPoint, direction: EDTSTooltipDirection) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: backgroundRect, cornerRadius: cornerRadius)

        let arrowPath = UIBezierPath()
        switch direction {
        case .top:
            let baseY = backgroundRect.maxY
            arrowPath.move(to: CGPoint(x: arrowTip.x - arrowSize.width / 2, y: baseY))
            arrowPath.addLine(to: arrowTip)
            arrowPath.addLine(to: CGPoint(x: arrowTip.x + arrowSize.width / 2, y: baseY))
        case .bottom:
            let baseY = backgroundRect.minY
            arrowPath.move(to: CGPoint(x: arrowTip.x - arrowSize.width / 2, y: baseY))
            arrowPath.addLine(to: arrowTip)
            arrowPath.addLine(to: CGPoint(x: arrowTip.x + arrowSize.width / 2, y: baseY))
        case .leading:
            let baseX = backgroundRect.maxX
            arrowPath.move(to: CGPoint(x: baseX, y: arrowTip.y - arrowSize.width / 2))
            arrowPath.addLine(to: arrowTip)
            arrowPath.addLine(to: CGPoint(x: baseX, y: arrowTip.y + arrowSize.width / 2))
        case .trailing:
            let baseX = backgroundRect.minX
            arrowPath.move(to: CGPoint(x: baseX, y: arrowTip.y - arrowSize.width / 2))
            arrowPath.addLine(to: arrowTip)
            arrowPath.addLine(to: CGPoint(x: baseX, y: arrowTip.y + arrowSize.width / 2))
        }
        arrowPath.close()
        path.append(arrowPath)
        return path
    }

    // MARK: - Gesture

    @objc private func handleTap() {
        dismiss()
    }
}
