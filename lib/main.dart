import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/reading_lists.dart';
import 'data/store.dart';
import 'model/feeds.dart';
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
  build(_) =>
    SafeArea(
      child: MaterialApp(
        title: 'Bible Feed',
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: ChangeNotifierProvider<Feeds>(
          create: (_) => feeds,
          child: FeedsView(feeds),
        ),
      ),
    );
}
