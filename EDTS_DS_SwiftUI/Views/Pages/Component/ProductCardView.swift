//
//  ProductCardView.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 20/08/26.
//

import SwiftUI

// MARK: - Currency formatting extension

extension Int {
    /// Formats an Int as "RpXX.XXX", e.g. 50000 -> "Rp50.000"
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        let numberString = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "Rp\(numberString)"
    }
}

// MARK: - Gradient Badge (Gratis Hadiah / Paket Bundling / Banyak Lebih Hemat)

struct GradientBadgeView: View {
    let text: String
    let leadingColor: Color
    let trailingColor: Color
    var icon: String? = nil
    /// Which corners to round. Product card badges only round bottomRight
    /// so the badge sits flush against the image (top) and card edge (left).
    var corners: UIRectCorner = .allCorners
    var cornerRadius: CGFloat = 4

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }

            Text(text)
                .font(EDTSFont.Klik.B4.Semibold.font)
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            LinearGradient(
                colors: [leadingColor, trailingColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(cornerRadius, corners: corners)
    }
}

// MARK: - Button Stepper Variant

enum StepperVariant {
    case blue
    case white
}

// MARK: - Button Stepper (3 states x 2 variants)

struct ButtonStepperView: View {
    @Binding var quantity: Int
    let isActive: Bool
    var variant: StepperVariant = .blue
    let onActivate: () -> Void
    var onDeactivate: () -> Void = {}

    private let circleSize: CGFloat = 32
    private let expandedWidth: CGFloat = 100

    private var accentColor: Color { EDTSColor.blueDefault }
    private var disabledColor: Color { EDTSColor.disabled }

    private var currentWidth: CGFloat {
        isActive ? expandedWidth : circleSize
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Single persistent background shape. Its WIDTH is the only
            // thing that animates — a plain frame change, not a transition
            // between two different views — which is what gives the
            // "background just grows/shrinks" morph with no fade or scale.
            RoundedRectangle(cornerRadius: circleSize / 2)
                .fill(variant == .blue ? accentColor : EDTSColor.white)
                .overlay(
                    Group {
                        if variant == .white {
                            RoundedRectangle(cornerRadius: circleSize / 2)
                                .stroke(accentColor, lineWidth: 1)
                        }
                    }
                )
                .frame(width: currentWidth, height: circleSize)

            HStack(spacing: 8) {
                minusButton
                    .frame(width: 22, height: 22)

                quantityText

                Spacer(minLength: 0)
            }
            .padding(.leading, 10)
            .padding(.trailing, circleSize + 4) // reserve space for the trailing circle
            .frame(width: currentWidth, alignment: .leading)
            .opacity(isActive ? 1 : 0)

            trailingCircle
        }
        .frame(width: currentWidth, height: circleSize)
    }

    // MARK: Minus button (only visible/tappable while expanded)

    private var minusButton: some View {
        Button(action: {
            guard quantity > 0 else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                quantity -= 1
                if quantity == 0 {
                    onDeactivate()
                }
            }
        }) {
            Image(systemName: "minus")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(variant == .blue ? .white : accentColor)
        }
        .disabled(!isActive)
    }

    // MARK: Quantity text (only visible while expanded)

    private var quantityText: some View {
        Text("\(quantity)")
            .font(EDTSFont.Klik.B2.Semibold.font)
            .foregroundColor(variant == .blue ? .white : EDTSColor.grey70)
            .frame(minWidth: 16)
    }

    // MARK: Trailing circle — the ONE persistent tap target.
    // Shows "+" when idle, the count when collapsed-with-quantity, or "+"
    // again (to increment) while expanded. Never moves, never gets swapped.

    private var trailingCircle: some View {
        Button(action: {
            if quantity == 0 {
                withAnimation(.easeInOut(duration: 0.2)) {
                    quantity = 1
                    onActivate()
                }
            } else if isActive {
                withAnimation(.easeInOut(duration: 0.2)) {
                    quantity += 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    onActivate()
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(isActive ? (variant == .blue ? EDTSColor.white : accentColor) : Color.clear)
                    .padding(isActive ? 4 : 0)

                Group {
                    if isActive {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(variant == .blue ? accentColor : .white)
                    } else if quantity > 0 {
                        Text("\(quantity)")
                            .font(EDTSFont.Klik.B2.Semibold.font)
                            .foregroundColor(variant == .blue ? .white : accentColor)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(variant == .blue ? .white : accentColor)
                    }
                }
            }
            .frame(width: circleSize, height: circleSize)
        }
    }
}

// MARK: - Product Card Model

struct ProductCardModel: Identifiable {
    let id = UUID()
    let image: String
    let giftBadgeText: String?
    let giftBadgeLeadingColor: Color?
    let giftBadgeTrailingColor: Color?
    let title: String
    let price: Int
    let originalPrice: Int?
    let discountText: String?           // e.g. "50%"
    let hematBadgeText: String?         // e.g. "Banyak Lebih Hemat"
    let bundlingBadgeText: String?      // e.g. "Paket Bundling"
    let poin: Int?
    let stamp: Int?
    /// If set, the poin row reads "Beli {n}, +{poin} Poin" instead of "+{poin} Poin".
    let buyQuantityForPoin: Int?
    /// If set, the stamp row reads "Beli {n}, +{stamp} Stamp" instead of "+{stamp} Stamp".
    let buyQuantityForStamp: Int?

    init(
        image: String,
        giftBadgeText: String? = nil,
        giftBadgeLeadingColor: Color? = nil,
        giftBadgeTrailingColor: Color? = nil,
        title: String,
        price: Int,
        originalPrice: Int? = nil,
        discountText: String? = nil,
        hematBadgeText: String? = nil,
        bundlingBadgeText: String? = nil,
        poin: Int? = nil,
        stamp: Int? = nil,
        buyQuantityForPoin: Int? = nil,
        buyQuantityForStamp: Int? = nil
    ) {
        self.image = image
        self.giftBadgeText = giftBadgeText
        self.giftBadgeLeadingColor = giftBadgeLeadingColor
        self.giftBadgeTrailingColor = giftBadgeTrailingColor
        self.title = title
        self.price = price
        self.originalPrice = originalPrice
        self.discountText = discountText
        self.hematBadgeText = hematBadgeText
        self.bundlingBadgeText = bundlingBadgeText
        self.poin = poin
        self.stamp = stamp
        self.buyQuantityForPoin = buyQuantityForPoin
        self.buyQuantityForStamp = buyQuantityForStamp
    }
}

// MARK: - Product Card View

struct ProductCardView: View {
    let product: ProductCardModel
    @Binding var quantity: Int
    let isActive: Bool
    let onActivateStepper: () -> Void
    var onDeactivateStepper: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection

            // Gradient badge sits flush under the image and flush with the
            // card's left edge — no padding, only bottomRight is rounded.
            if let giftText = product.giftBadgeText,
               let leading = product.giftBadgeLeadingColor,
               let trailing = product.giftBadgeTrailingColor {
                GradientBadgeView(
                    text: giftText,
                    leadingColor: leading,
                    trailingColor: trailing,
                    corners: [.bottomRight],
                    cornerRadius: 6
                )
            }

            infoSection

            if product.poin != nil || product.stamp != nil {
                footerSection
            }
        }
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(EDTSColor.grey30, lineWidth: 1)
        )
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Image (1:1) + stepper
    //
    // FIX: using .overlay() instead of ZStack here is deliberate.
    // ZStack sizes itself to the union of all its children, so when the
    // stepper expands from a 32x32 circle into the wider "- 0 +" pill,
    // the ZStack (and the whole card) would grow wider to fit it —
    // which reflows sibling cards sharing the same staggered column.
    // .overlay() draws the stepper on top without affecting the
    // reported size of the image beneath it, so expanding the stepper
    // never changes this card's (or its column's) layout width.
    private var imageSection: some View {
        GeometryReader { proxy in
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.width)
                .clipped()
        }
        .aspectRatio(1, contentMode: .fit) // forces a square based on available width
        .cornerRadius(8, corners: [.topLeft, .topRight])
        .overlay(alignment: .topTrailing) {
            ButtonStepperView(
                quantity: $quantity,
                isActive: isActive,
                variant: .blue,
                onActivate: onActivateStepper,
                onDeactivate: onDeactivateStepper
            )
            .padding(8)
        }
    }

    // MARK: Title, price, badges

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.title)
                .font(EDTSFont.Klik.B2.Regular.font)
                .foregroundColor(EDTSColor.grey70)
                .lineLimit(2)

            Text(product.price.asCurrency)
                .font(EDTSFont.Klik.B2.Semibold.font)
                .foregroundColor(EDTSColor.grey70)

            if product.discountText != nil || product.originalPrice != nil {
                HStack(spacing: 6) {
                    if let discountText = product.discountText {
                        BadgeView(
                            text: discountText,
                            textColor: EDTSColor.red30,
                            backgroundColor: EDTSColor.red10,
                            horizontalPadding: 4,
                            verticalPadding: 1
                        )
                    }

                    if let originalPrice = product.originalPrice {
                        Text(originalPrice.asCurrency)
                            .font(EDTSFont.Klik.B4.Regular.font)
                            .foregroundColor(EDTSColor.grey40)
                            .strikethrough()
                    }
                }
            }

            if let hematText = product.hematBadgeText {
                BadgeView(
                    text: hematText,
                    textColor: EDTSColor.red30,
                    backgroundColor: EDTSColor.red10,
                    horizontalPadding: 4,
                    verticalPadding: 1
                )
            }

            if let bundlingText = product.bundlingBadgeText {
                BadgeView(
                    text: bundlingText,
                    textColor: EDTSColor.warningStrong,
                    backgroundColor: EDTSColor.warningWeak,
                    horizontalPadding: 4,
                    verticalPadding: 1
                )
            }
        }
        .padding(12)
    }

    // MARK: Poin / stamp footer

    /// "Beli {n}, +{value} {label}" when a buy quantity is set, else "+{value} {label}".
    private func footerText(value: Int, label: String, buyQuantity: Int?) -> String {
        if let buyQuantity {
            return "Beli \(buyQuantity), +\(value) \(label)"
        }
        return "+\(value) \(label)"
    }

    private func poinContent(_ poin: Int) -> some View {
        HStack(spacing: 4) {
            Image("ic_poin_old")
                .resizable()
                .frame(width: 14, height: 14)

            Text(footerText(value: poin, label: "Poin", buyQuantity: product.buyQuantityForPoin))
                .font(EDTSFont.Klik.B4.Semibold.font)
                .foregroundColor(EDTSColor.blue50)
                .lineLimit(1)
        }
    }

    private func stampContent(_ stamp: Int) -> some View {
        HStack(spacing: 4) {
            Image("ic_stamp_old")
                .resizable()
                .frame(width: 14, height: 14)

            Text(footerText(value: stamp, label: "Stamp", buyQuantity: product.buyQuantityForStamp))
                .font(EDTSFont.Klik.B4.Semibold.font)
                .foregroundColor(EDTSColor.blue50)
                .lineLimit(1)
        }
    }

    private var footerSection: some View {
        HStack(spacing: 0) {
            if let poin = product.poin, let stamp = product.stamp {
                // Both present: symmetric halves, each hugging the center divider.
                poinContent(poin)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Rectangle()
                    .fill(EDTSColor.blue20)
                    .frame(width: 1, height: 12)
                    .padding(.horizontal, 8)

                stampContent(stamp)
                    .frame(maxWidth: .infinity, alignment: .leading)

            } else if let poin = product.poin {
                // Only poin: centered across the full card width.
                poinContent(poin)
                    .frame(maxWidth: .infinity, alignment: .center)

            } else if let stamp = product.stamp {
                // Only stamp: centered across the full card width.
                stampContent(stamp)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(EDTSColor.blue10) // always spans full card width
    }
}

// MARK: - Staggered Product List

struct ProductStaggeredListView: View {
    let products: [ProductCardModel]
    /// Called with the sum of all product quantities whenever any of them
    /// changes. Invoked directly from the Binding's setter below (not via
    /// `.onChange(of:)`, which is iOS 14+) to stay iOS 13-compatible.
    var onQuantityChange: (Int) -> Void = { _ in }

    @State private var quantities: [UUID: Int] = [:]
    @State private var activeProductID: UUID? = nil

    private var leftColumn: [ProductCardModel] {
        products.enumerated().filter { $0.offset % 2 == 0 }.map(\.element)
    }

    private var rightColumn: [ProductCardModel] {
        products.enumerated().filter { $0.offset % 2 != 0 }.map(\.element)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(spacing: 8) {
                ForEach(leftColumn) { product in
                    cardView(for: product)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 8) {
                ForEach(rightColumn) { product in
                    cardView(for: product)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }

    private func cardView(for product: ProductCardModel) -> some View {
        ProductCardView(
            product: product,
            quantity: Binding(
                get: { quantities[product.id] ?? 0 },
                set: { newValue in
                    quantities[product.id] = newValue
                    onQuantityChange(quantities.values.reduce(0, +))
                }
            ),
            isActive: activeProductID == product.id,
            onActivateStepper: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    activeProductID = product.id
                }
            },
            onDeactivateStepper: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if activeProductID == product.id {
                        activeProductID = nil
                    }
                }
            }
        )
    }
}

//import SwiftUI
//
//// MARK: - Currency formatting extension
//
//extension Int {
//    /// Formats an Int as "RpXX.XXX", e.g. 50000 -> "Rp50.000"
//    var asCurrency: String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = "."
//        formatter.usesGroupingSeparator = true
//        let numberString = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
//        return "Rp\(numberString)"
//    }
//}
//
//// MARK: - Gradient Badge (Gratis Hadiah / Paket Bundling / Banyak Lebih Hemat)
//
//struct GradientBadgeView: View {
//    let text: String
//    let leadingColor: Color
//    let trailingColor: Color
//    var icon: String? = nil
//    /// Which corners to round. Product card badges only round bottomRight
//    /// so the badge sits flush against the image (top) and card edge (left).
//    var corners: UIRectCorner = .allCorners
//    var cornerRadius: CGFloat = 4
//
//    var body: some View {
//        HStack(spacing: 4) {
//            if let icon {
//                Image(icon)
//                    .renderingMode(.template)
//                    .resizable()
//                    .frame(width: 14, height: 14)
//                    .foregroundColor(.white)
//            }
//
//            Text(text)
//                .font(EDTSFont.Klik.B4.Semibold.font)
//                .foregroundColor(.white)
//                .lineLimit(1)
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//        .background(
//            LinearGradient(
//                colors: [leadingColor, trailingColor],
//                startPoint: .leading,
//                endPoint: .trailing
//            )
//        )
//        .cornerRadius(cornerRadius, corners: corners)
//    }
//}
//
//// MARK: - Button Stepper Variant
//
//enum StepperVariant {
//    case blue
//    case white
//}
//
//// MARK: - Button Stepper (3 states x 2 variants)
//
//struct ButtonStepperView: View {
//    @Binding var quantity: Int
//    let isActive: Bool
//    var variant: StepperVariant = .blue
//    let onActivate: () -> Void
//
//    private var accentColor: Color { EDTSColor.blueDefault }
//    private var disabledColor: Color { EDTSColor.disabled }
//
//    var body: some View {
//        Group {
//            if isActive {
//                expandedStepper
//                    .transition(activeTransition)
//            } else if quantity > 0 {
//                collapsedCountCircle
//                    .transition(.scale)
//            } else {
//                plusOnlyCircle
//                    .transition(.scale)
//            }
//        }
//    }
//
//    /// The expanded stepper morphs in/out from the right (where the circle
//    /// button sits) rather than fading/scaling like the circle states.
//    private var activeTransition: AnyTransition {
//        .asymmetric(
//            insertion: .move(edge: .trailing).combined(with: .opacity),
//            removal: .move(edge: .trailing).combined(with: .opacity)
//        )
//    }
//
//    // State 1: default, qty == 0, not active -> plain "+" circle
//    private var plusOnlyCircle: some View {
//        Button(action: {
//            withAnimation(.easeInOut(duration: 0.2)) {
//                quantity = 1
//                onActivate()
//            }
//        }) {
//            Circle()
//                .fill(variant == .blue ? accentColor : EDTSColor.white)
//                .frame(width: 32, height: 32)
//                .overlay(
//                    Image(systemName: "plus")
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(variant == .blue ? .white : accentColor)
//                )
//                .overlay(
//                    Circle().stroke(accentColor, lineWidth: variant == .blue ? 0 : 1)
//                )
//        }
//    }
//
//    // State 2: expanded, active -> "- qty +"
//    private var expandedStepper: some View {
//        HStack(spacing: 8) {
//            Button(action: {
//                guard quantity > 0 else { return }
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    quantity -= 1
//                }
//            }) {
//                Image(systemName: "minus")
//                    .font(.system(size: 12, weight: .semibold))
//                    .foregroundColor(
//                        quantity > 0
//                            ? (variant == .blue ? .white : accentColor)
//                            : disabledColor
//                    )
//                    .frame(width: 22, height: 22)
//                    .overlay(
//                        variant == .white
//                            ? AnyView(Circle().stroke(accentColor, lineWidth: 1))
//                            : AnyView(EmptyView())
//                    )
//            }
//            .disabled(quantity == 0)
//
//            Text("\(quantity)")
//                .font(EDTSFont.Klik.B2.Semibold.font)
//                .foregroundColor(variant == .blue ? .white : EDTSColor.grey70)
//                .frame(minWidth: 16)
//
//            Button(action: {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    quantity += 1
//                }
//            }) {
//                Image(systemName: "plus")
//                    .font(.system(size: 12, weight: .semibold))
//                    .foregroundColor(variant == .blue ? accentColor : .white)
//                    .frame(width: 22, height: 22)
//                    .background(Circle().fill(variant == .blue ? EDTSColor.white : accentColor))
//            }
//        }
//        .padding(4)
//        .background(Capsule().fill(variant == .blue ? accentColor : EDTSColor.white))
//        .overlay(
//            Capsule().stroke(variant == .blue ? Color.clear : accentColor, lineWidth: 1)
//        )
//    }
//
//    // State 3: collapsed, qty > 0, not active -> filled circle showing the number
//    private var collapsedCountCircle: some View {
//        Button(action: {
//            withAnimation(.easeInOut(duration: 0.2)) {
//                onActivate()
//            }
//        }) {
//            Circle()
//                .fill(variant == .blue ? accentColor : EDTSColor.white)
//                .frame(width: 32, height: 32)
//                .overlay(
//                    Text("\(quantity)")
//                        .font(EDTSFont.Klik.B2.Semibold.font)
//                        .foregroundColor(variant == .blue ? .white : accentColor)
//                )
//                .overlay(
//                    Circle().stroke(accentColor, lineWidth: variant == .blue ? 0 : 1)
//                )
//        }
//    }
//}
//
//// MARK: - Product Card Model
//
//struct ProductCardModel: Identifiable {
//    let id = UUID()
//    let image: String
//    let giftBadgeText: String?
//    let giftBadgeLeadingColor: Color?
//    let giftBadgeTrailingColor: Color?
//    let title: String
//    let price: Int
//    let originalPrice: Int?
//    let discountText: String?           // e.g. "50%"
//    let hematBadgeText: String?         // e.g. "Banyak Lebih Hemat"
//    let bundlingBadgeText: String?      // e.g. "Paket Bundling"
//    let poin: Int?
//    let stamp: Int?
//    /// If set, the poin row reads "Beli {n}, +{poin} Poin" instead of "+{poin} Poin".
//    let buyQuantityForPoin: Int?
//    /// If set, the stamp row reads "Beli {n}, +{stamp} Stamp" instead of "+{stamp} Stamp".
//    let buyQuantityForStamp: Int?
//
//    init(
//        image: String,
//        giftBadgeText: String? = nil,
//        giftBadgeLeadingColor: Color? = nil,
//        giftBadgeTrailingColor: Color? = nil,
//        title: String,
//        price: Int,
//        originalPrice: Int? = nil,
//        discountText: String? = nil,
//        hematBadgeText: String? = nil,
//        bundlingBadgeText: String? = nil,
//        poin: Int? = nil,
//        stamp: Int? = nil,
//        buyQuantityForPoin: Int? = nil,
//        buyQuantityForStamp: Int? = nil
//    ) {
//        self.image = image
//        self.giftBadgeText = giftBadgeText
//        self.giftBadgeLeadingColor = giftBadgeLeadingColor
//        self.giftBadgeTrailingColor = giftBadgeTrailingColor
//        self.title = title
//        self.price = price
//        self.originalPrice = originalPrice
//        self.discountText = discountText
//        self.hematBadgeText = hematBadgeText
//        self.bundlingBadgeText = bundlingBadgeText
//        self.poin = poin
//        self.stamp = stamp
//        self.buyQuantityForPoin = buyQuantityForPoin
//        self.buyQuantityForStamp = buyQuantityForStamp
//    }
//}
//
//// MARK: - Product Card View
//
//struct ProductCardView: View {
//    let product: ProductCardModel
//    @Binding var quantity: Int
//    let isActive: Bool
//    let onActivateStepper: () -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            imageSection
//
//            // Gradient badge sits flush under the image and flush with the
//            // card's left edge — no padding, only bottomRight is rounded.
//            if let giftText = product.giftBadgeText,
//               let leading = product.giftBadgeLeadingColor,
//               let trailing = product.giftBadgeTrailingColor {
//                GradientBadgeView(
//                    text: giftText,
//                    leadingColor: leading,
//                    trailingColor: trailing,
//                    corners: [.bottomRight],
//                    cornerRadius: 6
//                )
//            }
//
//            infoSection
//
//            if product.poin != nil || product.stamp != nil {
//                footerSection
//            }
//        }
//        .background(Color.clear)
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(EDTSColor.grey30, lineWidth: 1)
//        )
//        .cornerRadius(8)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//
//    // MARK: Image (1:1) + stepper
//    //
//    // FIX: using .overlay() instead of ZStack here is deliberate.
//    // ZStack sizes itself to the union of all its children, so when the
//    // stepper expands from a 32x32 circle into the wider "- 0 +" pill,
//    // the ZStack (and the whole card) would grow wider to fit it —
//    // which reflows sibling cards sharing the same staggered column.
//    // .overlay() draws the stepper on top without affecting the
//    // reported size of the image beneath it, so expanding the stepper
//    // never changes this card's (or its column's) layout width.
//    private var imageSection: some View {
//        GeometryReader { proxy in
//            Image(product.image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: proxy.size.width, height: proxy.size.width)
//                .clipped()
//        }
//        .aspectRatio(1, contentMode: .fit) // forces a square based on available width
//        .cornerRadius(8, corners: [.topLeft, .topRight])
//        .overlay(alignment: .topTrailing) {
//            ButtonStepperView(
//                quantity: $quantity,
//                isActive: isActive,
//                variant: .blue,
//                onActivate: onActivateStepper
//            )
//            .padding(8)
//        }
//    }
//
//    // MARK: Title, price, badges
//
//    private var infoSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(product.title)
//                .font(EDTSFont.Klik.B2.Regular.font)
//                .foregroundColor(EDTSColor.grey70)
//                .lineLimit(2)
//
//            Text(product.price.asCurrency)
//                .font(EDTSFont.Klik.B2.Semibold.font)
//                .foregroundColor(EDTSColor.grey70)
//
//            if product.discountText != nil || product.originalPrice != nil {
//                HStack(spacing: 6) {
//                    if let discountText = product.discountText {
//                        BadgeView(
//                            text: discountText,
//                            textColor: EDTSColor.red30,
//                            backgroundColor: EDTSColor.red10,
//                            horizontalPadding: 4,
//                            verticalPadding: 1
//                        )
//                    }
//
//                    if let originalPrice = product.originalPrice {
//                        Text(originalPrice.asCurrency)
//                            .font(EDTSFont.Klik.B4.Regular.font)
//                            .foregroundColor(EDTSColor.grey40)
//                            .strikethrough()
//                    }
//                }
//            }
//
//            if let hematText = product.hematBadgeText {
//                BadgeView(
//                    text: hematText,
//                    textColor: EDTSColor.red30,
//                    backgroundColor: EDTSColor.red10,
//                    horizontalPadding: 4,
//                    verticalPadding: 1
//                )
//            }
//
//            if let bundlingText = product.bundlingBadgeText {
//                BadgeView(
//                    text: bundlingText,
//                    textColor: EDTSColor.warningStrong,
//                    backgroundColor: EDTSColor.warningWeak,
//                    horizontalPadding: 4,
//                    verticalPadding: 1
//                )
//            }
//        }
//        .padding(12)
//    }
//
//    // MARK: Poin / stamp footer
//
//    /// "Beli {n}, +{value} {label}" when a buy quantity is set, else "+{value} {label}".
//    private func footerText(value: Int, label: String, buyQuantity: Int?) -> String {
//        if let buyQuantity {
//            return "Beli \(buyQuantity), +\(value) \(label)"
//        }
//        return "+\(value) \(label)"
//    }
//
//    private func poinContent(_ poin: Int) -> some View {
//        HStack(spacing: 4) {
//            Image("ic_poin_old")
//                .resizable()
//                .frame(width: 14, height: 14)
//
//            Text(footerText(value: poin, label: "Poin", buyQuantity: product.buyQuantityForPoin))
//                .font(EDTSFont.Klik.B4.Semibold.font)
//                .foregroundColor(EDTSColor.blue50)
//                .lineLimit(1)
//        }
//    }
//
//    private func stampContent(_ stamp: Int) -> some View {
//        HStack(spacing: 4) {
//            Image("ic_stamp_old")
//                .resizable()
//                .frame(width: 14, height: 14)
//
//            Text(footerText(value: stamp, label: "Stamp", buyQuantity: product.buyQuantityForStamp))
//                .font(EDTSFont.Klik.B4.Semibold.font)
//                .foregroundColor(EDTSColor.blue50)
//                .lineLimit(1)
//        }
//    }
//
//    private var footerSection: some View {
//        HStack(spacing: 0) {
//            if let poin = product.poin, let stamp = product.stamp {
//                // Both present: symmetric halves, each hugging the center divider.
//                poinContent(poin)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//
//                Rectangle()
//                    .fill(EDTSColor.blue20)
//                    .frame(width: 1, height: 12)
//                    .padding(.horizontal, 8)
//
//                stampContent(stamp)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//            } else if let poin = product.poin {
//                // Only poin: centered across the full card width.
//                poinContent(poin)
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//            } else if let stamp = product.stamp {
//                // Only stamp: centered across the full card width.
//                stampContent(stamp)
//                    .frame(maxWidth: .infinity, alignment: .center)
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(EDTSColor.blue10) // always spans full card width
//    }
//}
//
//// MARK: - Staggered Product List
//
//struct ProductStaggeredListView: View {
//    let products: [ProductCardModel]
//
//    @State private var quantities: [UUID: Int] = [:]
//    @State private var activeProductID: UUID? = nil
//
//    private var leftColumn: [ProductCardModel] {
//        products.enumerated().filter { $0.offset % 2 == 0 }.map(\.element)
//    }
//
//    private var rightColumn: [ProductCardModel] {
//        products.enumerated().filter { $0.offset % 2 != 0 }.map(\.element)
//    }
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 8) {
//            VStack(spacing: 8) {
//                ForEach(leftColumn) { product in
//                    cardView(for: product)
//                }
//            }
//            .frame(maxWidth: .infinity)
//
//            VStack(spacing: 8) {
//                ForEach(rightColumn) { product in
//                    cardView(for: product)
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .padding(.horizontal, 16)
//    }
//
//    private func cardView(for product: ProductCardModel) -> some View {
//        ProductCardView(
//            product: product,
//            quantity: Binding(
//                get: { quantities[product.id] ?? 0 },
//                set: { quantities[product.id] = $0 }
//            ),
//            isActive: activeProductID == product.id,
//            onActivateStepper: {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    activeProductID = product.id
//                }
//            }
//        )
//    }
//}
