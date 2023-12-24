import 'dart:ui';

import "ship_type.dart";

class ShipState {
  final int id;
  final ShipType type;
  final Color color;
  int exp = 0;
  int health = 1;
  int moral = 1;
  String name = "";
  double movementUsed = 0;
  bool isTurnOver = false;

  ShipState(this.id, this.type, this.color);
}
