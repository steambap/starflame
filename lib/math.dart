/// 0, 0, 1, 2, 4, 6, 9, 12, 16, 20, 25, 30
int getMaintaince(int step) {
  if (step <= 2) {
    return 0;
  }
  final half = (step - 2) ~/ 2;
  final mod = step % 2;
  return (half + mod) * (half + 1);
}
