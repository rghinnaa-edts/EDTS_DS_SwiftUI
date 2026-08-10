//
//  ExtensionDouble.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 16/04/26.
//

import UIKit

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
