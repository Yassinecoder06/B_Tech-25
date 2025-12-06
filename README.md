# 🌍 WanderSphere - B_Tech 25 Project

> **Revolutionizing Travel Planning with AI-Powered Coordination and Community**

---

## 📋 Table of Contents
- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Installation & Setup](#installation--setup)
- [Usage](#usage)
- [Contributors](#contributors)

---

## 🔎 Overview

**WanderSphere** is a Flutter-based mobile and web application designed to solve modern travel coordination challenges. It combines AI-powered travel guidance, community engagement, budget management, and reward systems to create a seamless travel experience for users worldwide.

The application integrates with Firebase and Supabase backends to provide real-time data synchronization, user authentication, and cloud storage capabilities.

---

## ⚠️ Problem Statement

Travelers face multiple challenges when planning adventures:
- **Poor Travel Coordination**: Lack of structured planning tools and guidance
- **Disconnected Community**: Limited ways to connect with other travelers and locals
- **Budget Management**: Difficulty tracking and optimizing travel expenses
- **Overwhelming Choices**: Too many options without personalized recommendations
- **Safety Concerns**: Difficulty finding verified, safe locations and activities

WanderSphere addresses all these issues through an integrated platform.

---

## ✨ Key Features

### 🔍 Search & Browse (SBS Framework)
- **Search**: Find accounts, places, monuments, and activities
- **Browse**: Track other users' activities and discover trending locations
- **Engage**: Like, save, and comment on posts and activities

### 📤 Share & Post
- Post travel experiences, monuments, and activity visits
- Share recommendations with the community
- Upload photos and media to your travel journal

### 🎁 Reward System
- Earn coins for posting and engaging with the community
- Get discounts on accommodations and services
- Tiered rewards based on service type (3% discount on accommodations, 0.5% on others)
- Exclusive rewards for sponsored locations

### 💬 Real-Time Chat
- Connect with other travelers in real-time
- Join community discussions and groups
- Get instant notifications on messages

### 👤 User Profiles
- Personalized user profiles with activity history
- Achievement badges and reward tracking
- Settings and preferences management

### 🤖 AI Integration
- Google Gemini API for intelligent travel recommendations
- Smart itinerary planning
- Personalized suggestions based on user preferences and behavior

### 🛒 Shop Integration
- Browse travel deals and services
- Purchase travel packages
- Manage bookings and reservations

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter (Dart)
- **UI Components**: 
  - Google Navigation Bar (`google_nav_bar`)
  - Staggered Grid View (`flutter_staggered_grid_view`)
  - SVG Support (`flutter_svg`)

### Backend
- **Authentication**: Firebase Auth & Supabase Auth
- **Database**: 
  - Firebase Firestore (primary database)
  - Supabase PostgreSQL (supplementary)
- **File Storage**: Firebase Storage & Supabase Storage
- **Real-time Sync**: Cloud Firestore listeners

### AI & APIs
- **AI Model**: Google Gemini API (`flutter_gemini`)
- **URL Launcher**: Web and app linking (`url_launcher`)
- **Image Handling**: Image Picker (`image_picker`)

### State Management
- **Provider** (v6.1.2): For state management and dependency injection

### Utilities
- **UUID**: For unique identifier generation
- **Intl**: Internationalization and date formatting
- **Shared Preferences**: Local data persistence

### Platform-Specific
- **iOS**: Swift with Xcode integration
- **Android**: Kotlin/Java with Gradle
- **Web**: HTML5 with Firebase JS SDK
- **Desktop**: Linux (CMake), macOS (Swift/Xcode), Windows (CMake)

### Development Tools
- **Build System**: Flutter (Dart SDK 3.6.1+)
- **Version Control**: Git

---

## 📁 Project Structure

```
WanderSphere/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models
│   │   ├── user.dart
│   │   ├── post.dart
│   │   ├── message.dart
│   │   └── chat_bubble.dart
│   ├── pages/                       # Screen pages
│   │   ├── main_screen.dart
│   │   ├── main_pages/              # Main navigation pages
│   │   ├── home_pages/              # Home feed pages
│   │   ├── explore_pages/           # Exploration features
│   │   ├── search_pages/            # Search functionality
│   │   ├── profile_pages/           # User profile pages
│   │   └── shop_pages/              # Shop and deals
│   ├── providers/                   # State management
│   │   ├── user_provider.dart       # User state
│   │   └── reward_coins_provider.dart# Reward tracking
│   ├── services/                    # Business logic & API calls
│   │   ├── auth_service.dart        # Authentication
│   │   ├── user_service.dart        # User data management
│   │   ├── post_service.dart        # Post operations
│   │   ├── chat_service.dart        # Chat functionality
│   │   ├── storage_service_supa.dart# Supabase storage
│   │   └── login_or_register_service.dart
│   ├── widgets/                     # Reusable components
│   ├── styles/                      # Styling and themes
│   ├── utils/                       # Utility functions
│   │   ├── colors.dart              # Color palette
│   │   └── const.dart               # Constants & API keys
│   └── assets/                      # Images and static files
├── android/                         # Android platform code
├── ios/                             # iOS platform code
├── web/                             # Web platform code
├── windows/                         # Windows platform code
├── linux/                           # Linux platform code
├── macos/                           # macOS platform code
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: Version 3.6.1 or higher
- **Dart**: Included with Flutter
- **Git**: For version control
- **Code Editor**: VS Code, Android Studio, or IntelliJ IDEA
- **Mobile Device or Emulator**: For testing (Android/iOS)
- **Firebase Account**: For backend services
- **Supabase Account**: For supplementary services
- **Google Gemini API Key**: For AI features

### Platform-Specific Requirements

**Android**:
- Android SDK 21 or higher
- Android Studio (recommended)

**iOS**:
- Xcode 12 or higher
- iOS 11.0 or higher
- macOS device for building

**Web**:
- Any modern web browser
- No additional setup required

**Desktop (Windows/Linux/macOS)**:
- Native build tools (MSVC for Windows, GCC for Linux, Xcode for macOS)

---

## 📥 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Yassinecoder06/B_Tech-25.git
cd B_Tech-25
```

### 2. Navigate to the Flutter App
```bash
cd flutter_app/WanderSphere
```

### 3. Get Flutter Dependencies
```bash
flutter pub get
```

### 4. Configure Firebase
- Download your Firebase configuration files:
  - `google-services.json` for Android
  - `GoogleService-Info.plist` for iOS
- Place them in the appropriate directories

### 5. Set API Keys
Update `lib/utils/const.dart` with your API keys:
```dart
const String GEMINI_API_KEY = "YOUR_GEMINI_API_KEY";
```

Update `lib/main.dart` with your Firebase and Supabase credentials.

### 6. Run the App

**For Android**:
```bash
flutter run -d android
```

**For iOS**:
```bash
flutter run -d ios
```

**For Web**:
```bash
flutter run -d chrome
```

**For Desktop** (Windows/Linux/macOS):
```bash
flutter run -d windows  # or linux, macos
```

---

## 💡 Usage

### First Launch
1. Open the app and see the Welcome page
2. Sign up with email and password or log in with existing account
3. Complete your profile setup

### Main Features
- **Home Feed**: Browse posts from the community
- **Search**: Find places, users, and activities
- **Explore**: Discover trending locations and deals
- **Shop**: Browse and purchase travel packages
- **Profile**: View your profile, rewards, and activity history
- **Chat**: Connect with other travelers

### Earning Rewards
1. Post your travel experiences
2. Engage with community (like, comment, save)
3. Accumulate coins for each action
4. Redeem rewards for discounts on accommodations and services

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👥 Contributors

- **Jmal** - Project Vision & Strategy
- **Mariemm** - Methodology & Prototype Design
- **Yassinecoder06** - Lead Developer

---

## 📄 License

This project is part of the B_Tech 25 program. All rights reserved.

---

## 📞 Contact & Support

For questions, bugs, or feature requests:
- GitHub Issues: [B_Tech-25 Issues](https://github.com/Yassinecoder06/B_Tech-25/issues)
- Email: For specific inquiries

---

## 🎯 Future Roadmap

- [ ] Offline mode support
- [ ] Advanced AI recommendations
- [ ] Augmented Reality (AR) location features
- [ ] Integration with popular booking platforms
- [ ] Multi-language support
- [ ] Video content support for posts
- [ ] Group travel planning features

---

**Happy traveling with WanderSphere! 🌍✈️**
