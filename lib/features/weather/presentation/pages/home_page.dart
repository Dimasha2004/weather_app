import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/presentation/widgets/region_selector.dart';
import 'package:weather_app/features/weather/presentation/widgets/custom_app_bar.dart';
import '../providers/weather_provider.dart';
import 'forecast_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(currentWeatherProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Weather',
        icon: Icons.cloud,
        isMainPage: true,
        extraActions: [
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Select Region',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const RegionSelector(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: weatherAsyncValue.when(
        data: (weather) => Consumer(
          builder: (context, ref, child) {
            final favorites = ref.watch(favoritesProvider);
            final isFavorite = favorites.contains(weather.cityName);
            return FloatingActionButton(
              onPressed: () {
                ref
                    .read(favoritesProvider.notifier)
                    .toggleFavorite(weather.cityName);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? '${weather.cityName} removed from favorites'
                          : '${weather.cityName} added to favorites',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.deepPurple,
              ),
            );
          },
        ),
        loading: () => null,
        error: (_, __) => null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A00E0), // Vibrant Purple
              Color(0xFF8E2DE2), // Vibrant Violet
            ],
          ),
        ),
        child: weatherAsyncValue.when(
          data: (weather) => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.cityName,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatDate(weather.date),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  // Use My Location Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final position = await ref.refresh(
                        currentPositionProvider.future,
                      );
                      if (position != null) {
                        final locationWeather = await ref.refresh(
                          weatherByLocationProvider.future,
                        );
                        if (locationWeather != null) {
                          ref.read(currentCityProvider.notifier).state =
                              locationWeather.cityName;
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Location permission denied'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use My Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.error,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final tempUnit = ref.watch(
                                  temperatureUnitProvider,
                                );
                                final temp = convertTemperature(
                                  weather.temperature,
                                  tempUnit,
                                );
                                final symbol = getTemperatureSymbol(tempUnit);
                                return Text(
                                  '${temp.toStringAsFixed(1)}$symbol',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                );
                              },
                            ),
                            Text(
                              weather.description.toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white70,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildWeatherDetail(
                                  context,
                                  Icons.water_drop,
                                  '${weather.humidity}%',
                                  'Humidity',
                                ),
                                const SizedBox(width: 20),
                                _buildWeatherDetail(
                                  context,
                                  Icons.air,
                                  '${weather.windSpeed} m/s',
                                  'Wind',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ForecastPage(cityName: weather.cityName),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('5-Day Forecast'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }
}
