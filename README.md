# 🌟 Auri - Flutter Pictogram Gallery App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

**Auri** is an interactive Flutter application that provides a comprehensive pictogram gallery with offline functionality. Designed with accessibility and education in mind, it helps users explore visual symbols through an intuitive, kid-friendly interface with built-in text-to-speech capabilities.


---

## ✨ **Features**

### 🎯 **Core Functionality**
- **📦 Smart Asset Management**: Automatically downloads and extracts categorized pictogram assets from GitHub releases
- **🔍 Advanced Search**: Find pictograms by name, meaning, or category with real-time filtering
- **🗂️ Category Organization**: Browse through 14+ organized categories (Home & Family, Food & Drink, Emotions, etc.)
- **🔊 Offline Text-to-Speech**: Tap any pictogram to hear its meaning spoken aloud
- **📱 Responsive Design**: Optimized for various screen sizes and orientations

### 🎨 **User Experience**
- **✨ Smooth Animations**: Fluid transitions and interactive feedback throughout the app
- **🌈 Kid-Friendly Design**: Duolingo-inspired color palette with engaging visual elements
- **⚡ Fast Performance**: Local caching with Hive for instant pictogram access
- **📊 Progress Tracking**: Visual download progress with speed and time estimates
- **🎭 Interactive Elements**: Animated tiles, custom drawer, and engaging waiting screens

---

## 🛠️ **Tech Stack**

| Technology | Purpose |
|------------|---------|
| **Flutter & Dart** | Cross-platform mobile development |
| **Riverpod** | State management and dependency injection |
| **Hive** | Local NoSQL database for caching |
| **Flutter TTS** | Offline text-to-speech synthesis |
| **HTTP Client** | Asset downloading and network requests |
| **Archive Library** | ZIP file extraction and processing |
| **Flutter SVG** | SVG image rendering support |
| **Lottie** | Beautiful loading animations |

---

## 🏗️ **Architecture**

### **Project Structure**
lib/
├── features/
│ ├── components/ # Reusable UI widgets
│ │ ├── custom_appbar.dart
│ │ ├── custom_drawer.dart
│ │ └── download_progress_indicator.dart
│ ├── models/ # Data models
│ │ ├── image_model.dart
│ │ └── image_model.g.dart
│ ├── screens/ # App screens
│ │ ├── download_assets_page.dart
│ │ ├── categories_page.dart
│ │ ├── categories_images_page.dart
│ │ └── wait_screen.dart
│ ├── services/ # Business logic
│ │ ├── pictogram_assets_downloader.dart
│ │ ├── image_service.dart
│ │ ├── gallery_providers.dart
│ │ └── tts_service.dart
│ └── utils/ # Utilities
│ └── colors.dart
└── main.dart


### **Key Components**

#### **🔧 Services**
- **PictogramAssetsDownloader**: Handles asset downloading, extraction, and validation
- **ImageService**: Manages pictogram data retrieval and search functionality  
- **TTSService**: Provides offline text-to-speech capabilities
- **Gallery Providers**: Riverpod providers for state management

#### **📱 UI Components**
- **CustomAppbar**: Adaptive app bar with navigation controls
- **CustomDrawer**: Animated sidebar with colorful navigation menu
- **DownloadProgressIndicator**: Real-time download progress with statistics

---

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### **Installation**

1. **Clone the repository**
git clone https://github.com/ChauhanKrish4763/Auri.git
cd Auri

flutter pub get

3. **Run the app**

### **First Launch**
On first startup, Auri will:
1. Display an engaging wait screen with fun facts
2. Download pictogram assets (~15MB) from GitHub
3. Extract and organize images into categories
4. Index metadata for fast searching
5. Navigate to the main gallery

---

## 📋 **Available Categories**

| Category | Description | Icon |
|----------|-------------|------|
| **Home & Family** | Household items and family relationships | 🏠 |
| **Food & Drink** | Meals, beverages, and dining | 🍎 |
| **Emotions & Feelings** | Emotional expressions and states | 😊 |
| **Actions & Verbs** | Movement and action pictograms | 🏃 |
| **Objects & Things** | Common items and tools | 🔧 |
| **People & Relationships** | Social connections and roles | 👥 |
| **Places & Buildings** | Locations and structures | 🏢 |
| **Body & Health** | Anatomy and wellness | 💪 |
| **Time & Calendar** | Temporal concepts and scheduling | ⏰ |
| **Nature & Weather** | Natural elements and climate | 🌱 |
| **Colors & Shapes** | Visual properties and geometry | 🎨 |
| **Numbers & Math** | Numerical and mathematical concepts | 🔢 |
| **Communication** | Speaking and interaction symbols | 💬 |
| **Transportation** | Vehicles and travel methods | 🚗 |

---

## 🔧 **Configuration**

### **Customizing Asset Source**
Update the download URL in `pictogram_assets_downloader.dart`:
static const String _zipDownloadUrl = 'https://github.com/YourUsername/YourRepo/releases/download/v1/assets.zip';


### **TTS Settings**
Modify TTS parameters in `tts_service.dart`:

await _flutterTts.setLanguage("en-US"); // Language
await _flutterTts.setSpeechRate(0.5); // Speed (0.0-1.0)
await _flutterTts.setPitch(1.0); // Pitch (0.5-2.0)


---

## 🎨 **Design System**

### **Color Palette**
- **Primary**: Indigo (#4F46E5)
- **Accent**: Vibrant Blue (#1CB0F6)
- **Success**: Friendly Green (#58CC02)
- **Warning**: Warm Orange (#FF9600)
- **Background**: Snow White (#FBFBFB)

### **Typography**
- Clean, readable fonts optimized for accessibility
- Consistent sizing hierarchy throughout the app
- High contrast for better visibility

---

## 🤝 **Contributing**

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### **Development Guidelines**
- Follow Flutter best practices and conventions
- Write descriptive commit messages
- Add comments for complex logic
- Test on multiple devices/screen sizes
- Maintain consistent code formatting

---

## 📊 **Performance**

- **Cold Start**: < 3 seconds
- **Asset Download**: ~15MB (one-time)
- **Memory Usage**: < 100MB
- **Search Response**: < 100ms
- **TTS Latency**: < 500ms

---

## 🐛 **Known Issues**

- SVG rendering may be slower on older devices
- Large asset downloads require stable internet connection
- TTS availability varies by platform/device

---

## 📱 **Supported Platforms**

- ✅ Android 5.0+ (API 21+)
- ✅ iOS 11.0+
- ⏳ Web (coming soon)
- ⏳ Desktop (future release)

---

## 📞 **Contact & Support**

- **Developer**: Krish Chauhan, Deeaa Kaur, Vatsal Rastogi

---


