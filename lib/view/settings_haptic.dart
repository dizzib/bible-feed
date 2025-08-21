import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/haptic_service.dart';

class HapticSettings extends StatelessWidget {
  HapticSettings({super.key});

  final hs = watchIt<HapticService>();

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacing),
        child: SwitchListTile(
          title: const Text('Touch', style: TextStyle(fontSize: 20),),
          subtitle: const Text('Vibrate this device on tap.'),
          value: hs.isEnabled,
          onChanged: (value) => hs.isEnabled = value,
        ),
      ),
    );
  }
}
