import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart'; // ترقية حديثة ومعتمدة للأحداث
import 'package:flutter/material.dart';
import 'open_the_path_game.dart';
import 'player_component.dart';

class TapObstacleComponent extends PositionComponent with HasGameRef<OpenThePathGame>, CollisionCallbacks, TapCallbacks {
  // عدد النقرات المطلوبة لتدمير الحاجز
  int clicksLeft = 3;

  TapObstacleComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // إضافة مستطيل الاصطدام
    add(RectangleHitbox());
  }

  // استخدام النظام الحديث المستقر كلياً لمنع انهيار السيرفر أثناء الضغط
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    clicksLeft--;

    if (clicksLeft <= 0) {
      // إذا انتهت النقرات، يتم إزالة الحاجز من اللعبة بنجاح
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // إذا اصطدم اللاعب بهذا الحاجز قبل تدميره، يخسر فوراً
    if (other is PlayerComponent) {
      gameRef.triggerGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // تغيير تدرج اللون وقوة الوهج بناءً على عدد النقرات المتبقية
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

    // فكرة مبتكرة جديدة: إضافة حركة وميض خفيفة ديناميكية (Pulse Effect) للـ Glow تجعل اللعبة تبدو حية
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..imageFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // رسم المجسم وتأثير النيون
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)), borderPaint);

    // كتابة عدد النقرات المتبقية داخل الحاجز بشكل جمالي ومبتكر
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
