//
//  ExtensionString.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 16/04/26.
//

import UIKit

extension String {
    public func strikethrough(
        style: NSUnderlineStyle = .single,
        color: UIColor? = nil
    ) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: style.rawValue
        ]
        
        if let color = color {
            attributes[.strikethroughColor] = color
        }
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
