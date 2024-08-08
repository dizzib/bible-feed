import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/reading_lists.dart';
import 'model/feeds.dart';
import 'util/build_context.dart';
import 'util/store.dart';
import 'view/feeds_view.dart';

final feeds = Feeds(readingLists);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) feeds.maybeAdvance();
  }

  @override
  build(context) {
    theme(Brightness brightness) =>
      ThemeData(
        cardTheme: CardTheme(surfaceTintColor: context.surfaceTint),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffbb86fc),
          brightness: brightness,
        ),
      );

    return SafeArea(
      child: MaterialApp(
        title: 'Bible Feed',
        themeMode: ThemeMode.system,
        theme: theme(Brightness.light),
        darkTheme: theme(Brightness.dark),
        home: ChangeNotifierProvider<Feeds>(
          create: (_) => feeds,
          child: FeedsView(feeds),
        ),
      ),
    );
  }
}
