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
  late T _popupManager; // ignore: avoid-late-keyword, set in initState
  bool _isPopupShowing = false;

  @override
  void initState() {
    super.initState();
    _popupManager = sl<T>();
    _popupManager.addListener(_onPopupRequested);
  }

  Future showPopup() async {
    _isPopupShowing = true;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        final backgroundColor = _popupManager.getBackgroundColor();
        final foregroundColor = _popupManager.getForegroundColor();
        return BackdropFilter(
          // ignore: no-equal-arguments, x and y must be equal
          filter: ImageFilter.blur(sigmaX: Constants.blurSigma, sigmaY: Constants.blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(top: Constants.defaultBorderRadius),
            ),
            padding: Constants.defaultPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: Constants.defaultPadding,
                  child: Text(
                    _popupManager.getText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: foregroundColor),
                  ),
                ),
                if (_popupManager.hasAction)
                  ElevatedButton(
                    key: const ValueKey('popup_action'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: foregroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Constants.defaultBorderRadius),
                      ),
                    ),
                    onPressed: () {
                      _popupManager.action();
                      Navigator.pop(context);
                    },
                    child: Text(_popupManager.actionText!), // ignore: avoid-non-null-assertion, passed hasAction guard
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPopupRequested() {
    // Ensure safe timing
    // ignore: avoid-passing-async-when-sync-expected, must await
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _isPopupShowing) return;
      await showPopup();
      if (mounted) {
        setState(() => _isPopupShowing = false);
      } else {
        _isPopupShowing = false;
      }
    });
  }

  @override
  void dispose() {
    _popupManager.removeListener(_onPopupRequested);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
