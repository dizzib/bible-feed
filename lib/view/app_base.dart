import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '/extension/build_context.dart';
import '/service/haptic_service.dart';
import 'app.dart';

class AppBase extends StatelessWidget {
  @override
  build(context) {
    theme(Brightness brightness) => ThemeData(
          cardTheme: CardThemeData(surfaceTintColor: context.colorScheme.surfaceTint),
          colorScheme: ColorScheme.fromSeed(
            brightness: brightness,
            seedColor: const Color(0xffbb86fc),
            tertiary: brightness == Brightness.dark ? Colors.red : Colors.amber,
          ),
        );

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [sl<HapticService>()],
        title: 'Bible Feed',
        themeMode: ThemeMode.system,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        home: App(),
      ),
    );
  }
}
