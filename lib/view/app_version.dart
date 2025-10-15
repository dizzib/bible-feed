import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../service/app_service.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0.5, child: Text('Version ${sl<AppService>().version} (${sl<AppService>().buildNumber})'));
  }
}
