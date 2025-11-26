import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';

class Popup<T extends PopupManager> extends StatefulWidget {
  const Popup({super.key});

  @override
  State<Popup<T>> createState() => _PopupState<T>();
}

class _PopupState<T extends PopupManager> extends State<Popup<T>> {
  T? _popupManager; // nullable instead of late
  bool _isPopupShowing = false;

  @override
  void initState() {
    super.initState();
    _popupManager = sl<T>();
    _popupManager?.addListener(_onPopupRequested);
  }

  void _onPopupRequested() {
    final manager = _popupManager; // Grab a local copy to avoid reading a nullable repeatedly
    if (manager == null) return;

    // Ensure safe timing
    // ignore: avoid-passing-async-when-sync-expected, must await
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (_isPopupShowing) return;

      _isPopupShowing = true;

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: manager.backgroundColor(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: Constants.defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: Constants.defaultPadding,
                    child: Text(
                      manager.getText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: manager.foregroundColor()),
                    ),
                  ),
                  if (manager.hasAction)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: manager.backgroundColor(),
                        foregroundColor: manager.foregroundColor(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        manager.action?.call();
                        Navigator.pop(context);
                      },
                      child: Text(manager.actionText!), // ignore: avoid-non-null-assertion, passed hasAction guard
                    ),
                ],
              ),
            ),
          );
        },
      );

      if (mounted) {
        setState(() => _isPopupShowing = false);
      } else {
        _isPopupShowing = false;
      }
    });
  }

  @override
  void dispose() {
    _popupManager?.removeListener(_onPopupRequested);
    _popupManager = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
