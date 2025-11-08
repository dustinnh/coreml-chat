# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CoreChat is a native iOS chat application that runs AI models directly on-device using Core ML and the iPhone 17's Neural Engine. The project emphasizes privacy-first design with 100% on-device AI inference after initial model download.

**Platform:** iOS 18+ (iPhone 17 optimized)
**Tech Stack:** Swift, SwiftUI, Core ML 3+
**Development Stage:** Pre-implementation (PDR phase)

## Architecture

### Planned Directory Structure
```
CoreChat/
├── Models/
│   ├── ChatModel.swift           # Core ML wrapper
│   ├── ConversationManager.swift # State management
│   └── TokenizationEngine.swift  # Token handling
├── Views/
│   ├── ChatView.swift            # Main chat interface
│   ├── MessageBubble.swift       # Message UI components
│   └── InputBar.swift            # User input interface
├── ViewModels/
│   ├── ChatViewModel.swift       # Chat business logic
│   └── SettingsViewModel.swift   # Settings management
├── CoreML/
│   ├── ModelLoader.swift         # Model loading and caching
│   ├── InferenceEngine.swift     # Inference pipeline
│   └── PerformanceMonitor.swift  # Performance tracking
└── Utilities/
    ├── HapticFeedback.swift
    └── KeychainManager.swift
```

### Core ML Integration Pattern

The app uses Core ML 3+ models (.mlmodel, .mlpackage) with full Neural Engine optimization:

```swift
class ChatModelManager {
    private var model: MLModel?
    private let modelURL: URL

    func loadModel() async throws {
        let config = MLModelConfiguration()
        config.computeUnits = .all // Use Neural Engine
        model = try await MLModel.load(contentsOf: modelURL,
                                       configuration: config)
    }

    func generate(prompt: String, maxTokens: Int = 150) async -> String {
        // Tokenization → Inference → Detokenization pipeline
    }
}
```

### Key Design Patterns

- **Async/await** for all Core ML operations
- **Combine publishers** for reactive UI updates
- **Result types** for error handling
- **Protocol-oriented design** for testability
- **SwiftUI** with `@StateObject` and `@State` for view management

### Performance Requirements

- **Latency:** <100ms for first token (iPhone 17 ANE)
- **Throughput:** 30+ tokens/second sustained
- **Memory:** <500MB active footprint
- **Battery:** <5% drain per hour of active use

## Development Workflow

### Project Setup
Since this is a new project, the first step is to create the Xcode project:

1. Create Xcode project: `File → New → Project → iOS → App`
2. Configure for iOS 18+ deployment target
3. Enable Core ML capabilities
4. Set up folder structure as outlined above

### Building and Running
```bash
# Open project in Xcode
open CoreChat.xcodeproj  # or CoreChat.xcworkspace if using dependencies

# Build from command line (after project creation)
xcodebuild -scheme CoreChat -sdk iphoneos build

# Run tests
xcodebuild test -scheme CoreChat -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

### Testing Strategy
- **Unit Tests:** Core ML inference pipeline, tokenization accuracy
- **UI Tests:** Message flow, scrolling performance
- **Performance Tests:** Token generation speed, memory usage profiling
- **Device Tests:** iPhone 17-specific Neural Engine optimizations

## Implementation Phases

### Phase 1: Foundation (Week 1)
1. Initialize Xcode project with proper structure
2. Implement Core ML model loader with error handling
3. Create basic SwiftUI chat interface
4. Set up conversation state management
5. Implement basic tokenization

**Key Files:** `ContentView.swift`, `ChatModel.swift`, `Message.swift`, `ChatView.swift`

### Phase 2: Core ML Integration (Week 2)
1. Implement inference pipeline with async/await
2. Add token streaming support
3. Create response generation with temperature control
4. Implement context window management (2048 tokens initially)
5. Add performance monitoring

### Phase 3: Enhanced Features (Week 3)
1. Implement conversation persistence (Core Data)
2. Add model switching capability
3. Create settings interface for parameters
4. Implement export/import functionality
5. Add haptic feedback for interactions

## Error Handling Strategy

- **Model loading failures** → Cloud fallback mechanism
- **Memory pressure** → Context pruning to reduce footprint
- **Network issues** → Offline mode with request queuing
- **Inference errors** → Graceful degradation with user feedback

## Model Management

- **Storage:** `~/Library/Application Support/` for on-device models
- **Versioning:** Support model hot-swapping without app restart
- **Formats:** Core ML 3+ (.mlmodel, .mlpackage)
- **Target Models:** Start with Apple's pre-trained models (GPT-2 equivalent)

## SwiftUI Component Pattern

```swift
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText = ""

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                }
            }
            InputBar(text: $inputText, onSend: viewModel.sendMessage)
        }
    }
}
```

## Critical Implementation Notes

1. **Memory Management:** Use `LazyVStack` for chat history to avoid loading all messages
2. **Context Window:** Implement sliding window for token limit management (2048 tokens initially)
3. **Neural Engine:** Always set `MLModelConfiguration.computeUnits = .all` for iPhone 17 optimization
4. **Tokenization:** Implement efficient token buffer to minimize memory allocations
5. **UI Threading:** Keep inference off main thread using async/await patterns

## Success Metrics

- 90%+ on-device inference rate
- <2 second response generation (150 tokens)
- <0.1% crash rate
- 4.5+ user satisfaction

## Deployment

- **Initial:** TestFlight for user testing
- **Analytics:** Track performance metrics (token generation speed, memory usage)
- **A/B Testing:** Model variant performance comparison
- **Crash Reporting:** Integration for production monitoring
