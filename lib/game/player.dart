import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';
import 'cactus.dart';

class Player extends PositionComponent
    with HasGameRef<DinoGame>, CollisionCallbacks {
  static const double gravity = 1800;
  static const double jumpForce = -620;
  static const int maxJumps = 2;

  double _velocityY = 0;
  double _groundY = 0;
  bool _isOnGround = true;
  int _jumpCount = 0;
  bool isDead = false;

  double _legTimer = 0;
  bool _legToggle = false;
  double _squishY = 1.0;
  double _animTimer = 0;
  double _scale = 1.0;

  Player() : super(size: Vector2(70, 85));

  double _calcGroundY() {
    return gameRef.size.y - 82 - size.y;
  }

  @override
  Future<void> onLoad() async {
    _scale = (gameRef.size.x / 400).clamp(0.5, 1.0);
    size = Vector2(70 * _scale, 85 * _scale);
    _groundY = _calcGroundY();
    position = Vector2(60, _groundY);
    add(RectangleHitbox(
      size: Vector2(42 * _scale, 55 * _scale),
      position: Vector2(14 * _scale, 10 * _scale),
    ));
  }

  void jump() {
    if (_jumpCount < maxJumps) {
      _velocityY = jumpForce;
      _jumpCount++;
      _isOnGround = false;
      _squishY = 0.7;
    }
  }

  void reset() {
    _scale = (gameRef.size.x / 400).clamp(0.5, 1.0);
    size = Vector2(70 * _scale, 85 * _scale);
    _groundY = _calcGroundY();
    position = Vector2(60, _groundY);
    _velocityY = 0;
    _isOnGround = true;
    _jumpCount = 0;
    _squishY = 1.0;
    isDead = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isRunning || isDead) return;

    _velocityY += gravity * dt;
    position.y += _velocityY * dt;

    if (position.y >= _groundY) {
      position.y = _groundY;
      _velocityY = 0;
      _isOnGround = true;
      _jumpCount = 0;
    }

    if (_isOnGround) {
      _legTimer += dt * 8;
      if (_legTimer >= 1) {
        _legTimer = 0;
        _legToggle = !_legToggle;
      }
    }

    if (_squishY < 1.0) {
      _squishY = (_squishY + dt * 4).clamp(0.7, 1.0);
    }

    _animTimer += dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y);
    canvas.scale(1.0 / _squishY, _squishY);
    canvas.translate(-size.x / 2, -size.y);
    _drawRobot(canvas);
    canvas.restore();
  }

  void _drawRobot(Canvas canvas) {
    final s = _scale;

    final suitPaint = Paint()..color = const Color(0xFFCCCCDD);
    final darkSuitPaint = Paint()..color = const Color(0xFF9999AA);
    final cyanPaint = Paint()..color = const Color(0xFF00FFFF);
    final purplePaint = Paint()..color = const Color(0xFFBB86FC);
    final darkPaint = Paint()..color = const Color(0xFF0A0015);
    final whitePaint = Paint()..color = Colors.white;

    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * s);

    final bob = _isOnGround ? (sin(_animTimer * 12) * 2 * s) : 0.0;

    canvas.save();
    canvas.translate(0, bob);

    // ── LEGS ──
    if (_isOnGround) {
      if (_legToggle) {
        _drawLeg(canvas, darkSuitPaint, 20 * s, 62 * s, -12);
        _drawLeg(canvas, darkSuitPaint, 40 * s, 62 * s, 12);
      } else {
        _drawLeg(canvas, darkSuitPaint, 20 * s, 62 * s, 12);
        _drawLeg(canvas, darkSuitPaint, 40 * s, 62 * s, -12);
      }
    } else {
      _drawLeg(canvas, darkSuitPaint, 20 * s, 62 * s, -20);
      _drawLeg(canvas, darkSuitPaint, 40 * s, 62 * s, -20);
    }

    // ── BODY ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(14 * s, 38 * s, 42 * s, 26 * s),
        Radius.circular(8 * s),
      ),
      suitPaint,
    );

    // Chest panel glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(22 * s, 43 * s, 26 * s, 13 * s),
        Radius.circular(4 * s),
      ),
      glowPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(22 * s, 43 * s, 26 * s, 13 * s),
        Radius.circular(4 * s),
      ),
      Paint()..color = const Color(0xFF00FFFF).withOpacity(0.5),
    );

    // Chest dots
    canvas.drawCircle(Offset(31 * s, 50 * s), 3 * s, cyanPaint);
    canvas.drawCircle(Offset(41 * s, 50 * s), 3 * s, purplePaint);

    // ── ARMS ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4 * s, 38 * s, 11 * s, 20 * s),
        Radius.circular(5 * s),
      ),
      darkSuitPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(55 * s, 38 * s, 11 * s, 20 * s),
        Radius.circular(5 * s),
      ),
      darkSuitPaint,
    );

    // ── HELMET ──
    canvas.drawCircle(Offset(35 * s, 22 * s), 22 * s, glowPaint);
    canvas.drawCircle(Offset(35 * s, 22 * s), 20 * s, suitPaint);

    // Visor
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20 * s, 12 * s, 30 * s, 20 * s),
        Radius.circular(8 * s),
      ),
      darkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(22 * s, 14 * s, 26 * s, 16 * s),
        Radius.circular(6 * s),
      ),
      Paint()..color = const Color(0xFF00FFFF).withOpacity(0.15),
    );

    // Eyes
    canvas.drawCircle(Offset(29 * s, 22 * s), 4 * s, cyanPaint);
    canvas.drawCircle(Offset(41 * s, 22 * s), 4 * s, cyanPaint);
    canvas.drawCircle(
      Offset(29 * s, 22 * s),
      5 * s,
      Paint()
        ..color = const Color(0xFF00FFFF).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * s),
    );
    canvas.drawCircle(
      Offset(41 * s, 22 * s),
      5 * s,
      Paint()
        ..color = const Color(0xFF00FFFF).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * s),
    );
    canvas.drawCircle(Offset(30 * s, 23 * s), 2 * s, darkPaint);
    canvas.drawCircle(Offset(42 * s, 23 * s), 2 * s, darkPaint);
    canvas.drawCircle(Offset(31 * s, 21 * s), 1 * s, whitePaint);
    canvas.drawCircle(Offset(43 * s, 21 * s), 1 * s, whitePaint);

    // ── ANTENNA ──
    canvas.drawLine(
      Offset(35 * s, 2 * s),
      Offset(35 * s, 12 * s),
      Paint()
        ..color = const Color(0xFFCCCCDD)
        ..strokeWidth = 2.5 * s,
    );
    canvas.drawCircle(
      Offset(35 * s, 2 * s),
      4 * s,
      Paint()
        ..color = purplePaint.color.withOpacity(0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * s),
    );
    canvas.drawCircle(Offset(35 * s, 2 * s), 3 * s, purplePaint);

    canvas.restore();
  }

  void _drawLeg(Canvas canvas, Paint paint, double x, double y, double angle) {
    final s = _scale;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * 3.14159 / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-5 * s, 0, 11 * s, 18 * s),
        Radius.circular(5 * s),
      ),
      paint,
    );
    // Boot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-6 * s, 14 * s, 13 * s, 7 * s),
        Radius.circular(3 * s),
      ),
      Paint()..color = const Color(0xFF00FFFF).withOpacity(0.7),
    );
    canvas.restore();
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Obstacle && !isDead && gameRef.isRunning) {
      isDead = true;
      _velocityY = 0;
      gameRef.gameOver();
    }
    super.onCollisionStart(points, other);
  }
}