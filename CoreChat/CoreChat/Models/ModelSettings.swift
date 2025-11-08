//
//  ModelSettings.swift
//  CoreChat
//
//  Configuration for AI model parameters
//

import Foundation

struct ModelSettings: Codable {
    var temperature: Double = 0.7
    var maxTokens: Int = 150
    var topP: Double = 0.9
    var useSimulatedResponses: Bool = true

    // Validation
    var validatedTemperature: Double {
        min(max(temperature, 0.0), 2.0)
    }

    var validatedMaxTokens: Int {
        min(max(maxTokens, 10), 2048)
    }

    var validatedTopP: Double {
        min(max(topP, 0.0), 1.0)
    }
}
