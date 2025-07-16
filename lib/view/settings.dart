import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_reader_service.dart';
import 'bible_reader_link_icon.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    final bas = watchIt<BibleReaderService>();

    choiceChipList() => List.generate(bas.bibleReaderList.length, (idx) {
          var bibleApp = bas.bibleReaderList[idx];
          return FutureBuilder<bool>(
              future: bibleApp.isSelectable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                final isSelectable = snapshot.data == true;
                return ChoiceChip(
                  label: Text('${bibleApp.name}${isSelectable ? "" : " is not detected"}'),
                  onSelected: isSelectable
                      ? (bool selected) {
                          if (selected) bas.linkedBibleReaderIndex = idx;
                        }
                      : null,
                  selected: idx == bas.linkedBibleReaderIndex,
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
