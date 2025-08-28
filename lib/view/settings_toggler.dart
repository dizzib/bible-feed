import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/service/toggler_service.dart';

class SettingsToggler<T extends TogglerService> extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final ts = watchIt<T>();

    const spacing = 12.0;

    return Opacity(
      opacity: ts.canEnable ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !ts.canEnable,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(spacing),
            child: SwitchListTile(
              title: Text(
                ts.title,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: spacing),
                child: Text(ts.subtitle),
              ),
              value: ts.isEnabled,
              onChanged: (value) => ts.isEnabled = value,
            ),
          ),
        ),
      ),
    );
  }
}
