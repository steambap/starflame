import 'package:starflame/hex.dart';
import 'package:test/test.dart';

void main() {
  test("== works", () {
    expect(Hex(0, 0, 0) == Hex.zero, equals(true));
  });

  test('should return a list of hexes forming a ring with the given radius',
      () {
    final result = Hex(0, 0, 0).cubeRing(2);
    expect(result, hasLength(12));
  });

  test('toInt works', () {
    final testInputs = [
      Hex(1, 0, -1),
      Hex.zero,
      Hex(-3, 0, 3),
      Hex(-2, 3, -1),
    ];
    for (var hex in testInputs) {
      final int result = hex.toInt();
      final newHex = Hex.fromInt(result);
      expect(hex, equals(newHex));
    }
  });
}
