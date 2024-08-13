import 'package:flutter/material.dart';

class OnResumeWidget extends StatefulWidget {
  final Widget child;
  final Function onResume;

  const OnResumeWidget({
    required this.onResume,
    required this.child,
  });

  @override
  State<OnResumeWidget> createState() => _OnResumeWidgetState();
}

class _OnResumeWidgetState extends State<OnResumeWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) widget.onResume;
  }

  @override
  build(_) => widget.child;
}
