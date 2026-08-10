//
//  PoinkuColor.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

public enum PoinkuColor {

    //MARK: Neutral

    public static let white = Color(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0)
    public static let black = Color(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)

    //MARK: Grey

    public static let grey10 = Color(red: 248.0/255.0, green: 251.0/255.0, blue: 252.0/255.0)
    public static let grey20 = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 246.0/255.0)
    public static let grey30 = Color(red: 220.0/255.0, green: 222.0/255.0, blue: 227.0/255.0)
    public static let grey40 = Color(red: 195.0/255.0, green: 199.0/255.0, blue: 207.0/255.0)
    public static let grey50 = Color(red: 156.0/255.0, green: 157.0/255.0, blue: 166.0/255.0)
    public static let grey60 = Color(red: 112.0/255.0, green: 114.0/255.0, blue: 125.0/255.0)
    public static let grey70 = Color(red: 67.0/255.0, green: 71.0/255.0, blue: 85.0/255.0)
    public static let grey80 = Color(red: 21.0/255.0, green: 24.0/255.0, blue: 35.0/255.0)

    //MARK: Blue

    public static let blue10 = Color(red: 106.0/255.0, green: 165.0/255.0, blue: 224.0/255.0)
    public static let blue20 = Color(red: 54.0/255.0, green: 139.0/255.0, blue: 226.0/255.0)
    public static let blue30 = Color(red: 17.0/255.0, green: 120.0/255.0, blue: 212.0/255.0)
    public static let blue40 = Color(red: 9.0/255.0, green: 88.0/255.0, blue: 170.0/255.0)
    public static let blue50 = Color(red: 4.0/255.0, green: 75.0/255.0, blue: 149.0/255.0)

    //MARK: Red

    public static let red10 = Color(red: 255.0/255.0, green: 237.0/255.0, blue: 238.0/255.0)
    public static let red20 = Color(red: 253.0/255.0, green: 71.0/255.0, blue: 74.0/255.0)
    public static let red30 = Color(red: 238.0/255.0, green: 43.0/255.0, blue: 46.0/255.0)
    public static let red40 = Color(red: 220.0/255.0, green: 16.0/255.0, blue: 19.0/255.0)
    public static let red50 = Color(red: 187.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)

    //MARK: Orange

    public static let orange10 = Color(red: 238.0/255.0, green: 199.0/255.0, blue: 135.0/255.0)
    public static let orange20 = Color(red: 240.0/255.0, green: 175.0/255.0, blue: 66.0/255.0)
    public static let orange30 = Color(red: 242.0/255.0, green: 157.0/255.0, blue: 13.0/255.0)
    public static let orange40 = Color(red: 218.0/255.0, green: 141.0/255.0, blue: 11.0/255.0)
    public static let orange50 = Color(red: 204.0/255.0, green: 128.0/255.0, blue: 0.0/255.0)

    //MARK: Support

    public static let errorStrong = Color(red: 238.0/255.0, green: 43.0/255.0, blue: 46.0/255.0)
    public static let errorWeak = Color(red: 255.0/255.0, green: 237.0/255.0, blue: 238.0/255.0)
    public static let successStrong = Color(red: 143.0/255.0, green: 199.0/255.0, blue: 66.0/255.0)
    public static let successWeak = Color(red: 235.0/255.0, green: 255.0/255.0, blue: 208.0/255.0)
    public static let warningStrong = Color(red: 255.0/255.0, green: 125.0/255.0, blue: 29.0/255.0)
    public static let warningWeak = Color(red: 255.0/255.0, green: 240.0/255.0, blue: 230.0/255.0)
    public static let primaryStrong = Color(red: 17.0/255.0, green: 120.0/255.0, blue: 212.0/255.0)
    public static let primaryWeak = Color(red: 231.0/255.0, green: 241.0/255.0, blue: 253.0/255.0)
    public static let secondaryStrong = Color(red: 242.0/255.0, green: 157.0/255.0, blue: 13.0/255.0)
    public static let secondaryWeak = Color(red: 254.0/255.0, green: 251.0/255.0, blue: 245.0/255.0)

    //MARK: Gradient endpoint colors

    public static let blueLeading = Color(red: 17.0/255.0, green: 120.0/255.0, blue: 212.0/255.0)
    public static let blueTrailing = Color(red: 108.0/255.0, green: 184.0/255.0, blue: 252.0/255.0)
    public static let blue2Leading = Color(red: 108.0/255.0, green: 184.0/255.0, blue: 252.0/255.0)
    public static let blue2Trailing = Color(red: 17.0/255.0, green: 120.0/255.0, blue: 212.0/255.0)
    public static let goldLeading = Color(red: 250.0/255.0, green: 199.0/255.0, blue: 20.0/255.0)
    public static let goldTrailing = Color(red: 250.0/255.0, green: 158.0/255.0, blue: 20.0/255.0)
    public static let silverLeading = Color(red: 164.0/255.0, green: 167.0/255.0, blue: 179.0/255.0)
    public static let silverTrailing = Color(red: 79.0/255.0, green: 81.0/255.0, blue: 88.0/255.0)
    public static let diamondLeading = Color(red: 87.0/255.0, green: 92.0/255.0, blue: 112.0/255.0)
    public static let diamondTrailing = Color(red: 17.0/255.0, green: 21.0/255.0, blue: 42.0/255.0)
    public static let redLeading = Color(red: 212.0/255.0, green: 17.0/255.0, blue: 17.0/255.0)
    public static let redTrailing = Color(red: 252.0/255.0, green: 108.0/255.0, blue: 108.0/255.0)

    // MARK: - Gradients

    public struct Gradient {
        public static let blue = SwiftUIGradient(
            colors: [blueLeading, blueTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )

        public static let blue2 = SwiftUIGradient(
            colors: [blue2Leading, blue2Trailing],
            startPoint: .leading,
            endPoint: .trailing
        )

        public static let gold = SwiftUIGradient(
            colors: [goldLeading, goldTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )

        public static let silver = SwiftUIGradient(
            colors: [silverLeading, silverTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )

        public static let diamond = SwiftUIGradient(
            colors: [diamondLeading, diamondTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )

        public static let red = SwiftUIGradient(
            colors: [redLeading, redTrailing],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    public struct SwiftUIGradient {
        public let colors: [Color]
        public let startPoint: UnitPoint
        public let endPoint: UnitPoint

        public var linearGradient: LinearGradient {
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }
    }
}
