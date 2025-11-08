//
//  Conversation.swift
//  CoreChat
//
//  Container for chat conversation
//

import Foundation

struct Conversation: Identifiable, Codable {
    let id: UUID
    var messages: [Message]
    var title: String
    let createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), messages: [Message] = [], title: String = "New Chat", createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.messages = messages
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    mutating func addMessage(_ message: Message) {
        messages.append(message)
        updatedAt = Date()
    }

    mutating func updateLastMessage(content: String) {
        guard !messages.isEmpty else { return }
        var lastMessage = messages[messages.count - 1]
        lastMessage = Message(id: lastMessage.id, content: content, sender: lastMessage.sender, timestamp: lastMessage.timestamp, isStreaming: lastMessage.isStreaming)
        messages[messages.count - 1] = lastMessage
        updatedAt = Date()
    }
}
