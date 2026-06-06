import 'package:flutter/material.dart';
import 'home_page/home_page.dart';

void main() {
  runApp(const HolofoteApp());
}

class HolofoteApp extends StatelessWidget {
  const HolofoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holofote Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
