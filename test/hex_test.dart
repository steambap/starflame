import 'package:flutter_test/flutter_test.dart';
import 'package:starflame/hex.dart';

void main() {
  group('Hex.neighbour', () {
    group('even column (x=0)', () {
      const hex = Hex(0, 2);

      test('direction 0 returns correct neighbor', () {
        final neighbor = hex.neighbour(0);
        expect(neighbor, equals(const Hex(1, 2)));
      });

      test('direction 1 returns correct neighbor', () {
        final neighbor = hex.neighbour(1);
        expect(neighbor, equals(const Hex(1, 1)));
      });

      test('direction 2 returns correct neighbor', () {
        final neighbor = hex.neighbour(2);
        expect(neighbor, equals(const Hex(0, 1)));
      });

      test('direction 3 returns correct neighbor', () {
        final neighbor = hex.neighbour(3);
        expect(neighbor, equals(const Hex(-1, 1)));
      });

      test('direction 4 returns correct neighbor', () {
        final neighbor = hex.neighbour(4);
        expect(neighbor, equals(const Hex(-1, 2)));
      });

      test('direction 5 returns correct neighbor', () {
        final neighbor = hex.neighbour(5);
        expect(neighbor, equals(const Hex(0, 3)));
      });
    });

    group('odd column (x=1)', () {
      const hex = Hex(1, 2);

      test('direction 0 returns correct neighbor', () {
        final neighbor = hex.neighbour(0);
        expect(neighbor, equals(const Hex(2, 3)));
      });

      test('direction 1 returns correct neighbor', () {
        final neighbor = hex.neighbour(1);
        expect(neighbor, equals(const Hex(2, 2)));
      });

      test('direction 2 returns correct neighbor', () {
        final neighbor = hex.neighbour(2);
        expect(neighbor, equals(const Hex(1, 1)));
      });

      test('direction 3 returns correct neighbor', () {
        final neighbor = hex.neighbour(3);
        expect(neighbor, equals(const Hex(0, 2)));
      });

      test('direction 4 returns correct neighbor', () {
        final neighbor = hex.neighbour(4);
        expect(neighbor, equals(const Hex(0, 3)));
      });

      test('direction 5 returns correct neighbor', () {
        final neighbor = hex.neighbour(5);
        expect(neighbor, equals(const Hex(1, 3)));
      });
    });
  });
}
