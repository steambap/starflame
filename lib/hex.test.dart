import 'package:starfury/hex.dart';
import 'package:test/test.dart';

void main() {
  test("== works", () {
    expect(Hex(0, 0, 0) == Hex.zero, equals(true));
  });
}