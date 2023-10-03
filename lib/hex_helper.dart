import 'dart:math';
import 'package:flame/game.dart';

import 'hex.dart';

List<Hex> generateHexMap(int qMax) {
  final List<Hex> hexMap = List.empty(growable: true);
  for (int q = -qMax; q <= qMax; q++) {
    final r1 = max(-qMax, -q - qMax);
    final r2 = min(qMax, -q + qMax);
    for (int r = r1; r <= r2; r++) {
      hexMap.add(Hex(q, r, -q - r));
    }
  }

  return hexMap;
}

List<Vector2> polygonCorners(Hex h) {
  final List<Vector2> corners = List.empty(growable: true);
  final center = h.toPixel();
  for (int i = 0; i < 6; i++) {
    final angle = (2.0 * pi * (i + 0.5)) / 6.0;
    final x = cos(angle) * Hex.size + center.x;
    final y = sin(angle) * Hex.size + center.y;

    corners.add(Vector2(x, y));
  }

  return corners;
}

final List<Vector2> cornersOfZero = polygonCorners(Hex(0, 0, 0));
