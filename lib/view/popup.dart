import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../manager/popup_manager.dart';
import '_constants.dart';
import 'popup_body.dart';

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
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.1), // dim slightly
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BackdropFilter(
          // ignore: no-equal-arguments, x and y must be equal
          filter: ImageFilter.blur(sigmaX: Constants.blurSigma, sigmaY: Constants.blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: _popupManager.getBackgroundColor(),
              borderRadius: const BorderRadius.vertical(top: Constants.defaultBorderRadius),
            ),
            padding: Constants.defaultPadding,
            child: PopupBody<T>(),
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
