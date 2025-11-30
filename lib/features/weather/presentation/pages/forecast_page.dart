import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import '../providers/weather_provider.dart';
import '../widgets/date_range_selector.dart';
import '../widgets/custom_app_bar.dart';

class ForecastPage extends ConsumerWidget {
  final String cityName;

  const ForecastPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsyncValue = ref.watch(filteredForecastProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: '$cityName Forecast',
        icon: Icons.calendar_month,
        isMainPage: false,
      ),
      body: Column(
        children: [
          const DateRangeSelector(),
          Expanded(
            child: forecastAsyncValue.when(
              data: (forecast) {
                if (forecast.isEmpty) {
                  return const Center(
                    child: Text(
                      'No forecast data available for selected range',
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temperature Trend',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: _buildChart(context, ref, forecast),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Forecast Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: forecast.length,
                          itemBuilder: (context, index) {
                            final weather = forecast[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  'https://openweathermap.org/img/wn/${weather.iconCode}.png',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                                title: Text(
                                  DateFormat(
                                    'EEEE, MMM d • h:mm a',
                                  ).format(weather.date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(weather.description),
                                trailing: Consumer(
                                  builder: (context, ref, child) {
                                    final tempUnit = ref.watch(
                                      temperatureUnitProvider,
                                    );
                                    final temp = convertTemperature(
                                      weather.temperature,
                                      tempUnit,
                                    );
                                    final symbol = getTemperatureSymbol(
                                      tempUnit,
                                    );
                                    return Text(
                                      '${temp.toStringAsFixed(1)}$symbol',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    WidgetRef ref,
    List<Weather> forecast,
  ) {
    // Take the first 8 data points (approx 24 hours) for the chart to keep it readable
    final chartData = forecast.take(8).toList();
    final tempUnit = ref.watch(temperatureUnitProvider);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('h a').format(chartData[index].date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: chartData
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(
                    e.key.toDouble(),
                    convertTemperature(e.value.temperature, tempUnit),
                  ),
                )
                .toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
