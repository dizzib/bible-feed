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

class _OnResumeState extends State<OnResume> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: di<Feeds>().maybeAdvance);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  build(_) => widget.child;
}
