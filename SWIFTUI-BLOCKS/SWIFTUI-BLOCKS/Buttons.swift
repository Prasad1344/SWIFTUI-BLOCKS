//
//  Buttons.swift
//  SwiftUIBlocks
//
//  Created by Prasad Upputuri on 2/27/25.
//
import SwiftUI

// MARK: - Custom Button Configuration
public struct CustomButtonConfig {
    let title: String
    let icon: String? // Optional SF Symbol for icon (e.g., "star.fill")
    let style: ButtonStyle
    let foregroundColor: Color
    let backgroundColor: Color
    let borderColor: Color?
    let borderWidth: CGFloat
    let fontSize: CGFloat // Separated font size for customization
    let fontWeight: Font.Weight // Added font weight for customization
    let padding: CGFloat
    let cornerRadius: CGFloat
    let width: CGFloat? // Optional width (nil for maxWidth)
    let height: CGFloat? // Optional height
    let isEnabled: Bool
    let hasShadow: Bool
    let showProgress: Bool // Toggle ProgressView
    let progressTintColor: Color
    let gradientColors: [Color]? // For gradient style
    
    public enum ButtonStyle {
        case plain
        case bordered
        case filled
        case gradientLoading
        case neumorphic
        case glass
    }
    
    public static let defaultConfig = CustomButtonConfig(
        title: "Button",
        icon: nil,
        style: .filled,
        foregroundColor: .white,
        backgroundColor: .blue,
        borderColor: nil,
        borderWidth: 2,
        fontSize: 16, // Default font size
        fontWeight: .semibold, // Default font weight
        padding: 12,
        cornerRadius: 8,
        width: nil, // Default to maxWidth
        height: nil, // Default to flexible height
        isEnabled: true,
        hasShadow: true,
        showProgress: false,
        progressTintColor: .white,
        gradientColors: nil
    )
}

// MARK: - Custom Button View
public struct CustomButton: View {
    let config: CustomButtonConfig
    let action: () -> Void
    
    public init(config: CustomButtonConfig, action: @escaping () -> Void) {
        self.config = config
        self.action = action
    }
    
    public init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.init(config: CustomButtonConfig(
            title: title,
            icon: icon,
            style: .filled,
            foregroundColor: .white,
            backgroundColor: .blue,
            borderColor: nil,
            borderWidth: 2,
            fontSize: 16,
            fontWeight: .semibold,
            padding: 12,
            cornerRadius: 8,
            width: nil,
            height: nil,
            isEnabled: true,
            hasShadow: true,
            showProgress: false,
            progressTintColor: .white,
            gradientColors: nil
        ), action: action)
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = config.icon {
                    Image(systemName: icon)
                        .foregroundColor(config.foregroundColor)
                }
                
                if config.showProgress {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: config.progressTintColor))
                        .scaleEffect(0.8)
                }
                
                Text(config.title)
                    .font(.system(size: config.fontSize, weight: config.fontWeight))
                    .foregroundColor(config.foregroundColor)
            }
            .padding(config.padding)
            .frame(maxWidth: config.width ?? .infinity, maxHeight: config.height)
        }
        .background(backgroundView)
        .cornerRadius(config.cornerRadius)
        .shadow(radius: config.hasShadow ? 4 : 0)
        .overlay(
            borderView // Use overlay with conditional logic inside
        )
        .disabled(!config.isEnabled)
        .opacity(config.isEnabled ? 1.0 : 0.6)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch config.style {
        case .plain:
            Color.clear
            
        case .bordered:
            Color.clear
            
        case .filled:
            config.backgroundColor
            
        case .gradientLoading:
            LinearGradient(
                colors: config.gradientColors ?? [Color.red, Color.blue],
                startPoint: .leading,
                endPoint: .trailing
            )
            
        case .neumorphic:
            Color.white
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.7), radius: 5, x: -5, y: -5)
            
        case .glass:
            Color.white.opacity(0.2)
                .blur(radius: 2)
        }
    }
    
    @ViewBuilder
    private var borderView: some View {
        if config.style == .bordered || config.style == .glass {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .stroke(config.borderColor ?? config.backgroundColor, lineWidth: config.borderWidth)
                .opacity(config.style == .glass ? 0.5 : 1.0)
        }
    }
}

// MARK: - Extensions
extension CustomButton {
    public init(title: String, action: @escaping () -> Void) {
        self.init(title: title, icon: nil, action: action)
    }
}

// MARK: - Demo View
struct ButtonDemoView: View {
    @State private var counter = 0
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Plain Button
            CustomButton(title: "Plain Button") {
                counter += 1
            }
            
            // Bordered Button
            
            CustomButton(config: CustomButtonConfig(
                title: "Bordered Button",
                icon: nil,
                style: .bordered,
                foregroundColor: .purple,
                backgroundColor: .clear,
                borderColor: .purple,
                borderWidth: 2,
                fontSize: 16,
                fontWeight: .regular,
                padding: 10,
                cornerRadius: 8,
                width: 220,
                height: 45,
                isEnabled: true,
                hasShadow: false,
                showProgress: false,
                progressTintColor: .purple,
                gradientColors: nil
            ), action: {
                counter += 1
            })
            
            // Filled Button
            
            CustomButton(config: CustomButtonConfig(
                title: "Filled Button",
                icon: nil,
                style: .filled,
                foregroundColor: .white,
                backgroundColor: .green,
                borderColor: nil,
                borderWidth: 0,
                fontSize: 16,
                fontWeight: .bold,
                padding: 12,
                cornerRadius: 8,
                width: 200,
                height: 50,
                isEnabled: true,
                hasShadow: true,
                showProgress: false,
                progressTintColor: .white,
                gradientColors: nil
            ), action: {
                counter += 1
            })
            
            // Gradient Loading Button
            
            CustomButton(config: CustomButtonConfig(
                title: "Gradient Loading",
                icon: nil,
                style: .gradientLoading,
                foregroundColor: .white,
                backgroundColor: .clear,
                borderColor: nil,
                borderWidth: 0,
                fontSize: 16,
                fontWeight: .semibold,
                padding: 12,
                cornerRadius: 8,
                width: 230,
                height: 50,
                isEnabled: !isLoading,
                hasShadow: true,
                showProgress: isLoading,
                progressTintColor: .white,
                gradientColors: [Color.red, Color.blue]
            ), action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
                counter += 1
            })
            
            // Neumorphic Button

            
            CustomButton(config: CustomButtonConfig(
                title: "Neumorphic",
                icon: nil,
                style: .neumorphic,
                foregroundColor: .gray,
                backgroundColor: .white,
                borderColor: nil,
                borderWidth: 0,
                fontSize: 16,
                fontWeight: .medium,
                padding: 12,
                cornerRadius: 12,
                width: 210,
                height: 45,
                isEnabled: true,
                hasShadow: true,
                showProgress: false,
                progressTintColor: .gray,
                gradientColors: nil
            ), action: {
                counter += 1
            })
            
            // Glass Button
            
            CustomButton(config: CustomButtonConfig(
                title: "Glass Button",
                icon: "star.fill",
                style: .glass,
                foregroundColor: .black,
                backgroundColor: .clear,
                borderColor: .black,
                borderWidth: 1,
                fontSize: 16,
                fontWeight: .regular,
                padding: 12,
                cornerRadius: 12,
                width: 220,
                height: 50,
                isEnabled: true,
                hasShadow: false,
                showProgress: false,
                progressTintColor: .black,
                gradientColors: nil
            ), action: {
                counter += 1
            })
            
            Text("Counter: \(counter)")
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding()
    }
}

// MARK: - Previews
struct CustomButtonPreviews: PreviewProvider {
    static var previews: some View {
        ButtonDemoView()
    }
}
