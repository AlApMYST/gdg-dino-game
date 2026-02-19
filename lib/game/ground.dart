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
      ..color = const Color(0xFF4285F4).withOpacity(0.3)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, groundY), Offset(gameRef.size.x, groundY), glowPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF4285F4).withOpacity(0.8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, groundY), Offset(gameRef.size.x, groundY), linePaint);

    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2;
    double x = _scrollX;
    while (x < gameRef.size.x) {
      canvas.drawLine(Offset(x, groundY + 6), Offset(x + 20, groundY + 6), dashPaint);
      x += 40;
    }
  }
}