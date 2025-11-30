# 🌦️ Weather App - Complete Documentation

A comprehensive weather application built with Flutter, featuring Clean Architecture, Riverpod state management, and OpenWeatherMap API integration.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-%232D3748.svg?style=for-the-badge&logo=riverpod&logoColor=white)

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Installation & Setup](#-installation--setup)
- [API Configuration](#-api-configuration)
- [Project Structure](#-project-structure)
- [State Management](#-state-management)
- [Building the App](#-building-the-app)
- [Testing](#-testing)
- [Known Issues](#-known-issues)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### Core Features (10 Implemented)

1. **📍 GPS Location-Based Weather**

   - Automatic location detection using device GPS
   - Permission handling for Android/iOS
   - Reverse geocoding to display city name

2. **🔍 City Search & Filtering**

   - Search any city worldwide
   - Region-based filtering (Europe, Asia, Americas, Africa, Oceania)
   - 30+ popular cities across 5 regions

3. **📅 5-Day Weather Forecast**

   - Interactive temperature trend charts
   - Date range selection (1 day, 7 days, 1 month, custom)
   - Detailed forecast cards with weather icons

4. **❤️ Favorite Cities Management**

   - Save frequently checked cities
   - Quick access via grid view
   - Swipe-to-delete functionality
   - Persistent storage using SharedPreferences

5. **🔔 Weather Alerts**

   - Dedicated alerts page
   - Weather warnings display
   - Notification icon in app bar

6. **🌡️ Temperature Unit Conversion**

   - Toggle between Celsius and Fahrenheit
   - Real-time conversion across all screens
   - Persistent user preference

7. **📊 Weather Charts**

   - Interactive line charts using FL Chart
   - Temperature trend visualization
   - Responsive chart design

8. **🎨 Professional UI/UX**

   - Material Design 3 guidelines
   - Glassmorphism effects
   - Animated splash screen
   - Purple-to-violet gradient theme
   - Responsive layouts

9. **🌍 Region-Based City Browser**

   - Browse cities by continent
   - Popular cities quick selection
   - Modal bottom sheet interface

10. **⚙️ Settings & Customization**
    - Temperature unit preferences
    - App information
    - Clean settings interface

---

## 📸 Screenshots

|           Splash Screen           |        Home Page         |          Forecast          |
| :-------------------------------: | :----------------------: | :------------------------: |
| Animated logo with elastic bounce | Current weather with GPS | 5-day forecast with charts |

|          Favorites           |             Search             |        Settings         |
| :--------------------------: | :----------------------------: | :---------------------: |
| Grid view with glassmorphism | City search with region filter | Temperature unit toggle |

|          Alerts          |     Region Selector     |
| :----------------------: | :---------------------: |
| Weather warnings display | Browse cities by region |

_(Add screenshots to `docs/screenshots/` folder)_

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three distinct layers:

### Layer Structure

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (UI, Widgets, Providers)           │
│  - Pages (Home, Forecast, etc.)     │
│  - Riverpod Providers               │
│  - Custom Widgets                   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│       Domain Layer                  │
│  (Business Logic)                   │
│  - Entities (Weather)               │
│  - Repository Interfaces            │
│  - Use Cases                        │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│        Data Layer                   │
│  (Data Sources, Models)             │
│  - Remote Data Source (API)         │
│  - Models (WeatherModel)            │
│  - Repository Implementation        │
└─────────────────────────────────────┘
```

### Key Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: Domain layer is independent of external frameworks
- **Testability**: Easy to mock and test each layer independently
- **Scalability**: Easy to add new features without affecting existing code

---

## 🛠️ Tech Stack

### Framework & Language

- **Flutter**: 3.10+
- **Dart**: 3.0+

### State Management

- **flutter_riverpod**: 2.6.1 - Reactive state management

### Networking

- **dio**: 5.7.0 - HTTP client for API calls

### UI Components

- **fl_chart**: 0.70.2 - Interactive charts
- **google_fonts**: 6.2.1 - Custom typography (Outfit font)

### Location Services

- **geolocator**: 13.0.4 - GPS location access

### Local Storage

- **shared_preferences**: 2.3.5 - Persistent key-value storage

### Utilities

- **intl**: 0.19.0 - Date/time formatting
- **flutter_native_splash**: 2.4.1 - Native splash screen generation

---

## 📦 Installation & Setup

### Prerequisites

1. **Flutter SDK** (3.10 or higher)

   ```bash
   flutter --version
   ```

2. **Android Studio** or **VS Code** with Flutter extensions

3. **Android SDK** (for Android development)

4. **Xcode** (for iOS development, macOS only)

### Step-by-Step Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/weather_app.git
   cd weather_app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify Flutter Setup**

   ```bash
   flutter doctor
   ```

   Fix any issues reported by Flutter Doctor.

4. **Configure API Key** (See next section)

5. **Run the App**

   ```bash
   # For Android
   flutter run

   # For iOS
   flutter run -d ios

   # For specific device
   flutter devices
   flutter run -d <device-id>
   ```

---

## 🔑 API Configuration

### Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to **API Keys** section
4. Copy your API key

### Configure in Project

1. Open `lib/features/weather/data/datasources/weather_remote_datasource.dart`

2. Locate the `apiKey` constant:

   ```dart
   static const String apiKey = 'YOUR_API_KEY_HERE';
   ```

3. Replace `YOUR_API_KEY_HERE` with your actual API key

4. **Security Note**: For production, use environment variables:
   ```dart
   static const String apiKey = String.fromEnvironment('WEATHER_API_KEY');
   ```
   Then run:
   ```bash
   flutter run --dart-define=WEATHER_API_KEY=your_actual_key
   ```

---

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities
│   ├── error/                      # Error handling
│   └── usecases/                   # Base use cases
│
├── features/
│   └── weather/                    # Weather feature module
│       ├── data/                   # Data layer
│       │   ├── datasources/
│       │   │   └── weather_remote_datasource.dart
│       │   ├── models/
│       │   │   └── weather_model.dart
│       │   └── repositories/
│       │       └── weather_repository_impl.dart
│       │
│       ├── domain/                 # Domain layer
│       │   ├── entities/
│       │   │   └── weather.dart
│       │   └── repositories/
│       │       └── weather_repository.dart
│       │
│       └── presentation/           # Presentation layer
│           ├── pages/
│           │   ├── home_page.dart
│           │   ├── forecast_page.dart
│           │   ├── favorites_page.dart
│           │   ├── search_page.dart
│           │   ├── settings_page.dart
│           │   ├── weather_alerts_page.dart
│           │   ├── main_screen.dart
│           │   └── splash_screen.dart
│           ├── providers/
│           │   └── weather_provider.dart
│           └── widgets/
│               ├── custom_app_bar.dart
│               ├── date_range_selector.dart
│               └── region_selector.dart
│
└── main.dart                       # App entry point
```

---

## 🔄 State Management

### Riverpod Providers

The app uses multiple provider types:

#### 1. **Provider** - Dependency Injection

```dart
final dioProvider = Provider<Dio>((ref) => Dio());
```

#### 2. **FutureProvider** - Async Data

```dart
final currentWeatherProvider = FutureProvider<Weather>((ref) async {
  final city = ref.watch(currentCityProvider);
  final repository = ref.read(weatherRepositoryProvider);
  return await repository.getCurrentWeather(city);
});
```

#### 3. **StateProvider** - Simple State

```dart
final currentCityProvider = StateProvider<String>((ref) => 'London');
final temperatureUnitProvider = StateProvider<TemperatureUnit>(
  (ref) => TemperatureUnit.celsius
);
```

#### 4. **StateNotifierProvider** - Complex State

```dart
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) => FavoritesNotifier()
);
```

### Usage in Widgets

```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(currentWeatherProvider);

    return weatherAsyncValue.when(
      data: (weather) => WeatherDisplay(weather: weather),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

---

## 🔨 Building the App

### Debug Build

```bash
flutter run
```

### Release Build (Android)

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

### Release Build (iOS)

```bash
flutter build ios --release

# Output location
# build/ios/iphoneos/Runner.app
```

### Build Optimizations

- **Tree Shaking**: Automatically removes unused code
- **Obfuscation**: Use `--obfuscate --split-debug-info=/<directory>`
- **Compression**: APK is automatically compressed

---

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/weather_model_test.dart
```

### Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Test Categories

1. **Unit Tests**: Business logic, models, utilities
2. **Widget Tests**: UI components
3. **Integration Tests**: API calls, data flow
4. **Manual Tests**: User flows, edge cases

See `test_cases.md` for detailed test documentation.

---

## ⚠️ Known Issues

### 1. API Key Security

- **Issue**: API key is hardcoded in source
- **Impact**: Medium security risk
- **Solution**: Use environment variables (see API Configuration)

### 2. Free API Limitations

- **Issue**: OpenWeatherMap free tier has rate limits (60 calls/minute)
- **Impact**: May fail with rapid requests
- **Solution**: Implement caching or upgrade to paid tier

### 3. Deprecation Warnings

- **Issue**: Some Flutter APIs show deprecation warnings
- **Impact**: None (still functional)
- **Solution**: Will be updated in future Flutter versions

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**[Your Name]**

- Student ID: [Your ID]
- Course: Mobile Application Development
- Institution: [Your Institution]

---

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for the weather API
- [Flutter](https://flutter.dev/) team for the amazing framework
- [Riverpod](https://riverpod.dev/) for state management
- [FL Chart](https://github.com/imaNNeo/fl_chart) for charting library

---

## 📞 Support

For issues or questions:

- Open an issue on GitHub
- Email: [your.email@example.com]

---

**Last Updated**: November 30, 2024  
**Version**: 1.0.0  
**Flutter Version**: 3.10+
