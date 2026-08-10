//
//  KlikIDMFont.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

public struct KlikIDMFont {
    public enum BaseFont: String {
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case semibold = "Inter-SemiBold"
        case bold = "Inter-Bold"

        public static func regular(size: CGFloat, lineHeight: CGFloat) -> EDTSFont.FontStyle {
            EDTSFont.FontStyle(fontName: BaseFont.regular.rawValue, fontSize: size, lineHeight: lineHeight)
        }

        public static func medium(size: CGFloat, lineHeight: CGFloat) -> EDTSFont.FontStyle {
            EDTSFont.FontStyle(fontName: BaseFont.medium.rawValue, fontSize: size, lineHeight: lineHeight)
        }

        public static func semibold(size: CGFloat, lineHeight: CGFloat) -> EDTSFont.FontStyle {
            EDTSFont.FontStyle(fontName: BaseFont.semibold.rawValue, fontSize: size, lineHeight: lineHeight)
        }

        public static func bold(size: CGFloat, lineHeight: CGFloat) -> EDTSFont.FontStyle {
            EDTSFont.FontStyle(fontName: BaseFont.bold.rawValue, fontSize: size, lineHeight: lineHeight)
        }
    }

    // Display
    public static let D1 = BaseFont.semibold(size: 42, lineHeight: 44)
    public static let D2 = BaseFont.semibold(size: 28, lineHeight: 30)
    public static let D3 = BaseFont.semibold(size: 24, lineHeight: 26)
    public static let D4 = BaseFont.semibold(size: 20, lineHeight: 22)

    // Heading
    public static let H1 = BaseFont.semibold(size: 16, lineHeight: 18)
    public static let H2 = BaseFont.semibold(size: 14, lineHeight: 16)
    public static let H3 = BaseFont.semibold(size: 12, lineHeight: 14)

    // Body
    public struct B1 {
        public static let Medium = BaseFont.semibold(size: 16, lineHeight: 18)
        public static let Regular = BaseFont.regular(size: 16, lineHeight: 18)
    }

    public struct B2 {
        public static let Bold = BaseFont.bold(size: 14, lineHeight: 16)
        public static let Semibold = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 14, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 14, lineHeight: 16)
    }

    public struct B3 {
        public static let Bold = BaseFont.bold(size: 12, lineHeight: 16)
        public static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 12, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }

    public struct B4 {
        public static let Bold = BaseFont.bold(size: 10, lineHeight: 14)
        public static let Semibold = BaseFont.semibold(size: 10, lineHeight: 14)
        public static let Medium = BaseFont.medium(size: 10, lineHeight: 14)
        public static let Regular = BaseFont.regular(size: 10, lineHeight: 14)
    }

    // Paragraph
    public struct P1 {
        public static let Semibold = BaseFont.semibold(size: 14, lineHeight: 20)
        public static let Regular = BaseFont.regular(size: 14, lineHeight: 20)
    }

    public struct P2 {
        public static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }

    // Button
    public struct Button {
        public static let XtraLarge = BaseFont.semibold(size: 16, lineHeight: 24)
        public static let Large = BaseFont.semibold(size: 14, lineHeight: 24)
        public static let Medium = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Small = BaseFont.semibold(size: 12, lineHeight: 16)
    }
    
    // Price
    public struct Price {
        public static let Final = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Discount = BaseFont.regular(size: 10, lineHeight: 12)
    }
}
