import 'package:flutter/material.dart';

class StatsDisplay extends StatelessWidget {
  final String userId;

  const StatsDisplay({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Here you can fetch user stats from a provider or directly from Firebase
    // For now, we're using static data as a placeholder.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('100', style: Theme.of(context).textTheme.bodyLarge),
            const Text('Posts'),
          ],
        ),
        Column(
          children: [
            Text('200', style: Theme.of(context).textTheme.bodyLarge),
            const Text('Followers'),
          ],
        ),
        Column(
          children: [
            Text('180', style: Theme.of(context).textTheme.bodyLarge),
            const Text('Following'),
          ],
        ),
      ],
    );
  }
}
