import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/platform_service.dart';
import '_build_context_extension.dart';
import '_constants.dart';
import 'sync.dart';

class SyncIconButton extends StatelessWidget {
  @override
  build(BuildContext context) {
    final icon = sl<PlatformService>().isAndroid ? Icons.share : Icons.ios_share;
    return IconButton(
      key: const Key('syncIconButton'), // for generate screenshots
      icon: Icon(icon, size: Constants.appbarIconSize),
      tooltip: 'Share reading state',
      onPressed: () => context.showDialogWithBlurBackground(Sync()),
    );
  }
}
