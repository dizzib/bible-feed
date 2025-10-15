import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/setting_manager.dart';
import '_constants.dart';

class Setting<T extends SettingManager> extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final togglerService = watchIt<T>();

    return Opacity(
      opacity: togglerService.canEnable ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !togglerService.canEnable,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Constants.settingsSpacing),
            child: SwitchListTile(
              title: Text(togglerService.title, style: const TextStyle(fontSize: 20)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: Constants.settingsSpacing),
                child: Text(togglerService.subtitle),
              ),
              value: togglerService.isEnabled,
              onChanged: (value) => togglerService.isEnabled = value,
            ),
          ),
        ),
      ),
    );
  }
}
