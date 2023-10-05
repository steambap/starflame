import 'dart:math';
import 'package:flame/game.dart';

class Hex {
  static const double size = 72;
  static Hex zero = Hex(0, 0, 0);
  static List<Hex> directions = [
    Hex(1, 0, -1), // E
    Hex(1, -1, 0), // NE
    Hex(0, -1, 1), // NW
    Hex(-1, 0, 1), // W
    Hex(-1, 1, 0), // SW
    Hex(0, 1, -1), // SE
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
    return directions.map((e) => e + this).toList();
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
}
