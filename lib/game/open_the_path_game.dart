import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'player_component.dart';
import 'finish_line_component.dart';
import 'tap_obstacle_component.dart';
import 'slide_obstacle_component.dart'; // تعديل التسمية البرمجية الصحيحة هنا

class OpenThePathGame extends FlameGame with HasCollisionDetection, HasTappables, HasDraggables {
  late PlayerComponent player;
  late FinishLineComponent finishLine;

  final Function() onGameOver; // المسمى المعتمد في شاشة التجميع الخاصة بك
  final Function() onLevelComplete;

  OpenThePathGame({
    required this.onGameOver,
    required this.onLevelComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    startLevel();
  }

  void startLevel() {
    removeAll(children);

    player = PlayerComponent(
      position: Vector2(50, size.y / 2 - 20),
      size: Vector2(40, 40),
      playerColor: const Color(0xfffff007f),
    );
    add(player);

    finishLine = FinishLineComponent(
      position: Vector2(size.x - 60, 0),
      size: Vector2(20, size.y),
    );
    add(finishLine);

    // عائق النقر
    add(TapObstacleComponent(
      position: Vector2(size.x * 0.3, size.y / 2 - 40),
      size: Vector2(50, 80),
    ));

    // عائق السحب - تم إصلاح الاسم هنا ليطابق الملف تماماً
    add(SlideObstacleComponent(
      position: Vector2(size.x * 0.6, size.y / 2 - 50),
      size: Vector2(40, 100),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (player.position.x + player.size.x >= finishLine.position.x) {
      player.speed = 0;
      onLevelComplete();
    }
  }

  void triggerGameOver() {
    player.speed = 0;
    onGameOver();
  }
}
