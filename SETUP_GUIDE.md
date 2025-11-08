# CoreChat - Complete Setup Guide

This guide will walk you through setting up CoreChat on your Mac and iPhone 17.

## Prerequisites

- **Xcode 16+** (with iOS 18 SDK)
- **macOS 15+** (Sequoia)
- **iPhone 17** or iPhone 17 simulator
- **Apple Developer Account** (for device testing)

## Step-by-Step Setup

### 1. Create the Xcode Project

Since Xcode project files are binary and complex, you'll create a new project and add our source files:

#### 1.1 Create New Project
1. Open **Xcode**
2. Select **File → New → Project** (or Cmd+Shift+N)
3. Choose template:
   - Platform: **iOS**
   - Application: **App**
   - Click **Next**

#### 1.2 Configure Project
- **Product Name:** `CoreChat`
- **Team:** Select your team
- **Organization Identifier:** `com.yourname` (or your preference)
- **Bundle Identifier:** Will auto-fill as `com.yourname.CoreChat`
- **Interface:** **SwiftUI**
- **Language:** **Swift**
- **Storage:** None (we'll handle this manually)
- **Include Tests:** Yes (optional)

Click **Next**, choose save location (use the `corechat` directory), click **Create**.

#### 1.3 Clean Default Files
1. In Xcode's Project Navigator (left sidebar)
2. Delete these default files (Move to Trash):
   - `ContentView.swift`
   - `CoreChatApp.swift` (we have our own)

### 2. Add Source Code

#### 2.1 Add All Source Folders
1. In Finder, navigate to `CoreChat/CoreChat/`
2. Drag these folders into Xcode's Project Navigator:
   - `App/`
   - `Models/`
   - `ViewModels/`
   - `Views/`
   - `CoreML/`
   - `Utilities/`

3. When prompted:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ Add to target: **CoreChat**
   - Click **Finish**

#### 2.2 Verify File Structure
Your Project Navigator should look like:
```
CoreChat
├── App
│   └── CoreChatApp.swift
├── Models
│   ├── Message.swift
│   ├── Conversation.swift
│   └── ModelSettings.swift
├── ViewModels
│   └── ChatViewModel.swift
├── Views
│   ├── ChatView.swift
│   ├── MessageBubble.swift
│   ├── InputBar.swift
│   └── SettingsView.swift
├── CoreML
│   └── ModelManager.swift
├── Utilities
│   └── Extensions.swift
├── Assets.xcassets
└── Preview Content
```

### 3. Configure Project Settings

#### 3.1 Set Deployment Target
1. Click on **CoreChat** (top of Project Navigator)
2. Select **CoreChat** target
3. **General** tab:
   - **Minimum Deployments:** Change to **iOS 18.0**

#### 3.2 Configure Signing
1. **Signing & Capabilities** tab:
   - ✅ **Automatically manage signing**
   - **Team:** Select your team
   - Bundle Identifier should already be set

### 4. Add Dependencies

#### 4.1 Add Swift Transformers Package
1. **File → Add Package Dependencies...**
2. Enter package URL:
   ```
   https://github.com/huggingface/swift-transformers
   ```
3. **Dependency Rule:**
   - Up to Next Major Version
   - **0.1.17**
4. Click **Add Package**
5. In the next dialog:
   - Select **Transformers** library
   - Add to **CoreChat** target
6. Click **Add Package**

Wait for Xcode to resolve and download the package.

### 5. Build and Run

#### 5.1 Select Device/Simulator
- Top toolbar: Click device selector
- Choose **iPhone 17 Pro** (or your connected iPhone 17)

#### 5.2 Build the Project
1. Press **Cmd+B** or **Product → Build**
2. Wait for build to complete (should succeed with no errors)

#### 5.3 Run the App
1. Press **Cmd+R** or **Product → Run**
2. App should launch on simulator/device
3. You should see the CoreChat welcome screen!

### 6. Test the App

#### 6.1 Send Your First Message
1. Tap the text field at the bottom
2. Type: "Hello!"
3. Tap the blue send button
4. Watch the AI respond with a simulated message
5. Notice the typing animation!

#### 6.2 Explore Settings
1. Tap the gear icon (top right)
2. Adjust temperature slider
3. Change max tokens
4. Notice "Use Simulated Responses" is ON
5. Tap "Done"

#### 6.3 Test Features
- Send multiple messages
- Watch auto-scroll behavior
- Try the clear button (trash icon)
- Test in dark mode (iOS Settings)

## Troubleshooting

### Build Errors

**"Cannot find 'MLModel' in scope"**
- Solution: Make sure deployment target is iOS 18.0+
- Check: Project settings → General → Minimum Deployments

**"Missing package product 'Transformers'"**
- Solution: File → Packages → Resolve Package Versions
- Wait for Swift Package Manager to finish

**"Command CompileSwift failed"**
- Solution: Product → Clean Build Folder (Cmd+Shift+K)
- Then rebuild (Cmd+B)

### Runtime Issues

**App crashes on launch**
- Check Console (Cmd+Shift+Y) for error messages
- Verify all source files are in the project
- Make sure CoreChatApp.swift is included

**Interface looks broken**
- Try different simulator (iPhone 17 Pro recommended)
- Reset simulator: Device → Erase All Content and Settings
- Rebuild and run

**Package resolution fails**
- Xcode → Settings → Accounts → Sign out and sign in
- File → Packages → Reset Package Caches
- Try again

## Next Steps

### Phase 1: Test Current Features ✅
You're here! The app works with simulated responses.

### Phase 2: Add Core ML Model (Future)
When you're ready to add a real AI model:

1. **Get a Core ML Model:**
   - Option A: Convert from Hugging Face using `coremltools`
   - Option B: Download pre-converted Core ML model
   - Recommended: Llama 3.1-8B with Int4 quantization

2. **Add Model to Project:**
   ```
   - Drag .mlmodel or .mlpackage into Xcode
   - Check "Copy items if needed"
   - Add to CoreChat target
   ```

3. **Update ModelManager.swift:**
   - Open `CoreML/ModelManager.swift`
   - Uncomment the actual Core ML code (marked with /* */)
   - Update model name to match your file
   - Implement tokenization

4. **Test with Real Model:**
   - Settings → Turn off "Use Simulated Responses"
   - Send a message
   - Enjoy on-device AI!

### Phase 3: Advanced Features
- Add Core Data for conversation persistence
- Support multiple chat threads
- Add export/share functionality
- Implement voice input (Siri integration)

## Xcode Tips

### Useful Shortcuts
- **Cmd+B** - Build
- **Cmd+R** - Run
- **Cmd+.** - Stop running
- **Cmd+Shift+K** - Clean build folder
- **Cmd+Shift+Y** - Toggle console
- **Opt+Cmd+P** - Resume preview (for SwiftUI previews)

### Debugging
- Set breakpoints by clicking line numbers
- Use `print()` statements to log
- Check console for errors (bottom panel)

### SwiftUI Previews
- Open any View file (e.g., `MessageBubble.swift`)
- Click **Resume** in preview panel (right side)
- Live preview updates as you code!

## Resources

- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Swift Transformers GitHub](https://github.com/huggingface/swift-transformers)
- [Hugging Face Models](https://huggingface.co/models?library=coreml)

## Support

Having issues? Check:
1. This guide's troubleshooting section
2. CoreChat/README.md for quick reference
3. CLAUDE.md for technical architecture details

---

🎉 **You're all set!** Enjoy building with CoreChat!
