import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/verse_scope_service.dart';

class VerseScopeSettings extends StatelessWidget {
  VerseScopeSettings({super.key});

  final vss = watchIt<VerseScopeService>();

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacing),
        child: SwitchListTile(
          title: const Text(
            'Verse scopes',
            style: TextStyle(fontSize: 20),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: spacing),
            child: Text('Psalm 119'),
          ),
          value: vss.isEnabled,
          onChanged: (value) => vss.isEnabled = value,
        ),
      ),
    );
  }
}
