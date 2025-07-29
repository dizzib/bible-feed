import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:watch_it/watch_it.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version ${sl<PackageInfo>().version} (${sl<PackageInfo>().buildNumber})',
    );
  }
}
