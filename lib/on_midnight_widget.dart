import 'package:flutter/material.dart';
import 'package:cron/cron.dart';

class OnMidnightWidget extends StatefulWidget {
  final Function onMidnight;
  final Widget child;

  const OnMidnightWidget({
    required this.onMidnight,
    required this.child,
  });

  @override
  State<OnMidnightWidget> createState() => _OnMidnightWidgetState();
}

class _OnMidnightWidgetState extends State<OnMidnightWidget> {
  final _cron = Cron();
  int? _retval;

  _OnMidnightWidgetState() {
    _cron.schedule(
      Schedule.parse('0 0 * * *'), () async {
        setState(() {
          _retval = widget.onMidnight();
        });
      }
    );
  }

  @override
  build(context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
          visible: true,  // set to true for debugging
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
        ),
      ],
    );
  }
}
