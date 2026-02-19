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
  double _legTimer = 0;
  bool _legToggle = false;
  double _squishY = 1.0;
  bool isDead = false;
  Player() : super(size: Vector2(52, 60));
  @override
  Future<void> onLoad() async {
    _groundY = gameRef.size.y - 100 - size.y;
    position = Vector2(80, _groundY);
    add(RectangleHitbox(
      size: Vector2(38, 50),
      position: Vector2(7, 5),
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
    isDead=false;
  }
  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isRunning || isDead) return; 
    if (!gameRef.isRunning) return;

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
  }
  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y);
    canvas.scale(1.0 / _squishY, _squishY);
    canvas.translate(-size.x / 2, -size.y);
    _drawDino(canvas);
    canvas.restore();
  }
  void _drawDino(Canvas canvas) {
    final bodyPaint = Paint()..color = const Color(0xFF4285F4);
    final accentPaint = Paint()..color = const Color(0xFF34A853);
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = const Color(0xFF1A1A2E);
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(8, 10, 36, 32), const Radius.circular(10)),
      bodyPaint,
    ); 
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(16, 0, 32, 26), const Radius.circular(8)),
      bodyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(36, 10, 16, 12), const Radius.circular(5)),
      accentPaint,
    );
    canvas.drawCircle(const Offset(32, 10), 6, eyePaint);
    canvas.drawCircle(const Offset(33, 10), 3.5, pupilPaint);
    canvas.drawCircle(const Offset(34, 8), 1.2, whitePaint);
  
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(30, 24, 14, 8), const Radius.circular(4)),
      accentPaint,
    );
    canvas.drawOval(
      const Rect.fromLTWH(14, 22, 22, 14),
      Paint()..color = const Color(0xFF4285F4).withOpacity(0.5),
    );
    if (_isOnGround) {
      if (_legToggle) {
        _drawLeg(canvas, accentPaint, 12, 42, -8);
        _drawLeg(canvas, accentPaint, 28, 42, 8);
      } else {
        _drawLeg(canvas, accentPaint, 12, 42, 8);
        _drawLeg(canvas, accentPaint, 28, 42, -8);
      }
    } else {
      _drawLeg(canvas, accentPaint, 12, 42, -14);
      _drawLeg(canvas, accentPaint, 28, 42, -14);
    }
    final tailPath = Path()
      ..moveTo(8, 20)
      ..quadraticBezierTo(-8, 28, 2, 42)
      ..quadraticBezierTo(6, 44, 10, 38)
      ..quadraticBezierTo(4, 30, 12, 24)
      ..close();
    canvas.drawPath(tailPath, accentPaint);
    canvas.drawCircle(const Offset(22, 30), 4, Paint()..color = const Color(0xFFFBBC04));
  }

  void _drawLeg(Canvas canvas, Paint paint, double x, double y, double angle) {
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * 3.14159 / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-4, 0, 9, 18), const Radius.circular(4)),
      paint,
    );
    canvas.restore();
  }

  @override
void onCollisionStart(Set<Vector2> points, PositionComponent other) {
  if (other is Obstacle && !isDead && gameRef.isRunning) {
    isDead = true;
    _velocityY = 0;
    position = Vector2(position.x, position.y);  
    gameRef.gameOver();
  }
  super.onCollisionStart(points, other);
}
}