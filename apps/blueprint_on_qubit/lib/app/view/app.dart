//
// ignore_for_file: public_member_api_docs

import 'package:blueprint_on_qubit/counter/counter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
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
