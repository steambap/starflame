import 'package:flame/components.dart';

import '../layouter.dart';

class RowContainer extends PositionComponent implements Layouter {
  RowContainer({
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

      final size = child.size;
      child.position = Vector2(dx, y);
      child.anchor = Anchor.centerLeft;
      dx += size.x + 4;
    }

    size = Vector2(dx, size.y);
  }

  @override
  void onGameResize(Vector2 size) {
    layout();
    super.onGameResize(size);
  }
}
