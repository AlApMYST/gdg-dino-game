import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dino_game.dart';

class Obstacle extends PositionComponent with HasGameRef<DinoGame> {
  final Random _random = Random();
  late Color _color;
  late int _type;

  Obstacle() : super(size: Vector2(30, 55));

  @override
  Future<void> onLoad() async {
    _type = _random.nextInt(3);
    final colors = [
      const Color(0xFFEA4335),
      const Color(0xFFFBBC04),
      const Color(0xFF34A853),
    ];
    _color = colors[_random.nextInt(colors.length)];

    switch (_type) {
      case 0:
        size = Vector2(28, 55);
        break;
      case 1:
        size = Vector2(54, 55);
        break;
      case 2:
        size = Vector2(36, 42);
        break;
    }

    final groundY = gameRef.size.y - 100;
    position = Vector2(gameRef.size.x + 50, groundY - size.y);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.gameSpeed * dt;
    if (position.x < -100) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    switch (_type) {
      case 0:
        _drawCactus(canvas, 0, 0, size.x, size.y);
        break;
      case 1:
        _drawCactus(canvas, 0, 8, 26, size.y - 8);
        _drawCactus(canvas, 28, 0, 26, size.y);
        break;
      case 2:
        _drawWideCactus(canvas);
        break;
    }
  }

  void _drawCactus(Canvas canvas, double x, double y, double w, double h) {
    final paint = Paint()..color = _color;
    final darkPaint = Paint()..color = _color.withOpacity(0.6);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + w * 0.3, y, w * 0.4, h),
        const Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y + h * 0.3, w * 0.35, h * 0.18),
        const Radius.circular(3),
      ),
      darkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y + h * 0.15, w * 0.18, h * 0.22),
        const Radius.circular(3),
      ),
      darkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + w * 0.65, y + h * 0.38, w * 0.35, h * 0.18),
        const Radius.circular(3),
      ),
      darkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + w * 0.82, y + h * 0.22, w * 0.18, h * 0.22),
        const Radius.circular(3),
      ),
      darkPaint,
    );
    final topPath = Path()
      ..moveTo(x + w * 0.5, y - 6)
      ..lineTo(x + w * 0.35, y + 4)
      ..lineTo(x + w * 0.65, y + 4)
      ..close();
    canvas.drawPath(topPath, paint);
  }

  void _drawWideCactus(Canvas canvas) {
    final paint = Paint()..color = _color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.y * 0.4, size.x, size.y * 0.6),
        const Radius.circular(4),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.25, 0, size.x * 0.5, size.y * 0.7),
        const Radius.circular(5),
      ),
      paint,
    );
    for (int i = 0; i < 3; i++) {
      final sx = size.x * (0.15 + i * 0.35);
      final topPath = Path()
        ..moveTo(sx, -5)
        ..lineTo(sx - 6, 8)
        ..lineTo(sx + 6, 8)
        ..close();
      canvas.drawPath(topPath, Paint()..color = _color.withOpacity(0.8));
    }
  }
}