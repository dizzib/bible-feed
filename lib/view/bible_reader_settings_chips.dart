import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/app_install_manager.dart';
import '../manager/bible_reader_launch_manager.dart';
import '../manager/bible_reader_link_manager.dart';
import '../manager/bible_readers_certified_manager.dart';
import '_constants.dart';

class BibleReaderSettingsChips extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    watchIt<AppInstallManager>();
    final brlm = watchIt<BibleReaderLinkManager>();
    final certifiedBibleReaderList = sl<BibleReadersCertifiedManager>().certifiedBibleReaderList;

    return Wrap(
      spacing: Constants.defaultSpacing,
      children: List.generate(certifiedBibleReaderList.length, (idx) {
        final bibleReader = certifiedBibleReaderList[idx];
        // Using watchFuture here causes an infinite loop because .isAvailable always returns a new future.
        return FutureBuilder(
          future: sl<BibleReaderLaunchManager>().isAvailable(bibleReader),
          builder: (_, AsyncSnapshot<bool> snapshot) {
            onSelected(bool selected) {
              if (selected) brlm.linkedBibleReaderIndex = idx;
            }

            final isAvailable = snapshot.data ?? false;
            return ChoiceChip(
              label: Text('${bibleReader.displayName}${isAvailable ? "" : " is not detected"}'),
              onSelected: isAvailable ? onSelected : null,
              selected: idx == brlm.linkedBibleReaderIndex,
            );
          },
        );
      }),
    );
  }
}
