import 'package:flutter/material.dart';
import 'package:PengingatKu/screens/home.dart';
import 'package:PengingatKu/screens/splash.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
