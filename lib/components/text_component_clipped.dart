import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

class TextComponentClipped extends TextComponent {
  late final Path path;

  TextComponentClipped(
    Vector2 rectSize, {
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
  }) {
    path = Rectangle.fromRect(rectSize.toRect()).asPath();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.clipPath(path);
    super.render(canvas);
    canvas.restore();
  }
}
