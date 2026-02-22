import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class HudComponent extends PositionComponent with HasGameRef<DinoGame> {
  @override
  void render(Canvas canvas) {
    if (!gameRef.isRunning) return;

    final isMobile = gameRef.size.x < 600;
    final scoreFs = isMobile ? 10.0 : 14.0;
    final bestFs = isMobile ? 8.0 : 10.0;
    final levelFs = isMobile ? 7.0 : 9.0;
    final bottomFs = isMobile ? 6.0 : 8.0;

    final scorePaint = TextPaint(
      style: TextStyle(
        fontSize: scoreFs,
        color: const Color(0xFF00FFFF),
        fontWeight: FontWeight.bold,
        fontFamily: 'PressStart2P',
      ),
    );

    final bestPaint = TextPaint(
      style: TextStyle(
        fontSize: bestFs,
        color: const Color(0xFFBB86FC),
        fontFamily: 'PressStart2P',
      ),
    );

    final levelPaint = TextPaint(
      style: TextStyle(
        fontSize: levelFs,
        color: const Color(0xFFFF6B9D),
        fontFamily: 'PressStart2P',
      ),
    );

    final bottomPaint = TextPaint(
      style: TextStyle(
        fontSize: bottomFs,
        color: const Color(0xFF00FFFF).withOpacity(0.5),
        fontFamily: 'PressStart2P',
      ),
    );

    // Score — top right, always visible
    scorePaint.render(
      canvas,
      'SCORE ${gameRef.score.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - (isMobile ? 140 : 220), 16),
    );

    bestPaint.render(
      canvas,
      'BEST  ${gameRef.highScore.toString().padLeft(5, '0')}',
      Vector2(gameRef.size.x - (isMobile ? 140 : 220), 34),
    );

    // Level — top left
    final speedLevel = ((gameRef.gameSpeed - 300) / 400 * 5).floor() + 1;
    levelPaint.render(
      canvas,
      'LV.$speedLevel',
      Vector2(12, 16),
    );

    // Bottom hint
    bottomPaint.render(
      canvas,
      isMobile ? 'TAP > JUMP' : 'BREAKING AN LLM  |  SPACE/TAP > JUMP',
      Vector2(12, gameRef.size.y - 20),
    );
  }
}