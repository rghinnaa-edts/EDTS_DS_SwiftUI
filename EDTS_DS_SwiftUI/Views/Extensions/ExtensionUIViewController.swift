//
//  ExtensionUIViewController.swift
//  EDTS_DS_SwiftUI
//
//  Created by Yovita Handayiani on 05/11/26.
//

import SwiftUI

public extension UIViewController {
    var edtsTopMost: UIViewController { presentedViewController?.edtsTopMost ?? self }
}
