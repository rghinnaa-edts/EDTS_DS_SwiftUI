//
//  ExtensionString.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

extension String {
    public func strikethrough(
        style: Text.LineStyle.Pattern = .solid,
        color: Color? = nil
    ) -> AttributedString {
        var attributedString = AttributedString(self)
        attributedString.strikethroughStyle = Text.LineStyle(pattern: style, color: color)
        return attributedString
    }
}
