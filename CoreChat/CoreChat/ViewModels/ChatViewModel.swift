//
//  ChatViewModel.swift
//  CoreChat
//
//  Business logic for chat interface
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var conversation: Conversation
    @Published var settings: ModelSettings
    @Published var isGenerating = false
    @Published var errorMessage: String?

    private let modelManager: ModelManager

    init(modelManager: ModelManager = ModelManager()) {
        self.conversation = Conversation()
        self.settings = ModelSettings()
        self.modelManager = modelManager
    }

    // MARK: - Public Methods

    func sendMessage(_ content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isGenerating else { return }

        // Add user message
        let userMessage = Message(content: content, sender: .user)
        conversation.addMessage(userMessage)

        // Generate AI response
        Task {
            await generateResponse()
        }
    }

    func regenerateLastResponse() {
        // Remove last AI message if exists
        if let lastMessage = conversation.messages.last, lastMessage.sender == .ai {
            conversation.messages.removeLast()
        }

        Task {
            await generateResponse()
        }
    }

    func clearConversation() {
        conversation = Conversation()
    }

    // MARK: - Private Methods

    private func generateResponse() async {
        isGenerating = true
        errorMessage = nil

        // Create placeholder AI message
        let aiMessage = Message(content: "", sender: .ai, isStreaming: true)
        conversation.addMessage(aiMessage)

        do {
            // Get context (last 10 messages for now)
            let context = conversation.messages
                .suffix(10)
                .map { "\($0.sender == .user ? "User" : "Assistant"): \($0.content)" }
                .joined(separator: "\n")

            if settings.useSimulatedResponses {
                // Simulated streaming response
                await simulateStreamingResponse(context: context)
            } else {
                // Real Core ML inference (placeholder)
                let response = try await modelManager.generate(
                    prompt: context,
                    maxTokens: settings.validatedMaxTokens,
                    temperature: settings.validatedTemperature
                )
                conversation.updateLastMessage(content: response)
            }

        } catch {
            errorMessage = "Failed to generate response: \(error.localizedDescription)"
            conversation.messages.removeLast() // Remove placeholder message
        }

        isGenerating = false
    }

    private func simulateStreamingResponse(context: String) async {
        let responses = [
            "I'm a simulated AI response running on your iPhone! The real Core ML model will go here once you add it.",
            "This is pretty cool! I can chat with you in a beautiful interface while we wait for the actual language model to be integrated.",
            "Once we add the Core ML model, I'll be running entirely on your iPhone 17's Neural Engine - no internet required!",
            "The interface is fully functional. Try asking me different questions to see how the chat flows!",
            "Privacy first! When the real model is added, all your conversations will stay on your device.",
            "The typing animation you're seeing? That's simulating real token streaming from a language model.",
            "Pretty responsive, right? That's the power of SwiftUI and async/await working together."
        ]

        let response = responses.randomElement() ?? responses[0]

        // Simulate typing effect
        for char in response {
            conversation.updateLastMessage(content: conversation.messages.last!.content + String(char))
            try? await Task.sleep(nanoseconds: 20_000_000) // 20ms per character
        }

        // Mark streaming as complete
        if var lastMessage = conversation.messages.last {
            lastMessage = Message(
                id: lastMessage.id,
                content: lastMessage.content,
                sender: lastMessage.sender,
                timestamp: lastMessage.timestamp,
                isStreaming: false
            )
            conversation.messages[conversation.messages.count - 1] = lastMessage
        }
    }
}
