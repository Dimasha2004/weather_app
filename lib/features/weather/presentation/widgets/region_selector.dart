import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

// Region selector widget for filtering cities by region
class RegionSelector extends ConsumerWidget {
  const RegionSelector({super.key});

  static const Map<String, List<String>> regionCities = {
    'Europe': ['London', 'Paris', 'Berlin', 'Rome', 'Madrid', 'Amsterdam'],
    'Asia': ['Tokyo', 'Beijing', 'Mumbai', 'Seoul', 'Bangkok', 'Singapore'],
    'Americas': [
      'New York',
      'Los Angeles',
      'Toronto',
      'Mexico City',
      'São Paulo',
      'Buenos Aires',
    ],
    'Africa': [
      'Cairo',
      'Lagos',
      'Nairobi',
      'Johannesburg',
      'Casablanca',
      'Accra',
    ],
    'Oceania': [
      'Sydney',
      'Melbourne',
      'Auckland',
      'Brisbane',
      'Perth',
      'Wellington',
    ],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegion = ref.watch(selectedRegionProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Region',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedRegion,
              isExpanded: true,
              items: regionCities.keys.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(selectedRegionProvider.notifier).state = newValue;
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Popular Cities in $selectedRegion',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (regionCities[selectedRegion] ?? []).map((city) {
                return ActionChip(
                  label: Text(city),
                  onPressed: () {
                    ref.read(currentCityProvider.notifier).state = city;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
