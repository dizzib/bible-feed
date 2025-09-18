import 'package:flutter/material.dart';

import 'build_context_extension.dart';
import 'settings.dart';

class SettingsIconButton extends StatelessWidget {
  @override
  build(BuildContext context) => IconButton(
    key: const Key('settingsIconButton'), // for generate screenshots
    icon: const Icon(Icons.settings, size: 32),
    tooltip: 'Open settings',
    onPressed: () => context.navigateTo(Settings()),
  );
}
