//
//  ExtensionBundle.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 23/07/26.
//

import UIKit

final class EDTSBundleFinder {}

extension Bundle {
    public static let edtsDS: Bundle = {
        let frameworkBundle = Bundle(for: EDTSBundleFinder.self)

        // CocoaPods with resource_bundle nests it inside the framework bundle
        if let url = frameworkBundle.url(forResource: "EDTS_DSAssets", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }

        // Fallback for static-lib installs where CocoaPods puts it next to the main bundle
        if let url = Bundle.main.url(forResource: "EDTS_DSAssets", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }

        return frameworkBundle
    }()
}
