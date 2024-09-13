import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';
import '../util/build_context.dart';

class AllDoneDialog extends StatelessWidget {
  @override
  build(context) {
    return CupertinoAlertDialog(
      title: Text('All done!', style: context.textTheme.titleLarge),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Lists advance at midnight.', style: context.textTheme.bodyLarge),
            Text('Advance now?', style: context.textTheme.bodyLarge),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            di<Feeds>().forceAdvance();
          }, // dialog is dismissed in FeedsView
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
