import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../widgets/custom_app_bar.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search City',
        icon: Icons.search,
        isMainPage: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'City Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // In a real app, we might want to update a "selected city" provider
                  // For now, let's just pop back with the result or navigate to home with new city
                  // But since HomePage uses a provider family, we need a way to update the "current city" state.
                  // Let's create a StateProvider for the current city.
                  ref.read(currentCityProvider.notifier).state = value;
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  ref.read(currentCityProvider.notifier).state =
                      _controller.text;
                  Navigator.pop(context);
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
