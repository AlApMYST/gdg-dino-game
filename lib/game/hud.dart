import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class HudComponent extends PositionComponent with HasGameRef<DinoGame> {
  @override
  void render(Canvas canvas) {
    if (!gameRef.isRunning) return;
    final scorePaint = TextPaint(
      style: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontFamily: 'monospace',
      ),
    );
    final labelPaint = TextPaint(
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF4285F4),
        letterSpacing: 3,
        fontFamily: 'monospace',
      ),
    );
    scorePaint.render(
      canvas,
      'SCORE: ${gameRef.score.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - 220, 20),
    );
    scorePaint.render(
      canvas,
      'BEST:  ${gameRef.highScore.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - 220, 48),
    );

    final speedLevel = ((gameRef.gameSpeed - 300) / 400 * 5).floor() + 1;
    labelPaint.render(canvas, 'SPEED LV.$speedLevel', Vector2(20, 20));

    final gdgPaint = TextPaint(
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF4285F4),
        letterSpacing: 2,
        fontFamily: 'monospace',
      ),
    );
    gdgPaint.render(canvas, 'GDG', Vector2(20, gameRef.size.y - 30));

    final hintPaint = TextPaint(
      style: TextStyle(
        fontSize: 11,
        color: Colors.white.withOpacity(0.3),
        fontFamily: 'monospace',
      ),
    );
    hintPaint.render(
      canvas,
      'SPACE / TAP  |  2x Jump!',
      Vector2(gameRef.size.x / 2 - 90, gameRef.size.y - 30),
    );
  }
}