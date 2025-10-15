import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/feeds_advance_manager.dart';
import '_build_context_extension.dart';
import '_constants.dart';

class AllDoneDialog extends StatelessWidget {
  @override
  build(context) {
    void onPressYes() {
      sl<FeedsAdvanceManager>().advance();
      Navigator.pop(context);
    }

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
        TextButton(onPressed: onPressYes, child: const Text('Yes')),
      ],
    );
  }
}
