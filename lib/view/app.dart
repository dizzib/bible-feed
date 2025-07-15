import 'package:flutter/material.dart';
import '/extension/build_context.dart';
import 'feeds_view.dart';
import 'settings.dart';

class App extends StatelessWidget {
  @override
  build(context) {
    return Scaffold(
      appBar: context.isOrientationLandscape
          ? null
          : AppBar(
              actions: [
                IconButton(
                    onPressed: () => context.showDialogNormal(Settings()),
                    icon: const Icon(
                      Icons.settings,
                      size: 35,
                    )),
              ],
            ),
      body: FeedsView(),
    );
  }
}
