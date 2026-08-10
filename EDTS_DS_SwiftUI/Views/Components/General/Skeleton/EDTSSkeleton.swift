//
//  EDTSSkeleton.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI
import Combine

public struct EDTSSkeleton: View {
    public var cornerRadius: CGFloat
    public var baseColor: Color
    public var highlightColor: Color
    public var duration: Double
    public var isActive: Bool

    @State private var phase: CGFloat = -1

    public init(
        cornerRadius: CGFloat = 8,
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
    }

    public var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let gradient = LinearGradient(
                gradient: Gradient(colors: [baseColor, highlightColor, baseColor]),
                startPoint: .leading,
                endPoint: .trailing
            )

            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(baseColor)
                .overlay(
                    gradient
                        .frame(width: max(width * 2, 1))
                        .offset(x: phase * width * 2)
                )
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white)
                )
        }
        .onAppear { startIfNeeded() }
        .onChangeCompat(of: isActive) { newValue in
            if newValue { startIfNeeded() } else { stop() }
        }
        .accessibilityHiddenCompat(true)
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

private extension View {
    @ViewBuilder
    func onChangeCompat<T: Equatable>(of value: T, perform action: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: action)
        } else {
            self.onReceive(Just(value).removeDuplicates()) { newValue in
                action(newValue)
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func accessibilityHiddenCompat(_ hidden: Bool) -> some View {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            self.accessibilityHidden(hidden)
        } else {
            self.accessibility(hidden: hidden)
        }
    }
}

public struct EDTSSkeletonModifier: ViewModifier {
    public let active: Bool
    public let cornerRadius: CGFloat
    public let baseColor: Color
    public let highlightColor: Color
    public let duration: Double

    public func body(content: Content) -> some View {
        ZStack {
            content
                .opacity(active ? 0 : 1)
            if active {
                EDTSSkeleton(
                    cornerRadius: cornerRadius,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    duration: duration,
                    isActive: true
                )
            }
        }
    }
}

public extension View {
    func edtsSkeleton(
        active: Bool,
        cornerRadius: CGFloat = 8,
        baseColor: Color = EDTSColor.grey20,
        highlightColor: Color = EDTSColor.grey30,
        duration: Double = 1.5
    ) -> some View {
        modifier(
            EDTSSkeletonModifier(
                active: active,
                cornerRadius: cornerRadius,
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
        Text("Loaded content")
            .edtsSkeleton(active: true, cornerRadius: 6)
            .frame(height: 16)
    }
    .padding()
}
