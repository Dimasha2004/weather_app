import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class DateRangeSelector extends ConsumerWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(dateRangeTypeProvider);
    final customRange = ref.watch(customDateRangeProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('1 Day'),
                  selected: selectedRange == DateRangeType.oneDay,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(dateRangeTypeProvider.notifier).state =
                          DateRangeType.oneDay;
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('7 Days'),
                  selected: selectedRange == DateRangeType.sevenDays,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(dateRangeTypeProvider.notifier).state =
                          DateRangeType.sevenDays;
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('1 Month'),
                  selected: selectedRange == DateRangeType.oneMonth,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(dateRangeTypeProvider.notifier).state =
                          DateRangeType.oneMonth;
                    }
                  },
                ),
                ChoiceChip(
                  label: Text(
                    customRange != null
                        ? 'Custom (${_formatDateRange(customRange)})'
                        : 'Custom',
                  ),
                  selected: selectedRange == DateRangeType.custom,
                  onSelected: (selected) async {
                    if (selected) {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 5)),
                        initialDateRange: customRange,
                      );
                      if (picked != null) {
                        ref.read(customDateRangeProvider.notifier).state =
                            picked;
                        ref.read(dateRangeTypeProvider.notifier).state =
                            DateRangeType.custom;
                      }
                    }
                  },
                ),
              ],
            ),
            if (selectedRange == DateRangeType.oneMonth)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '1 Month forecast requires a premium API plan. Showing maximum available data (5 days).',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTimeRange range) {
    return '${range.start.month}/${range.start.day} - ${range.end.month}/${range.end.day}';
  }
}
