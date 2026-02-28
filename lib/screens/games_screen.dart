import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/game_card_widget.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = Provider.of<AppProvider>(context).games;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('O\'YINLAR'),
        actions: [
          Row(
            children: const [
              Icon(Icons.star_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 4),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GameCardWidget(game: games[index]);
        },
      ),
    );
  }
}
