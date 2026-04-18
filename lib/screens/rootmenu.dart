import 'package:flutter/material.dart';
import 'package:project/screens/bisection_screen.dart';
import 'package:project/screens/false_postion.dart';
import 'package:project/screens/Simple_flex.dart';
import 'package:project/screens/newton.dart';
import 'package:project/screens/secant_method.dart';
class Rootmenu  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Linear Methode",
          style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          const SizedBox(height: 100),
          buildButton(context, "Bisection Method", BisectionPage() ),
          buildButton(context, "FalsePositionMethod", FalsePositionPage()),
          buildButton(context, " SimpleFixedPoint",SimpleFixedPointDark ()),
          buildButton(context, "Newton Method", NewtonScreen()),
          buildButton(context, "Secant Method", SecantPage())

        ],
      ),

    );
  }
}
Widget buildButton(BuildContext context, String text,Widget page ) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 70),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
