# TicTacToe

A highly polished, local 2-player Tic-Tac-Toe game built in Flutter. This project focuses on extremely satisfying gameplay mechanics, seamless state management, and a clean "Toy Pop Minimal" aesthetic complete with juicy animations and dynamic audio.

<img width="360" height="700" alt="2" src="https://github.com/user-attachments/assets/bb793355-762b-4bf8-9846-8190007d63b9" />
<img width="360" height="700" alt="3" src="https://github.com/user-attachments/assets/0e07af57-a94a-48a6-b214-e52eacd9928c" />
<img width="360" height="700" alt="1" src="https://github.com/user-attachments/assets/7e9c677d-96fa-42e9-b6d5-2a0eea02431b" />





## Features

* **Juicy UI & Animations:** Features elastic tap animations, bouncy button scaling, and a custom confetti particle system for victories.
* **Advanced Audio System:** Integrates the `audioplayers` package for non-blocking SFX (pops, errors, wins) layered over continuous, looping background music.
* **Lifecycle-Aware:** The background music automatically pauses when the app is minimized or interrupted, and resumes when brought back to the foreground.
* **Dynamic Gameplay:** Randomized starting turns (Red vs. Blue) on every fresh match or restart.
* **State Management:** Clean separation of business logic and UI using the `provider` package and a central `GameController`.
* **Fully Custom Theming:** Centralized color palettes, box shadows, and styling rules matching the Toy Pop Minimal design language.

## Tech Stack

* **Framework:** Flutter / Dart
* **State Management:** Provider
* **Audio:** Audioplayers
* **Assets Generator:** Flutter Launcher Icons

## Getting Started

### Prerequisites
* Flutter SDK (>=3.0.0)
* Android Studio / VS Code with Flutter extensions installed
* An emulator or physical Android/iOS device

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YourUsername/YourRepoName.git](https://github.com/YourUsername/YourRepoName.git)
   cd YourRepoName
2. **Install dependencies:**
   ```bash
   flutter pub get
3. **Run the app:**
   ```bash
   flutter run
## Building the APK
To generate a standalone Android APK (with a custom package name and launcher icon), run the following commands:
```bash
flutter clean
flutter pub get
flutter build apk --release
```
The generated APK will be located at build/app/outputs/flutter-apk/app-release.apk.
## Project Structure
```text
lib/
├── controllers/
│   └── game_controller.dart      # Core game logic, win detection, state and audio triggers
├── screens/
│   ├── active_match_screen.dart  # 3x3 grid, HUD, and gameplay view
│   └── start_menu_screen.dart    # Main menu and audio toggle
├── services/
│   └── audio_service.dart        # BGM and SFX player isolation, lifecycle handling
├── theme/
│   └── toy_pop_theme.dart        # Centralized colors and styling rules
├── widgets/
│   ├── confetti_painter.dart     # Custom particle system for wins
│   ├── toy_button.dart           # Animated, bouncy UI buttons
│   └── victory_overlay.dart      # End-game popup dialog
└── main.dart                     # App entry point & Provider initialization
```

