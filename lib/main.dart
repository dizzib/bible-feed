import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/feeds.dart';
import 'data/store.dart';
import 'model/feeds.dart';
import 'view/feeds_view.dart';

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
  Widget build(BuildContext context) {
    var td = ThemeData.dark();
    var tl = ThemeData.light();
    return SafeArea(
      child: MaterialApp(
        title: 'Bible Feed',
        // other techniques to customise these themes seem to result in high-contrast!?
        theme: tl.copyWith(colorScheme: tl.colorScheme.copyWith(secondaryContainer: Colors.amber)),
        darkTheme: td.copyWith(colorScheme: td.colorScheme.copyWith(secondaryContainer: Colors.red)),
        themeMode: ThemeMode.system,
        home: ChangeNotifierProvider<Feeds>(
          create: (_) => feeds,
          child: FeedsView(),
        ),
      ),
    );
  }
}
