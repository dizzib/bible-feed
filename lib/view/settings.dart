import 'package:bible_feed/model/bible_reader.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_reader_service.dart';
import 'bible_reader_link_icon.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    final brs = watchIt<BibleReaderService>();

    choiceChipList() => List.generate(brs.certifiedBibleReaderList.length, (idx) {
          final BibleReader br = brs.certifiedBibleReaderList[idx];
          return FutureBuilder<bool>(
              future: br.isSelectable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                final isSelectable = snapshot.data == true;
                return ChoiceChip(
                  label: Text('${br.displayName}${isSelectable ? "" : " is not detected"}'),
                  onSelected: isSelectable
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
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text(
                'You can configure a bible reader to open a chapter when tapped. If the bible reader is an app, please ensure it is installed.'),
            tiles: [
              SettingsTile(
                leading: BibleReaderLinkIcon(),
                title: const Text('Bible Reader'),
                value: Wrap(spacing: 16, children: choiceChipList()),
              )
            ],
          )
        ],
      ),
    );
  }
}
