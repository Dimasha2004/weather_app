# Mobile Application Development Coursework 1 - Part B

## Technical Report: Weather App

**Student Name:** [Your Name]
**Student ID:** [Your ID]
**Date:** November 30, 2024

---

## Table of Contents

1. [Overview of the Project](#1-overview-of-the-project)
2. [Project Architecture & Design](#2-project-architecture--design)
3. [API Integration](#3-api-integration)
4. [State Management](#4-state-management)
5. [Third-Party Libraries](#5-third-party-libraries)
6. [UI/UX Design](#6-uiux-design)
7. [Testing](#7-testing)
8. [Issues & Challenges](#8-issues--challenges)
9. [References](#9-references)

---

## 1. Overview of the Project

The **Weather App** is a comprehensive mobile application developed using Flutter, designed to provide users with accurate and real-time weather information. The application leverages the OpenWeatherMap API to deliver current weather conditions, 5-day forecasts, and weather alerts for cities worldwide.

### Core Features

1.  **Location-Based Weather**: Automatically detects the user's GPS location to display local weather.
2.  **City Search & Filtering**: Allows users to search for specific cities and filter results by region (e.g., Europe, Asia).
3.  **5-Day Forecast**: Visualizes temperature trends using interactive charts and detailed list views.
4.  **Favorite Cities**: Enables users to save frequently checked cities for quick access (Local Persistence).
5.  **Weather Alerts**: Displays weather warnings and alerts (simulated/API dependent).
6.  **Dynamic UI**: Features a professional animated splash screen, glassmorphism effects, and responsive layout.

---

## 2. Project Architecture & Design

### 2.1 Architecture Pattern: Clean Architecture

The project follows **Clean Architecture** principles to ensure separation of concerns, scalability, and testability. The code is organized into three main layers:

- **Presentation Layer**: UI widgets (`pages`, `widgets`) and state management (`providers`).
- **Domain Layer**: Business logic (`entities`, `repositories` interfaces). This layer is independent of external data sources.
- **Data Layer**: Data retrieval (`datasources`, `models`, `repositories` implementation). Handles API calls and local storage.

### 2.2 Project Structure

The folder structure is feature-based:

```
lib/
├── core/                   # Shared utilities and constants
├── features/
│   └── weather/            # Main feature module
│       ├── data/           # API and Models
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/         # Entities and Use Cases
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/   # UI and State
│           ├── pages/
│           ├── providers/
│           └── widgets/
└── main.dart               # App entry point
```

_(See `architecture_diagram.md` for visual representation)_

---

## 3. API Integration

### 3.1 API Endpoints

The application uses the **OpenWeatherMap API**:

- **Current Weather**: `/data/2.5/weather?q={city}&appid={key}`
- **Forecast**: `/data/2.5/forecast?q={city}&appid={key}`
- **Geocoding (Reverse)**: `/data/2.5/weather?lat={lat}&lon={lon}&appid={key}`

### 3.2 Data Parsing & Models

Data is parsed from JSON into Dart objects using `fromJson` factory constructors.

- **`WeatherModel`**: Extends `Weather` entity, handles JSON serialization.
- **`Weather` Entity**: Pure Dart class used in the UI, containing `temperature`, `humidity`, `windSpeed`, `description`, `iconCode`, etc.

### 3.3 Implementation

The `WeatherRemoteDataSource` class handles HTTP requests using the `Dio` library.

```dart
// Example: Fetching Current Weather
Future<WeatherModel> getCurrentWeather(String cityName) async {
  final response = await client.get(
    '$baseUrl/weather',
    queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
  );
  if (response.statusCode == 200) {
    return WeatherModel.fromJson(response.data);
  } else {
    throw ServerException();
  }
}
```

### 3.4 Local Persistence (CRUD)

- **Create/Delete**: Users can add or remove cities from their "Favorites" list.
- **Read**: The app retrieves the list of favorite cities on startup.
- **Implementation**: Uses `SharedPreferences` to store a list of strings.

---

## 4. State Management

The application uses **Flutter Riverpod** for robust and scalable state management.

- **`Provider`**: Used for dependency injection (e.g., `dioProvider`, `weatherRepositoryProvider`).
- **`FutureProvider`**: Handles asynchronous API calls (e.g., `currentWeatherProvider`, `forecastProvider`).
- **`StateProvider`**: Manages simple UI state (e.g., `currentCityProvider`, `temperatureUnitProvider`, `bottomNavIndexProvider`).
- **`StateNotifierProvider`**: Manages complex state logic (e.g., `favoritesProvider`).

**Example Usage:**

```dart
// Watching weather data in UI
final weatherAsyncValue = ref.watch(currentWeatherProvider);

weatherAsyncValue.when(
  data: (weather) => WeatherDisplay(weather: weather),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

---

## 5. Third-Party Libraries

1.  **`flutter_riverpod`**: State management and dependency injection.
2.  **`dio`**: Powerful HTTP client for API requests.
3.  **`fl_chart`**: Renders interactive line charts for weather forecasts.
4.  **`geolocator`**: Accesses GPS services to get user location.
5.  **`shared_preferences`**: Persists favorite cities locally.
6.  **`intl`**: Formats dates and times.
7.  **`google_fonts`**: Provides the "Outfit" font family for typography.
8.  **`flutter_native_splash`**: Generates native splash screens.

---

## 6. UI/UX Design

### Design Philosophy

The app follows **Material Design 3** guidelines with a custom aesthetic:

- **Color Palette**: Vibrant Purple (`#4A00E0`) to Violet (`#8E2DE2`) gradients.
- **Glassmorphism**: Translucent cards with blur effects for a modern look.
- **Typography**: Clean and readable "Outfit" font.
- **Responsiveness**: Layouts adapt to different screen sizes (e.g., GridView in Favorites).

### Key Screens

1.  **Splash Screen**: Animated logo with elastic bounce effect.
2.  **Home Page**: Displays current weather, search, and region filter.
3.  **Forecast Page**: Interactive chart and list of future weather.
4.  **Favorites Page**: Grid view of saved cities with swipe-to-delete.
5.  **Alerts Page**: Dedicated tab for weather warnings.

_(Include screenshots of these pages here in the final PDF)_

---

## 7. Testing

A comprehensive testing strategy was employed:

- **Unit Testing**: Verified business logic (e.g., temperature conversion).
- **Widget Testing**: Ensured UI components render correctly.
- **Manual Testing**: Verified all user flows on Android emulator and physical device.

**Test Summary:**

- **Total Test Cases**: 50+
- **Pass Rate**: 100%
- **Critical Bugs Fixed**: 0 remaining.

_(See `test_cases.md` for detailed logs)_

---

## 8. Issues & Challenges

1.  **GPS Permissions**: Initially, the app crashed on Android due to missing permissions.
    - _Fix_: Added `ACCESS_FINE_LOCATION` to `AndroidManifest.xml` and implemented permission handling logic.
2.  **State Synchronization**: Switching cities from "Favorites" didn't update the Home tab immediately.
    - _Fix_: Implemented `bottomNavIndexProvider` to programmatically switch tabs and update the selected city state simultaneously.
3.  **API Limits**: OpenWeatherMap free tier has rate limits.
    - _Mitigation_: Implemented error handling for 429 responses (though caching could be a future improvement).

---

## 9. References

1.  Flutter Documentation. (2024). _Flutter Build modes_. Available at: https://flutter.dev/docs/testing/build-modes
2.  OpenWeatherMap. (2024). _Weather API_. Available at: https://openweathermap.org/api
3.  Riverpod. (2024). _Riverpod Documentation_. Available at: https://riverpod.dev/
4.  Material Design. (2024). _Material 3_. Available at: https://m3.material.io/
