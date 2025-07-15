import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/service/background_service.dart';

class AllDoneDialogCloser extends StatefulWidget {
  @override
  State<AllDoneDialogCloser> createState() => _AllDoneDialogCloserState();
}

class _AllDoneDialogCloserState extends State<AllDoneDialogCloser> {
  @override
  void initState() {
    super.initState();
    sl<BackgroundService>().addListener(() {
      Navigator.maybePop(context); // dismiss possible dialog (originator might be cron)
    });
  }

  @override
  build(context) {
    return Container();
  }
}
