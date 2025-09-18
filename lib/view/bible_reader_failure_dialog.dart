import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/service/result.dart';

class BibleReaderFailureDialog extends StatelessWidget {
  final Failure failure;

  const BibleReaderFailureDialog(this.failure);

  @override
  build(context) {
    return CupertinoAlertDialog(
      title: const Text('Failed to launch the bible reader'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('The bible reader is now disabled.\n\n${failure.exception?.toString() ?? ''}'.trim()),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],
    );
  }
}
