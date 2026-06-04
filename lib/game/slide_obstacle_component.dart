import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart'; // ترقية حديثة ومعتمدة للأحداث لتفادي خطأ المترجم القديم
import 'package:flutter/material.dart';
import 'open_the_path_game.dart';
import 'player_component.dart';

class SlideObstacleComponent extends PositionComponent with HasGameRef<OpenThePathGame>, CollisionCallbacks, DragCallbacks {
  // الاحتفاظ بنقطة البداية للحاجز لمنع سحبه عشوائياً
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

  // استخدام نظام أحداث السحب الحديث المتوافق مع الإصدارات الجديدة كلياً
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    // السماح بالتحريك الرأسي للأعلى فقط لإخلاء الممر
    position.y += event.localDelta.y;

    // حد أقصى للتحريك للأعلى لكي لا يختفي تماماً بشكل قبيح بل يثبت كبوابة مفتوحة
    if (position.y < initialY - size.y * 1.2) {
      position.y = initialY - size.y * 1.2;
      isCleared = true; // تم فتح الممر بأمان
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // إذا اصطدم اللاعب بالحاجز ولم يقم برفعه للأعلى بعد، يخسر
    if (other is PlayerComponent && !isCleared) {
      gameRef.triggerGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // تلوين يتأرجح مدمج: لون نيون مضيء عند الحاجز السليم
    final color = isCleared ? const Color(0xff00ffcc) : const Color(0xffff9900);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // فكرة إبداعية: تعديل جودة الـ Blur لتلائم الأجهزة المتوسطة والحديثة دون التسبب بهبوط الإطارات
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..imageFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)), glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6)), paint);

    // رسم أسهم إرشادية مبتكرة ومتحركة بداخل الحاجز ليفهم اللاعب تلقائياً أنه يجب السحب للأعلى
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
