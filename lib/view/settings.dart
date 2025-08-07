import 'package:bible_feed/model/bible_reader.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/model/bible_readers.dart';
import '/service/bible_reader_service.dart';
import 'app_version.dart';
import 'bible_reader_link_icon.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();

    choiceChipList() => List.generate(sl<BibleReaders>().certifiedList.length, (idx) {
          final BibleReader br = sl<BibleReaders>().certifiedList[idx];
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
      appBar: AppBar(title: const Text('Settings')),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              spacing: 16,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        BibleReaderLinkIcon(),
                        Expanded(
                          // https://docs.flutter.dev/ui/layout/constraints example 24-25
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              const Text('Bible Reader',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              const Text(
                                  'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.'),
                              Wrap(spacing: 16, children: choiceChipList()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const AppVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
