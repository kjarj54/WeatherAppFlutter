import 'package:flutter/material.dart';
import 'package:weatherappflutter/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      checkerboardRasterCacheImages: false,
      debugShowMaterialGrid: false,
      title: 'Weather App',
      home: HomeScreen()
      );
  }
}
