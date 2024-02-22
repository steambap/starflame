import 'dart:math';
import 'package:flame/game.dart';

class Hex {
  static const double size = 36;
  static Hex zero = Hex(0, 0, 0);
  static List<Hex> directions = [
    Hex(1, 0, -1), // E 0-5
    Hex(1, -1, 0), // NE 4-5
    Hex(0, -1, 1), // NW 3-4
    Hex(-1, 0, 1), // W 2-3
    Hex(-1, 1, 0), // SW 1-2
    Hex(0, 1, -1), // SE 0-1
  ];

  final int q;
  final int r;
  final int s;

  Hex(this.q, this.r, this.s) {
    assert(q + r + s == 0, "not a hex");
  }

  Hex operator +(Hex that) {
    return Hex(q + that.q, r + that.r, s + that.s);
  }

  Hex operator -(Hex that) {
    return Hex(q - that.q, r - that.r, s - that.s);
  }

  Hex scale(int k) {
    return Hex(q * k, r * k, s * k);
  }

  double distance(Hex that) {
    final Hex hex = this - that;

    return (hex.q.abs().toDouble() +
            hex.r.abs().toDouble() +
            hex.s.abs().toDouble()) /
        2;
  }

  Vector2 toPixel() {
    final x = (sqrt(3.0) * q + (sqrt(3.0) / 2.0) * r) * size;
    final y = (3.0 / 2.0) * r * size;

    return Vector2(x, y);
  }

  List<Hex> getNeighbours() {
    return directions.map((e) => e + this).toList(growable: false);
  }

  List<Hex> cubeRing(int radius) {
    assert(radius > 0, "radius must be greater than 0");
    final List<Hex> results = [];
    // start at SW since it lines up with the directions
    Hex hex = this + (Hex.directions[4].scale(radius));

    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < radius; j++) {
        results.add(hex);
        hex = hex.getNeighbours()[i];
      }
    }

    return results;
  }

  List<Vector2> polygonCorners([double size = Hex.size]) {
    final List<Vector2> corners = List.empty(growable: true);
    final center = toPixel();
    for (int i = 0; i < 6; i++) {
      final angle = (2.0 * pi * (i + 0.5)) / 6.0;
      final x = cos(angle) * size + center.x;
      final y = sin(angle) * size + center.y;

      corners.add(Vector2(x, y));
    }

    return corners;
  }

  @override
  int get hashCode => Object.hash(q, r, s);

  @override
  bool operator ==(Object other) {
    return (other is Hex) && q == other.q && r == other.r && s == other.s;
  }

  @override
  String toString() {
    return "($q,$r,$s)";
  }

  /// For serialization
  int toInt() {
    return (q & 0xffff) | ((r & 0xffff) << 16);
  }

  /// For deserialization
  static Hex fromInt(int i) {
    int q = i & 0xffff;
    final qSign = q & (1 << 7);
    if (qSign != 0) {
      q = q - 0x10000;
    }
    int r = (i >> 16) & 0xffff;
    final rSign = r & (1 << 7);
    if (rSign != 0) {
      r = r - 0x10000;
    }
    return Hex(q, r, -q - r);
  }

  // https://www.redblobgames.com/grids/hexagons/#rounding
  static Hex cubeRound(Vector3 frac) {
    int q = frac.x.round();
    int r = frac.y.round();
    int s = frac.z.round();

    final qDiff = (q - frac.x).abs();
    final rDiff = (r - frac.y).abs();
    final sDiff = (s - frac.z).abs();

    if ((qDiff > rDiff) && (qDiff > sDiff)) {
      q = -r - s;
    } else if (rDiff > sDiff) {
      r = -q - s;
    } else {
      s = -q - r;
    }

    return Hex(q, r, s);
  }

  static Hex center(List<Hex> hexes) {
    int q = 0;
    int r = 0;
    int s = 0;
    for (final hex in hexes) {
      q += hex.q;
      r += hex.r;
      s += hex.s;
    }
    final n = hexes.length;
    return Hex.cubeRound(Vector3(q / n, r / n, s / n));
  }
}
