import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/dino_game.dart';

void main() {
  runApp(const GDGApp());
}

class GDGApp extends StatelessWidget {
  const GDGApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDG Dino Jump',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget(
          game: DinoGame(),
          overlayBuilderMap: {
            'StartScreen': (context, game) => StartScreen(game: game as DinoGame),
            'GameOver': (context, game) => GameOverScreen(game: game as DinoGame),
          },
          initialActiveOverlays: const ['StartScreen'],
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  final DinoGame game;
  const StartScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('GDG', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF4285F4), letterSpacing: 4)),
          const SizedBox(height: 8),
          const Text('🦕 DINO JUMP', style: TextStyle(fontSize: 28, color: Colors.white, letterSpacing: 2)),
          const SizedBox(height: 40),
          const Text('Press SPACE or TAP to Jump', style: TextStyle(fontSize: 16, color: Colors.white60)),
          const SizedBox(height: 8),
          const Text('Double jump supported!', style: TextStyle(fontSize: 13, color: Colors.white38)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              game.startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285F4),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('PLAY NOW', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          const SizedBox(height: 60),
          const Text('Want to build this? Tune in on the 28th 🚀', style: TextStyle(fontSize: 13, color: Color(0xFFEA4335))),
        ],
      ),
    );
  }
}
class GameOverScreen extends StatelessWidget {
  final DinoGame game;
  const GameOverScreen({super.key, required this.game});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('GAME OVER', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFEA4335), letterSpacing: 4)),
          const SizedBox(height: 20),
          Text('Score: ${game.score}', style: const TextStyle(fontSize: 28, color: Colors.white)),
          Text('Best: ${game.highScore}', style: const TextStyle(fontSize: 18, color: Colors.white60)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              game.resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A853),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('TRY AGAIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ),
          const SizedBox(height: 60),
          const Text('Want to build this? Tune in on the 28th!! 🚀', style: TextStyle(fontSize: 13, color: Color(0xFFEA4335))),
        ],
      ),
    );
  }
}
