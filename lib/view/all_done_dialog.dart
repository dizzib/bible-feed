import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/feeds_advance_service.dart';
import 'build_context_extension.dart';
import 'constants.dart';

class AllDoneDialog extends StatelessWidget {
  @override
  build(context) {
    return CupertinoAlertDialog(
      title: Text('All done!', style: context.textTheme.titleLarge),
      content: SingleChildScrollView(
        child: Padding(
          padding: Constants.defaultPadding,
          child: Text('Lists advance at midnight.\n\nAdvance now?', style: context.textTheme.bodyLarge),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
        TextButton(
          onPressed: () {
            sl<FeedsAdvanceService>().forceAdvance();
            Navigator.pop(context);
          }, // dialog is dismissed in FeedsView
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
