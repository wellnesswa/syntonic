# Syntonic Wellness

A comprehensive, cross-platform wellness application built with Flutter for tracking mood, building healthy habits, and practicing meditation.

## Features

### 🎭 Mood Tracking
- Log your daily mood with an intuitive emoji-based interface
- Add detailed notes to your mood entries
- View mood history and patterns
- Track average mood over time

### ✅ Habit Tracker
- Create custom habits with icons and colors
- Track daily completion with visual streak indicators
- Weekly overview of habit completion
- Gamified experience with fire streak badges

### 🧘 Meditation Timer
- Multiple meditation types: Breathing, Guided, Silent
- Customizable session durations (5, 10, 15, 20, 30 minutes)
- Beautiful timer interface with progress indicator
- Session history and statistics
- Track total meditation minutes

### 📊 Analytics Dashboard
- Overview of all wellness metrics
- Visual statistics cards
- Quick action buttons
- Personalized greetings

## Tech Stack

- **Framework**: Flutter 3.2+
- **State Management**: Provider
- **Local Storage**: SQLite (sqflite)
- **UI**: Material Design 3 with custom theming
- **Fonts**: Google Fonts (Inter)
- **Platform Support**: Android, iOS, Windows, Linux (Web ready)

## Architecture

The app follows clean architecture principles:

```
lib/
├── models/          # Data models (MoodEntry, Habit, MeditationSession)
├── services/        # Business logic (Providers, Database)
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── utils/           # Constants and utilities
```

## Getting Started

### Prerequisites

- Flutter SDK 3.2 or higher
- Dart 3.2 or higher
- Android Studio / Xcode (for mobile development)
- Visual Studio (for Windows development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/syntonic.git
   cd syntonic
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   For Android:
   ```bash
   flutter run
   ```

   For iOS:
   ```bash
   flutter run -d ios
   ```

   For Windows:
   ```bash
   flutter run -d windows
   ```

   For Linux:
   ```bash
   flutter run -d linux
   ```

### Building for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

**Windows**
```bash
flutter build windows --release
```

**Linux**
```bash
flutter build linux --release
```

## Project Structure

### Models
- `MoodEntry`: Represents a mood log with timestamp, score, notes, and tags
- `Habit`: Defines a habit with name, icon, color, and target days
- `HabitCompletion`: Tracks daily habit completion
- `MeditationSession`: Records meditation sessions with duration and type

### Services
- `DatabaseService`: SQLite database operations
- `MoodProvider`: State management for mood tracking
- `HabitProvider`: State management for habit tracking
- `MeditationProvider`: State management for meditation sessions

### Screens
- `HomeScreen`: Main dashboard with navigation
- `MoodScreen`: Mood logging and history
- `HabitsScreen`: Habit creation and tracking
- `MeditationScreen`: Meditation timer and session history

## Database Schema

### mood_entries
- id (TEXT PRIMARY KEY)
- timestamp (TEXT)
- moodScore (INTEGER)
- note (TEXT)
- tags (TEXT)

### habits
- id (TEXT PRIMARY KEY)
- name (TEXT)
- description (TEXT)
- icon (TEXT)
- color (TEXT)
- targetDays (TEXT)
- createdAt (TEXT)
- isActive (INTEGER)

### habit_completions
- id (TEXT PRIMARY KEY)
- habitId (TEXT, FOREIGN KEY)
- date (TEXT)
- completed (INTEGER)

### meditation_sessions
- id (TEXT PRIMARY KEY)
- startTime (TEXT)
- endTime (TEXT)
- durationSeconds (INTEGER)
- type (TEXT)
- notes (TEXT)

## Customization

### Colors
Edit `lib/utils/constants.dart` to customize app colors:
```dart
class AppColors {
  static const primary = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  // ...
}
```

### Habit Icons
Add or modify habit icons in `lib/utils/constants.dart`:
```dart
const List<String> habitIcons = ['💧', '🏃', '📚', '🧘', ...];
```

## Roadmap

### Planned Features
- [ ] Cloud sync with Firebase/Supabase
- [ ] User authentication
- [ ] Social features (share progress, challenges)
- [ ] Advanced analytics and charts
- [ ] Custom meditation audio guides
- [ ] Widget support (Android/iOS)
- [ ] Dark mode
- [ ] Export data (CSV, JSON)
- [ ] Reminders and notifications
- [ ] Goal setting and achievements
- [ ] Journal integration
- [ ] Sleep tracking
- [ ] Water intake tracker

### Platform Expansion
- [x] Android
- [ ] iOS
- [ ] Windows
- [ ] Linux
- [ ] macOS
- [ ] Web

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- All open-source contributors

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
