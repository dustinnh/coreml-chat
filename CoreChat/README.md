# CoreChat - Setup Instructions

This is the complete source code for CoreChat, an on-device AI chat application for iPhone 17.

## 🚀 Quick Start

### Option 1: Create Xcode Project (Recommended)

1. **Open Xcode 16+**
2. **Create New Project:**
   - File → New → Project
   - Choose: iOS → App
   - Product Name: `CoreChat`
   - Team: Your team
   - Organization Identifier: `com.yourname` (or preferred)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Click "Next" and choose a location

3. **Add Source Files:**
   - Delete the default `ContentView.swift` file
   - Drag all folders from `CoreChat/` into your Xcode project:
     - App/
     - Models/
     - ViewModels/
     - Views/
     - CoreML/
     - Utilities/
   - Make sure "Copy items if needed" is checked
   - Make sure "CoreChat" target is selected

4. **Configure Project Settings:**
   - Select project in navigator
   - General tab:
     - Deployment Target: **iOS 18.0** or later
     - Bundle Identifier: Update if needed
   - Signing & Capabilities tab:
     - Select your development team
     - Enable automatic signing

5. **Add Swift Package Dependencies:**
   - File → Add Package Dependencies
   - Enter URL: `https://github.com/huggingface/swift-transformers`
   - Version: `0.1.17` or later
   - Add to target: CoreChat

6. **Build and Run:**
   - Select iPhone 17 simulator or your device
   - Press Cmd+R to build and run

### Option 2: Use Provided Package.swift

If you prefer Swift Package Manager:

```bash
cd CoreChat
swift build
```

## 📱 Testing

The app currently runs in **simulated mode** - it will respond with canned messages to test the interface. This allows you to:

- Test the beautiful chat UI
- See streaming responses in action
- Explore settings and parameters
- Verify everything works before adding a real model

## 🧠 Adding a Core ML Model (Future)

When you're ready to add a real language model:

1. **Get a Core ML model:**
   - Convert a model using `coremltools`
   - Download from Hugging Face (Core ML format)
   - Recommended: Llama 3.1-8B with Int4 quantization

2. **Add to project:**
   - Drag .mlmodel or .mlpackage file into Xcode
   - Make sure it's added to the CoreChat target

3. **Update ModelManager.swift:**
   - Uncomment the actual Core ML loading code
   - Update model name to match your file
   - Implement tokenization using Swift Transformers

4. **Toggle in Settings:**
   - Open app → Settings
   - Turn off "Use Simulated Responses"
   - Enjoy on-device AI!

## 📝 Features

- ✅ Beautiful iMessage-style chat interface
- ✅ Simulated streaming responses
- ✅ Settings for model parameters
- ✅ Auto-scroll to new messages
- ✅ Dark mode support
- ✅ Haptic feedback
- ✅ Ready for Core ML integration

## 🏗️ Architecture

- **SwiftUI** - Modern declarative UI
- **Async/await** - For model inference
- **Combine** - For reactive state management
- **Core ML** - On-device AI inference (placeholder)
- **Swift Transformers** - Tokenization (when model added)

## 🎯 Next Steps

1. Build and run the app
2. Test the chat interface with simulated responses
3. Explore the settings and parameters
4. When ready, add a Core ML model
5. Switch to Core ML mode in settings

## 💡 Tips

- The app requires iOS 18+ and works best on iPhone 17
- All conversations are currently in-memory (not persisted)
- Core Data persistence will be added in Phase 4
- Check CLAUDE.md for detailed technical information

## 🐛 Troubleshooting

**Build errors?**
- Make sure deployment target is iOS 18.0+
- Verify Swift Transformers package is added
- Clean build folder (Cmd+Shift+K)

**App crashes?**
- Check Xcode console for error messages
- Verify all source files are added to target
- Make sure Info.plist is configured

**Want to modify the UI?**
- Edit files in Views/ folder
- Preview files work in Xcode canvas
- All views use SwiftUI

---

Built with ❤️ for iPhone 17 Neural Engine
