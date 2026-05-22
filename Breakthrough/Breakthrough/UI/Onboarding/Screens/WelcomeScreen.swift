//
//  WelcomeScreen.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 2/15/26.
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 80, height: 80)

                        Image(systemName: "shippingbox")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.green.gradient)
                    }

                    Text("Hello, it's Breakthrough")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("Protocol Oriented View Architecture")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }

                VStack(spacing: 12) {
                    FeatureRow(
                        icon: "link.circle.fill",
                        title: "Logic Injection",
                        description: "Business logic lives in Protocol Extensions — composition over inheritance",
                        color: .purple
                    )

                    FeatureRow(
                        icon: "arrow.triangle.branch",
                        title: "Direct Environment",
                        description: "Access dependencies via @Environment — no manual injection",
                        color: .blue
                    )

                    FeatureRow(
                        icon: "square.split.2x1",
                        title: "State & Behavior Split",
                        description: "@Observable holds data while Protocol defines what happens",
                        color: .orange
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    WelcomeScreen()
}
