import 'dart:ui';

class PlayerState {
  final int playerNumber;
  Color color = const Color(0x00000000);
  int race = 0;
  bool isAlive = true;
  final bool isCPU;
  int energy = 0;
  int metal = 0;
  int science = 0;
  int actionPoint = 0;

  PlayerState(this.playerNumber, this.isCPU);
}
