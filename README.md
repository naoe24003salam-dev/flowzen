# FlowZen - Your Mindful Productivity Companion

FlowZen is a premium, fully offline productivity suite for Android that combines time management, habit tracking, goal setting, focus tools, and wellness features into one beautifully crafted experience.

## ✨ Features

### 🎯 Comprehensive Productivity Tools
- **Focus Timer** - Pomodoro technique with customizable sessions
- **Habit Tracker** - Build and maintain daily habits with streak tracking
- **Goal Management** - Track short-term and long-term goals with progress visualization
- **Quick Notes** - Capture thoughts and ideas with color-coded notes
- **Daily Planner** - Time-blocking and schedule management (coming soon)
- **Analytics** - Comprehensive productivity insights and statistics

### 🎨 Premium Design
- Beautiful Material Design 3 UI
- Smooth animations and transitions
- Dark mode support
- Calming color palette
- Intuitive navigation

### 🔒 Privacy-First
- **100% Offline** - No internet permission required
- **Local Storage** - All data stored securely on your device with Hive
- **No Tracking** - Zero analytics or data collection
- **No Accounts** - No sign-up, no login, just productivity

## 📋 Requirements

- Android 8.0 (API 26) or higher
- No permissions required (except optional notifications)

## 🛠️ Technical Stack

- **Framework**: Flutter 3.10+
- **State Management**: Provider
- **Local Database**: Hive
- **Animations**: flutter_animate, flutter_staggered_animations
- **Charts**: fl_chart, syncfusion_flutter_charts
- **Fonts**: Google Fonts (Inter, Playfair Display)

## 🚀 Build Instructions

### Prerequisites
- Flutter SDK 3.5.0 or higher
- Android SDK 36
- NDK 27.0.12077973

### Building the App

```bash
# Get dependencies
flutter pub get

# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Build release APK
flutter build apk --release

# Build release App Bundle (for Play Store)
flutter build appbundle --release
```

### Running in Development

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # FlowZen app configuration
├── core/                     # Core utilities and themes
│   ├── theme/               # App theming
│   ├── constants/           # App constants
│   ├── utils/               # Utility functions
│   └── widgets/             # Reusable widgets
├── data/                    # Data layer
│   ├── models/              # Hive models
│   └── repositories/        # Data repositories
├── providers/               # State management
└── screens/                 # UI screens
```

## 🎯 App Features Detail

### Focus Timer
- 25-minute work sessions
- 5-minute short breaks
- 15-minute long breaks (every 4 sessions)
- Session tracking and history
- Confetti celebration on completion

### Habit Tracker
- Daily habit completion tracking
- Streak calculation (current and longest)
- Color-coded habit categories
- Swipe-to-delete functionality
- Beautiful completion animations

### Goals
- Short-term and long-term goal management
- Progress tracking (0-100%)
- Visual progress indicators
- Category organization
- Deadline notifications

### Quick Notes
- Grid or list view
- Color-coded notes
- Pin important notes
- Tag system
- Search functionality

### Analytics
- Productivity score calculation
- Daily activity summary
- Focus time tracking
- Habit completion rates
- Visual charts and graphs

## 🎨 Design Philosophy

FlowZen follows these design principles:
- **Calm & Minimal** - Reduce cognitive load
- **Beautiful & Functional** - Form follows function
- **Consistent** - Unified design language
- **Accessible** - Inclusive for all users
- **Delightful** - Micro-interactions and animations

## 📱 Play Store Compliance

- ✅ No dangerous permissions
- ✅ Fully offline functionality
- ✅ 16KB page size support
- ✅ Edge-to-edge layout
- ✅ Target SDK 35
- ✅ 64-bit support
- ✅ Material Design 3

## 🤝 Contributing

This is a personal project, but feedback and suggestions are welcome!

## 📄 License

This project is proprietary software. All rights reserved.

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
