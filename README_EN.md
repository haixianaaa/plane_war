# Plane War - 飞机大战

A classic plane shooting game built with Flutter.

一款使用 Flutter 开发的经典飞机射击游戏。

## Features

- Player aircraft with smooth touch controls
- Multiple enemy types with different behaviors
- Power-up system (shield, rapid fire, triple shot)
- Gradient backgrounds and particle effects
- Score tracking and game state management
- Responsive design for various screen sizes

## Screenshots

| Game Start | In Game | Game Over |
|------------|---------|-----------|
| ![Start](screenshots/start.png) | ![Game](screenshots/game.png) | ![Over](screenshots/over.png) |

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK (for Android builds)

### Installation

1. Clone the repository
```bash
git clone https://github.com/haixianaaa/plane_war.git
cd plane_war
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Build APK

Use the included build script:

```powershell
.\build_apk.ps1 -AppName "MyPlaneWar"
```

Or build manually:

```bash
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

## Project Structure

```
lib/
├── game/
│   ├── game_controller.dart    # Game state management
│   ├── models/
│   │   └── game_models.dart    # Game entities (Player, Enemy, Bullet, etc.)
│   └── widgets/
│       └── game_canvas.dart    # Game rendering widget
├── pages/
│   └── game_page.dart          # Main game UI
└── main.dart                   # App entry point
```

## Game Controls

- **Move**: Touch and drag to move the player aircraft
- **Shoot**: Automatic firing
- **Power-ups**: Collect items to gain abilities
  - Shield: Temporary invincibility
  - Rapid Fire: Increased fire rate
  - Triple Shot: Fire three bullets at once

## Technical Notes

### Windows Build Fix

This project includes a workaround for the Windows Ninja `GetOverlappedResult` bug by using Unix Makefiles instead of Ninja for native builds. See `android/app/build.gradle.kts` for details.

## Dependencies

- `flutter` - UI framework
- `cupertino_icons` - iOS style icons

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

- GitHub: [@haixianaaa](https://github.com/haixianaaa)

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Inspired by classic arcade shooting games
