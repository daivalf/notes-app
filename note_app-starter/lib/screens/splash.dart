import 'package:flutter/material.dart';
import 'package:note_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToMainMenu();
  }

  Future<void> _navigateToMainMenu() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Text(
          'PengingatKu',
          style: TextStyle(fontSize: 32, color: Color(0xFF293942), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}