import 'package:flutter/material.dart';
import 'package:project/screens/gauss_screen.dart';
import 'package:project/screens/gauss_jordan.dart';
import 'package:project/screens/lUdecomposition.dart';
import 'package:project/screens/cramer.dart';
class LinearMenu  extends StatelessWidget{
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
          buildButton(context, "Gauss elimination", GaussPage() ),
          buildButton(context, "LU  ", LUPivotPage()),
          buildButton(context, "Gauss Jordan", GaussJordanPage()),
          buildButton(context, "Cramer", CramerPage())



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
