//
//  Message.swift
//  CoreChat
//
//  Data model for individual chat messages
//

import Foundation

struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let sender: Sender
    let timestamp: Date
    var isStreaming: Bool = false

    init(id: UUID = UUID(), content: String, sender: Sender, timestamp: Date = Date(), isStreaming: Bool = false) {
        self.id = id
        self.content = content
        self.sender = sender
        self.timestamp = timestamp
        self.isStreaming = isStreaming
    }

    enum Sender: String, Codable {
        case user
        case ai
    }

    var isFromUser: Bool {
        sender == .user
    }
}
