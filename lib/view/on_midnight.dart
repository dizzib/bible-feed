import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:cron/cron.dart';
import '../model/feeds.dart';

class OnMidnight extends StatefulWidget {
  @override
  State<OnMidnight> createState() => _OnMidnightState();
}

class _OnMidnightState extends State<OnMidnight> {
  final _cron = Cron();
  int? _retval;

  _OnMidnightState() {
    _cron.schedule(
      Schedule.parse('0 * * * *'), () async {
        setState(() {
          _retval = di<Feeds>().maybeAdvance();
        });
      }
    );
  }

  @override
  build(context) =>
    Visibility(
      visible: false,  // set to true for debugging
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 24),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateTime.now().toString()),
              if (_retval == null) const Text('waiting...'),
              if (_retval != null) Text('retval = $_retval'),
            ],
          ),
        ),
      ),
    );
}
