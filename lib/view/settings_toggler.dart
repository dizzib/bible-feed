import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/toggler_service.dart';

class SettingsToggler<T extends TogglerService> extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final togglerService = watchIt<T>();

    const spacing = 12.0;

    return Opacity(
      opacity: togglerService.canEnable ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !togglerService.canEnable,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(spacing),
            child: SwitchListTile(
              title: Text(togglerService.title, style: const TextStyle(fontSize: 20)),
              subtitle: Padding(padding: const EdgeInsets.only(top: spacing), child: Text(togglerService.subtitle)),
              value: togglerService.isEnabled,
              onChanged: (value) => togglerService.isEnabled = value,
            ),
          ),
        ),
      ),
    );
  }
}
