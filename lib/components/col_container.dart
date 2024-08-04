import 'package:flame/components.dart';

import '../layouter.dart';

class ColContainer extends PositionComponent implements Layouter {
  final int marginBottom;

  ColContainer({
    this.marginBottom = 4,
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
  void layout() {
    double dy = marginBottom.toDouble();
    for (final child in children) {
      if (child is Layouter) {
        (child as Layouter).layout();
      }
      if (child is! PositionComponent) {
        continue;
      }

      final size = child.size;
      child.position = Vector2(0, dy);
      dy += size.y + marginBottom;
    }

    size = Vector2(size.x, dy);
  }
}
