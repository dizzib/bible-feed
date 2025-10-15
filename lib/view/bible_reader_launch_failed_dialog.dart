import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/bible_reader_link_manager.dart';
import 'constants.dart';

class BibleReaderLaunchFailedDialog extends StatelessWidget {
  final Exception exception;

  const BibleReaderLaunchFailedDialog(this.exception);

  @override
  build(context) {
    final bibleReader = sl<BibleReaderLinkManager>().linkedBibleReader;
    final bibleReaderName = bibleReader.name;
    var message = bibleReader.isApp ? 'Please ensure the $bibleReaderName app is installed, or try' : 'Try';
    message = '$message choosing another bible reader in settings.';

    return CupertinoAlertDialog(
      title: Text('Failed to launch the $bibleReaderName bible reader'),
      content: Padding(padding: Constants.defaultPadding, child: Text('$message\n\n${exception.toString()}'.trim())),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],
    );
  }
}
