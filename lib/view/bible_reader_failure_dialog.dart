import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/bible_reader_link_service.dart';
import '/service/result.dart';

class BibleReaderFailureDialog extends StatelessWidget {
  final Failure failure;

  const BibleReaderFailureDialog(this.failure);

  @override
  build(context) {
    final bibleReader = sl<BibleReaderLinkService>().linkedBibleReader;
    final bibleReaderName = bibleReader.name;
    var message = bibleReader.isApp ? 'Please ensure the $bibleReaderName app is installed, or try' : 'Try';
    message = '$message choosing another bible reader in settings';

    return CupertinoAlertDialog(
      title: Text('Failed to launch the $bibleReaderName bible reader'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('$message\n\n${failure.exception?.toString() ?? ''}'.trim()),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],
    );
  }
}
