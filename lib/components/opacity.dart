import "dart:ui" show Paint, BlendMode, Canvas;
import "package:flame/components.dart";
import "package:flame/palette.dart";
import "package:flame/effects.dart";

// https://github.com/flame-engine/flame/issues/1013
mixin HasOpacityProvider on Component implements OpacityProvider {
  final Paint _paint = BasicPalette.white.paint()
    ..blendMode = BlendMode.modulate;
  final Paint _srcOverPaint = Paint()..blendMode = BlendMode.srcOver;

  @override
  double get opacity => _paint.color.opacity;

  @override
  set opacity(double newOpacity) {
    _paint
      ..color = _paint.color.withOpacity(newOpacity)
      ..blendMode = BlendMode.modulate;
  }

  @override
  void renderTree(Canvas canvas) {
    canvas.saveLayer(null, _srcOverPaint);
    super.renderTree(canvas);
    canvas.drawPaint(_paint);
    canvas.restore();
  }
}
