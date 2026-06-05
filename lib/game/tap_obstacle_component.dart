import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'open_the_path_game.dart';
import 'player_component.dart';

class TapObstacleComponent extends PositionComponent with HasGameRef<OpenThePathGame>, CollisionCallbacks, Tappable {
  int clicksLeft = 3;

  TapObstacleComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    clicksLeft--;
    if (clicksLeft <= 0) {
      removeFromParent();
    }
    return true;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerComponent) {
      gameRef.triggerGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final color = clicksLeft == 3
        ? const Color(0xffff3333)
        : clicksLeft == 2 ? const Color(0xffff6600) : const Color(0xffffff00);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..imageFilter = ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15);

    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$clicksLeft',
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2),
    );
  }
}
