import 'dart:math';

final logphi = log((1 + sqrt(5)) / 2);
final sqrt5 = sqrt(5);

int reverseFib(int n, [int offset = 0]) {
  return (log(n * sqrt5 + 0.5) / logphi).floor() - offset;
}
