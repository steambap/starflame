import 'package:starfury/hex.dart';
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
}
