//
//  SettingsView.swift
//  CoreChat
//
//  Settings and configuration interface
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: ModelSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                // Model Mode Section
                Section {
                    Toggle("Use Simulated Responses", isOn: $settings.useSimulatedResponses)

                    if !settings.useSimulatedResponses {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Core ML model not yet integrated")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Model Mode")
                } footer: {
                    Text("Simulated mode allows testing the interface without a Core ML model. Switch to Core ML mode once you've added a model file.")
                }

                // Generation Parameters Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Temperature")
                            Spacer()
                            Text(String(format: "%.2f", settings.temperature))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.temperature, in: 0.0...2.0, step: 0.1)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Max Tokens")
                            Spacer()
                            Text("\(settings.maxTokens)")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: Binding(
                            get: { Double(settings.maxTokens) },
                            set: { settings.maxTokens = Int($0) }
                        ), in: 10...2048, step: 10)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Top P")
                            Spacer()
                            Text(String(format: "%.2f", settings.topP))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.topP, in: 0.0...1.0, step: 0.05)
                    }
                } header: {
                    Text("Generation Parameters")
                } footer: {
                    Text("Temperature controls randomness (0 = focused, 2 = creative). Max tokens limits response length. Top P controls diversity.")
                }

                // Model Information Section
                Section {
                    InfoRow(label: "Model Status", value: settings.useSimulatedResponses ? "Simulated" : "Core ML")
                    InfoRow(label: "Platform", value: "iOS 18+")
                    InfoRow(label: "Compute", value: "Neural Engine")
                } header: {
                    Text("Model Information")
                }

                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://developer.apple.com/documentation/coreml")!) {
                        HStack {
                            Text("Core ML Documentation")
                            Spacer()
                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(settings: .constant(ModelSettings()))
}
