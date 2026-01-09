import 'package:flutter/material.dart';
import 'package:shared_widgets/public_api/loaders.dart' show AppLoader;

/// ⏳ [SplashPage] — Displays a loading indicator
//
final class SplashPage extends StatelessWidget {
  ///-----------------------------------------
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoader());
  }
}
