import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/bible_reader_service.dart';

class BibleReaderFailureDialog extends StatelessWidget {
  @override
  build(context) {
    final br = sl<BibleReaderService>().linkedBibleReader;
    return CupertinoAlertDialog(
      title: const Text('Error!'),
      content: Text('Bible Feed was unable to launch ${br.displayName}.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],
    );
  }
}
