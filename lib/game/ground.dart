import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class Ground extends PositionComponent with HasGameRef<DinoGame> {
  double _scrollX = 0;

  static double getGroundY(double screenHeight) => screenHeight - 82;

  @override
  void update(double dt) {
    if (!gameRef.isRunning) return;
    _scrollX -= gameRef.gameSpeed * dt;
    if (_scrollX < -40) _scrollX += 40;
  }

  @override
  void render(Canvas canvas) {
    final gY = getGroundY(gameRef.size.y);

    // Neon glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.2)
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(Offset(0, gY), Offset(gameRef.size.x, gY), glowPaint);

    // Main line
    final linePaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.9)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, gY), Offset(gameRef.size.x, gY), linePaint);

    // Scrolling dashes
    final dashPaint = Paint()
      ..color = const Color(0xFFBB86FC).withOpacity(0.3)
      ..strokeWidth = 1.5;
    double x = _scrollX;
    while (x < gameRef.size.x) {
      canvas.drawLine(
        Offset(x, gY + 8),
        Offset(x + 20, gY + 8),
        dashPaint,
      );
      x += 40;
    }

    // Ground fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00FFFF).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, gY, gameRef.size.x, 82));
    canvas.drawRect(Rect.fromLTWH(0, gY, gameRef.size.x, 82), fillPaint);
  }
}