import 'package:flutter/material.dart';

class OnResume extends StatefulWidget {
  final Function onResume;
  final Widget child;

  const OnResume({
    required this.onResume,
    required this.child,
  });

  @override
  State<OnResume> createState() => _OnResumeState();
}

class _OnResumeState extends State<OnResume> with WidgetsBindingObserver {
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
