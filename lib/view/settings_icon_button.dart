import 'package:flutter/material.dart';

import '/extension/build_context.dart';
import 'settings.dart';

class SettingsIconButton extends StatelessWidget {
  @override
  build(BuildContext context) => IconButton(
        onPressed: () => context.navigateTo(Settings()),
        icon: const Icon(
          Icons.settings,
          size: 32,
        ),
      );
}
