//
//  ExtensionBundle.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import Foundation

final class EDTSBundleFinder {}

extension Bundle {
    public static let edtsDS: Bundle = {
        let frameworkBundle = Bundle(for: EDTSBundleFinder.self)

        if let url = frameworkBundle.url(forResource: "EDTS_DSAssets", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }

        if let url = Bundle.main.url(forResource: "EDTS_DSAssets", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }

        return frameworkBundle
    }()
}
