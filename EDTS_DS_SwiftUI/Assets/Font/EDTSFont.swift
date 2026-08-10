//
//  EDTSFont.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 10/08/26.
//

import SwiftUI

public struct EDTSFont {
    
    public typealias Klik = KlikIDMFont
    public typealias Poinku = PoinkuFont
    
    // MARK: - Shared Type
    public struct FontStyle {
        public let fontName: String
        public let fontSize: CGFloat
        public let lineHeight: CGFloat
        
        public var font: Font {
            .custom(fontName, size: fontSize)
        }
        
        public var lineSpacing: CGFloat {
            max(lineHeight - fontSize, 0)
        }
    }
}

// MARK: - View Modifier

public struct EDTSFontModifier: ViewModifier {
    let style: EDTSFont.FontStyle

    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}

public extension View {
    func edtsFont(_ style: EDTSFont.FontStyle) -> some View {
        self.modifier(EDTSFontModifier(style: style))
    }
}

// MARK: - Font Weight Utilities

public enum FontWeight: String {
    case ultralight = "ultralight"
    case thin = "thin"
    case light = "light"
    case regular = "regular"
    case medium = "medium"
    case semibold = "semibold"
    case bold = "bold"
    case heavy = "heavy"
    case black = "black"
}

public func setupFontWeight(from value: String) -> Font.Weight {
    let normalized = value
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()

    let weight = FontWeight(rawValue: normalized) ?? .regular

    switch weight {
    case .ultralight: return .ultraLight
    case .thin:       return .thin
    case .light:      return .light
    case .regular:    return .regular
    case .medium:     return .medium
    case .semibold:   return .semibold
    case .bold:       return .bold
    case .heavy:      return .heavy
    case .black:      return .black
    }
}
