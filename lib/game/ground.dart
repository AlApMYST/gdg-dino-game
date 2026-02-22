import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class Ground extends PositionComponent with HasGameRef<DinoGame> {
  double _scrollX = 0;

  @override
  void update(double dt) {
    if (!gameRef.isRunning) return;
    _scrollX -= gameRef.gameSpeed * dt;
    if (_scrollX < -40) _scrollX += 40;
  }

  @override
  void render(Canvas canvas) {
    final groundY = gameRef.size.y - 100;
    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.2)
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(Offset(0, groundY), Offset(gameRef.size.x, groundY), glowPaint);
    final linePaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.9)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, groundY), Offset(gameRef.size.x, groundY), linePaint);
    final dashPaint = Paint()
      ..color = const Color(0xFFBB86FC).withOpacity(0.3)
      ..strokeWidth = 1.5;
    double x = _scrollX;
    while (x < gameRef.size.x) {
      canvas.drawLine(
        Offset(x, groundY + 8),
        Offset(x + 20, groundY + 8),
        dashPaint,
      );
      x += 40;
    }
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00FFFF).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, groundY, gameRef.size.x, 80));
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, gameRef.size.x, 80),
      fillPaint,
    );
  }
}