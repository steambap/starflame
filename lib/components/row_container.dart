import 'package:flame/components.dart';

import '../layouter.dart';

class RowContainer extends PositionComponent implements Layouter {
  final double columnSize;
  final double columnGap;

  RowContainer({
    this.columnSize = 0,
    this.columnGap = 4,
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
  void onMount() {
    super.onMount();
    layout();
  }

  @override
  void layout() {
    final y = size.y / 2;
    double dx = 4;
    for (final child in children) {
      if (child is Layouter) {
        (child as Layouter).layout();
      }
      if (child is! PositionComponent) {
        continue;
      }

      child.position = Vector2(dx, y);
      child.anchor = Anchor.centerLeft;
      final w = columnSize > 0 ? columnSize : child.size.x;
      dx += w + columnGap;
    }

    size = Vector2(dx, size.y);
  }

  @override
  void onGameResize(Vector2 size) {
    layout();
    super.onGameResize(size);
  }
}
