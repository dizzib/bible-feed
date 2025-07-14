import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watch_it/watch_it.dart';
import '/service/bible_app_service.dart';

class Settings extends WatchingWidget {
  @override
  build(context) {
    final bas = watchIt<BibleAppService>();

    choiceChipList() => List.generate(bas.bibleAppList.length, (idx) {
          var bibleApp = bas.bibleAppList[idx];
          return ChoiceChip(
            label: Text(bibleApp.name),
            onSelected: (bool selected) {
              if (selected) bas.selectedBibleAppIndex = idx;
            },
            selected: idx == bas.selectedBibleAppIndex,
          );
        });

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Tap behaviour'),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.link),
                title: const Text('App'),
                value: Wrap(spacing: 16, children: choiceChipList()),
              )
            ],
          )
        ],
      ),
    );
  }
}
