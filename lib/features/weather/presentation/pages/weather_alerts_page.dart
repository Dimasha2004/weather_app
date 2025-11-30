import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_app_bar.dart';

// Simple weather alerts page
// Note: Free OpenWeatherMap API has limited alert data
class WeatherAlertsPage extends ConsumerWidget {
  const WeatherAlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock alerts for demonstration
    final alerts = <Map<String, String>>[];

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Weather Alerts',
        icon: Icons.warning_amber_rounded,
        isMainPage: true,
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Active Alerts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'There are currently no weather alerts for your area',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.warning,
                      color: _getSeverityColor(alert['severity'] ?? 'low'),
                    ),
                    title: Text(alert['title'] ?? ''),
                    subtitle: Text(alert['description'] ?? ''),
                    trailing: Text(
                      alert['time'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.yellow;
    }
  }
}
