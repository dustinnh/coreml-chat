//
//  MessageBubble.swift
//  CoreChat
//
//  Individual message bubble component
//

import SwiftUI

struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer(minLength: 50)
            }

            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                // Message content
                Text(message.content.isEmpty ? " " : message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.isFromUser ? Color.userBubble : Color.aiBubble)
                    .foregroundColor(message.isFromUser ? Color.userText : Color.aiText)
                    .cornerRadius(18)
                    .overlay(
                        // Streaming indicator
                        Group {
                            if message.isStreaming {
                                HStack(spacing: 4) {
                                    Spacer()
                                    TypingIndicator()
                                }
                                .padding(.trailing, 12)
                            }
                        }
                    )

                // Timestamp
                Text(message.timestamp.timeString)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }

            if !message.isFromUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var animationPhase = 0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 6, height: 6)
                    .scaleEffect(animationPhase == index ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            animationPhase = 1
        }
    }
}

// MARK: - Preview

#Preview("User Message") {
    MessageBubble(message: Message(
        content: "Hello! This is a test message from the user.",
        sender: .user
    ))
}

#Preview("AI Message") {
    MessageBubble(message: Message(
        content: "Hi there! I'm an AI assistant running on your iPhone.",
        sender: .ai
    ))
}

#Preview("Streaming Message") {
    MessageBubble(message: Message(
        content: "This message is being generated...",
        sender: .ai,
        isStreaming: true
    ))
}
