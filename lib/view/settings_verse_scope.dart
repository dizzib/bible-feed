import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/toggler_service.dart';

class VerseScopeSettings extends StatelessWidget {
  VerseScopeSettings({super.key});

  final vsts = watchIt<VerseScopeTogglerService>();

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacing),
        child: SwitchListTile(
          title: const Text(
            'Psalm 119',
            style: TextStyle(fontSize: 20),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: spacing),
            child: Text('Read 2 Hebrew letters each day.'),
          ),
          value: vsts.isEnabled,
          onChanged: (value) => vsts.isEnabled = value,
        ),
      ),
    );
  }
}
