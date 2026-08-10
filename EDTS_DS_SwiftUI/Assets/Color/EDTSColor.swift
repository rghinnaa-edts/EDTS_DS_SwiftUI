//
//  EDTSColor.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 08/04/26.
//

import UIKit

public enum EDTSColorTheme {
    case klikIDM
    case poinku
}

open class EDTSColor {
    
    // MARK: - Configuration
    
    public static var theme: EDTSColorTheme = .klikIDM
    
    // MARK: - Neutral
    
    public class var white: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.white
        case .poinku:  return PoinkuColor.white
        }
    }
    
    public class var black: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.black
        case .poinku:  return PoinkuColor.black
        }
    }
    
    // MARK: - Grey
    
    public class var grey10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey10
        case .poinku:  return PoinkuColor.grey10
        }
    }
    
    public class var grey20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey20
        case .poinku:  return PoinkuColor.grey20
        }
    }
    
    public class var grey30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey30
        case .poinku:  return PoinkuColor.grey30
        }
    }
    
    public class var grey40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey40
        case .poinku:  return PoinkuColor.grey40
        }
    }
    
    public class var grey50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey50
        case .poinku:  return PoinkuColor.grey50
        }
    }
    
    public class var grey60: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey60
        case .poinku:  return PoinkuColor.grey60
        }
    }
    
    public class var grey70: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey70
        case .poinku:  return PoinkuColor.grey70
        }
    }
    
    public class var grey80: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.grey70
        case .poinku:  return PoinkuColor.grey80
        }
    }
    
    // MARK: - Blue
    
    public class var blue10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue10
        case .poinku:  return PoinkuColor.blue10
        }
    }
    
    public class var blue20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue20
        case .poinku:  return PoinkuColor.blue20
        }
    }
    
    public class var blue30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue30
        case .poinku:  return PoinkuColor.blue30
        }
    }
    
    public class var blue40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue40
        case .poinku:  return PoinkuColor.blue40
        }
    }
    
    public class var blue50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue50
        case .poinku:  return PoinkuColor.blue50
        }
    }
    
    public class var blue60: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue60
        case .poinku:  return PoinkuColor.blue50
        }
    }
    
    public class var blue70: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue70
        case .poinku:  return PoinkuColor.blue50
        }
    }
    
    // MARK: - Yellow
    
    public class var yellow10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow10
        case .poinku:  return UIColor(red: 254.0/255.0, green: 249.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        }
    }
    
    public class var yellow20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow20
        case .poinku:  return UIColor(red: 253.0/255.0, green: 230.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        }
    }
    
    public class var yellow30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow30
        case .poinku:  return UIColor(red: 249.0/255.0, green: 202.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        }
    }
    
    public class var yellow40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow40
        case .poinku:  return UIColor(red: 214.0/255.0, green: 168.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        }
    }
    
    public class var yellow50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.yellow50
        case .poinku:  return UIColor(red: 179.0/255.0, green: 136.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        }
    }
    
    // MARK: - Red
    
    public class var red10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.red10
        case .poinku:  return PoinkuColor.red10
        }
    }
    
    public class var red20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.red20
        case .poinku:  return PoinkuColor.red20
        }
    }
    
    public class var red30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.red30
        case .poinku:  return PoinkuColor.red30
        }
    }
    
    public class var red40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.red40
        case .poinku:  return PoinkuColor.red40
        }
    }
    
    public class var red50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.red50
        case .poinku:  return PoinkuColor.red50
        }
    }
    
    // MARK: - Green
    
    public class var green10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.green10
        case .poinku:  return UIColor(red: 235.0/255.0, green: 255.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        }
    }
    
    public class var green20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.green20
        case .poinku:  return UIColor(red: 206.0/255.0, green: 238.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        }
    }
    
    public class var green30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.green30
        case .poinku:  return UIColor(red: 143.0/255.0, green: 199.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        }
    }
    
    public class var green40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.green40
        case .poinku:  return UIColor(red: 114.0/255.0, green: 171.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        }
    }
    
    public class var green50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.green50
        case .poinku:  return UIColor(red: 87.0/255.0, green: 143.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        }
    }
    
    // MARK: - Orange
    
    public class var orange10: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange10
        case .poinku:  return PoinkuColor.orange10
        }
    }
    
    public class var orange20: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange20
        case .poinku:  return PoinkuColor.orange20
        }
    }
    
    public class var orange30: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange30
        case .poinku:  return PoinkuColor.orange30
        }
    }
    
    public class var orange40: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange40
        case .poinku:  return PoinkuColor.orange40
        }
    }
    
    public class var orange50: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange50
        case .poinku:  return PoinkuColor.orange50
        }
    }
    
    // MARK: - Button (KlikIDM only)
    
    public class var blueDefault: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blueDefault
        case .poinku:  return PoinkuColor.blue30
        }
    }
    
    public class var bluePressed: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.bluePressed
        case .poinku:  return PoinkuColor.blue40
        }
    }
    
    public class var disabled: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.disabled
        case .poinku:  return PoinkuColor.grey30
        }
    }
    
    public class var greyDefault: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyDefault
        case .poinku:  return PoinkuColor.grey30
        }
    }
    
    public class var greyPressed: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyPressed
        case .poinku:  return PoinkuColor.grey50
        }
    }
    
    public class var greyText: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.greyText
        case .poinku:  return PoinkuColor.grey70
        }
    }
    
    // MARK: - Cart FAB (KlikIDM only)
    
    public class var cartDefault: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.cartDefault
        case .poinku:  return PoinkuColor.orange30
        }
    }
    
    public class var cartPressed: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.cartPressed
        case .poinku:  return PoinkuColor.orange40
        }
    }
    
    // MARK: - Support
    
    public class var errorStrong: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.errorStrong
        case .poinku:  return PoinkuColor.errorStrong
        }
    }
    
    public class var errorWeak: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.errorWeak
        case .poinku:  return PoinkuColor.errorWeak
        }
    }
    
    public class var successStrong: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.successStrong
        case .poinku:  return PoinkuColor.successStrong
        }
    }
    
    public class var successWeak: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.successWeak
        case .poinku:  return PoinkuColor.successWeak
        }
    }
    
    public class var warningStrong: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.warningStrong
        case .poinku:  return PoinkuColor.warningStrong
        }
    }
    
    public class var warningWeak: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.warningWeak
        case .poinku:  return PoinkuColor.warningWeak
        }
    }
    
    public class var primaryStrong: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blueDefault
        case .poinku:  return PoinkuColor.primaryStrong
        }
    }
    
    public class var primaryWeak: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.blue20
        case .poinku:  return PoinkuColor.primaryWeak
        }
    }
    
    public class var secondaryStrong: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.orange30
        case .poinku:  return PoinkuColor.secondaryStrong
        }
    }
    
    public class var secondaryWeak: UIColor {
        switch theme {
        case .klikIDM: return UIColor(red: 254.0/255.0, green: 251.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        case .poinku:  return PoinkuColor.secondaryWeak
        }
    }
    
    // MARK: - Brand (KlikIDM only)
    
    public class var xtra: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.xtra
        case .poinku:  return UIColor(red: 67.0/255.0, green: 158.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        }
    }
    
    public class var xpress: UIColor {
        switch theme {
        case .klikIDM: return KlikIDMColor.xpress
        case .poinku:  return PoinkuColor.secondaryStrong
        }
    }
    
    // MARK: KlikIDM Base Gradients
    
    public class var sunsetLeading: UIColor {
        return KlikIDMColor.sunsetLeading
    }
    
    public class var sunsetTrailing: UIColor {
        return KlikIDMColor.sunsetTrailing
    }
    
    public class var skyblueLeading: UIColor {
        return KlikIDMColor.skyblueLeading
    }
    
    public class var skyblueTrailing: UIColor {
        return KlikIDMColor.skyblueTrailing
    }
    
    public class var oceanleafLeading: UIColor {
        return KlikIDMColor.oceanleafLeading
    }
    
    public class var oceanleafTrailing: UIColor {
        return KlikIDMColor.oceanleafTrailing
    }
    
    public class var greenforestLeading: UIColor {
        return KlikIDMColor.greenforestLeading
    }
    
    public class var greenforestTrailing: UIColor {
        return KlikIDMColor.greenforestTrailing
    }
    
    public class var sunflowerLeading: UIColor {
        return KlikIDMColor.sunflowerLeading
    }
    
    public class var sunflowerTrailing: UIColor {
        return KlikIDMColor.sunflowerTrailing
    }
    
    public class var sunriseLeading: UIColor {
        return KlikIDMColor.sunriseLeading
    }
    
    public class var sunriseTrailing: UIColor {
        return KlikIDMColor.sunriseTrailing
    }
    
    // MARK: Poinku Base Gradients
    
    public class var blueLeading: UIColor {
        return PoinkuColor.blueLeading
    }
    
    public class var blueTrailing: UIColor {
        return PoinkuColor.blueTrailing
    }
    
    public class var blue2Leading: UIColor {
        return PoinkuColor.blue2Leading
    }
    
    public class var blue2Trailing: UIColor {
        return PoinkuColor.blue2Trailing
    }
    
    public class var goldLeading: UIColor {
        return PoinkuColor.goldLeading
    }
    
    public class var goldTrailing: UIColor {
        return PoinkuColor.goldTrailing
    }
    
    public class var silverLeading: UIColor {
        return PoinkuColor.silverLeading
    }
    
    public class var silverTrailing: UIColor {
        return PoinkuColor.silverTrailing
    }
    
    public class var diamondLeading: UIColor {
        return PoinkuColor.diamondLeading
    }
    
    public class var diamondTrailing: UIColor {
        return PoinkuColor.diamondTrailing
    }
    
    public class var redLeading: UIColor {
        return PoinkuColor.redLeading
    }
    
    public class var redTrailing: UIColor {
        return PoinkuColor.redTrailing
    }
    
    // MARK: - Gradient
    
    public struct Gradient {
        
        // MARK: KlikIDM Gradients
        
        public static var sunset: KlikIDMColor.UIKitGradient {
            return KlikIDMColor.Gradient.sunset
        }
        
        public static var skyblue: KlikIDMColor.UIKitGradient {
            return KlikIDMColor.Gradient.skyblue
        }
        
        public static var greenforest: KlikIDMColor.UIKitGradient {
            return KlikIDMColor.Gradient.greenforest
        }
        
        public static var sunflower: KlikIDMColor.UIKitGradient {
            return KlikIDMColor.Gradient.sunflower
        }
        
        // MARK: Poinku Gradients
        
        public static var blue: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.blue
        }
        
        public static var blue2: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.blue2
        }
        
        public static var gold: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.gold
        }
        
        public static var silver: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.silver
        }
        
        public static var diamond: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.diamond
        }
        
        public static var red: PoinkuColor.UIKitGradient {
            return PoinkuColor.Gradient.red
        }
    }
}
