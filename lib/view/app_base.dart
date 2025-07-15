import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import '/extension/build_context.dart';
import '/service/background_service.dart';
import 'app.dart';

class AppBase extends StatefulWidget {
  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  @override
  void initState() {
    super.initState();
    sl<BackgroundService>().addListener(() {
      Navigator.maybePop(context); // dismiss possible dialog (originator might be cron)
    });
  }

  @override
  build(context) {
    theme(Brightness brightness) => ThemeData(
          cardTheme: CardTheme(surfaceTintColor: context.colorScheme.surfaceTint),
          colorScheme: ColorScheme.fromSeed(
            brightness: brightness,
            seedColor: const Color(0xffbb86fc),
            tertiary: brightness == Brightness.dark ? Colors.red : Colors.amber,
          ),
        );

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bible Feed',
        themeMode: ThemeMode.system,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        home: App(),
      ),
    );
  }
}
