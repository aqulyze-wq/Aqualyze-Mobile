# Aqualyze — Flutter

Flutter conversion of the Aqualyze React/Tailwind aquaculture monitoring app.

## Project Structure

```
lib/
├── main.dart                    # App entry + full state management (_AppRootState)
├── theme/
│   └── app_theme.dart           # Design tokens, colors, text styles, glassCard()
├── models/
│   └── models.dart              # AquaUser, AquaNotification, enums
├── widgets/
│   └── shared_widgets.dart      # GlassCard, AppHeader, AquaNavBar,
│                                #   AquaTextField, StatusBadge, SparklinePainter
└── screens/
    ├── login_screen.dart        # LoginScreen — animated login button states
    ├── dashboard_screen.dart    # DashboardScreen — live metrics, camera switcher,
    │                            #   fullscreen modal
    └── other_screens.dart       # MonitoringScreen, AnalyticsScreen,
                                 #   NotificationsScreen, ProfileScreen
                                 #   + all modal sub-widgets
```

## Design Token Mapping

| CSS / Tailwind             | Flutter constant                  |
|----------------------------|-----------------------------------|
| `--color-primary: #1565C0` | `AquaColors.primary`              |
| `--color-primary: #004D99` | `AquaColors.primaryDark`          |
| `#ba1a1a`                  | `AquaColors.danger`               |
| `#26C6DA`                  | `AquaColors.cyan`                 |
| `.glass-card`              | `glassCard()` + `GlassCard` widget|
| `Plus Jakarta Sans`        | `AquaText.font`                   |
| `.wave-bg` gradient        | `Positioned` gradient overlays    |

## Key Flutter Patterns

| React pattern               | Flutter equivalent                          |
|-----------------------------|---------------------------------------------|
| `useState` live timer       | `Timer.periodic` + `setState`               |
| `AnimatePresence` fade/slide| `AnimatedSwitcher` with Fade+Slide          |
| `CSS @keyframes moveWave`   | `LinearGradient` bottom overlay (static)    |
| SVG sparkline path          | `CustomPainter` (`SparklinePainter`)        |
| SVG chart with gradient     | `CustomPainter` + `LinearGradient` shader   |
| Framer `scale-95` active    | `GestureDetector` + `AnimatedContainer`     |
| `fixed bottom-0` navbar     | `Stack` + `Positioned` bottom               |
| Modal overlay               | `Stack` + `_ModalOverlay` widget            |

## Setup

1. **Font** — Download [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans),
   place `.ttf` files in `fonts/` folder.

2. **Install deps**
   ```bash
   flutter pub get
   ```

3. **Run**
   ```bash
   flutter run
   ```

## Screens Overview

| Screen        | Features                                                      |
|---------------|---------------------------------------------------------------|
| Login         | Animated button (idle → loading → success), remember me toggle|
| Dashboard     | Live temp/pH ticker, camera switcher, fullscreen modal        |
| Monitoring    | 3 sensor cards with sparklines, refresh button                |
| Analytics     | Period toggle (daily/weekly/monthly), metric tabs, SVG chart  |
| Notifications | Action buttons, dismiss with animation, mark all read         |
| Profile       | Edit modal, notification settings modal, FAQ accordion modal  |
