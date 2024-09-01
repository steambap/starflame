import 'dart:ui' show Radius;
import 'package:flutter/painting.dart' show BorderRadius;
import 'package:flame/components.dart';

class CutOutRect extends PolygonComponent {
  CutOutRect({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.paint,
    super.paintLayers,
    super.key,
    BorderRadius cut = const BorderRadius.only(bottomRight: Radius.circular(8)),
  }) : super(sizeToVertices(size ?? Vector2.zero(), cut, anchor)) {
    size.addListener(
      () => refreshVertices(
        newVertices: sizeToVertices(size, cut, anchor),
        shrinkToBoundsOverride: false,
      ),
    );
  }

  static final primarySize = Vector2(108, 48);
  static const primaryCut = BorderRadius.only(
      bottomLeft: Radius.circular(8), topRight: Radius.circular(8));

  static List<Vector2> sizeToVertices(
    Vector2 size,
    BorderRadius cut,
    Anchor? componentAnchor,
  ) {
    final anchor = componentAnchor ?? Anchor.topLeft;
    final ret = [
      // top left
      Vector2(-size.x * anchor.x, -size.y * anchor.y),
    ];

    if (cut.bottomLeft.x > 0) {
      final split = cut.bottomLeft.x;

      ret.addAll([
        // 2 points at bottom left
        Vector2(-size.x * anchor.x, size.y - size.y * anchor.y - split),
        Vector2(-size.x * anchor.x + split, size.y - size.y * anchor.y),
      ]);
    } else {
      ret.add(Vector2(-size.x * anchor.x, size.y - size.y * anchor.y));
    }

    if (cut.bottomRight.x > 0) {
      final split = cut.bottomRight.x;

      ret.addAll([
        // 2 points at bottom right
        Vector2(size.x - size.x * anchor.x - split, size.y - size.y * anchor.y),
        Vector2(size.x - size.x * anchor.x, size.y - size.y * anchor.y - split),
      ]);
    } else {
      ret.add(Vector2(size.x - size.x * anchor.x, size.y - size.y * anchor.y));
    }

    if (cut.topRight.x > 0) {
      final split = cut.topRight.x;

      ret.addAll([
        // 2 points at top right
        Vector2(size.x - size.x * anchor.x, -size.y * anchor.y + split),
        Vector2(size.x - size.x * anchor.x - split, -size.y * anchor.y),
      ]);
    } else {
      ret.add(Vector2(size.x - size.x * anchor.x, -size.y * anchor.y));
    }

    return ret;
  }
}
