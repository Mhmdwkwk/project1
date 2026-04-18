import 'package:flutter/material.dart';
import 'package:project/screens/home_screen.dart';

void main() {
  runApp( NumericalApp());
}

class NumericalApp extends StatelessWidget {
  NumericalApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Numerical Analysis Solver',

      theme: ThemeData(
        primaryColor: Colors.blue
      ),
        home: HomeScreen(),
    );}}
