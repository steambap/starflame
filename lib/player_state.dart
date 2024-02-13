import 'package:flutter/material.dart' show Color, Colors;

class PlayerState {
  final int playerNumber;
  Color color = Colors.black;
  int race = 0;
  bool isAlive = true;
  final bool isAI;
  double energy = 0;
  int techPoint = 0;
  int age = 0;

  PlayerState(this.playerNumber, this.isAI);
}
