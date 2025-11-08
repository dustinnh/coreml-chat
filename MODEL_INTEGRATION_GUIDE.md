# Core ML Model Integration Guide

This guide explains how to integrate a real Core ML language model into CoreChat when you're ready.

## Overview

CoreChat is currently running in **simulated mode** with canned responses. When you add a Core ML model, it will:

1. Load the model on app launch
2. Run inference using the iPhone 17 Neural Engine
3. Generate real AI responses on-device
4. Tokenize/detokenize using Swift Transformers

## Model Requirements

### Recommended Models

**Llama 3.1-8B (Quantized)**
- Size: ~4-5GB (Int4 quantized)
- Performance: ~33 tokens/s on M1 Max (similar on iPhone 17)
- Quality: Excellent for chat
- Memory: Requires 8GB+ RAM device

**Gemma 2B**
- Size: ~1-2GB (quantized)
- Performance: Faster inference
- Quality: Good for basic chat
- Memory: Works on 6GB+ RAM devices

**GPT-2 (Small)**
- Size: ~500MB
- Performance: Very fast
- Quality: Basic, but good for testing
- Memory: Works on all devices

### Technical Requirements

- Format: `.mlmodel` or `.mlpackage`
- Core ML version: 3+
- Optimization: Int4 or Int8 quantization recommended
- Stateful: KV cache support preferred for efficiency

## Step 1: Get a Core ML Model

### Option A: Convert from Hugging Face (Advanced)

If you have Python and want to convert a model yourself:

```bash
# Install coremltools
pip install coremltools transformers torch

# Python script to convert
python convert_to_coreml.py
```

Example conversion script:

```python
import coremltools as ct
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# Load model from Hugging Face
model_name = "meta-llama/Llama-3.1-8B-Instruct"
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Convert to Core ML
mlmodel = ct.convert(
    model,
    inputs=[ct.TensorType(shape=(1, 512), dtype=np.int32)],
    compute_units=ct.ComputeUnit.ALL,  # Neural Engine
    minimum_deployment_target=ct.target.iOS18,
    compute_precision=ct.precision.FLOAT16
)

# Apply Int4 quantization
quantized_model = ct.compression.quantize_weights(
    mlmodel,
    mode="linear_quantization",
    dtype=np.int4
)

# Save
quantized_model.save("CoreChatModel.mlpackage")
```

### Option B: Download Pre-converted Model (Easier)

Look for pre-converted Core ML models:

1. **Hugging Face Hub:**
   - Search for "core ml" models
   - Filter by "coreml" tag
   - Download .mlmodel or .mlpackage file

2. **Apple's Model Gallery:**
   - Visit developer.apple.com/machine-learning/models
   - Download language models
   - Some are Core ML ready

3. **Community Repositories:**
   - GitHub: Search "llama coreml"
   - Check Apple's ML examples
   - mlx-swift-examples has conversions

## Step 2: Add Model to Xcode Project

1. **Drag Model File:**
   - Locate your `.mlmodel` or `.mlpackage` file
   - Drag into Xcode Project Navigator
   - Choose location: Root or create `Models/` folder

2. **Import Settings:**
   - ✅ Copy items if needed
   - ✅ Add to target: CoreChat
   - Click Finish

3. **Verify Model:**
   - Click on model file in Xcode
   - Check "Predictions" tab for interface
   - Note input/output tensor shapes

## Step 3: Update ModelManager.swift

Open `CoreML/ModelManager.swift` and make these changes:

### 3.1 Update loadModel() Function

Find the commented-out code and update:

```swift
func loadModel() async throws {
    let config = MLModelConfiguration()
    config.computeUnits = .all  // Use Neural Engine

    // Update model name to match your file
    guard let modelURL = Bundle.main.url(
        forResource: "CoreChatModel",  // ← Change this
        withExtension: "mlmodelc"
    ) else {
        throw ModelError.modelNotFound
    }

    model = try await MLModel.load(contentsOf: modelURL, configuration: config)
    isModelLoaded = true

    print("✅ Model loaded successfully on Neural Engine")
}
```

### 3.2 Implement Token Generation

Update the `generate()` function:

```swift
import Transformers  // Add at top of file

func generate(prompt: String, maxTokens: Int, temperature: Double) async throws -> String {
    guard isModelLoaded, let model = model else {
        throw ModelError.modelNotLoaded
    }

    // Initialize tokenizer (you'll need to add this)
    let tokenizer = try await AutoTokenizer.from(pretrained: "meta-llama/Llama-3.1-8B-Instruct")

    // Tokenize input
    let encoding = tokenizer(prompt)
    let inputTokens = encoding.input_ids

    // Prepare Core ML input
    let input = try CoreChatModelInput(input_ids: inputTokens)

    // Run inference
    let prediction = try await model.prediction(from: input)

    // Get output tokens
    let outputTokens = prediction.output_ids

    // Detokenize
    let response = tokenizer.decode(tokens: outputTokens)

    return response
}
```

### 3.3 Add Tokenizer Setup

Add a tokenizer property:

```swift
private var tokenizer: AutoTokenizer?

func setupTokenizer() async throws {
    // Download and cache tokenizer
    tokenizer = try await AutoTokenizer.from(
        pretrained: "meta-llama/Llama-3.1-8B-Instruct"
    )
}
```

Call it in `loadModel()`:

```swift
func loadModel() async throws {
    // ... existing model loading code ...

    // Setup tokenizer
    try await setupTokenizer()
}
```

## Step 4: Update Input/Output Types

Your model will have specific input/output types. Update based on model:

```swift
// Example for Llama model
struct CoreChatModelInput: MLFeatureProvider {
    var input_ids: MLMultiArray

    var featureNames: Set<String> {
        return ["input_ids"]
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "input_ids" {
            return MLFeatureValue(multiArray: input_ids)
        }
        return nil
    }

    init(tokens: [Int]) throws {
        let shape = [1, tokens.count] as [NSNumber]
        input_ids = try MLMultiArray(shape: shape, dataType: .int32)

        for (index, token) in tokens.enumerated() {
            input_ids[[0, index] as [NSNumber]] = NSNumber(value: token)
        }
    }
}
```

## Step 5: Test the Integration

### 5.1 Update App to Load Model

In `ChatViewModel.swift`, ensure model loads on init:

```swift
init(modelManager: ModelManager = ModelManager()) {
    self.conversation = Conversation()
    self.settings = ModelSettings()
    self.modelManager = modelManager

    // Load model on startup
    Task {
        do {
            try await modelManager.loadModel()
            print("✅ Model ready")
        } catch {
            print("❌ Model loading failed: \(error)")
        }
    }
}
```

### 5.2 Disable Simulated Mode

In Settings:
- Open Settings view
- Toggle OFF "Use Simulated Responses"
- Send a test message

### 5.3 Monitor Performance

Add logging to track performance:

```swift
func generate(prompt: String, maxTokens: Int, temperature: Double) async throws -> String {
    let startTime = Date()

    // ... inference code ...

    let duration = Date().timeIntervalSince(startTime)
    let tokensPerSecond = Double(outputTokens.count) / duration

    print("⚡️ Generated \(outputTokens.count) tokens in \(duration)s")
    print("📊 Performance: \(tokensPerSecond) tokens/s")

    return response
}
```

## Step 6: Optimize Performance

### 6.1 Enable Stateful KV Cache

If your model supports it:

```swift
let config = MLModelConfiguration()
config.computeUnits = .all
config.allowLowPrecisionAccumulationOnGPU = true  // Faster on Neural Engine
```

### 6.2 Implement Streaming Generation

For better UX, stream tokens:

```swift
func generateStreaming(
    prompt: String,
    maxTokens: Int,
    onToken: @escaping (String) -> Void
) async throws {
    // Generate one token at a time
    var currentTokens = initialTokens

    for _ in 0..<maxTokens {
        let nextToken = try await predictNextToken(currentTokens)
        let tokenText = tokenizer.decode(tokens: [nextToken])

        onToken(tokenText)  // Send to UI
        currentTokens.append(nextToken)

        if nextToken == eosToken { break }
    }
}
```

Update ChatViewModel to use streaming:

```swift
private func generateResponse() async {
    // ...

    try await modelManager.generateStreaming(
        prompt: context,
        maxTokens: settings.validatedMaxTokens
    ) { token in
        conversation.updateLastMessage(
            content: conversation.messages.last!.content + token
        )
    }
}
```

## Troubleshooting

### Model Won't Load

**Error: "Model file not found"**
- Verify file is in project
- Check spelling of model name
- Ensure .mlmodelc extension (compiled)

**Error: "Failed to load model"**
- Check deployment target is iOS 18+
- Verify model is Core ML 3+
- Try rebuilding project

### Inference Errors

**Error: "Input shape mismatch"**
- Check tokenizer output shape
- Verify model expects correct input format
- Log tensor shapes to debug

**Error: "Out of memory"**
- Model too large for device
- Try smaller/quantized model
- Check available RAM

### Performance Issues

**Slow inference (<5 tokens/s)**
- Verify Neural Engine is being used
- Check `computeUnits = .all`
- Try Int4/Int8 quantization
- Monitor with Instruments

**High memory usage**
- Enable KV cache stateful models
- Limit context window size
- Use quantized models

## Advanced: Implement Context Management

Handle long conversations efficiently:

```swift
func prepareContext(messages: [Message], maxTokens: Int = 2048) -> String {
    var context = ""
    var tokenCount = 0

    // Add messages from newest to oldest until max tokens
    for message in messages.reversed() {
        let messageText = "\(message.sender): \(message.content)\n"
        let tokens = tokenizer.encode(messageText).count

        if tokenCount + tokens > maxTokens {
            break
        }

        context = messageText + context
        tokenCount += tokens
    }

    return context
}
```

## Resources

- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [coremltools Guide](https://coremltools.readme.io/docs)
- [Swift Transformers](https://github.com/huggingface/swift-transformers)
- [Apple ML Optimize](https://apple.github.io/ml-optimize/)

## Next Steps

Once your model is integrated:

1. ✅ Test with various prompts
2. ✅ Monitor performance metrics
3. ✅ Optimize for battery life
4. ✅ Add conversation persistence
5. ✅ Share with beta testers!

---

**Questions?** Check the code comments in `ModelManager.swift` for detailed examples and patterns.
