//
//  DesignScreen.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/22/26.
//

import SwiftUI

struct DesignScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 80, height: 80)

                        Image(systemName: "square.3.layers.3d")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.blue.gradient)
                    }

                    Text("Layers of Architecture")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("Protocol Oriented View Architecture Design")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }

                VStack(spacing: 12) {
                    FeatureRow(
                        icon: "doc.text.fill",
                        title: "The Protocol",
                        description: "Defines the contract: required dependencies and business logic functions",
                        color: .green
                    )

                    FeatureRow(
                        icon: "wrench.and.screwdriver.fill",
                        title: "The Extension",
                        description: "Default logic implementation — write once, reuse everywhere",
                        color: .purple
                    )

                    FeatureRow(
                        icon: "display.and.arrow.down",
                        title: "The View",
                        description: "Conforms to the protocol, holds UI layout and manages State",
                        color: .orange
                    )
                }
                .padding(.horizontal, 20)

                HStack(spacing: 16) {
                    Link(destination: AppConstants.projectURL) {
                        HStack(spacing: 6) {
                            Text("Project GitHub")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "arrow.up.right.square")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    DesignScreen()
}
