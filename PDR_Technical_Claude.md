# Core ML Chat App - Technical Product Design Requirements
## For Claude (AI Developer)

### Project Overview
**Product Name:** CoreChat  
**Platform:** iOS 18+ (iPhone 17 optimized)  
**Core Technology:** Core ML, Swift, SwiftUI  
**Development Approach:** AI-Driven Development with Claude as primary developer

### Technical Architecture

#### 1. Core ML Integration
- **Model Format:** Core ML 3+ models (.mlmodel, .mlpackage)
- **Target Models:**
  - Start with Apple's pre-trained models (GPT-2 equivalent)
  - Support for custom fine-tuned models
  - Eventual migration from cloud-based Claude API to on-device
- **Neural Engine Optimization:** Full utilization of iPhone 17's ANE
- **Model Management:**
  - On-device model storage (~/Library/Application Support/)
  - Model versioning and hot-swapping capability
  - Fallback to cloud when model unavailable

#### 2. Application Architecture
```
CoreChat/
├── Models/
│   ├── ChatModel.swift (Core ML wrapper)
│   ├── ConversationManager.swift
│   └── TokenizationEngine.swift
├── Views/
│   ├── ChatView.swift (main interface)
│   ├── MessageBubble.swift
│   └── InputBar.swift
├── ViewModels/
│   ├── ChatViewModel.swift
│   └── SettingsViewModel.swift
├── CoreML/
│   ├── ModelLoader.swift
│   ├── InferenceEngine.swift
│   └── PerformanceMonitor.swift
└── Utilities/
    ├── HapticFeedback.swift
    └── KeychainManager.swift
```

### Development Phases

#### Phase 1: Foundation (Week 1)
**Claude Tasks:**
1. Initialize Xcode project with proper structure
2. Implement Core ML model loader with error handling
3. Create basic SwiftUI chat interface
4. Set up conversation state management
5. Implement basic tokenization

**Key Files to Create:**
- `ContentView.swift` - Main app entry
- `ChatModel.swift` - Core ML wrapper class
- `Message.swift` - Data model
- `ChatView.swift` - Primary UI

#### Phase 2: Core ML Integration (Week 2)
**Claude Tasks:**
1. Implement inference pipeline
2. Add token streaming support
3. Create response generation with temperature control
4. Implement context window management (2048 tokens initially)
5. Add performance monitoring

**Technical Requirements:**
- Async/await pattern for inference
- Combine framework for reactive UI updates
- Memory-efficient token buffer management

#### Phase 3: Enhanced Features (Week 3)
**Claude Tasks:**
1. Implement conversation persistence (Core Data)
2. Add model switching capability
3. Create settings interface for parameters
4. Implement export/import functionality
5. Add haptic feedback for interactions
### Implementation Details

#### Core ML Model Integration
```swift
// Example implementation pattern for Claude to follow
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

#### Performance Targets
- **Latency:** <100ms for first token (iPhone 17 ANE)
- **Throughput:** 30+ tokens/second sustained
- **Memory:** <500MB active footprint
- **Battery:** <5% drain per hour of active use

#### SwiftUI Component Structure
```swift
// Main chat interface pattern
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

### Testing Strategy
1. **Unit Tests:** Core ML inference, tokenization accuracy
2. **UI Tests:** Message flow, scrolling performance
3. **Performance Tests:** Token generation speed, memory usage
4. **Device Tests:** iPhone 17 specific optimizations

### API Design Patterns
- Async/await for all Core ML operations
- Combine publishers for UI reactivity
- Result types for error handling
- Protocol-oriented design for testability

### Error Handling
- Model loading failures → Cloud fallback
- Memory pressure → Context pruning
- Network issues → Offline mode with queuing

### Deployment Considerations
- TestFlight initial release
- A/B testing for model variants
- Analytics for performance tracking
- Crash reporting integration

### Success Metrics
- 90%+ on-device inference rate
- <2 second response generation (150 tokens)
- 4.5+ App Store rating
- <0.1% crash rate

---
*This PDR is optimized for Claude's implementation. Request specific sections for deeper technical details during development.*