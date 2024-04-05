import 'package:calculator/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Import CalculatorScreen
import 'pages/consts.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // Set CalculatorScreen as the home page
    );
  }
}
