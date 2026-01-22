import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show immutable;

const oddqDirectionDiff = [
  // even cols
  [
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0],
    [0, 1],
  ],
  // odd cols
  [
    [1, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [-1, 1],
    [0, 1],
  ],
];

// odd‑q (flat‑top) vertical layout from redblob
@immutable
class Hex {
  static const double size = 60;
  static Hex zero = const Hex(0, 0);
  static Hex invalid = const Hex(-1, -1);

  final int x;
  final int y;

  const Hex(this.x, this.y);

  Hex operator +(Hex that) {
    return Hex(x + that.x, y + that.y);
  }

  Hex operator -(Hex that) {
    return Hex(x - that.x, y - that.y);
  }

  int distance(Hex that) {
    final int q = x - that.x;
    final int r =
        y - (x - (x & 1)) ~/ 2 - (that.y - (that.x - (that.x & 1)) ~/ 2);
    final int s = q + r;

    return (q.abs() + r.abs() + s.abs()) ~/ 2;
  }

  Vector2 toPixel() {
    final dx = (3 / 2) * x * size;
    final dy = sqrt(3) * (y + 0.5 * (x & 1)) * size;

    return Vector2(dx, dy);
  }

  Hex neighbour(int direction) {
    final parity = x & 1;
    final diff = oddqDirectionDiff[parity][direction];
    return Hex(x + diff[0], y + diff[1]);
  }

  List<Hex> getNeighbours() {
    return List.generate(6, (i) => neighbour(i), growable: false);
  }

  List<Vector2> polygonCorners([double size = Hex.size]) {
    final List<Vector2> corners = [];
    final center = toPixel();
    for (int i = 0; i < 6; i++) {
      final angle = (2.0 * pi * i) / 6.0;
      final x = cos(angle) * size + center.x;
      final y = sin(angle) * size + center.y;

      corners.add(Vector2(x, y));
    }

    return corners;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) {
    return (other is Hex) && x == other.x && y == other.y;
  }

  @override
  String toString() {
    return "($x,$y)";
  }

  Map<String, int> toJson() {
    return {"x": x, "y": y};
  }
}
