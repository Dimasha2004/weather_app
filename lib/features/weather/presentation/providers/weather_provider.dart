import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';

// Data Source Provider
final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((
  ref,
) {
  return WeatherRemoteDataSourceImpl(client: Dio());
});

// Repository Provider
final weatherRepositoryProvider = Provider<WeatherRepositoryImpl>((ref) {
  return WeatherRepositoryImpl(
    remoteDataSource: ref.read(weatherRemoteDataSourceProvider),
  );
});

// Use Case Providers
final getCurrentWeatherProvider = Provider<GetCurrentWeather>((ref) {
  return GetCurrentWeather(ref.read(weatherRepositoryProvider));
});

final getForecastProvider = Provider<GetForecast>((ref) {
  return GetForecast(ref.read(weatherRepositoryProvider));
});

// State Providers
final currentCityProvider = StateProvider<String>((ref) => 'London');

final currentWeatherProvider = FutureProvider<Weather>((ref) async {
  final city = ref.watch(currentCityProvider);
  final getCurrentWeather = ref.read(getCurrentWeatherProvider);
  final result = await getCurrentWeather(city);
  return result.fold(
    (failure) => throw Exception('Failed to load weather'),
    (weather) => weather,
  );
});

final forecastProvider = FutureProvider<List<Weather>>((ref) async {
  final city = ref.watch(currentCityProvider);
  final getForecast = ref.read(getForecastProvider);
  final result = await getForecast(city);
  return result.fold(
    (failure) => throw Exception('Failed to load forecast'),
    (forecast) => forecast,
  );
});

// Date Range Providers
final dateRangeTypeProvider = StateProvider<DateRangeType>(
  (ref) => DateRangeType.sevenDays,
);

final customDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

final filteredForecastProvider = Provider<AsyncValue<List<Weather>>>((ref) {
  final forecastAsync = ref.watch(forecastProvider);
  final rangeType = ref.watch(dateRangeTypeProvider);
  final customRange = ref.watch(customDateRangeProvider);

  return forecastAsync.when(
    data: (forecast) {
      final now = DateTime.now();
      List<Weather> filtered;

      switch (rangeType) {
        case DateRangeType.oneDay:
          final oneDayLater = now.add(const Duration(days: 1));
          filtered = forecast
              .where((w) => w.date.isBefore(oneDayLater))
              .toList();
          break;
        case DateRangeType.sevenDays:
        case DateRangeType.oneMonth:
          // Show all available data (API limitation: max 5 days)
          filtered = forecast;
          break;
        case DateRangeType.custom:
          if (customRange != null) {
            filtered = forecast.where((w) {
              return w.date.isAfter(
                    customRange.start.subtract(const Duration(days: 1)),
                  ) &&
                  w.date.isBefore(customRange.end.add(const Duration(days: 1)));
            }).toList();
          } else {
            filtered = forecast;
          }
          break;
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// DateRangeType enum
enum DateRangeType { oneDay, sevenDays, oneMonth, custom }

// Temperature Unit Provider
enum TemperatureUnit { celsius, fahrenheit }

final temperatureUnitProvider = StateProvider<TemperatureUnit>(
  (ref) => TemperatureUnit.celsius,
);

// Helper function to convert temperature
double convertTemperature(double celsius, TemperatureUnit unit) {
  if (unit == TemperatureUnit.fahrenheit) {
    return (celsius * 9 / 5) + 32;
  }
  return celsius;
}

String getTemperatureSymbol(TemperatureUnit unit) {
  return unit == TemperatureUnit.celsius ? '°C' : '°F';
}

// GPS Location Providers
final locationPermissionProvider = FutureProvider<LocationPermission>((
  ref,
) async {
  return await Geolocator.checkPermission();
});

final currentPositionProvider = FutureProvider<Position?>((ref) async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  return await Geolocator.getCurrentPosition();
});

final weatherByLocationProvider = FutureProvider<Weather?>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  if (position == null) return null;

  final remoteDataSource = ref.read(weatherRemoteDataSourceProvider);
  try {
    return await remoteDataSource.getCurrentWeatherByCoordinates(
      position.latitude,
      position.longitude,
    );
  } catch (e) {
    return null;
  }
});

// Region Filtering Provider
final selectedRegionProvider = StateProvider<String>((ref) => 'Europe');

// Bottom Navigation Index Provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
