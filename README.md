# Game of Life (Flutter)

A polished Flutter implementation of Conway's Game of Life with an interactive simulator, pattern reference demos, and a theme system.

## What This App Includes

- Interactive Life grid:
  - Tap cells to toggle alive/dead state.
  - Drag to paint multiple cells quickly.
  - Start/Pause simulation, clear board, and random seed generation.
  - Speed control slider.
  - Live metrics for generation count and alive cells.
- PNG export:
  - Save the **initial setup** (generation `0`) as a PNG.
  - Export path: app documents directory under `gol_exports/`.
- Info experience:
  - Rules, philosophy, and core concepts of Conway's Game of Life.
  - Animated pattern showcase with filters (`All`, `Still Life`, `Oscillator`, `Spaceship`).
  - Included demo patterns: `Block`, `Blinker`, `Toad`, `Glider`, `LWSS`.
- Theme system:
  - Light/Dark mode toggle.
  - Multiple curated themes:
    - Monochrome: `Graphite`, `Mist`, `Slate`
    - Color: `Old Green Geek`, `Dark Solaris`, `Solaris Cyan`, `Solaris Crimson`, `Solaris Lime`
- UI shell:
  - Splash intro screen.
  - 3-tab dock navigation: Life, Info, Settings.

## Tech Stack

- Flutter (Material 3)
- Dart SDK constraint: `^3.10.1`
- Packages:
  - `path_provider` (for PNG export location)

## Getting Started

### Prerequisites

- Flutter SDK installed and configured (`flutter doctor` should pass)

### Run

```bash
flutter pub get
flutter run
```

### Test

```bash
flutter test
```

## Project Structure

- `lib/main.dart` - app entrypoint
- `lib/src/app.dart` - root app widget and theme mode wiring
- `lib/src/screens/life_screen.dart` - simulator, controls, export logic
- `lib/src/screens/info_screen.dart` - educational content + pattern demos
- `lib/src/screens/settings_screen.dart` - theme and dark mode controls
- `lib/src/screens/app_shell.dart` - dock navigation shell
- `lib/src/screens/splash_gate.dart` - splash-to-app transition
- `lib/src/theme/app_theme.dart` - theme definitions and palettes

