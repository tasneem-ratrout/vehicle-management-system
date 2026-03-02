import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VehicleApp());
}

class VehicleApp extends StatelessWidget {
  const VehicleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Management System',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}