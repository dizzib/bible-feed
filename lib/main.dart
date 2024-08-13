import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/reading_lists.dart';
import 'model/feeds.dart';
import 'util/build_context.dart';
import 'util/store.dart';
import 'view/feeds_view.dart';
import 'on_resume_widget.dart';

final feeds = Feeds(readingLists);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
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
        home: OnResumeWidget(
          onResume: feeds.maybeAdvance,
          child: ChangeNotifierProvider<Feeds>(
            create: (_) => feeds,
            child: FeedsView(feeds),
            ),
          ),
        ),
      );
  }
}
