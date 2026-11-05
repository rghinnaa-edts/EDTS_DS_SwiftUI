//
//  EDTSAnimation.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 04/11/26.
//

import SwiftUI

// MARK: - Gradient Border
private struct EDTSGradientBorderModifier: ViewModifier {
    let isAnimating: Bool
    let width: CGFloat
    let colors: [Color]
    let cornerRadius: CGFloat
    let duration: TimeInterval
    let stopDuration: TimeInterval
    let settleColor: Color

    @State private var hasStarted = false
    @State private var rotationStart: Date?
    @State private var gradientOpacity = 0.0
    @State private var generation = 0

    func body(content: Content) -> some View {
        content
            .overlay { borderOverlay }
            .edtsOnChange(of: isAnimating) { newValue in
                newValue ? start() : stop()
            }
    }

    // MARK: Rendering
    @ViewBuilder
    private var borderOverlay: some View {
        if hasStarted {
            ZStack {
                border(settleColor)

                if let rotationStart {
                    TimelineView(.animation) { context in
                        let elapsed = context.date.timeIntervalSince(rotationStart)
                        let progress = elapsed.truncatingRemainder(dividingBy: duration) / duration
                        border(
                            AngularGradient(
                                gradient: Gradient(colors: loopedColors),
                                center: .center,
                                angle: .degrees(progress * 360)
                            )
                        )
                    }
                    .opacity(gradientOpacity)
                }
            }
        }
    }

    private var loopedColors: [Color] {
        colors + colors.dropLast().reversed()
    }

    private func border<S: ShapeStyle>(_ style: S) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(style, lineWidth: width)
            .allowsHitTesting(false)
    }

    // MARK: State changes
    private func start() {
        generation += 1
        withAnimation(nil) {
            hasStarted = true
            rotationStart = Date()
            gradientOpacity = 1
        }
    }

    private func stop() {
        guard hasStarted else { return }
        generation += 1
        let current = generation

        withAnimation(.easeInOut(duration: stopDuration)) {
            gradientOpacity = 0
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(stopDuration * 1_000_000_000))
            if generation == current { rotationStart = nil }
        }
    }
}

// MARK: - Neon Pulse
private struct EDTSNeonPulseModifier: ViewModifier {
    let isActive: Bool
    let color: Color
    let duration: TimeInterval

    @State private var expanded = false

    func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(isActive ? (expanded ? 0.5 : 0.1) : 0),
                radius: isActive ? (expanded ? 12 : 0.5) : 0
            )
            .animation(
                isActive
                    ? .easeInOut(duration: duration).repeatForever(autoreverses: true)
                    : nil,
                value: expanded
            )
            .edtsOnChange(of: isActive) { active in
                expanded = active
            }
    }
}

// MARK: - Card Selected
private struct EDTSTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct EDTSCardSelectedModifier: ViewModifier {
    let isSelected: Bool
    let tintColor: Color
    let unselectedBorderColor: Color
    let icon: UIImage?
    let iconTintColor: Color
    let iconSize: CGFloat
    let triangleSize: CGFloat
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let duration: TimeInterval
    let animated: Bool

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) { triangle }
            .overlay { border }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(isSelected ? tintColor : unselectedBorderColor, lineWidth: borderWidth)
            .animation(animated ? .linear(duration: duration) : nil, value: isSelected)
            .allowsHitTesting(false)
    }

    private var triangle: some View {
        ZStack(alignment: .topLeading) {
            EDTSTriangle().fill(tintColor)
            iconView
                .frame(width: iconSize, height: iconSize)
                .position(x: triangleSize / 3, y: triangleSize / 3)
        }
        .frame(width: triangleSize, height: triangleSize)
        .offset(isSelected ? .zero : CGSize(width: -triangleSize, height: -triangleSize))
        .opacity(isSelected ? 1 : 0)
        .animation(animated ? (isSelected ? .easeOut(duration: duration) : .easeIn(duration: duration)) : nil,
                   value: isSelected)
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private var iconView: some View {
        if let resolved = icon ?? UIImage(named: "ic_check", in: .edtsDS, compatibleWith: nil) {
            Image(uiImage: resolved)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(iconTintColor)
        } else {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(iconTintColor)
        }
    }
}

// MARK: - Public API

extension View {
    public func animateGradientBorder(
        isAnimating: Bool,
        width: CGFloat = 2,
        colors: [Color] = [EDTSColor.white, EDTSColor.blue30],
        cornerRadius: CGFloat = 0,
        duration: TimeInterval = 2.0,
        stopDuration: TimeInterval = 0.5,
        settleColor: Color = EDTSColor.blue30
    ) -> some View {
        modifier(EDTSGradientBorderModifier(
            isAnimating: isAnimating,
            width: width,
            colors: colors,
            cornerRadius: cornerRadius,
            duration: duration,
            stopDuration: stopDuration,
            settleColor: settleColor
        ))
    }

    public func animateNeonPulse(
        isActive: Bool,
        color: Color = EDTSColor.blue30,
        duration: TimeInterval = 1.0
    ) -> some View {
        modifier(EDTSNeonPulseModifier(isActive: isActive, color: color, duration: duration))
    }

    public func animateCardSelected(
        isSelected: Bool,
        cornerRadius: CGFloat = 0,
        tintColor: Color = EDTSColor.blue50,
        unselectedBorderColor: Color = EDTSColor.grey30,
        icon: UIImage? = UIImage(named: "ic_check"),
        iconTintColor: Color = EDTSColor.white,
        iconSize: CGFloat = 16,
        triangleSize: CGFloat = 32,
        borderWidth: CGFloat = 1,
        durationAnimation: TimeInterval = 0.25,
        animated: Bool = true
    ) -> some View {
        modifier(EDTSCardSelectedModifier(
            isSelected: isSelected,
            tintColor: tintColor,
            unselectedBorderColor: unselectedBorderColor,
            icon: icon,
            iconTintColor: iconTintColor,
            iconSize: iconSize,
            triangleSize: triangleSize,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            duration: durationAnimation,
            animated: animated
        ))
    }
}

// MARK: - Previews
private struct EDTSDemoCard: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .frame(maxWidth: .infinity, minHeight: 72)
            .padding(.horizontal, 16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct EDTSGradientBorderPreview: View {
    @State private var isAnimating = true
    var body: some View {
        VStack(spacing: 24) {
            EDTSDemoCard(title: "Gradient border")
                .animateGradientBorder(isAnimating: isAnimating, cornerRadius: 12)
            Toggle("Animating", isOn: $isAnimating.animation())
        }
        .padding(24)
    }
}

private struct EDTSNeonPulsePreview: View {
    @State private var isActive = true
    var body: some View {
        VStack(spacing: 32) {
            EDTSDemoCard(title: "Neon pulse")
                .animateNeonPulse(isActive: isActive)
            Toggle("Active", isOn: $isActive)
        }
        .padding(24)
    }
}

private struct EDTSCardSelectedPreview: View {
    @State private var selected = 0
    private let titles = ["Option A", "Option B", "Option C"]
    var body: some View {
        VStack(spacing: 16) {
            ForEach(titles.indices, id: \.self) { index in
                EDTSDemoCard(title: titles[index])
                    .animateCardSelected(isSelected: selected == index, cornerRadius: 12)
                    .contentShape(Rectangle())
                    .onTapGesture { selected = index }
            }
        }
        .padding(24)
    }
}

#Preview("All") {
    ScrollView {
        VStack(spacing: 8) {
            EDTSGradientBorderPreview()
            EDTSNeonPulsePreview()
            EDTSCardSelectedPreview()
        }
    }
    .background(Color(.secondarySystemBackground))
}
