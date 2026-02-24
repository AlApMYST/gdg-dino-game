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

class GlitchTitle extends StatefulWidget {
  final double fontSize;
  const GlitchTitle({super.key, required this.fontSize});

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
    final style = TextStyle(
      fontFamily: 'PressStart2P',
      fontSize: widget.fontSize,
      color: Colors.white,
      letterSpacing: 2,
    );

    return SizedBox(
      height: widget.fontSize * 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showGlitch)
            Transform.translate(
              offset: Offset(_offsetX, 2),
              child: Text(
                text,
                style: style.copyWith(
                  color: const Color(0xFFFF0040).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (_showGlitch)
            Transform.translate(
              offset: Offset(_offsetX2, -2),
              child: Text(
                text,
                style: style.copyWith(
                  color: const Color(0xFF00FFFF).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Text(text, style: style, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  final DinoGame game;
  const StartScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isMobile = sw < 600;

    final titleSize = isMobile ? 16.0 : 28.0;
    final subtitleSize = isMobile ? 7.0 : 11.0;
    final buttonSize = isMobile ? 12.0 : 16.0;
    final taglineSize = isMobile ? 7.0 : 9.0;
    final spacing = isMobile ? sh * 0.03 : sh * 0.05;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0015), Color(0xFF0D0D2B)],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlitchTitle(fontSize: titleSize),
                SizedBox(height: spacing * 0.5),
                Text(
                  'LOADING... > TOKENIZE... > INFERENCE > GLITCH',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: const Color(0xFF00FF88),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 1.5),
                Text(
                  '[ PRESS SPACE OR TAP ]',
                  style: TextStyle(
                    fontSize: isMobile ? 10.0 : 12.0,
                    color: const Color(0xFFBB86FC),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 0.3),
                Text(
                  '2x JUMP ENABLED',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: const Color(0xFF00FFFF),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                GestureDetector(
                  onTap: () => game.startGame(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.08,
                      vertical: sh * 0.018,
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
                    child: Text(
                      '> INITIALIZE',
                      style: TextStyle(
                        fontSize: buttonSize,
                        color: const Color(0xFF00FFFF),
                        fontFamily: 'PressStart2P',
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                Text(
                  'CAN YOU SURVIVE THE LLM?',
                  style: TextStyle(
                    fontSize: taglineSize,
                    color: const Color(0xFFFF6B9D),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  final DinoGame game;
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isMobile = sw < 600;

    final titleSize = isMobile ? 18.0 : 24.0;
    final subtitleSize = isMobile ? 8.0 : 10.0;
    final scoreSize = isMobile ? 14.0 : 20.0;
    final bestSize = isMobile ? 10.0 : 14.0;
    final buttonSize = isMobile ? 12.0 : 16.0;
    final taglineSize = isMobile ? 7.0 : 9.0;
    final spacing = isMobile ? sh * 0.025 : sh * 0.04;

    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '[ SYSTEM CRASH ]',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6B9D),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 0.5),
                Text(
                  'LLM HAS BROKEN YOU',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: const Color(0xFFBB86FC),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing),
                Text(
                  'SCORE: ${game.score.toString().padLeft(5, '0')}',
                  style: TextStyle(
                    fontSize: scoreSize,
                    color: const Color(0xFF00FFFF),
                    fontFamily: 'PressStart2P',
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: spacing * 0.4),
                Text(
                  'BEST:  ${game.highScore.toString().padLeft(5, '0')}',
                  style: TextStyle(
                    fontSize: bestSize,
                    color: const Color(0xFFBB86FC),
                    fontFamily: 'PressStart2P',
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: spacing * 1.2),
                GestureDetector(
                  onTap: () => game.resetGame(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.08,
                      vertical: sh * 0.018,
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
                    child: Text(
                      '> RESTART',
                      style: TextStyle(
                        fontSize: buttonSize,
                        color: const Color(0xFFFF6B9D),
                        fontFamily: 'PressStart2P',
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.5),
                Text(
                  'WANT TO BUILD THIS?',
                  style: TextStyle(
                    fontSize: taglineSize,
                    color: const Color(0xFF00FF88),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 0.3),
                Text(
                  'JOIN US ON OUR NEXT EVENT!',
                  style: TextStyle(
                    fontSize: taglineSize,
                    color: const Color(0xFF00FF88),
                    letterSpacing: 2,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}