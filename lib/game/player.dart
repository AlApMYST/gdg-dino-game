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

  Player() : super(size: Vector2(75, 90)); // Slightly wider to accommodate the backpack

  double _calcGroundY() {
    return gameRef.size.y - 82 - size.y;
  }

  @override
  Future<void> onLoad() async {
    _scale = (gameRef.size.x / 400).clamp(0.5, 1.0);
    size = Vector2(75 * _scale, 90 * _scale);
    _groundY = _calcGroundY();
    position = Vector2(60, _groundY);
    add(RectangleHitbox(
      size: Vector2(45 * _scale, 60 * _scale),
      position: Vector2(15 * _scale, 10 * _scale),
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
    size = Vector2(75 * _scale, 90 * _scale);
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
    _drawAstronaut(canvas);
    canvas.restore();
  }

void _drawAstronaut(Canvas canvas) {
    final s = _scale;

    // Color Palette based on your image
    final suitPaint = Paint()..color = const Color(0xFFE8E9F3); // Off-white
    final shadePaint = Paint()..color = const Color(0xFF8B8B9E); // Light purple-grey
    final darkPaint = Paint()..color = const Color(0xFF2B2B45); // Dark purple-blue
    final screenPaint = Paint()..color = const Color(0xFF0F172A); // Almost black
    final cyanPaint = Paint()..color = const Color(0xFF00E5FF); // Bright Cyan
    
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * s);

    final bob = _isOnGround ? (sin(_animTimer * 12) * 2 * s) : 0.0;

    canvas.save();
    canvas.translate(0, bob);

    // ── LEGS ──
    if (_isOnGround) {
      if (_legToggle) {
        _drawLeg(canvas, darkPaint, 25 * s, 65 * s, -15);
        _drawLeg(canvas, darkPaint, 45 * s, 65 * s, 25);
      } else {
        _drawLeg(canvas, darkPaint, 25 * s, 65 * s, 15);
        _drawLeg(canvas, darkPaint, 45 * s, 65 * s, -25);
      }
    } else {
      _drawLeg(canvas, darkPaint, 25 * s, 65 * s, -30);
      _drawLeg(canvas, darkPaint, 45 * s, 65 * s, -10);
    }

    // ── BACKPACK ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8 * s, 35 * s, 15 * s, 25 * s),
        Radius.circular(4 * s),
      ),
      darkPaint,
    );
    // Backpack highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10 * s, 37 * s, 11 * s, 21 * s),
        Radius.circular(2 * s),
      ),
      shadePaint,
    );

    // ── BACK ARM ──
    _drawArm(canvas, darkPaint, suitPaint, 22 * s, 45 * s, _isOnGround && _legToggle ? -30 : 30);

    // ── BODY ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20 * s, 38 * s, 35 * s, 28 * s),
        Radius.circular(6 * s),
      ),
      suitPaint,
    );
    // Body shading/details
    canvas.drawRect(Rect.fromLTWH(30 * s, 48 * s, 15 * s, 10 * s), shadePaint);
    canvas.drawRect(Rect.fromLTWH(32 * s, 50 * s, 4 * s, 4 * s), darkPaint);
    canvas.drawRect(Rect.fromLTWH(38 * s, 50 * s, 4 * s, 4 * s), darkPaint);

    // ── FRONT ARM ──
    _drawArm(canvas, darkPaint, suitPaint, 45 * s, 45 * s, _isOnGround && _legToggle ? 30 : -30);

    // ── HELMET ──
    // Helmet Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(18 * s, 5 * s, 48 * s, 38 * s),
        Radius.circular(8 * s),
      ),
      suitPaint,
    );
    
    // Helmet Shading (bottom edge)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20 * s, 35 * s, 44 * s, 6 * s),
        Radius.circular(4 * s),
      ),
      shadePaint,
    );

    // Screen Outline / Bezel
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(24 * s, 10 * s, 38 * s, 25 * s),
        Radius.circular(4 * s),
      ),
      darkPaint,
    );

    // Screen Inner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(26 * s, 12 * s, 34 * s, 21 * s),
        Radius.circular(3 * s),
      ),
      screenPaint,
    );

    // Glowing Face / Visor Screen Elements
    canvas.drawRect(Rect.fromLTWH(30 * s, 15 * s, 25 * s, 15 * s), glowPaint);

    // "Eyes" / Digital Expression
    canvas.drawRect(Rect.fromLTWH(32 * s, 16 * s, 8 * s, 8 * s), cyanPaint); // Left eye
    canvas.drawRect(Rect.fromLTWH(46 * s, 16 * s, 8 * s, 8 * s), cyanPaint); // Right eye
    
    // NEW: Blocky Digital Smile :)
    canvas.drawRect(Rect.fromLTWH(32 * s, 25 * s, 4 * s, 4 * s), cyanPaint); // Left corner of smile
    canvas.drawRect(Rect.fromLTWH(50 * s, 25 * s, 4 * s, 4 * s), cyanPaint); // Right corner of smile
    canvas.drawRect(Rect.fromLTWH(36 * s, 28 * s, 14 * s, 4 * s), cyanPaint); // Bottom curve of smile

    canvas.restore();
  }
  void _drawArm(Canvas canvas, Paint darkPaint, Paint suitPaint, double x, double y, double angle) {
    final s = _scale;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * 3.14159 / 180);
    // Sleeve
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-6 * s, -5 * s, 12 * s, 20 * s),
        Radius.circular(4 * s),
      ),
      suitPaint,
    );
    // Glove
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-7 * s, 12 * s, 14 * s, 10 * s),
        Radius.circular(3 * s),
      ),
      darkPaint,
    );
    canvas.restore();
  }

  void _drawLeg(Canvas canvas, Paint paint, double x, double y, double angle) {
    final s = _scale;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle * 3.14159 / 180);
    
    // Leg base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-6 * s, 0, 12 * s, 15 * s),
        Radius.circular(3 * s),
      ),
      paint,
    );
    // Boot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-8 * s, 12 * s, 18 * s, 10 * s),
        Radius.circular(4 * s),
      ),
      Paint()..color = const Color(0xFF1B1B2F), // Darker base for boots
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