import 'package:flutter/material.dart';
import '../screens/versus_game_screen.dart';
import '../models/models.dart';
import '../config/theme/colors.dart';
import 'glass_container.dart';

class GameCardWidget extends StatelessWidget {
  final GameModel game;
  const GameCardWidget({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          if (game.title == 'VERSUS') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VersusGameScreen()),
            );
          }
        },
        child: GlassContainer(
          borderRadius: 32,
          padding: const EdgeInsets.all(2),
          opacity: 0.1,
          gradient: LinearGradient(
            colors: [
              game.gradientColors[0].withValues(alpha: 0.4),
              game.gradientColors[1].withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          game.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'O\'ynash',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Hero(
                    tag: 'game_${game.title}',
                    child: _buildGameIcon(game),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameIcon(GameModel game) {
    if (game.extraData == 'GAME_GRID') {
      return GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(8),
        opacity: 0.2,
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
        clipBehavior: Clip.none,
        children: [
          _buildMemoryCard(0.1, const Offset(0, 0)),
          _buildMemoryCard(-0.1, const Offset(20, -5)),
          _buildMemoryCard(0.2, const Offset(40, -10)),
        ],
      );
    } else if (game.title == 'CRAFT IT') {
      return GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(8),
        opacity: 0.2,
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            'W', 'O', 'Z', 'L', 'R', 'D', 'N', 'U', '',
          ].map((e) => _buildLetterBox(e)).toList(),
        ),
      );
    }
    return GlassContainer(
      borderRadius: 20,
      width: 80,
      height: 80,
      opacity: 0.2,
      child: const Center(
        child: Icon(
          Icons.videogame_asset_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGridRow(List<String> letters, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        letters.length,
        (i) => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: colors[i].withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              letters[i],
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
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
        child: GlassContainer(
          width: 44,
          height: 54,
          borderRadius: 10,
          opacity: 0.3,
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
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
        color: l == 'O' || l == 'R' 
            ? Colors.orange.withValues(alpha: 0.3) 
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          l,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
