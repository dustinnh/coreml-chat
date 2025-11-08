//
//  ChatView.swift
//  CoreChat
//
//  Main chat interface
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Message list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            // Welcome message for empty state
                            if viewModel.conversation.messages.isEmpty {
                                emptyStateView
                            }

                            // Messages
                            ForEach(viewModel.conversation.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .defaultScrollAnchor(.bottom)
                    .onChange(of: viewModel.conversation.messages.count) { _, _ in
                        // Auto-scroll to bottom when new message arrives
                        if let lastMessage = viewModel.conversation.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: viewModel.conversation.messages.last?.content) { _, _ in
                        // Auto-scroll during streaming
                        if let lastMessage = viewModel.conversation.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }

                Divider()

                // Input bar
                InputBar(
                    text: $inputText,
                    isGenerating: viewModel.isGenerating,
                    onSend: {
                        viewModel.sendMessage(inputText)
                    }
                )
            }
            .navigationTitle("CoreChat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.conversation.messages.isEmpty {
                        Button(action: {
                            withAnimation {
                                viewModel.clearConversation()
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(settings: $viewModel.settings)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Welcome to CoreChat")
                .font(.title2)
                .fontWeight(.bold)

            Text("AI-powered conversations\nrunning on your iPhone 17")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Divider()
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(
                    icon: "cpu",
                    title: "On-Device AI",
                    description: "Powered by Core ML & Neural Engine"
                )

                FeatureRow(
                    icon: "lock.shield",
                    title: "Privacy First",
                    description: "Your conversations stay on device"
                )

                FeatureRow(
                    icon: "bolt.fill",
                    title: "Lightning Fast",
                    description: "Instant responses, zero latency"
                )
            }
            .padding(.horizontal, 32)

            Spacer()

            Text("Start a conversation below")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ChatView()
}
