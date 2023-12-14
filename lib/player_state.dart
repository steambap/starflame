import 'dart:ui';

class PlayerState {
  final int playerNumber;
  Color color = const Color(0x00000000);
  int race = 0;
  bool isAlive = true;
  final bool isCPU;
  int energy = 0;
  int techPoint = 0;
  int age = 0;

  PlayerState(this.playerNumber, this.isCPU);
}
