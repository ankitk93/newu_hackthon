# NewU Health

A polished Flutter breathing exercise app that guides users through customizable **box breathing** sessions with smooth animations, audio cues, and full light/dark theme support.

## Features

- **Box Breathing** — four-phase cycle: *Breathe In → Hold → Breathe Out → Hold*
- **Customizable Sessions** — pick duration presets (3s, 4s, 5s, 10s) and round counts (2, 4, 6, 8)
- **Advanced Timing** — fine-tune each phase independently (2–10 seconds)
- **Animated Breathing Bubble** — scales smoothly in sync with your breathing rhythm
- **Audio Chimes** — optional chime between phases to keep you on track
- **Light & Dark Themes** — gradient backgrounds with decorative SVG clouds and stars
- **Session Progress** — real-time countdown, cycle counter, and progress bar
- **Pause / Resume** — pause mid-session and pick up right where you left off
- **Completion Screen** — Lottie success animation with options to restart or reconfigure

## Screenshots

<!-- Add screenshots here -->
<!-- ![Setup Screen](screenshots/setup.png) -->
<!-- ![Breathing Session](screenshots/breathing.png) -->
<!-- ![Finish Screen](screenshots/finish.png) -->

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Installation

```bash
git clone https://github.com/<your-username>/newu_health.git
cd newu_health
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run code generation (Freezed / JSON)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run tests

```bash
flutter test
```

## Tech Stack

| Category | Libraries |
|---|---|
| **Framework** | Flutter 3 / Dart 3 |
| **State Management** | `flutter_bloc`, `bloc` |
| **Networking** | `dio`, `connectivity_plus` |
| **Local Storage** | `hive`, `hive_flutter`, `shared_preferences` |
| **Models** | `freezed_annotation`, `json_annotation` |
| **Animations** | `lottie`, `archive` (dotLottie extraction) |
| **Audio** | `audioplayers` |
| **SVG** | `flutter_svg` |
| **Testing** | `mockito`, `bloc_test` |
| **Code Gen** | `build_runner`, `freezed`, `json_serializable` |

## Architecture

The project follows a **feature-first Clean Architecture** structure with clear separation between domain, presentation, and core infrastructure layers.

```
lib/
├── main.dart                       # Entry point
├── app.dart                        # Root widget & route definitions
│
├── core/                           # Shared infrastructure
│   ├── di/                         # Dependency injection (ServiceLocator)
│   ├── error/                      # Exception & Failure classes
│   ├── local/                      # Hive + SharedPreferences services
│   ├── network/                    # Dio client & interceptors
│   │   └── interceptors/
│   │       ├── connectivity_interceptor.dart
│   │       ├── retry_interceptor.dart
│   │       └── logging_interceptor.dart
│   ├── theme/                      # AppColors, AppTextStyles, AppTheme, ThemeCubit
│   ├── router/                     # (Prepared for future route management)
│   └── utils/                      # Logger, constants, dotLottie helper
│
└── features/
    └── breathing/                  # Breathing exercise feature
        ├── domain/
        │   └── entities/
        │       ├── breathing_config.dart    # Session configuration model
        │       └── breathing_phase.dart     # Phase enum & extensions
        └── presentation/
            ├── blocs/
            │   ├── setup/          # SetupBloc — config state
            │   └── session/        # SessionBloc — timer, phases, audio
            ├── screens/
            │   ├── setup_screen.dart       # Configure session parameters
            │   ├── breathing_screen.dart   # Active breathing session
            │   └── finish_screen.dart      # Session complete
            └── widgets/
                ├── breathing_bubble.dart        # Animated bubble widget
                ├── duration_chip.dart           # Duration selector chip
                └── phase_duration_control.dart  # Per-phase stepper
```

### Layer Responsibilities

**Core** — framework-agnostic infrastructure: HTTP client with retry/connectivity interceptors, local storage wrappers, theming system, error handling, and shared utilities.

**Domain** — business entities and enums. `BreathingConfig` holds session parameters (durations per phase, rounds, sound preference). `BreathingPhase` defines the four-phase cycle with display labels and bubble behavior.

**Presentation** — UI and state management via BLoC:

| BLoC | Purpose |
|---|---|
| `BreathingSetupBloc` | Manages configuration UI: duration selection, round count, advanced timing, sound toggle |
| `BreathingSessionBloc` | Drives the active session: countdown timer, phase transitions, cycle tracking, audio playback, pause/resume |
| `ThemeCubit` | Toggles between light and dark theme modes |

### Navigation Flow

```
SetupScreen (/)
    │
    ▼  [Start]
BreathingScreen (/breathing)
    │
    ▼  [Session completes]
FinishScreen (/finish)
    │
    ├── [Start Again] ──▶ BreathingScreen
    └── [Back to Setup] ──▶ SetupScreen
```

Routes are defined in `app.dart` using `MaterialApp`'s named routing with `BreathingConfig` passed as a route argument.

## Theming

The app ships with two fully designed themes controlled by `ThemeCubit`:

| | Light | Dark |
|---|---|---|
| **Background** | `#E8D7F1` → `#F5E0D0` gradient | `#1A1128` → `#2D1B4E` gradient |
| **Decorations** | SVG clouds | SVG clouds + stars overlay |
| **Buttons** | Purple `#630068` | Muted purple `#823386` |
| **Chips** | White fill, orange selected | Dark fill, orange selected |

Brand gradient (orange `#FF8A00` → purple `#6C0862`) is used across accent elements.

## Assets

```
assets/
├── images/
│   ├── light_mode_assets/   # SVG clouds, moon icon
│   └── dark_mode_assets/    # SVG clouds, stars, sun icon
├── animations/
│   └── green_check.lottie   # Success animation (dotLottie format)
├── icons/
│   ├── icon_cross.svg       # Close / cancel
│   └── fast_wind.svg        # Breathing icon
└── chime.mp3                # Phase transition chime
```

The `.lottie` file is a zipped Lottie archive extracted at runtime using a custom `DotLottieUtil` helper.

## Future-Ready Infrastructure

While the app currently runs fully offline, the codebase includes production-ready networking infrastructure:

- **DioClient** with configurable base URL, auth token management, and standard CRUD methods
- **ConnectivityInterceptor** that rejects requests when offline
- **RetryInterceptor** with exponential backoff for transient failures
- **LoggingInterceptor** for debugging HTTP traffic
- **PreferenceService** with auth token storage keys pre-defined
- **HiveService** ready for structured local data persistence

This makes it straightforward to add backend features (user accounts, session history sync, etc.) without restructuring the app.

## License

This project is proprietary. All rights reserved.
