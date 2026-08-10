//
//  EDTSColor.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 07/08/26.
//

import SwiftUI

public enum EDTSColorTheme {
    case klikIDM
    case poinku
}

public enum EDTSColor {

    // MARK: - Configuration

    public static var theme: EDTSColorTheme = .klikIDM

    // MARK: - Neutral

    public static var white: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.white
        case .poinku:  return PoinkuColor.white
        }
    }

    public static var black: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.black
        case .poinku:  return PoinkuColor.black
        }
    }

    // MARK: - Grey

    public static var grey10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey10
        case .poinku:  return PoinkuColor.grey10
        }
    }

    public static var grey20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey20
        case .poinku:  return PoinkuColor.grey20
        }
    }

    public static var grey30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey30
        case .poinku:  return PoinkuColor.grey30
        }
    }

    public static var grey40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey40
        case .poinku:  return PoinkuColor.grey40
        }
    }

    public static var grey50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey50
        case .poinku:  return PoinkuColor.grey50
        }
    }

    public static var grey60: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey60
        case .poinku:  return PoinkuColor.grey60
        }
    }

    public static var grey70: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey70
        case .poinku:  return PoinkuColor.grey70
        }
    }

    public static var grey80: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey70
        case .poinku:  return PoinkuColor.grey80
        }
    }

    // MARK: - Blue

    public static var blue10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue10
        case .poinku:  return PoinkuColor.blue10
        }
    }

    public static var blue20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue20
        case .poinku:  return PoinkuColor.blue20
        }
    }

    public static var blue30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue30
        case .poinku:  return PoinkuColor.blue30
        }
    }

    public static var blue40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue40
        case .poinku:  return PoinkuColor.blue40
        }
    }

    public static var blue50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue50
        case .poinku:  return PoinkuColor.blue50
        }
    }

    public static var blue60: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue60
        case .poinku:  return PoinkuColor.blue50
        }
    }

    public static var blue70: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue70
        case .poinku:  return PoinkuColor.blue50
        }
    }

    // MARK: - Yellow

    public static var yellow10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow10
        case .poinku:  return Color(red: 254.0/255.0, green: 249.0/255.0, blue: 211.0/255.0)
        }
    }

    public static var yellow20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow20
        case .poinku:  return Color(red: 253.0/255.0, green: 230.0/255.0, blue: 123.0/255.0)
        }
    }

    public static var yellow30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow30
        case .poinku:  return Color(red: 249.0/255.0, green: 202.0/255.0, blue: 36.0/255.0)
        }
    }

    public static var yellow40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow40
        case .poinku:  return Color(red: 214.0/255.0, green: 168.0/255.0, blue: 26.0/255.0)
        }
    }

    public static var yellow50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow50
        case .poinku:  return Color(red: 179.0/255.0, green: 136.0/255.0, blue: 18.0/255.0)
        }
    }

    // MARK: - Red

    public static var red10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.red10
        case .poinku:  return PoinkuColor.red10
        }
    }

    public static var red20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.red20
        case .poinku:  return PoinkuColor.red20
        }
    }

    public static var red30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.red30
        case .poinku:  return PoinkuColor.red30
        }
    }

    public static var red40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.red40
        case .poinku:  return PoinkuColor.red40
        }
    }

    public static var red50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.red50
        case .poinku:  return PoinkuColor.red50
        }
    }

    // MARK: - Green

    public static var green10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.green10
        case .poinku:  return Color(red: 235.0/255.0, green: 255.0/255.0, blue: 208.0/255.0)
        }
    }

    public static var green20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.green20
        case .poinku:  return Color(red: 206.0/255.0, green: 238.0/255.0, blue: 142.0/255.0)
        }
    }

    public static var green30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.green30
        case .poinku:  return Color(red: 143.0/255.0, green: 199.0/255.0, blue: 66.0/255.0)
        }
    }

    public static var green40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.green40
        case .poinku:  return Color(red: 114.0/255.0, green: 171.0/255.0, blue: 48.0/255.0)
        }
    }

    public static var green50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.green50
        case .poinku:  return Color(red: 87.0/255.0, green: 143.0/255.0, blue: 33.0/255.0)
        }
    }

    // MARK: - Orange

    public static var orange10: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange10
        case .poinku:  return PoinkuColor.orange10
        }
    }

    public static var orange20: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange20
        case .poinku:  return PoinkuColor.orange20
        }
    }

    public static var orange30: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange30
        case .poinku:  return PoinkuColor.orange30
        }
    }

    public static var orange40: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange40
        case .poinku:  return PoinkuColor.orange40
        }
    }

    public static var orange50: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange50
        case .poinku:  return PoinkuColor.orange50
        }
    }

    // MARK: - Button (KlikIDM only)

    public static var blueDefault: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blueDefault
        case .poinku:  return PoinkuColor.blue30
        }
    }

    public static var bluePressed: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.bluePressed
        case .poinku:  return PoinkuColor.blue40
        }
    }

    public static var disabled: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.disabled
        case .poinku:  return PoinkuColor.grey30
        }
    }

    public static var greyDefault: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyDefault
        case .poinku:  return PoinkuColor.grey30
        }
    }

    public static var greyPressed: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyPressed
        case .poinku:  return PoinkuColor.grey50
        }
    }

    public static var greyText: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyText
        case .poinku:  return PoinkuColor.grey70
        }
    }

    // MARK: - Cart FAB (KlikIDM only)

    public static var cartDefault: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.cartDefault
        case .poinku:  return PoinkuColor.orange30
        }
    }

    public static var cartPressed: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.cartPressed
        case .poinku:  return PoinkuColor.orange40
        }
    }

    // MARK: - Support

    public static var errorStrong: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.errorStrong
        case .poinku:  return PoinkuColor.errorStrong
        }
    }

    public static var errorWeak: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.errorWeak
        case .poinku:  return PoinkuColor.errorWeak
        }
    }

    public static var successStrong: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.successStrong
        case .poinku:  return PoinkuColor.successStrong
        }
    }

    public static var successWeak: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.successWeak
        case .poinku:  return PoinkuColor.successWeak
        }
    }

    public static var warningStrong: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.warningStrong
        case .poinku:  return PoinkuColor.warningStrong
        }
    }

    public static var warningWeak: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.warningWeak
        case .poinku:  return PoinkuColor.warningWeak
        }
    }

    public static var primaryStrong: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blueDefault
        case .poinku:  return PoinkuColor.primaryStrong
        }
    }

    public static var primaryWeak: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue20
        case .poinku:  return PoinkuColor.primaryWeak
        }
    }

    public static var secondaryStrong: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange30
        case .poinku:  return PoinkuColor.secondaryStrong
        }
    }

    public static var secondaryWeak: Color {
        switch theme {
        case .klikIDM: return Color(red: 254.0/255.0, green: 251.0/255.0, blue: 245.0/255.0)
        case .poinku:  return PoinkuColor.secondaryWeak
        }
    }

    // MARK: - Brand (KlikIDM only)

    public static var xtra: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.xtra
        case .poinku:  return Color(red: 67.0/255.0, green: 158.0/255.0, blue: 37.0/255.0)
        }
    }

    public static var xpress: Color {
        switch theme {
        case .klikIDM: return KlikIDMColor.xpress
        case .poinku:  return PoinkuColor.secondaryStrong
        }
    }

    // MARK: KlikIDM Base Gradients

    public static var sunsetLeading: Color { KlikIDMColor.sunsetLeading }
    public static var sunsetTrailing: Color { KlikIDMColor.sunsetTrailing }
    public static var skyblueLeading: Color { KlikIDMColor.skyblueLeading }
    public static var skyblueTrailing: Color { KlikIDMColor.skyblueTrailing }
    public static var oceanleafLeading: Color { KlikIDMColor.oceanleafLeading }
    public static var oceanleafTrailing: Color { KlikIDMColor.oceanleafTrailing }
    public static var greenforestLeading: Color { KlikIDMColor.greenforestLeading }
    public static var greenforestTrailing: Color { KlikIDMColor.greenforestTrailing }
    public static var sunflowerLeading: Color { KlikIDMColor.sunflowerLeading }
    public static var sunflowerTrailing: Color { KlikIDMColor.sunflowerTrailing }
    public static var sunriseLeading: Color { KlikIDMColor.sunriseLeading }
    public static var sunriseTrailing: Color { KlikIDMColor.sunriseTrailing }

    // MARK: Poinku Base Gradients

    public static var blueLeading: Color { PoinkuColor.blueLeading }
    public static var blueTrailing: Color { PoinkuColor.blueTrailing }
    public static var blue2Leading: Color { PoinkuColor.blue2Leading }
    public static var blue2Trailing: Color { PoinkuColor.blue2Trailing }
    public static var goldLeading: Color { PoinkuColor.goldLeading }
    public static var goldTrailing: Color { PoinkuColor.goldTrailing }
    public static var silverLeading: Color { PoinkuColor.silverLeading }
    public static var silverTrailing: Color { PoinkuColor.silverTrailing }
    public static var diamondLeading: Color { PoinkuColor.diamondLeading }
    public static var diamondTrailing: Color { PoinkuColor.diamondTrailing }
    public static var redLeading: Color { PoinkuColor.redLeading }
    public static var redTrailing: Color { PoinkuColor.redTrailing }

    // MARK: - Gradient

    public struct Gradient {

        // MARK: KlikIDM Gradients

        public static var sunset: KlikIDMColor.SwiftUIGradient { KlikIDMColor.Gradient.sunset }
        public static var skyblue: KlikIDMColor.SwiftUIGradient { KlikIDMColor.Gradient.skyblue }
        public static var greenforest: KlikIDMColor.SwiftUIGradient { KlikIDMColor.Gradient.greenforest }
        public static var sunflower: KlikIDMColor.SwiftUIGradient { KlikIDMColor.Gradient.sunflower }

        // MARK: Poinku Gradients

        public static var blue: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.blue }
        public static var blue2: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.blue2 }
        public static var gold: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.gold }
        public static var silver: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.silver }
        public static var diamond: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.diamond }
        public static var red: PoinkuColor.SwiftUIGradient { PoinkuColor.Gradient.red }
    }
}
