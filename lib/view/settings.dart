import 'package:bible_feed/model/bible_reader.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_reader_app_install_service.dart';
import '/service/bible_reader_service.dart';
import 'bible_reader_link_icon.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    watchIt<BibleReaderAppInstallService>();
    final brs = watchIt<BibleReaderService>();

    choiceChipList() => List.generate(brs.certifiedBibleReaderList.length, (idx) {
          final BibleReader br = brs.certifiedBibleReaderList[idx];
          return FutureBuilder<bool>(
              future: br.isAvailable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                final isAvailable = snapshot.data == true;
                return ChoiceChip(
                  label: Text('${br.displayName}${isAvailable ? "" : " is not detected"}'),
                  onSelected: isAvailable
                      ? (bool selected) {
                          if (selected) brs.linkedBibleReaderIndex = idx;
                        }
                      : null,
                  selected: idx == brs.linkedBibleReaderIndex,
                );
              });
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Row(
              spacing: 8,
              children: [
                const Text(
                  'Bible Reader',
                  style: TextStyle(fontSize: 20),
                ),
                BibleReaderLinkIcon(),
              ],
            ),
            const Text(
                'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.'),
            Wrap(spacing: 16, children: choiceChipList()),
          ],
        ),
      ),
    );
  }
}
