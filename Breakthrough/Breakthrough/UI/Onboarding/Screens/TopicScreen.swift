//
//  TopicScreen.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/22/26.
//

import SwiftUI
import SwiftData

struct TopicScreen: View {
    @Binding var selectedTopic: Topic?
    @Query(sort: \Topic.name) var topics: [Topic]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 80, height: 80)

                        Image(systemName: "quote.bubble")
                            .font(.system(size: 36))
                            .foregroundStyle(Color.orange.gradient)
                    }

                    Text("Select a Topic")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("What topic you would like to discuss")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 8)
                }

                VStack(spacing: 12) {
                    if topics.isEmpty {
                        Text("No topics available")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(topics) { topic in
                            SelectionCard(
                                title: topic.name,
                                subtitle: topic.summary,
                                isSelected: selectedTopic == topic) {
                                    selectedTopic = topic
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .task {
            selectedTopic = topics.first
        }
    }
}

#Preview {
    @Previewable @Query var topics: [Topic]
    @Previewable @State var selectedTopic: Topic?
    TopicScreen(selectedTopic: $selectedTopic)
        .modelContainer(ModelContainer.previewContainer)
}
