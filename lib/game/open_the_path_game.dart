import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'player_component.dart';
import 'finish_line_component.dart';

class OpenThePathGame extends FlameGame with HasCollisionDetection, TapDetector {
  late PlayerComponent player;
  late FinishLineComponent finishLine;
  
  // دالة تُستدعى عند خسارة اللاعب ليظهر مربع الحوار في Flutter
  final Function() onGameOver;
  // دالة تُستدعى عند الفوز والانتقال للمرحلة التالية
  final Function() onLevelComplete;

  OpenThePathGame({
    required this.onGameOver,
    required this.onLevelComplete,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // تعيين لون خلفية اللعبة لتتناسب مع الطابع السيبراني المظلم
    camera.viewfinder.anchor = Anchor.topLeft;

    // بدء تهيئة وتوليد المرحلة الحالية
    startLevel();
  }

  void startLevel() {
    // تنظيف المرحلة من أي عناصر قديمة عند الإعادة
    removeAll(children);

    // 1. إضافة اللاعب في يسار الشاشة (توهج فسفوري مميز)
    player = PlayerComponent(
      position: Vector2(50, size.y / 2 - 20),
      size: Vector2(40, 40),
      playerColor: const Color(0xffff007f), // يمكن ربطه بالمتجر لاحقاً
    );
    add(player);

    // 2.添加 خط النهاية في أقصى يمين الشاشة
    finishLine = FinishLineComponent(
      position: Vector2(size.x - 60, 0),
      size: Vector2(20, size.y),
    );
    add(finishLine);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // التحقق من وصول اللاعب لخط النهاية وفوزه بالمرحلة
    if (player.position.x + player.size.x >= finishLine.position.x) {
      player.speed = 0; // إيقاف حركة اللاعب
      onLevelComplete();
    }
  }

  // دالة استدعاء الخسارة عند الاصطدام بالمعيقات (سنقوم بربط العوائق بها في الخطوة القادمة)
  void triggerGameOver() {
    player.speed = 0;
    onGameOver();
  }
}
