import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';

class Obstacle extends PositionComponent with HasGameRef<DinoGame> {
  final Random _random = Random();
  late Color _color;
  late int _type;
  late String _label;
  double _floatTimer = 0;
  double _scale = 1.0;

  Obstacle() : super(size: Vector2(50, 60));

  @override
  Future<void> onLoad() async {
    _type = _random.nextInt(3);
    final labels = ['WEIGHT', 'BIAS', 'OVERFIT'];
    _label = labels[_type];

    final colors = [
      const Color(0xFF00FFFF),
      const Color(0xFFBB86FC),
      const Color(0xFFFF6B9D),
    ];
    _color = colors[_type];

    _scale = (gameRef.size.x / 400).clamp(0.5, 1.0);
    size = Vector2(44 * _scale, 52 * _scale);

    final groundY = gameRef.size.y - 82;
    position = Vector2(gameRef.size.x + 50, groundY - size.y);

    add(RectangleHitbox(
      size: Vector2(36 * _scale, 44 * _scale),
      position: Vector2(4 * _scale, 4 * _scale),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.gameSpeed * dt;
    _floatTimer += dt;
    if (position.x < -100) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    _drawGhost(canvas);
  }

  void _drawGhost(Canvas canvas) {
    final s = _scale;
    final float = sin(_floatTimer * 3) * 5 * s;

    final bodyPaint = Paint()..color = _color;
    final glowPaint = Paint()
      ..color = _color.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12 * s);
    final darkPaint = Paint()..color = const Color(0xFF0A0015);
    final bgPaint = Paint()..color = const Color(0xFF111122);
    final eyeColor = _type == 1 ? const Color(0xFF00FF88) : Colors.white;
    final eyePaint = Paint()..color = eyeColor;

    canvas.save();
    canvas.translate(0, float);

    // Dark bg box
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    // Round top
    canvas.drawCircle(
      Offset(size.x / 2, size.y * 0.38),
      size.x * 0.46,
      bodyPaint,
    );
    canvas.drawCircle(
      Offset(size.x / 2, size.y * 0.38),
      size.x * 0.46,
      glowPaint,
    );

    // Rectangle body middle
    canvas.drawRect(
      Rect.fromLTWH(4 * s, size.y * 0.36, size.x - 8 * s, size.y * 0.34),
      bodyPaint,
    );

    // Square blocky spikes at bottom
    final spikeW = (size.x - 8 * s) / 3;
    for (int i = 0; i < 3; i++) {
      final sx = 4 * s + i * spikeW;
      canvas.drawRect(
        Rect.fromLTWH(
          sx + 2 * s,
          size.y * 0.70,
          spikeW - 4 * s,
          size.y * 0.25,
        ),
        bodyPaint,
      );
    }

    // Eyes
    if (_type == 1) {
      // Square green eyes for BIAS
      canvas.drawRect(
        Rect.fromLTWH(size.x * 0.18, size.y * 0.20, 14 * s, 14 * s),
        eyePaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(size.x * 0.56, size.y * 0.20, 14 * s, 14 * s),
        eyePaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          size.x * 0.18 + 2 * s,
          size.y * 0.20 + 2 * s,
          10 * s,
          10 * s,
        ),
        darkPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          size.x * 0.56 + 2 * s,
          size.y * 0.20 + 2 * s,
          10 * s,
          10 * s,
        ),
        darkPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          size.x * 0.18 + 8 * s,
          size.y * 0.20 + 2 * s,
          4 * s,
          4 * s,
        ),
        Paint()..color = Colors.white,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          size.x * 0.56 + 8 * s,
          size.y * 0.20 + 2 * s,
          4 * s,
          4 * s,
        ),
        Paint()..color = Colors.white,
      );
    } else {
      // Round eyes for WEIGHT and OVERFIT
      canvas.drawCircle(
        Offset(size.x * 0.32, size.y * 0.30),
        6 * s,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.68, size.y * 0.30),
        6 * s,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.32, size.y * 0.32),
        3 * s,
        darkPaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.68, size.y * 0.32),
        3 * s,
        darkPaint,
      );
      canvas.drawCircle(
        Offset(size.x * 0.30, size.y * 0.28),
        1.5 * s,
        Paint()..color = Colors.white,
      );
    }

    // Label
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 9 * s,
        color: _color,
        fontFamily: 'PressStart2P',
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(color: _color.withOpacity(0.8), blurRadius: 6),
        ],
      ),
    );
    textPaint.render(
      canvas,
      _label,
      Vector2(size.x / 2 - (_label.length * 2.8 * s), size.y + 4 * s),
    );

    canvas.restore();
  }
}