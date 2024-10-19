import 'package:starflame/math.dart';
import 'package:test/test.dart';

void main() {
  test("works", () {
    expect(getMaintaince(0), equals(0));
    expect(getMaintaince(1), equals(0));
    expect(getMaintaince(2), equals(0));
    expect(getMaintaince(3), equals(1));
    expect(getMaintaince(4), equals(2));
    expect(getMaintaince(5), equals(4));
    expect(getMaintaince(6), equals(6));
    expect(getMaintaince(7), equals(9));
    expect(getMaintaince(8), equals(12));
    expect(getMaintaince(9), equals(16));
    expect(getMaintaince(10), equals(20));
    expect(getMaintaince(11), equals(25));
    expect(getMaintaince(12), equals(30));
  });
}
