import 'dart:ui';
import 'dart:math';

import 'package:flame/components.dart';
import 'styles.dart';

class RallyArrow extends PositionComponent {
  RallyArrow(this.from, this.to, {super.priority})
      : super(anchor: Anchor.center);
  static const double wLen = 20;

  final Vector2 from;
  final Vector2 to;
  late final Path _arrowheadPath;

  @override
  Future<void> onLoad() async {
    final vec = (to - from) * 0.5;
    final ud = vec.normalized();
    final ax = (ud.x * sqrt(3) / 2 - ud.y * 1 / 2) * wLen;
    final ay = (ud.x * 1 / 2 + ud.y * sqrt(3) / 2) * wLen;
    final bx = (ud.x * sqrt(3) / 2 + ud.y * 1 / 2) * wLen;
    final by = (-ud.x * 1 / 2 + ud.y * sqrt(3) / 2) * wLen;

    _arrowheadPath = Path()
      ..moveTo(vec.x, vec.y)
      ..lineTo(ax, ay)
      ..lineTo(bx, by)
      ..close();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(_arrowheadPath, FlameTheme.targetPaint);
  }
}
