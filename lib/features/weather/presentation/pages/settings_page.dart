import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../widgets/custom_app_bar.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);
    final isCelsius = temperatureUnit == TemperatureUnit.celsius;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        icon: Icons.settings,
        isMainPage: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Temperature Unit'),
            subtitle: Text(isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
            trailing: Switch(
              value: isCelsius,
              onChanged: (value) {
                ref.read(temperatureUnitProvider.notifier).state = value
                    ? TemperatureUnit.celsius
                    : TemperatureUnit.fahrenheit;
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Weather App v1.0.0'),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
