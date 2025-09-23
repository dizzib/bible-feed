import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/bible_reader_launch_service.dart';
import '/model/bible_reader.dart';
import '/service/app_install_service.dart';
import '/service/bible_reader_service.dart';
import 'bible_reader_link_icon.dart';

class BibleReaderSettings extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    watchIt<AppInstallService>();
    final brs = watchIt<BibleReaderService>();

    List<FutureBuilder<bool>> choiceChipList() => List.generate(brs.certifiedBibleReaderList.length, (idx) {
      final BibleReader br = brs.certifiedBibleReaderList[idx];
      return FutureBuilder<bool>(
        future: sl<BibleReaderLaunchService>().isAvailable(br),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          onSelected(bool selected) {
            if (selected) brs.linkedBibleReaderIndex = idx;
          }

          final isAvailable = snapshot.data == true;
          return ChoiceChip(
            label: Text('${br.displayName}${isAvailable ? "" : " is not detected"}'),
            onSelected: isAvailable ? onSelected : null,
            selected: idx == brs.linkedBibleReaderIndex,
          );
        },
      );
    });

    const spacing = 12.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: spacing,
          children: [
            BibleReaderLinkIcon(),
            Expanded(
              // https://docs.flutter.dev/ui/layout/constraints example 24-25
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing,
                children: [
                  const Text('Bible Reader', style: TextStyle(fontSize: 20)),
                  const Text(
                    'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.',
                  ),
                  Wrap(spacing: spacing, children: choiceChipList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
