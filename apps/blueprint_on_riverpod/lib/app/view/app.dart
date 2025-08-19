import 'package:blueprint_on_riverpod/app/counter/view/counter_page.dart';
import 'package:flutter/material.dart';

///
final class App extends StatelessWidget {
  ///
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}
