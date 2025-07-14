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
                final isSelectable = snapshot.data == true;
                return ChoiceChip(
                  label: Text('${bibleApp.name}${isSelectable ? "" : " is not detected"}'),
                  onSelected: isSelectable
                      ? (bool selected) {
                          if (selected) bas.linkedBibleAppIndex = idx;
                        }
                      : null,
                  selected: idx == bas.linkedBibleAppIndex,
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
            title: const Text(
                'You can configure a bible reading app to open whenever an unread chapter is tapped. To do so, first install the app then select it below.'),
            tiles: [
              SettingsTile(
                leading: Icon(bas.isLinked ? Icons.link : Icons.link_off),
                title: const Text('Linked App'),
                value: Wrap(spacing: 16, children: choiceChipList()),
              )
            ],
          )
        ],
      ),
    );
  }
}
