import 'package:flutter/material.dart';

import '/extension/build_context.dart';
import 'settings.dart';

class SettingsIconButton extends StatelessWidget {
  @override
  build(BuildContext context) => IconButton(
    key: const Key('settingsIconButton'), // for generate screenshots
    icon: const Icon(Icons.settings, size: 32),
    onPressed: () => context.navigateTo(Settings()),
  );
}
