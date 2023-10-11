import 'dart:ui';

import 'package:flame/components.dart';

class LineComponent extends PositionComponent with HasPaint {
  final Vector2 _from;
  late Vector2 _to;

  LineComponent(
    this._from, {
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
    Paint? paint,
  }) {
    this.paint = paint ?? this.paint;
    _to = _from;
  }

  set to(Vector2 to) {
    _to = to;
  }

  reset() {
    _to = _from;
  }

  @override
  void render(Canvas canvas) {
    if (_from == _to) {
      return;
    }

    canvas.drawLine(_from.toOffset(), _to.toOffset(), paint);
  }
}
