import 'package:flutter/material.dart';
import '../models/models.dart';

class GameCardWidget extends StatelessWidget {
  final GameModel game;
  const GameCardWidget({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: game.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        game.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildGameIcon(game)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameIcon(GameModel game) {
    if (game.extraData == 'GAME_GRID') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildGridRow(
              ['G', 'A', 'M', 'E'],
              [
                Colors.blue.shade200,
                Colors.orange.shade300,
                Colors.grey.shade400,
                Colors.orange.shade200,
              ],
            ),
            const SizedBox(height: 4),
            _buildGridRow(
              ['H', 'E', 'A', 'D'],
              [
                Colors.grey.shade400,
                Colors.green.shade400,
                Colors.green.shade400,
                Colors.green.shade400,
              ],
            ),
            const SizedBox(height: 4),
            _buildGridRow(
              ['R', 'E', 'A', 'D'],
              [
                Colors.green.shade400,
                Colors.green.shade400,
                Colors.green.shade400,
                Colors.green.shade400,
              ],
            ),
          ],
        ),
      );
    } else if (game.title == 'MEMORY PATH') {
      return Stack(
        children: [
          _buildMemoryCard(0.1, const Offset(0, 0)),
          _buildMemoryCard(-0.1, const Offset(30, 10)),
          _buildMemoryCard(0.2, const Offset(60, 20)),
        ],
      );
    } else if (game.title == 'CRAFT IT') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            'W',
            'O',
            'Z',
            'L',
            'R',
            'D',
            'N',
            'U',
            '',
          ].map((e) => _buildLetterBox(e)).toList(),
        ),
      );
    }
    // Fallback for VERSUS and LAST LETTER
    return const Icon(
      Icons.videogame_asset_rounded,
      size: 80,
      color: Colors.white,
    );
  }

  Widget _buildGridRow(List<String> letters, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        letters.length,
        (i) => Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: colors[i],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              letters[i],
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryCard(double angle, Offset offset) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBox(String l) {
    if (l.isEmpty) return const SizedBox();
    return Container(
      decoration: BoxDecoration(
        color: l == 'O' || l == 'R' ? Colors.orange.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          l,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: l == 'O' || l == 'R' ? Colors.orange : Colors.black87,
          ),
        ),
      ),
    );
  }
}
