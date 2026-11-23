//
//  EDTSInnerShadow.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 23/11/26.
//

import SwiftUI

// MARK: - Inner Shadow Modifier

public struct EDTSInnerShadowModifier<S: InsettableShape>: ViewModifier {
    let shape: S
    let shadows: [EDTSTrackShadow]

    public init(shape: S, shadows: [EDTSTrackShadow]) {
        self.shape = shape
        self.shadows = shadows
    }

    public func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geo in
                ZStack {
                    ForEach(Array(shadows.enumerated()), id: \.offset) { _, shadow in
                        if shadow.opacity > 0 {
                            let color = (shadow.color ?? EDTSColor.black).opacity(shadow.opacity)
                            let sigma = max(shadow.radius / 2, 0.01)
                            let expansion = max(abs(shadow.offset.width), abs(shadow.offset.height)) + sigma * 6 + 2

                            EDTSInsetShadowShape(
                                shapePath: { rect in shape.path(in: rect) },
                                expansion: expansion
                            )
                            .fill(color, style: FillStyle(eoFill: true))
                            .frame(width: geo.size.width, height: geo.size.height)
                            .blur(radius: sigma)
                            .offset(shadow.offset)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .mask { shape }
            }
            .allowsHitTesting(false)
        }
    }
}

public extension View {
    func edtsInnerShadow<S: InsettableShape>(
        in shape: S,
        shadows: [EDTSTrackShadow]
    ) -> some View {
        modifier(EDTSInnerShadowModifier(shape: shape, shadows: shadows))
    }

    func edtsInnerShadow<S: InsettableShape>(
        in shape: S,
        color: Color? = nil,
        opacity: Double = 0.1,
        radius: CGFloat = 2,
        offset: CGSize = .zero
    ) -> some View {
        edtsInnerShadow(
            in: shape,
            shadows: [EDTSTrackShadow(color: color, opacity: opacity, radius: radius, offset: offset)]
        )
    }

    func edtsInnerShadow(
        cornerRadius: CGFloat,
        color: Color? = nil,
        opacity: Double = 0.1,
        radius: CGFloat = 2,
        offset: CGSize = .zero
    ) -> some View {
        edtsInnerShadow(
            in: RoundedRectangle(cornerRadius: cornerRadius),
            color: color, opacity: opacity, radius: radius, offset: offset
        )
    }
}
