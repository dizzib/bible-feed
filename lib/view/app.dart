import 'package:flutter/material.dart';
import '../util/build_context.dart';
import 'feeds_view.dart';

class App extends StatelessWidget {
  @override
  build(context) {
    theme(Brightness brightness) =>
      ThemeData(
        cardTheme: CardTheme(surfaceTintColor: context.colorScheme.surfaceTint),
        colorScheme: ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: const Color(0xffbb86fc),
          tertiary: brightness == Brightness.dark ? Colors.red : Colors.amber,
        ),
      );

    return SafeArea(
      child: MaterialApp(
        title: 'Bible Feed',
        themeMode: ThemeMode.system,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        home: FeedsView(),
      ),
    );
  }
}
