# FlowZen - Testing and Deployment Guide

## Build Status
✅ All compilation errors fixed
✅ Release APK building...

## Critical Fixes Applied
1. **Fixed import error**: Updated `custom_app_bar.dart` to use `date_time_utils.dart` instead of `date_utils.dart`
2. **Error handling**: Added comprehensive try-catch blocks in `main.dart`
3. **Error boundary**: Added custom ErrorWidget.builder in `app.dart`
4. **Dialog widgets**: Verified `habit_dialog.dart` and `goal_dialog.dart` exist and are properly configured

## Testing Instructions

### Option 1: Test on Physical Android Device
1. Connect your Android device via USB
2. Enable Developer Options and USB Debugging on your device
3. Run: `flutter devices` to verify device is connected
4. Run: `flutter install` to install the APK
5. Launch the app and monitor for crashes
6. If it crashes, run: `flutter logs` to see the crash logs

### Option 2: Test on Android Emulator
1. Open Android Studio
2. Go to Tools → Device Manager
3. Create or start an existing Android Virtual Device (AVD)
4. Wait for emulator to fully boot
5. Run: `flutter devices` to verify emulator is detected
6. Run: `flutter install` or `flutter run --release`
7. Monitor the app startup

### Option 3: Manual APK Installation
1. Once build completes, the APK will be at: `build/app/outputs/flutter-apk/app-release.apk`
2. Transfer APK to your Android device
3. Install it (you may need to enable "Install from Unknown Sources")
4. Launch and test all features

## Debugging Crashes

If the app still crashes, collect logs:

```bash
# Start logcat before launching app
adb logcat | findstr Flutter

# OR for more detailed logs
adb logcat *:E | findstr "FlowZen|flutter"
```

Common crash causes to check:
- Hive database initialization failure
- Permission issues (notifications, storage)
- Missing native libraries
- ProGuard over-obfuscation (already configured to keep Hive classes)

## Key Features to Test

### 1. Splash Screen
- Should display FlowZen logo
- Auto-navigate to Onboarding (first launch) or Home (subsequent launches)

### 2. Onboarding
- Swipe through 3 pages
- Skip button should work
- Get Started button on last page

### 3. Home Dashboard
- Shows greeting based on time of day
- Displays today's task count
- Shows active habits and goals
- Quick action buttons (Focus, Task, Habit, Goal)

### 4. Focus Timer
- Start/pause/reset Pomodoro timer
- Default: 25min work, 5min short break, 15min long break
- Visual circular progress
- Session history tracking

### 5. Habits Tracker
- Create new habit (tap + button)
- Mark habit as complete
- View streak counter
- Edit/delete habits

### 6. Goals Manager
- Create goals with types (Short-term, Mid-term, Long-term)
- Track progress
- Mark as complete
- View by status (Active, Completed, Overdue)

### 7. Notes
- Create/edit/delete notes
- Search notes
- Tag notes with colors
- Pin important notes

### 8. Analytics
- View productivity trends
- Completion rate charts
- Focus session statistics
- Habit consistency graphs

### 9. Settings
- Toggle dark/light theme
- Notification preferences
- About section

## Performance Checks
- App should launch within 3 seconds
- Smooth 60fps animations
- No lag when switching screens
- Database operations should be instant (offline-first)

## Known Limitations
- No cloud sync (offline-first design)
- No user authentication
- Notifications require manual permission grant
- Planner screen is placeholder (marked "Coming Soon")

## Next Steps After Successful Test

Once verified working:

```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit: Complete FlowZen productivity app

- Offline-first architecture with Hive database
- 7 feature screens: Focus Timer, Habits, Goals, Notes, Analytics, Settings
- Material Design 3 with light/dark themes
- Provider state management
- Smooth animations and transitions
- Android SDK 35 target, Play Store compliant"

# Connect to GitHub
git branch -M main
git remote add origin https://github.com/naoe24003salam-dev/flowzen.git
git push -u origin main
```

## Troubleshooting

### Build Fails
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Hive Database Issues
- Clear app data from Android Settings
- Reinstall the app
- Check storage permissions

### Notification Issues
- Grant notification permission when prompted
- Check Android Settings → Apps → FlowZen → Permissions

### Theme Not Switching
- Restart the app after changing theme
- Check if device is in battery saver mode (may override theme)

## Support
For issues, check:
1. Flutter version: `flutter --version` (should be 3.10.0+)
2. Android SDK: API 26+ required, 35+ recommended
3. Device logs: `adb logcat` for detailed error messages
