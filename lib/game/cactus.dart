import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dino_game.dart';

class Obstacle extends PositionComponent with HasGameRef<DinoGame> {
  final Random _random = Random();
  late Color _color;
  late int _type;
  late String _label;
  double _floatTimer = 0;

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

    size = Vector2(50, 60);

    final groundY = gameRef.size.y - 100;
    position = Vector2(gameRef.size.x + 50, groundY - size.y + 10);

    add(RectangleHitbox(
      size: Vector2(40, 50),
      position: Vector2(5, 5),
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
  final float = sin(_floatTimer * 3) * 5;

  final bodyPaint = Paint()..color = _color;
  final glowPaint = Paint()
    ..color = _color.withOpacity(0.4)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  final bgPaint = Paint()..color = const Color(0xFF111122);
  final blackPaint = Paint()..color = Colors.black;
  final whitePaint = Paint()..color = Colors.white;
  final eyeColor = _type == 1 ? const Color(0xFF00FF88) : Colors.white;
  canvas.save();
  canvas.translate(0, float);
  canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);
  canvas.drawCircle(Offset(size.x / 2, size.y * 0.38), size.x * 0.46, bodyPaint);
  canvas.drawCircle(Offset(size.x / 2, size.y * 0.38), size.x * 0.46, glowPaint);
  canvas.drawRect(
    Rect.fromLTWH(4, size.y * 0.36, size.x - 8, size.y * 0.34),
    bodyPaint,
  );
  final spikeW = (size.x - 8) / 3;
  for (int i = 0; i < 3; i++) {
    final sx = 4 + i * spikeW;
    canvas.drawRect(
      Rect.fromLTWH(sx + 2, size.y * 0.70, spikeW - 4, size.y * 0.25),
      bodyPaint,
    );
  }
  final eyeOutlinePaint = Paint()
    ..color = eyeColor
    ..style = PaintingStyle.fill;
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.18, size.y * 0.20, 14, 14),
    eyeOutlinePaint,  // colored outline
  );
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.18 + 2, size.y * 0.20 + 2, 10, 10),
    blackPaint, 
  );
 
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.18 + 8, size.y * 0.20 + 2, 4, 4),
    whitePaint,
  );

  // Right eye
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.56, size.y * 0.20, 14, 14),
    eyeOutlinePaint,
  );
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.56 + 2, size.y * 0.20 + 2, 10, 10),
    blackPaint,
  );
  canvas.drawRect(
    Rect.fromLTWH(size.x * 0.56 + 8, size.y * 0.20 + 2, 4, 4),
    whitePaint,
  );
  final textPaint = TextPaint(
    style: TextStyle(
      fontSize: 10,
      color: _color,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
      shadows: [Shadow(color: _color.withOpacity(0.8), blurRadius: 6)],
    ),
  );
  textPaint.render(
    canvas,
    _label,
    Vector2(size.x / 2 - (_label.length * 3.2), size.y + 6),
  );

  canvas.restore();
}}