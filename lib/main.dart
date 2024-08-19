import 'package:flutter/material.dart';
import 'util/build_context.dart';
import 'view/feeds_view.dart';
import 'view/on_midnight.dart';
import 'view/on_resume.dart';
import 'init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(App());
}

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
        home: Stack(
          children: [
            OnResume(),
            FeedsView(),
            OnMidnight(),  // last, for debugging
          ],
        ),
      ),
    );
  }
}
