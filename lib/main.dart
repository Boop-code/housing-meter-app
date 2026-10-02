import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const HousingMeterApp());
}

class HousingMeterApp extends StatelessWidget {
  const HousingMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Учёт показаний ЖКХ',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),

      home: const HomeScreen(),
    );
  }
}