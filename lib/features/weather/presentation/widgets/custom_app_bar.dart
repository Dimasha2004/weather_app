import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final bool isMainPage;
  final List<Widget>? extraActions;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.isMainPage = true,
    this.extraActions,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: isMainPage
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            )
          : null, // Default back button will show if null and canPop
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMainPage) ...[
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        if (onNotificationPressed != null || isMainPage)
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black87,
            ),
            onPressed:
                onNotificationPressed ??
                () {
                  // Switch to Alerts tab (index 2)
                  ref.read(bottomNavIndexProvider.notifier).state = 2;

                  // If we are not on the main screen (e.g. search page), pop until we are
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
          ),
        if (extraActions != null) ...extraActions!,
      ],
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
