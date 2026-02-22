import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class HudComponent extends PositionComponent with HasGameRef<DinoGame> {
  @override
  void render(Canvas canvas) {
    if (!gameRef.isRunning) return;

    final scorePaint = TextPaint(
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF00FFFF),
        fontWeight: FontWeight.bold,
        fontFamily: 'PressStart2P',
      ),
    );

    final bestPaint = TextPaint(
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFBB86FC),
        fontFamily: 'PressStart2P',
      ),
    );

    final levelPaint = TextPaint(
      style: const TextStyle(
        fontSize: 9,
        color: Color(0xFFFF6B9D),
        fontFamily: 'PressStart2P',
      ),
    );

    final bottomPaint = TextPaint(
      style: TextStyle(
        fontSize: 8,
        color: const Color(0xFF00FFFF).withOpacity(0.5),
        fontFamily: 'PressStart2P',
      ),
    );

    scorePaint.render(
      canvas,
      'SCORE ${gameRef.score.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - 260, 20),
    );

    bestPaint.render(
      canvas,
      'BEST  ${gameRef.highScore.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - 260, 46),
    );

    final speedLevel = ((gameRef.gameSpeed - 300) / 400 * 5).floor() + 1;
    levelPaint.render(
      canvas,
      'LV.$speedLevel',
      Vector2(20, 20),
    );

    bottomPaint.render(
      canvas,
      'BREAKING AN LLM  |  SPACE/TAP > JUMP',
      Vector2(20, gameRef.size.y - 28),
    );
  }
}