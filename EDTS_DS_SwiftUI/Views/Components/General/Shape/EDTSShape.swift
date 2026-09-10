//
//  EDTSShape.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 10/09/26.
//

import SwiftUI

public struct EDTSShape: Shape {
    private let pathBuilder: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.pathBuilder = { rect in shape.path(in: rect) }
    }

    public func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}
