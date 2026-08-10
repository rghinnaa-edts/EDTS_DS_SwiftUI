//
//  PoinkuFont.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

public struct PoinkuFont {
    public enum BaseFont: String {
        case regular = "Rubik-Regular"
        case medium = "Rubik-Medium"
        case semibold = "Rubik-SemiBold"
        case bold = "Rubik-Bold"

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
    public struct D1 {
        public static let Heavy = BaseFont.semibold(size: 28, lineHeight: 30)
        public static let Medium = BaseFont.medium(size: 28, lineHeight: 30)
    }
    public struct D2 {
        public static let Heavy = BaseFont.semibold(size: 24, lineHeight: 26)
        public static let Medium = BaseFont.medium(size: 24, lineHeight: 26)
    }
    public struct D3 {
        public static let Heavy = BaseFont.semibold(size: 20, lineHeight: 26)
        public static let Medium = BaseFont.medium(size: 20, lineHeight: 26)
    }
    
    //Heading
    public struct H1 {
        public static let Heavy = BaseFont.semibold(size: 16, lineHeight: 18)
        public static let Medium = BaseFont.medium(size: 16, lineHeight: 18)
    }
    public struct H2 {
        public static let Heavy = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 14, lineHeight: 16)
    }
    public struct H3 {
        public static let Heavy = BaseFont.semibold(size: 12, lineHeight: 14)
        public static let Medium = BaseFont.medium(size: 12, lineHeight: 14)
    }
    public struct H4 {
        public static let Heavy = BaseFont.semibold(size: 10, lineHeight: 12)
        public static let Medium = BaseFont.medium(size: 10, lineHeight: 12)
    }

    // Body
    public struct B1 {
        public static let Heavy = BaseFont.bold(size: 16, lineHeight: 18)
        public static let Medium = BaseFont.semibold(size: 16, lineHeight: 18)
        public static let Light = BaseFont.regular(size: 16, lineHeight: 18)
    }

    public struct B2 {
        public static let Bulk = BaseFont.bold(size: 14, lineHeight: 16)
        public static let Heavy = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 14, lineHeight: 16)
        public static let Light = BaseFont.regular(size: 14, lineHeight: 16)
    }

    public struct B3 {
        public static let Heavy = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 12, lineHeight: 16)
        public static let Light = BaseFont.regular(size: 12, lineHeight: 16)
    }

    public struct B4 {
        public static let Heavy = BaseFont.semibold(size: 10, lineHeight: 14)
        public static let Medium = BaseFont.medium(size: 10, lineHeight: 14)
        public static let Light = BaseFont.regular(size: 10, lineHeight: 14)
    }

    public struct B5 {
        public static let Medium = BaseFont.bold(size: 8, lineHeight: 12)
        public static let Light = BaseFont.regular(size: 8, lineHeight: 12)
    }

    // Paragraph
    public struct P1 {
        public static let Heavy = BaseFont.semibold(size: 14, lineHeight: 20)
        public static let Regular = BaseFont.regular(size: 14, lineHeight: 20)
    }

    public struct P2 {
        public static let Heavy = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }
    
    public struct P3 {
        public static let Heavy = BaseFont.semibold(size: 10, lineHeight: 14)
        public static let Regular = BaseFont.regular(size: 10, lineHeight: 14)
    }

    // Button
    public struct Button {
        public static let Large = BaseFont.semibold(size: 16, lineHeight: 24)
        public static let Medium = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Small = BaseFont.semibold(size: 12, lineHeight: 16)
    }
}
