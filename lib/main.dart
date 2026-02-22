import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'game/dino_game.dart';

void main() {
  runApp(const GDGApp());
}

class GDGApp extends StatelessWidget {
  const GDGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breaking an LLM',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget(
          game: DinoGame(),
          overlayBuilderMap: {
            'StartScreen': (context, game) =>
                StartScreen(game: game as DinoGame),
            'GameOver': (context, game) =>
                GameOverScreen(game: game as DinoGame),
          },
          initialActiveOverlays: const ['StartScreen'],
        ),
      ),
    );
  }
}

// ── GLITCH TITLE WIDGET ──
class GlitchTitle extends StatefulWidget {
  const GlitchTitle({super.key});

  @override
  State<GlitchTitle> createState() => _GlitchTitleState();
}

class _GlitchTitleState extends State<GlitchTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _offsetX = 0;
  double _offsetX2 = 0;
  bool _showGlitch = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(() {
        if (_random.nextDouble() > 0.97) {
          setState(() {
            _showGlitch = true;
            _offsetX = (_random.nextDouble() - 0.5) * 8;
            _offsetX2 = (_random.nextDouble() - 0.5) * 6;
          });
          Future.delayed(const Duration(milliseconds: 80), () {
            if (mounted) setState(() => _showGlitch = false);
          });
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const text = 'BREAKING AN LLM';
    const style = TextStyle(
      fontFamily: 'PressStart2P',
      fontSize: 28,
      color: Colors.white,
      letterSpacing: 2,
    );

    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Red glitch layer
          if (_showGlitch)
            Transform.translate(
              offset: Offset(_offsetX, 2),
              child: Text(
                text,
                style: style.copyWith(
                  color: const Color(0xFFFF0040).withOpacity(0.7),
                ),
              ),
            ),
          // Cyan glitch layer
          if (_showGlitch)
            Transform.translate(
              offset: Offset(_offsetX2, -2),
              child: Text(
                text,
                style: style.copyWith(
                  color: const Color(0xFF00FFFF).withOpacity(0.7),
                ),
              ),
            ),
          // Main white text on top
          Text(text, style: style),
        ],
      ),
    );
  }
}

// ── START SCREEN ──
class StartScreen extends StatelessWidget {
  final DinoGame game;
  const StartScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0015), Color(0xFF0D0D2B)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glitch title
            const GlitchTitle(),
            const SizedBox(height: 12),
            const Text(
              'LOADING... > TOKENIZE... > INFERENCE > GLITCH',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF00FF88),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              '[ PRESS SPACE OR TAP ]',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFBB86FC),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '2x JUMP ENABLED',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF00FFFF),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () => game.startGame(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF00FFFF),
                    width: 2,
                  ),
                  color: const Color(0xFF00FFFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFFF).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  '> INITIALIZE',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00FFFF),
                    fontFamily: 'PressStart2P',
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'CAN YOU SURVIVE THE LLM?',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFFFF6B9D),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── GAME OVER SCREEN ──
class GameOverScreen extends StatelessWidget {
  final DinoGame game;
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '[ SYSTEM CRASH ]',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'LLM HAS BROKEN YOU',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFFBB86FC),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'SCORE: ${game.score.toString().padLeft(5, '0')}',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF00FFFF),
                fontFamily: 'PressStart2P',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'BEST:  ${game.highScore.toString().padLeft(5, '0')}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFBB86FC),
                fontFamily: 'PressStart2P',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => game.resetGame(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFF6B9D),
                    width: 2,
                  ),
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B9D).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  '> RESTART',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFF6B9D),
                    fontFamily: 'PressStart2P',
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'WANT TO BUILD THIS?',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF00FF88),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'JOIN US ON THE 28TH!',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF00FF88),
                letterSpacing: 2,
                fontFamily: 'PressStart2P',
              ),
            ),
          ],
        ),
      ),
    );
  }
}