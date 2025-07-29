import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:watch_it/watch_it.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Version:', style: TextStyle(fontWeight: FontWeight.normal)),
        Text(sl<PackageInfo>().version),
      ],
    );
  }
}
