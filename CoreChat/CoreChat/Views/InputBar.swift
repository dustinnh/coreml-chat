//
//  InputBar.swift
//  CoreChat
//
//  User input text field with send button
//

import SwiftUI

struct InputBar: View {
    @Binding var text: String
    let isGenerating: Bool
    let onSend: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Text input
            TextField("Message", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .lineLimit(1...6)
                .focused($isFocused)
                .disabled(isGenerating)
                .onSubmit {
                    if !text.isEmpty {
                        sendMessage()
                    }
                }

            // Send button
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(canSend ? .blue : .gray)
            }
            .disabled(!canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGenerating
    }

    private func sendMessage() {
        guard canSend else { return }
        HapticFeedback.light()
        onSend()
        text = ""
        isFocused = true
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Spacer()
        InputBar(text: .constant(""), isGenerating: false) {
            print("Send tapped")
        }
    }
}

#Preview("With Text") {
    VStack {
        Spacer()
        InputBar(text: .constant("Hello, this is a test message!"), isGenerating: false) {
            print("Send tapped")
        }
    }
}

#Preview("Generating") {
    VStack {
        Spacer()
        InputBar(text: .constant(""), isGenerating: true) {
            print("Send tapped")
        }
    }
}
