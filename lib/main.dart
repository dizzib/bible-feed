import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'data/reading_lists.dart';
import 'model/book.dart';
import 'model/feeds.dart';
import 'util/build_context.dart';
import 'util/store.dart';
import 'view/feeds_view.dart';
import 'view/on_midnight.dart';
import 'view/on_resume.dart';
import 'view/list_wheel_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  di.registerSingleton(Feeds(readingLists));
  di.registerSingleton(ListWheelState<Book>());
  di.registerSingleton(ListWheelState<int>());
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
        home: OnMidnight(
          child: OnResume(
            child: FeedsView(),
          ),
        ),
      ),
    );
  }
}
