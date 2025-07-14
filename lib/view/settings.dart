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
          return FutureBuilder<bool>(
              future: bibleApp.isSelectable(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ChoiceChip(
                  label: Text(bibleApp.name),
                  onSelected: snapshot.data == true
                      ? (bool selected) {
                          if (selected) bas.selectedBibleAppIndex = idx;
                        }
                      : null,
                  selected: idx == bas.selectedBibleAppIndex,
                );
              });
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Tap behaviour'),
            tiles: [
              SettingsTile(
                leading: Icon(bas.isLinked ? Icons.link : Icons.link_off),
                title: const Text('Link App'),
                value: Wrap(spacing: 16, children: choiceChipList()),
              )
            ],
          )
        ],
      ),
    );
  }
}
