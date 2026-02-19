import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'player.dart';
import 'cactus.dart';
import 'ground.dart';
import 'hud.dart';
class DinoGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  late Player player;
  late Ground ground;
  late HudComponent hud;
  int score = 0;
  int highScore = 0;
  double _scoreTimer = 0;
  double _obstacleTimer = 0;
  double _obstacleInterval = 2.2;
  double gameSpeed = 300;
  bool isRunning = false;
  final Random _random = Random();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    ground = Ground()
      ..size = Vector2(size.x, size.y);
    add(ground);
    player = Player();
    add(player);
    hud = HudComponent()
      ..size = Vector2(size.x, size.y);
    add(hud);
  }
  void startGame() {
    overlays.remove('StartScreen');
    overlays.remove('GameOver');
    isRunning = true;
    score = 0;
    gameSpeed = 300;
    _obstacleInterval = 2.2;
  }

  void resetGame() {
    overlays.remove('GameOver');
    children.whereType<Obstacle>().toList().forEach((o) => o.removeFromParent());
    player.reset();
    isRunning = true;
    score = 0;
    gameSpeed = 300;
    _obstacleInterval = 2.2;
    _obstacleTimer = 0;
    _scoreTimer = 0;
  }
  void gameOver() {
  if (!isRunning) return;
  isRunning = false;          
  if (score > highScore) highScore = score;
  children.whereType<Obstacle>().toList().forEach((o) {
    o.removeFromParent();   
  });
  if (score > highScore) highScore = score;
  overlays.add('GameOver');
}

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning) return;

    _scoreTimer += dt;
    if (_scoreTimer >= 0.1) {
      score++;
      _scoreTimer = 0;
      if (score % 100 == 0) {
        gameSpeed = (gameSpeed + 15).clamp(300, 700);
        _obstacleInterval = (_obstacleInterval - 0.05).clamp(1.0, 2.2);
      }
    }

    _obstacleTimer += dt;
    if (_obstacleTimer >= _obstacleInterval) {
      _obstacleTimer = 0;
      _obstacleInterval = 1.0 + _random.nextDouble() * 1.4;
      add(Obstacle());
    }
  }
@override
void onTapDown(TapDownEvent event) {
  if (isRunning) player.jump();
}

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        if (isRunning) player.jump();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);
  @override
  void render(Canvas canvas) {
    final gridPaint = Paint()
      ..color = const Color(0xFF4285F4).withOpacity(0.05)
      ..strokeWidth = 1;
    for (double x = 0; x < size.x; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }
    for (double y = 0; y < size.y; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }
    super.render(canvas);
  }
}