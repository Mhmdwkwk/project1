import 'package:flutter/material.dart';
import 'package:project/screens/rootmenu.dart';
import 'package:project/screens/Linear_menu.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Numerical Analysis Solver",
          style: TextStyle(
              color: Colors.white70
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/IMG-20250710-WA0021.jpg",
            ),SizedBox(height: 20,),

            ElevatedButton(style:

            ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 70)
            ), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => Rootmenu(),));
            }, child: Text("Chapter One",style: TextStyle(
              color: Colors.white54,
              fontSize: 39,
              fontWeight: FontWeight.bold ,
            ),
            ),),
            const SizedBox(height: 20),

            ElevatedButton(style:
          ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 70)
          ), onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder:(context) =>  LinearMenu(),));
           }, child: Text("Chapter Two",style: TextStyle(
              color: Colors.white54,
              fontSize: 39,
              fontWeight: FontWeight.bold ,
    ),
    ),),

          ],
        ),
      ),

    );
  }
}
