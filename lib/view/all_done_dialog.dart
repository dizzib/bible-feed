import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/extension/build_context.dart';
import '/model/feeds.dart';
import '/service/haptic_service.dart';

class AllDoneDialog extends StatelessWidget {
  @override
  build(context) {
    return CupertinoAlertDialog(
      title: Text('All done!', style: context.textTheme.titleLarge),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListBody(
            children: [
              Text('Lists advance at midnight.', style: context.textTheme.bodyLarge),
              Text('Advance now?', style: context.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            sl<HapticService>().impact();
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            sl<HapticService>().impact();
            sl<Feeds>().forceAdvance();
            Navigator.pop(context);
          }, // dialog is dismissed in FeedsView
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
