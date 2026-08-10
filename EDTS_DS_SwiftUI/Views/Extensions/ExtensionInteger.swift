//
//  ExtensionDouble.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import Foundation

extension Int {
    public func formatRupiah() -> String {
        if self < 0 {
            return String(format: "-Rp%@", abs(self).formatDecimal())
        } else {
            return String(format: "Rp%@", self.formatDecimal())
        }
    }
    
    public func formatDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
