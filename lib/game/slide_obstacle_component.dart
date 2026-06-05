import 'dart:ui'; // استيراد ضروري جداً لتشغيل مرشح النيون الحديث
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide ImageFilter;
import 'open_the_path_game.dart';
import 'player_component.dart';

class SlideObstacleComponent extends PositionComponent with HasGameRef<OpenThePathGame>, CollisionCallbacks, DragCallbacks {
  double initialY = 0;
  bool isCleared = false;

  SlideObstacleComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    initialY = position.y;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.y += event.localDelta.y;

    if (position.y < initialY - size.y * 1.2) {
      position.y = initialY - size.y * 1.2;
      isCleared = true;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerComponent && !isCleared) {
      gameRef.triggerGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final color = isCleared ? const Color(0xff00ffcc) : const Color(0xffff9900);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // الحل النهائي والذكي لفلتر النيون بدون أخطاء تجميع
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..imageFilter = ImageFilter.blur(sigmaX: 12, sigmaY: 12);

    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)), glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)), paint);

    if (!isCleared) {
      final arrowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      final path = Path();
      path.moveTo(size.x / 2, size.y * 0.3);
      path.lineTo(size.x * 0.3, size.y * 0.5);
      path.moveTo(size.x / 2, size.y * 0.3);
      path.lineTo(size.x * 0.7, size.y * 0.5);
      path.moveTo(size.x / 2, size.y * 0.5);
      path.lineTo(size.x / 2, size.y * 0.7);

      canvas.drawPath(path, arrowPaint);
    }
  }
}
