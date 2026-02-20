import 'package:blinkit/mobile_home.dart';
import 'package:blinkit/webhome.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const WebHome();
        } else {
          return const MobileHome();
        }
      },
    );
  }
}