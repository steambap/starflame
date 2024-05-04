import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

class TextComponentClipped extends TextComponent {
  static final rectSize = Vector2(188, 24);
  TextComponentClipped({
    super.text,
    super.textRenderer,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
  });

  @override
  void render(Canvas canvas) {
    final path = Rectangle.fromRect(rectSize.toRect()).asPath();
    canvas.save();
    canvas.clipPath(path);
    super.render(canvas);
    canvas.restore();
  }
}
