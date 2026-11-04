Pod::Spec.new do |spec|
  spec.name         = "EDTS_DS_SwiftUI"
  spec.version      = "0.0.1"
  spec.summary      = "UI Components and Animation"
  spec.description  = "UI Components and Animation of EDTS Apps with SwiftUI"

  spec.homepage     = "https://github.com/rghinnaa-edts/EDTS_DS_SwiftUI"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rizka Ghinna" => "rizka.ghinna@sg-dsa.com", "Yovita Handayiani" => "yovita.handayiani@sg-dsa.com" }

  spec.platform     = :ios, "15.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/rghinnaa-edts/EDTS_DS_SwiftUI.git", :tag => spec.version.to_s }
  spec.framework    = "SwiftUI"

  # ──────────────────────────────────────────────────────────

  podspec_dir = File.dirname(__FILE__)
  set_resources_if_present = lambda do |ss, pattern|
    ss.resources = pattern unless Dir.glob(File.join(podspec_dir, pattern)).empty?
  end

  # ──────────────────────────────────────────────────────────
  # Assets (shared foundation — Color, Font, xcassets)
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Color' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Assets/Color/**/*.swift'
  end

  spec.subspec 'Font' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Assets/Font/**/*.swift'
    set_resources_if_present.call(ss, 'EDTS_DS_SwiftUI/Assets/Font/Inter/*.{ttf,otf}')
  end

  spec.subspec 'Assets' do |ss|
    ss.resource_bundle = { 'EDTS_DSAssets' => 'EDTS_DS_SwiftUI/Assets/**/*.xcassets' }
  end

  # ──────────────────────────────────────────────────────────
  # Animations
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Animations' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Animations/**/*.swift'
    ss.dependency 'EDTS_DS_SwiftUI/Color'
  end

  # ──────────────────────────────────────────────────────────
  # Helper
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Helper' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Helper/**/*.swift'
  end

  # ──────────────────────────────────────────────────────────
  # Extensions
  # ──────────────────────────────────────────────────────────

  # Extensions
  spec.subspec 'Extensions' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Extensions/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Extensions/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
  end

  # ──────────────────────────────────────────────────────────
  # General components (shared across all brands)
  # ──────────────────────────────────────────────────────────

  general_components = %w[
    Card Checkbox Chip
    Ribbon Search Skeleton
    StepPageNav Textfield Toggle Tooltip View
  ]

  general_components.each do |name|
    spec.subspec name do |ss|
      ss.source_files = "EDTS_DS_SwiftUI/Views/Components/General/#{name}/**/*.swift"
      set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/#{name}/**/*.xib")
      ss.dependency 'EDTS_DS_SwiftUI/Color'
      ss.dependency 'EDTS_DS_SwiftUI/Font'
      ss.dependency 'EDTS_DS_SwiftUI/Assets'
      ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    end
  end

  # Alertbox
  spec.subspec 'Alertbox' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Alertbox/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Alertbox/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
    ss.dependency 'EDTS_DS_SwiftUI/Shape'
  end

  # Badge
  spec.subspec 'Badge' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Badge/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Badge/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Skeleton'
  end

 # Button Default
  spec.subspec 'Button' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Button/Default/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Button/Default/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Signifier'
  end

  # Button Icon
  spec.subspec 'ButtonIcon' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Button/Icon/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Button/Icon/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
    ss.dependency 'EDTS_DS_SwiftUI/Signifier'
  end

 # Button Stepper
  spec.subspec 'ButtonStepper' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Button/Stepper/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Button/Stepper/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Signifier'
  end

  # Card Selection
  spec.subspec 'CardSelection' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Card/Selection/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Card/Selection/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
  end

  # Circular Loading
  spec.subspec 'CircularLoading' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/ProgressTracker/CircularLoading/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/ProgressTracker/CircularLoading/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/View'
    ss.dependency 'EDTS_DS_SwiftUI/ProgressTracker'
  end

  # Coachmark
  spec.subspec 'Coachmark' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Coachmark/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Coachmark/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
  end

  # Dialog
  spec.subspec 'Dialog' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Dialog/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Dialog/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
  end

  # Progress Tracker
  spec.subspec 'ProgressTracker' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/ProgressTracker/Default/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/ProgressTracker/Default/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/View'
  end

  # Radio Button
  spec.subspec 'RadioButton' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/RadioButton/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/RadioButton/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/View'
  end

# Shape
  spec.subspec 'Shape' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Shape/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Shape/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
  end

  # Signifier
  spec.subspec 'Signifier' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Signifier/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Signifier/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Skeleton'
  end

  # Tab
  spec.subspec 'Tab' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Tab/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Tab/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Chip'
    ss.dependency 'EDTS_DS_SwiftUI/Skeleton'
  end

  # Toast
  spec.subspec 'Toast' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Toast/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Toast/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
    ss.dependency 'EDTS_DS_SwiftUI/ButtonIcon'
  end

  # Tray
  spec.subspec 'Tray' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/General/Tray/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/General/Tray/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
  end

  # ──────────────────────────────────────────────────────────
  # KlikIDM brand-specific components (nested subspecs)
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Klik' do |klik|

  # Card Coupon Offered
  klik.subspec 'CouponOffered' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/CouponOffered/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/CouponOffered/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Badge'
    ss.dependency 'EDTS_DS_SwiftUI/Button'
    ss.dependency 'EDTS_DS_SwiftUI/Ribbon'
    ss.dependency 'EDTS_DS_SwiftUI/Helper'
  end

  # Card My Coupon
  klik.subspec 'MyCoupon' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/MyCoupon/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/MyCoupon/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Badge'
    ss.dependency 'EDTS_DS_SwiftUI/Ribbon'
    ss.dependency 'EDTS_DS_SwiftUI/View'
  end

  # Card Product
  klik.subspec 'Product' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/Product/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/Product/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
    ss.dependency 'EDTS_DS_SwiftUI/Badge'
    ss.dependency 'EDTS_DS_SwiftUI/ButtonStepper'
  end

  # Card Shopping Type
  klik.subspec 'ShoppingType' do |ss|
    ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/ShoppingType/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/KlikIDM/Card/ShoppingType/**/*.xib")
    ss.dependency 'EDTS_DS_SwiftUI/Color'
    ss.dependency 'EDTS_DS_SwiftUI/Font'
    ss.dependency 'EDTS_DS_SwiftUI/Assets'
    ss.dependency 'EDTS_DS_SwiftUI/Extensions'
  end

  end

  # ──────────────────────────────────────────────────────────
  # Poinku brand-specific components (nested subspecs)
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Poinku' do |poinku|

    poinku.subspec 'Card' do |card|

      card_components = %w[Coupon Poin Stamp]

      card_components.each do |name|
        card.subspec name do |ss|
          ss.source_files = "EDTS_DS_SwiftUI/Views/Components/Poinku/Card/#{name}/**/*.swift"
          set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/Poinku/Card/#{name}/**/*.xib")
          ss.dependency 'EDTS_DS_SwiftUI/Color'
          ss.dependency 'EDTS_DS_SwiftUI/Font'
          ss.dependency 'EDTS_DS_SwiftUI/Assets'
          ss.dependency 'EDTS_DS_SwiftUI/Extensions'
          ss.dependency 'EDTS_DS_SwiftUI/Font'
          ss.dependency 'EDTS_DS_SwiftUI/Ribbon'
        end
      end

    end   # closes 'Card'

    poinku.subspec 'OnBoarding' do |onboarding|

      # shared page control used by both V1 and V2
      onboarding.subspec 'PageControl' do |ss|
        ss.source_files = 'EDTS_DS_SwiftUI/Views/Components/Poinku/OnBoarding/EDTSPageControl.swift'
      end

      onboarding_versions = %w[OnBoardingV1 OnBoardingV2]

      onboarding_versions.each do |name|
        onboarding.subspec name do |ss|
          ss.source_files = "EDTS_DS_SwiftUI/Views/Components/Poinku/OnBoarding/#{name}/**/*.swift"
          set_resources_if_present.call(ss, "EDTS_DS_SwiftUI/Views/Components/Poinku/OnBoarding/**/*.xib")
          ss.dependency 'EDTS_DS_SwiftUI/Color'
          ss.dependency 'EDTS_DS_SwiftUI/Font'
          ss.dependency 'EDTS_DS_SwiftUI/Assets'
          ss.dependency 'EDTS_DS_SwiftUI/Extensions'
          ss.dependency 'EDTS_DS_SwiftUI/Poinku/OnBoarding/PageControl'
        end
      end

    end   # closes 'OnBoarding'

  end     # closes 'Poinku'

  # ──────────────────────────────────────────────────────────
  # Default install (bare `pod 'EDTS_DS_SwiftUI'` with no subspec)
  # ──────────────────────────────────────────────────────────

  spec.default_subspecs = 'Color', 'Font', 'Assets'

end
