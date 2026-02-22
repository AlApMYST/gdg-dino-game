import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dino_game.dart';
import 'cactus.dart';
import 'dart:math';

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

  Player() : super(size: Vector2(70, 80));

  @override
  Future<void> onLoad() async {
    _groundY = gameRef.size.y - 100 - size.y;
    position = Vector2(80, _groundY);
    add(RectangleHitbox(
      size: Vector2(50, 65),
      position: Vector2(10, 8),
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
    _groundY = gameRef.size.y - 100 - size.y;
    position = Vector2(80, _groundY);
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
    final suitPaint = Paint()..color = const Color(0xFFCCCCDD);
    final darkSuitPaint = Paint()..color = const Color(0xFF9999AA);
    final cyanPaint = Paint()..color = const Color(0xFF00FFFF);
    final purplePaint = Paint()..color = const Color(0xFFBB86FC);
    final darkPaint = Paint()..color = const Color(0xFF0A0015);
    final whitePaint = Paint()..color = Colors.white;

    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Body bob while running
    final bob = _isOnGround ? (sin(_animTimer * 12) * 2) : 0.0;

    canvas.save();
    canvas.translate(0, bob);
    if (_isOnGround) {
      if (_legToggle) {
        _drawLeg(canvas, darkSuitPaint, 18, 58, -12);
        _drawLeg(canvas, darkSuitPaint, 38, 58, 12);
      } else {
        _drawLeg(canvas, darkSuitPaint, 18, 58, 12);
        _drawLeg(canvas, darkSuitPaint, 38, 58, -12);
      }
    } else {
      _drawLeg(canvas, darkSuitPaint, 18, 58, -20);
      _drawLeg(canvas, darkSuitPaint, 38, 58, -20);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(12, 36, 46, 28),
        const Radius.circular(8),
      ),
      suitPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 42, 26, 14),
        const Radius.circular(4),
      ),
      glowPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 42, 26, 14),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF00FFFF).withOpacity(0.5),
    );
    canvas.drawCircle(const Offset(30, 49), 3, cyanPaint);
    canvas.drawCircle(const Offset(40, 49), 3, purplePaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 37, 11, 20),
        const Radius.circular(5),
      ),
      darkSuitPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(57, 37, 11, 20),
        const Radius.circular(5),
      ),
      darkSuitPaint,
    );

    canvas.drawCircle(const Offset(35, 22), 22, glowPaint);

    
    canvas.drawCircle(const Offset(35, 22), 20, suitPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(20, 12, 30, 20),
        const Radius.circular(8),
      ),
      darkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 14, 26, 16),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF00FFFF).withOpacity(0.15),
    );
    canvas.drawCircle(const Offset(29, 22), 4, cyanPaint);
    canvas.drawCircle(const Offset(41, 22), 4, cyanPaint);
    canvas.drawCircle(
      const Offset(29, 22),
      5,
      Paint()
        ..color = const Color(0xFF00FFFF).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      const Offset(41, 22),
      5,
      Paint()
        ..color = const Color(0xFF00FFFF).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(const Offset(30, 23), 2, darkPaint);
    canvas.drawCircle(const Offset(42, 23), 2, darkPaint);
    canvas.drawCircle(const Offset(31, 21), 1, whitePaint);
    canvas.drawCircle(const Offset(43, 21), 1, whitePaint);
    canvas.drawLine(
      const Offset(35, 2),
      const Offset(35, 12),
      Paint()
        ..color = const Color(0xFFCCCCDD)
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(
      const Offset(35, 2),
      4,
      Paint()
        ..color = purplePaint.color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(const Offset(35, 2), 3, purplePaint);

    canvas.restore();
  }

  void _drawLeg(Canvas canvas, Paint paint, double x, double y, double angle) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * 3.14159 / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, 0, 11, 20),
        const Radius.circular(5),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-6, 16, 13, 8),
        const Radius.circular(3),
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