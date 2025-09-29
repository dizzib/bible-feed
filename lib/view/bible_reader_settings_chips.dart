import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/bible_reader_launch_service.dart';
import '/model/bible_reader.dart';
import '/service/app_install_service.dart';
import '/service/bible_reader_link_service.dart';

class BibleReaderSettingsChips extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    watchIt<AppInstallService>();
    final brs = watchIt<BibleReaderLinkService>();

    return Wrap(
      spacing: 12.0,
      children: List.generate(brs.certifiedBibleReaderList.length, (idx) {
        final BibleReader bibleReader = brs.certifiedBibleReaderList[idx];
        return FutureBuilder<bool>(
          future: sl<BibleReaderLaunchService>().isAvailable(bibleReader),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            onSelected(bool selected) {
              if (selected) brs.linkedBibleReaderIndex = idx;
            }

            final isAvailable = snapshot.data == true;
            return ChoiceChip(
              label: Text('${bibleReader.displayName}${isAvailable ? "" : " is not detected"}'),
              onSelected: isAvailable ? onSelected : null,
              selected: idx == brs.linkedBibleReaderIndex,
            );
          },
        );
      }),
    );
  }
}
