import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "O‘YINLAR",
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange),
                SizedBox(width: 6),
                Text("0", style: TextStyle(color: Colors.black)),
              ],
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildGameCard(
              "LETTER BOX",
              "Kataklar orasidagi yashirin so'zni toping",
              [Colors.amber, Colors.orange],
            ),
            buildGameCard(
              "MEMORY PATH",
              "Rasmlarni eslang va ularni to'g'ri so'zlar bilan moslang",
              [Colors.red, Colors.orange],
            ),
            buildGameCard(
              "CRAFT IT",
              "Harfalar orasiga yashiringan so'zlarni toping",
              [Colors.purple, Colors.pinkAccent],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGameCard(String title, String subtitle, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          /// МЕСТО ДЛЯ ФОТО (одинаковое)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}