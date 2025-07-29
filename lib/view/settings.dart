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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: RawScrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              spacing: 16,
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: BibleReaderLinkIcon(),
                        title: const Text('Bible Reader'),
                        subtitle: const Text(
                            'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(spacing: 16, children: choiceChipList()),
                      ),
                    ],
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
