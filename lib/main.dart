import 'package:flutter/material.dart';

import 'calculatory_two.dart'; // For evaluating math expressions

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: CalculatorScreen(),
    );
  }
}