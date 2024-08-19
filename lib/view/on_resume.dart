import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '../model/feeds.dart';

class OnResume extends StatefulWidget {
  final Widget child;

  const OnResume({
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
    if (state == AppLifecycleState.resumed) di<Feeds>().maybeAdvance;
  }

  @override
  build(_) => widget.child;
}
