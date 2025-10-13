import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/app_install_service.dart';
import '../manager/bible_reader_launch_service.dart';
import '../manager/bible_reader_link_service.dart';
import '../manager/bible_readers_certified_service.dart';
import 'constants.dart';

class BibleReaderSettingsChips extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    watchIt<AppInstallService>();
    final brcs = sl<BibleReadersCertifiedService>();
    final brls = watchIt<BibleReaderLinkService>();

    return Wrap(
      spacing: Constants.settingsSpacing,
      children: List.generate(brcs.certifiedBibleReaderList.length, (idx) {
        final bibleReader = brcs.certifiedBibleReaderList[idx];
        // Using watchFuture here causes an infinite loop because .isAvailable always returns a new future.
        return FutureBuilder(
          future: sl<BibleReaderLaunchService>().isAvailable(bibleReader),
          builder: (_, AsyncSnapshot<bool> snapshot) {
            onSelected(bool selected) {
              if (selected) brls.linkedBibleReaderIndex = idx;
            }

            final isAvailable = snapshot.data ?? false;
            return ChoiceChip(
              label: Text('${bibleReader.displayName}${isAvailable ? "" : " is not detected"}'),
              onSelected: isAvailable ? onSelected : null,
              selected: idx == brls.linkedBibleReaderIndex,
            );
          },
        );
      }),
    );
  }
}
