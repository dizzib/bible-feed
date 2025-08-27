import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/toggler_service.dart';

class SettingsToggler<T extends TogglerService> extends StatelessWidget {
  SettingsToggler({super.key});

  final ts = watchIt<T>();

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacing),
        child: SwitchListTile(
          title: Text(
            ts.title,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: spacing),
            child: Text(ts.subtitle),
          ),
          value: ts.isEnabled,
          onChanged: (value) => ts.isEnabled = value,
        ),
      ),
    );
  }
}
