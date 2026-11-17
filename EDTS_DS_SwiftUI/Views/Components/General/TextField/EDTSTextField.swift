//
//  EDTSTextField.swift
//  EDTS_DS_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 17/11/26.
//

import SwiftUI

// MARK: - State

public nonisolated enum EDTSTextFieldState: String, Equatable, Sendable {
    case `default` = "default"
    case focus = "focus"
    case error = "error"
    case disabled = "disabled"
}

public struct EDTSTextFieldStateValue<Value> {
    public var `default`: Value
    public var focus: Value
    public var error: Value
    public var disabled: Value

    public init(default defaultValue: Value, focus: Value, error: Value, disabled: Value) {
        self.default = defaultValue
        self.focus = focus
        self.error = error
        self.disabled = disabled
    }

    public init(_ value: Value) {
        self.default = value
        self.focus = value
        self.error = value
        self.disabled = value
    }

    func value(for state: EDTSTextFieldState) -> Value {
        switch state {
        case .default: return self.default
        case .focus: return focus
        case .error: return error
        case .disabled: return disabled
        }
    }
}

// MARK: - Style

public struct EDTSTextFieldStyle {

    public var titleColor = EDTSTextFieldStateValue<Color>(EDTSColor.grey60)
    public var placeholderColor = EDTSTextFieldStateValue<Color>(EDTSColor.grey50)
    public var valueColor = EDTSTextFieldStateValue<Color>(
        default: EDTSColor.grey80,
        focus: EDTSColor.grey80,
        error: EDTSColor.grey80,
        disabled: EDTSColor.grey60
    )
    public var iconLeadingTintColor = EDTSTextFieldStateValue<Color>(EDTSColor.grey60)
    public var iconTrailingTintColor = EDTSTextFieldStateValue<Color>(EDTSColor.grey60)
    public var bgColor = EDTSTextFieldStateValue<Color>(
        default: EDTSColor.white,
        focus: EDTSColor.white,
        error: EDTSColor.errorWeak,
        disabled: EDTSColor.grey20
    )
    public var borderWidth = EDTSTextFieldStateValue<CGFloat>(1)
    public var borderColor = EDTSTextFieldStateValue<Color>(
        default: EDTSColor.grey30,
        focus: EDTSColor.blue30,
        error: EDTSColor.errorStrong,
        disabled: EDTSColor.grey30
    )
    public var supportTextColor = EDTSTextFieldStateValue<Color>(
        default: EDTSColor.grey50,
        focus: EDTSColor.grey50,
        error: EDTSColor.errorStrong,
        disabled: EDTSColor.grey50
    )
    public var counterTextColor = EDTSTextFieldStateValue<Color>(
        default: EDTSColor.grey50,
        focus: EDTSColor.grey50,
        error: EDTSColor.errorStrong,
        disabled: EDTSColor.grey50
    )
    public var requiredTextColor: Color = EDTSColor.red30
    public var passwordIconTintColor: Color = EDTSColor.grey50
    public var clearIconTintColor: Color = EDTSColor.grey50
    public var iconPressColor: Color = EDTSColor.grey30.opacity(0.4)

    public var titleFont: Font = EDTSFont.Klik.H3.font
    public var valueFont: Font = EDTSFont.Klik.B2.Regular.font
    public var placeholderFont: Font = EDTSFont.Klik.B2.Regular.font
    public var supportFont: Font = EDTSFont.Klik.B4.Regular.font
    public var counterFont: Font = EDTSFont.Klik.B4.Regular.font

    public var cornerRadius: CGFloat = 4
    public var paddingTop: CGFloat = 12
    public var paddingBottom: CGFloat = 12
    public var paddingLeading: CGFloat = 12
    public var paddingTrailing: CGFloat = 12
    public var iconSize: CGFloat = 24
    public var iconSpacing: CGFloat = 8
    public var labelSpacing: CGFloat = 8
    public var supportSpacing: CGFloat = 4

    public init() {}
}

// MARK: - Icon press style

private struct EDTSTextFieldIconButtonStyle: ButtonStyle {
    let size: CGFloat
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Circle()
                    .fill(color)
                    .frame(width: size + 8, height: size + 8)
                    .opacity(configuration.isPressed ? 1 : 0)
            )
    }
}

// MARK: - Text Field

public struct EDTSTextField: View {

    @Binding public var text: String

    public var title: String?
    public var titleAttributed: AttributedString?
    public var placeholder: String?
    public var supportMessage: String?
    public var iconLeading: Image?
    public var iconTrailing: Image?

    public var state: EDTSTextFieldState
    public var isRequired: Bool
    public var isPassword: Bool
    public var isPasswordToggleHide: Bool
    public var isClearable: Bool
    public var isReadOnly: Bool
    public var counterMax: Int?
    public var isCounterHide: Bool
    public var keyboardType: UIKeyboardType
    public var submitLabel: SubmitLabel
    public var style: EDTSTextFieldStyle

    public var onIconLeadingTap: (() -> Void)?
    public var onIconTrailingTap: (() -> Void)?
    public var onSubmit: (() -> Void)?
    public var isFocused: Binding<Bool>?

    @FocusState private var internalFocus: Bool
    @State private var isPasswordVisible: Bool = false

    public init(
        text: Binding<String>,
        title: String? = nil,
        titleAttributed: AttributedString? = nil,
        placeholder: String? = nil,
        supportMessage: String? = nil,
        iconLeading: Image? = nil,
        iconTrailing: Image? = nil,
        state: EDTSTextFieldState = .default,
        isRequired: Bool = false,
        isPassword: Bool = false,
        isPasswordToggleHide: Bool = false,
        isClearable: Bool = false,
        isReadOnly: Bool = false,
        counterMax: Int? = nil,
        isCounterHide: Bool = false,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        style: EDTSTextFieldStyle = .init(),
        isFocused: Binding<Bool>? = nil,
        onIconLeadingTap: (() -> Void)? = nil,
        onIconTrailingTap: (() -> Void)? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.title = title
        self.titleAttributed = titleAttributed
        self.placeholder = placeholder
        self.supportMessage = supportMessage
        self.iconLeading = iconLeading
        self.iconTrailing = iconTrailing
        self.state = state
        self.isRequired = isRequired
        self.isPassword = isPassword
        self.isPasswordToggleHide = isPasswordToggleHide
        self.isClearable = isClearable
        self.isReadOnly = isReadOnly
        self.counterMax = counterMax
        self.isCounterHide = isCounterHide
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.style = style
        self.isFocused = isFocused
        self.onIconLeadingTap = onIconLeadingTap
        self.onIconTrailingTap = onIconTrailingTap
        self.onSubmit = onSubmit
    }

    // MARK: Derived state

    private var effectiveState: EDTSTextFieldState {
        switch state {
        case .disabled: return .disabled
        case .error: return .error
        case .focus: return .focus
        case .default: return internalFocus ? .focus : .default
        }
    }

    private var isInputDisabled: Bool {
        effectiveState == .disabled || isReadOnly
    }

    private var hasLabel: Bool {
        if titleAttributed != nil { return true }
        return !(title ?? "").isEmpty
    }

    private var showsCounter: Bool {
        guard let counterMax, counterMax >= 0 else { return false }
        return !isCounterHide
    }

    private var showsSupportRow: Bool {
        supportMessage != nil || showsCounter
    }

    private var hasTrailing: Bool {
        if isPassword { return !isPasswordToggleHide }
        return isClearable || iconTrailing != nil
    }

    // MARK: Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            fieldBox

            if showsSupportRow {
                supportRow
                    .padding(.top, style.supportSpacing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.25), value: effectiveState)
        .onChange(of: text) { newValue in
            if let counterMax, counterMax >= 0, newValue.count > counterMax {
                text = String(newValue.prefix(counterMax))
            }
        }
        .onChange(of: internalFocus) { newValue in
            isFocused?.wrappedValue = newValue
        }
        .onChange(of: isFocused?.wrappedValue) { newValue in
            if let newValue, newValue != internalFocus {
                internalFocus = newValue
            }
        }
    }

    // MARK: Field box

    private var fieldBox: some View {
        HStack(spacing: 0) {
            if let iconLeading {
                iconView(iconLeading,
                         color: style.iconLeadingTintColor.value(for: effectiveState),
                         action: onIconLeadingTap)
                    .padding(.trailing, style.iconSpacing)
            }

            VStack(alignment: .leading, spacing: 0) {
                if hasLabel {
                    labelRow
                        .padding(.bottom, style.labelSpacing)
                }
                inputField
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if hasTrailing {
                trailingView
                    .padding(.leading, style.iconSpacing)
            }
        }
        .padding(EdgeInsets(top: style.paddingTop,
                            leading: style.paddingLeading,
                            bottom: style.paddingBottom,
                            trailing: style.paddingTrailing))
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.bgColor.value(for: effectiveState))
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor.value(for: effectiveState),
                        lineWidth: style.borderWidth.value(for: effectiveState))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if !isInputDisabled { internalFocus = true }
        }
    }

    private var labelRow: some View {
        HStack(spacing: 2) {
            Group {
                if let titleAttributed {
                    Text(titleAttributed)
                } else {
                    Text(title ?? "")
                }
            }
            .font(style.titleFont)
            .foregroundColor(style.titleColor.value(for: effectiveState))
            .lineLimit(1)

            if isRequired {
                Text("*")
                    .font(style.titleFont)
                    .foregroundColor(style.requiredTextColor)
            }
        }
    }

    private var inputField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty, let placeholder, !placeholder.isEmpty {
                Text(placeholder)
                    .font(style.placeholderFont)
                    .foregroundColor(style.placeholderColor.value(for: effectiveState))
                    .lineLimit(1)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }

            Group {
                if isPassword && !isPasswordVisible {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .font(style.valueFont)
            .foregroundColor(style.valueColor.value(for: effectiveState))
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .focused($internalFocus)
            .onSubmit { onSubmit?() }
            .disabled(isInputDisabled)
            .accessibilityLabel(title ?? placeholder ?? "")
        }
        .frame(height: 20)
    }

    // MARK: Icons

    @ViewBuilder
    private var trailingView: some View {
        if isPassword {
            if !isPasswordToggleHide {
                iconView(
                    Image(isPasswordVisible ? "ic_visibility_on" : "ic_visibility_off", bundle: .edtsDS),
                    color: style.passwordIconTintColor,
                    accessibilityLabel: isPasswordVisible ? "Hide password" : "Show password",
                    action: togglePasswordVisibility
                )
            }
        } else if isClearable {
            iconView(
                Image("ic_error", bundle: .edtsDS),
                color: style.clearIconTintColor,
                accessibilityLabel: "Clear text",
                action: { text = "" }
            )
            .opacity(text.isEmpty ? 0 : 1)
            .allowsHitTesting(!text.isEmpty)
            .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        } else if let iconTrailing {
            iconView(iconTrailing,
                     color: style.iconTrailingTintColor.value(for: effectiveState),
                     action: onIconTrailingTap)
        }
    }

    @ViewBuilder
    private func iconView(_ image: Image,
                          color: Color,
                          accessibilityLabel: String? = nil,
                          action: (() -> Void)?) -> some View {
        let icon = image
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: style.iconSize, height: style.iconSize)
            .foregroundColor(color)

        if let action {
            Button(action: action) { icon }
                .buttonStyle(EDTSTextFieldIconButtonStyle(size: style.iconSize,
                                                          color: style.iconPressColor))
                .accessibilityLabel(accessibilityLabel ?? "")
        } else {
            icon.accessibilityHidden(true)
        }
    }

    private func togglePasswordVisibility() {
        let wasFocused = internalFocus
        isPasswordVisible.toggle()

        // The field is swapped between SecureField and TextField, which drops the focus
        if wasFocused {
            DispatchQueue.main.async { internalFocus = true }
        }
    }

    // MARK: Support row

    private var supportRow: some View {
        HStack(alignment: .top, spacing: 8) {
            if let supportMessage {
                Text(supportMessage)
                    .font(style.supportFont)
                    .foregroundColor(style.supportTextColor.value(for: effectiveState))
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer(minLength: 0)
            }

            if showsCounter, let counterMax {
                Text("\(text.count)/\(counterMax)")
                    .font(style.counterFont)
                    .foregroundColor(style.counterTextColor.value(for: effectiveState))
                    .fixedSize()
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
private struct EDTSTextFieldPreviewHost: View {
    @State private var name = ""
    @State private var email = "rizka@example.com"
    @State private var password = ""
    @State private var bio = ""
    @State private var search = "Indomaret"
    @State private var locked = "Tidak bisa diubah"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                EDTSTextField(
                    text: $name,
                    title: "Nama lengkap",
                    placeholder: "Masukkan nama",
                    supportMessage: "Sesuai KTP",
                    isRequired: true
                )

                EDTSTextField(
                    text: $email,
                    title: "Email",
                    placeholder: "Masukkan email",
                    supportMessage: "Format email tidak valid",
                    state: .error,
                    keyboardType: .emailAddress
                )

                EDTSTextField(
                    text: $password,
                    title: "Password",
                    placeholder: "Masukkan password",
                    isPassword: true
                )

                EDTSTextField(
                    text: $bio,
                    title: "Bio",
                    placeholder: "Ceritakan tentang kamu",
                    counterMax: 50
                )

                EDTSTextField(
                    text: $search,
                    placeholder: "Cari",
                    iconLeading: Image(systemName: "magnifyingglass"),
                    isClearable: true
                )

                EDTSTextField(
                    text: $locked,
                    title: "Nonaktif",
                    state: .disabled
                )
            }
            .padding()
        }
    }
}

#Preview {
    EDTSTextFieldPreviewHost()
}
#endif
