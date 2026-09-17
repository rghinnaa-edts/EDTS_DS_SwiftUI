//
//  EDTSSkeleton.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

public struct EDTSSkeleton: View {
    public var cornerRadius: CGFloat
    public var cornerRadiusTopLeft: CGFloat
    public var cornerRadiusTopRight: CGFloat
    public var cornerRadiusBottomLeft: CGFloat
    public var cornerRadiusBottomRight: CGFloat
    public var baseColor: Color
    public var highlightColor: Color
    public var duration: Double
    public var isActive: Bool

    @State private var phase: CGFloat = -1

    public init(
        cornerRadius: CGFloat = 8,
        cornerRadiusTopLeft: CGFloat? = nil,
        cornerRadiusTopRight: CGFloat? = nil,
        cornerRadiusBottomLeft: CGFloat? = nil,
        cornerRadiusBottomRight: CGFloat? = nil,
        baseColor: Color = EDTSColor.grey20,
        highlightColor: Color = EDTSColor.grey30,
        duration: Double = 1.5,
        isActive: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.duration = duration
        self.isActive = isActive

        let hasCustomCorner = cornerRadiusTopLeft != nil
            || cornerRadiusTopRight != nil
            || cornerRadiusBottomLeft != nil
            || cornerRadiusBottomRight != nil

        if hasCustomCorner {
            self.cornerRadiusTopLeft = cornerRadiusTopLeft ?? 0.0
            self.cornerRadiusTopRight = cornerRadiusTopRight ?? 0.0
            self.cornerRadiusBottomLeft = cornerRadiusBottomLeft ?? 0.0
            self.cornerRadiusBottomRight = cornerRadiusBottomRight ?? 0.0
        } else {
            self.cornerRadiusTopLeft = cornerRadius
            self.cornerRadiusTopRight = cornerRadius
            self.cornerRadiusBottomLeft = cornerRadius
            self.cornerRadiusBottomRight = cornerRadius
        }
    }

    private var skeletonShape: UnevenRoundedShape {
        UnevenRoundedShape(
            topLeft: cornerRadiusTopLeft,
            topRight: cornerRadiusTopRight,
            bottomLeft: cornerRadiusBottomLeft,
            bottomRight: cornerRadiusBottomRight
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let gradient = LinearGradient(
                gradient: Gradient(colors: [baseColor, highlightColor, baseColor]),
                startPoint: .leading,
                endPoint: .trailing
            )

            skeletonShape
                .fill(baseColor)
                .overlay(
                    gradient
                        .frame(width: max(width * 2, 1))
                        .offset(x: phase * width * 2)
                )
                .mask(
                    skeletonShape
                        .fill(Color.white)
                )
        }
        .onAppear { startIfNeeded() }
        .onChange(of: isActive) { newValue in
            if newValue { startIfNeeded() } else { stop() }
        }
        .accessibilityHidden(true)
    }

    private func startIfNeeded() {
        guard isActive else { return }
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            phase = 1
        }
    }

    private func stop() {
        withAnimation(.none) {
            phase = -1
        }
    }
}

// MARK: View Modifier

public struct EDTSSkeletonModifier: ViewModifier {
    public let active: Bool
    public let cornerRadius: CGFloat
    public let cornerRadiusTopLeft: CGFloat?
    public let cornerRadiusTopRight: CGFloat?
    public let cornerRadiusBottomLeft: CGFloat?
    public let cornerRadiusBottomRight: CGFloat?
    public let baseColor: Color
    public let highlightColor: Color
    public let duration: Double

    public func body(content: Content) -> some View {
        content
            .opacity(active ? 0 : 1)
            .overlay {
                if active {
                    EDTSSkeleton(
                        cornerRadius: cornerRadius,
                        cornerRadiusTopLeft: cornerRadiusTopLeft,
                        cornerRadiusTopRight: cornerRadiusTopRight,
                        cornerRadiusBottomLeft: cornerRadiusBottomLeft,
                        cornerRadiusBottomRight: cornerRadiusBottomRight,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        duration: duration,
                        isActive: true
                    )
                }
            }
    }
}

// MARK: Extension View

public extension View {
    func edtsSkeleton(
        active: Bool,
        cornerRadius: CGFloat = 8,
        cornerRadiusTopLeft: CGFloat? = nil,
        cornerRadiusTopRight: CGFloat? = nil,
        cornerRadiusBottomLeft: CGFloat? = nil,
        cornerRadiusBottomRight: CGFloat? = nil,
        baseColor: Color = EDTSColor.grey20,
        highlightColor: Color = EDTSColor.grey30,
        duration: Double = 1.5
    ) -> some View {
        modifier(
            EDTSSkeletonModifier(
                active: active,
                cornerRadius: cornerRadius,
                cornerRadiusTopLeft: cornerRadiusTopLeft,
                cornerRadiusTopRight: cornerRadiusTopRight,
                cornerRadiusBottomLeft: cornerRadiusBottomLeft,
                cornerRadiusBottomRight: cornerRadiusBottomRight,
                baseColor: baseColor,
                highlightColor: highlightColor,
                duration: duration
            )
        )
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        EDTSSkeleton(cornerRadius: 12)
            .frame(height: 60)
        HStack(spacing: 12) {
            EDTSSkeleton(cornerRadius: 8)
                .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 8) {
                EDTSSkeleton(cornerRadius: 6)
                    .frame(height: 14)
                EDTSSkeleton(cornerRadius: 6)
                    .frame(width: 120, height: 14)
            }
        }
        EDTSSkeleton(
            cornerRadiusTopLeft: 16,
            cornerRadiusTopRight: 16,
            cornerRadiusBottomLeft: 0,
            cornerRadiusBottomRight: 0
        )
        .frame(height: 60)
        Text("Loaded content")
            .edtsSkeleton(active: true, cornerRadius: 6)
            .frame(height: 16)
    }
    .padding()
}
