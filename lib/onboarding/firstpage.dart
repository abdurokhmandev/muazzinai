import 'package:flutter/material.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SizedBox(
            width: 52,
            height: 32,
            child: Image.asset("assets/icon.png"),
          ),
        ),
        title: const Icon(Icons.arrow_drop_down),
        actions: const [
          Icon(Icons.local_fire_department),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(child: Text("0")),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Super Arab tili", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          Container(
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          )
        ],
      ),
    );
  }
}