import 'package:blinkit/food_login.dart';
import 'package:blinkit/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: _RootDecider(),
    );
  }
}

/// Decides the initial screen based on layout:
/// - Wide layouts (web/desktop) → `HomeScreen` (which shows `WebHome`)
/// - Narrow layouts (mobile/tablet) → `LoginPage` first
class _RootDecider extends StatelessWidget {
  const _RootDecider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const HomeScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
